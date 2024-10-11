# Linux box setup

Hello me!

Are you setting up a new Linux box? Then follow these steps!

Note: Never store sensitive data like credentials, etc. in this project!

## Create bootable USB drive

Download a Linux ISO image (e.g. [EndeavourOS](https://endeavouros.com/)) and burn it to a USB drive:

```sh
ls -l /dev/disk/by-id | grep usb
sudo dd if=endeavouros.iso of=/dev/XdA bs=1M oflag=sync status=progress
```

## Install Linux

Boot from the USB drive and follow the installation steps.

## First steps after a fresh Linux installation

1. Perform a full system upgrade (via yay).
1. Reboot.
1. Log in to your Bitwarden vault via browser using email address, password, and your 2FA device (i.e. via the Bitwarden Authenticator app on your mobile phone).
   - There is a password hint.
   - In the event that you can no longer use your normal two-step login provider (e.g. because you have lost your mobile device), your recovery code allows you to access your Bitwarden account. You can find your Bitwarden two-step login recovery code in your secret location.
   - If you ever need to restore your Bitwarden vault, import the backed-up encrypted JSON export from your Google Drive's `Backups` folder. The password is your Bitwarden password.
1. Restore backup (see resp. section below).
1. Run the `~/mydata/projects/private/shell-tools/setup_linux_box/setup_linux_box.sh` shell script.
1. Continue with further setups and settings (see resp. section below).

## Backup / Restore

### Restore backup

Follow the instructions at <https://github.com/tztz/backup>.

Note: You can download the needed `.backup.env` file from your Google Drive's `__INSTALL__` folder.
If you wish you can also download the `backup_restore.sh` file from there but it's recommended to use the version from the GitHub repository.

### Create backup

After restoring the backup (see previous section) and running `setup_linux_box.sh` new backups can be created by executing `backup_create.sh` (it's in the PATH).

## Setup apps, more settings/configurations

### Bitwarden browser plugin

- log in
- set vault timeout to 15 minutes
- enable "Unlock with PIN" (PIN is stored in Bitwarden)
- enable "clear clipboard after 1 minute"

### vscode

- log in to sync settings

### IntelliJ IDEA Ultimate

- log in to JetBrains account
- activate license

### VPN

The VPN configs are created during setup. Only add your credentials afterwards via the resp. settings UI.

### Mailing with GnuPG encryption

#### Qvest Digital / tarent

##### Thunderbird

###### Import `tarent-everyone.gpg` public keyring in Thunderbird

- see <https://confluence.tarent.de/pages/viewpage.action?pageId=592937048&focusedCommentId=1470595110#comment-1470595110>

###### Import private key in Thunderbird

- import private key (e.g. `~/.gnupg/my_privkey.asc`) in Thunderbird

### Disable system bell

TODO: still needed?

Go to _Settings -> Accessibility -> Bell_ and disable the checkbox