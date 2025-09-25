# Instructions

Parallel installation of Ubuntu and NixOS

Overview:

1. Prepare GRUB to boot live images.
2. Create LUKS key GRUB can decode.
3. Resize filesystem.
4. Install NixOS

## Grub preparations

1. Open the file `/etc/grub.d/40_custom`.

2. Disable grub authentication by commenting out `superusers` and `password_pbkdf2` stuff.

3. GParted menu entry
   ```
   menuentry "GParted Live ISO" {
     set isoFile="/gparted-live-1.7.0-8-amd64.iso"
     loopback loop (hd0,gpt2)$isoFile
     linux (loop)/live/vmlinuz boot=live components config findiso=$isoFile ip=frommedia toram=filesystem.squashfs union=overlay username=user
     initrd (loop)/live/initrd.img
   }
   ```

4. NixOS Live image menu entry
   ```
   menuentry "NixOS Live" {
     set isoFile="/nixos-minimal-25.05.810175.b2a3852bd078-x86_64-linux.iso"
     loopback loop (hd0,gpt2)$isoFile
     linux (loop)/boot//nix/store/v8ksl5fd07s8j0zarmcysbjzfspsljla-linux-6.12.48/bzImage ${isoboot} init=/nix/store/p4nih8503jz0ifviz4mxd295lgpxzp4y-nixos-system-nixos-25.05.810175.b2a3852bd078/init root=LABEL=nixos-minimal-25.05-x86_64 ip=frommedia toram=filesystem.squashfs union=overlay
     initrd (loop)/boot//nix/store/gvyk99li3i5z5i125fffs39hsmycphij-initrd-linux-6.12.48/initrd
   }
   ```

> [!NOTE]  
> To get the right path into the nix store, mount the iso and open the file `/EFI/BOOT/grub.cfg` and copy the path from one of the menu entries.

5. NixOS menu entry
   ```
   menuentry "NixOS" --unrestricted {
     insmod part_gpt
     insmod cryptodisk
     insmod luks2
     insmod lvm
     insmod pbkdf2
     cryptomount -u <uuid of luks encrypted partition>
     configfile (lvm/ubuntu--vg-nixos--lv--boot)/grub/grub.cfg
   }
   ```

6. Update Grub configuration
   ```sh
   sudo update-grub
   ```

## LUKS preparations

1. Add a key
   ```sh
   sudo cryptsetup luksAddKey /dev/nvme0n1p3
   ```

2. Convert the key to PBKDF2
   ```sh
   sudo cryptsetup luksConvertKey /dev/nvme0n1p3 --pbkdf pbkdf2 --pbkdf-force-iterations 600000
   ```

> [!NOTE]
> PBKDF2 is required when using GRUB to open the luks disk during boot. 

## Filesystem preparations

1. Boot the GParted live system to resize the filesystem.
2. If it does not open automatically, start `gparted`.
3. Encrypt the LUKS partition.
4. Shrink the logical volume of Ubuntu.
5. Create a logical volume `nixos-lv-boot` (e.g. 4096 MiB) for the nixos boot partition and add the label `NIXOSBOOT`.
6. Create a logical volume `nixos-lv-root` (e.g. 512 000 MiB) for the nixos root partition and add the label `NIXOSROOT`.

> [!TIP]
> Shrinking the logical volume of Ubuntu can also be archived by using `lvreduce`.
> `lvreduce -r -L 200G /dev/ubuntu-vg/ubuntu-lv-root`

## NixOS installation

> [!NOTE]
> Installation requires access to the internet! 

1. Boot NixOS live system.

2. Open LUKS volume:
   ```sh
   sudo cryptsetup open /dev/nvme0n1p3 crypt0
   ```
3. Mount `NIXROOT` to `/mnt`:
   ```sh
   sudo mount /dev/disk/by-label/NIXROOT /mnt
   ```
4. Create `/mnt/boot`:
   ```sh
   sudo mkdir -p /mnt/boot
   ```
5. Mount `NIXBOOT` to `/mnt/boot`:
   ```sh
   sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
   ```
6. Change directory to `/mnt`:
   ```sh
   cd /mnt
   ```
7. Run NixOS installation:
   ```sh
   sudo nixos-install --flake <path>\#<host>
   ```
8. Set password for user:
   ```sh
   sudo nixos-enter --root /mnt -c 'passwd <user>'
   ```
