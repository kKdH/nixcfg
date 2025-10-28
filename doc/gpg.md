# GPG

## Common commands

**Generate a GPG key pair:**

```sh
gpg --expert --full-generate-key
```

**Edit a GPG key:**

```sh
gpg --expert --edit-key <key-id>
```

**Export secret (private) GPG keys:**

```sh
gpg --armor --export-secret-key <key-id>
```

**Delete secret (private) GPG keys:**

```sh
gpg --delete-secret-key <key-id>
```

**Delete (public) GPG keys:**

```sh
gpg --delete-key <key-id>
```

**Sanity Check:**
```sh
echo "test" | gpg --clearsign
```

## Trouble Shooting

**No such device**

```sh
❯ gpg --card-status
gpg: selecting card failed: No such device
gpg: OpenPGP card not available: No such device
```

1. Restart `pcscd` service: `sudo systemctl restart pcscd.service`
2. Kill `gpg-agent`:
   ```sh
    ❯ ps -e | grep gpg
    62293 ?        00:00:01 gpg-agent
   ```
   ```sh
   sudo kill -9 62293
   ```
