# Linux box setup

Hello!

Are you setting up a new Linux box? Then follow my setup instructions below.

Note: Never store sensitive data like credentials, etc. in this project!

## Table of Contents

- [Create bootable USB drive](#create-bootable-usb-drive)
- [Install Linux](#install-linux)
- [First steps after a fresh Linux installation](#first-steps-after-a-fresh-linux-installation)
- [Backup / Restore](#backup--restore)
- [Setup apps, more settings/configurations](#setup-apps-more-settingsconfigurations)

## Create bootable USB drive

Download a Linux ISO image (e.g. [EndeavourOS](https://endeavouros.com/) or [Ubuntu](https://ubuntu.com/)) and burn it to a USB drive:

```sh
# Return the device (e.g. /dev/sda) of the inserted USB drive:
ls -l /dev/disk/by-id | grep usb

# Replace /dev/??? with the corresponding device and burn image to USB drive:
sudo dd if=endeavouros.iso of=/dev/??? bs=1M oflag=sync status=progress
```

## Install Linux

Boot from the USB drive and follow the installation steps.

## First steps after a fresh Linux installation

1. Perform a full system upgrade (e.g. via `yay` or `apt`).
1. Reboot.
1. Log in to your Bitwarden vault via browser using email address, password, and your 2FA device (i.e. via the Bitwarden Authenticator app on your mobile phone).
   - There is a password hint.
   - In the event that you can no longer use your normal two-step login provider (e.g. because you have lost your mobile device), your recovery code allows you to access your Bitwarden account. You can find your Bitwarden two-step login recovery code in your secret location.
   - If you ever need to restore your Bitwarden vault, import the backed-up encrypted JSON export from your Google Drive's `Backups` folder. The password is your Bitwarden password.
1. Restore backup (see [Restore backup](#restore-backup) section below).
1. Run the setup script:
   ```sh
   ~/mydata/projects/private/shell-tools/setup_linux_box/setup_linux_box.sh
   ```
1. Continue with further setups and settings (see [Setup apps](#setup-apps-more-settingsconfigurations) section below).

## Backup / Restore

### Restore backup

Follow the instructions at <https://github.com/tztz/backup>.

Note: You can download the needed `.backup.env` file from your Google Drive's `__INSTALL__` folder.
If you wish you can also download the `backup_restore.sh` file from there but it's recommended to use the version from the GitHub repository.

> **Important**: Make sure that the downloaded file starts with a dot. It must be named `.backup.env` not `backup.env`.

### Create backup

After restoring the backup and running `setup_linux_box.sh`, new backups can be created by executing `backup_create.sh` (it's in the PATH).

## Setup apps, more settings/configurations

### Bitwarden browser plugin

- Log in
- Set vault timeout to 15 minutes
- Enable "Unlock with PIN" (PIN is stored in Bitwarden)
- Enable "Clear clipboard after 1 minute"

### vscode

- Log in to sync settings

### IntelliJ IDEA Ultimate

- Log in to JetBrains account
- Activate license

### VPN

The VPN configs are created during setup. After setup, add your credentials via the network manager settings UI (e.g. GNOME Settings → Network → VPN).
