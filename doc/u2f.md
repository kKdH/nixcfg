# Universal 2nd Factor

## Register YubiKeys

### First Key

1. Open Terminal

2. Insert your FIDO U2F-capable YubiKey

3. Run the following command:
  ```sh
  pamu2fcfg
  ```
  You may be prompted for a PIN when running pamu2fcfg. If you are, note that this is your YubiKey's FIDO2 PIN you need to enter. For more information, refer to Understanding YubiKey PINs.

4. When your device begins flashing, touch the metal contact to confirm the registration.

### Further Keys

1. Open Terminal

2. Insert your FIDO U2F-capable YubiKey

3. Run the following command:
   ```sh
   pamu2fcfg --nouser
   ```
   This will print only registration information which can be appended.

4.   When your device begins flashing, touch the capacitive touch sensor on your YubiKey contact to confirm the association
