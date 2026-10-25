# Security

## Assumptions

### Full-Disk-Encryption is enabled
todo: zenarchy is installed after bse install. luks encryption is part of base install and we assume fde was used

### Yubikeys will be used (optional)

## todo chapter title. security concepts? architecture? 

### Yubikey setup
todo: requirements and minimum features. u2f and smartcard

#### LUKS Enrollment 
todo: enroll yubikey to luks slot

#### PGP Key Management
- key generation out of scope use: https://github.com/drduh/yubikey-guide
todo: description f how to get pgp keys on the yubikey

#### git commit signing
todo: describe on how to use yubikey for commit signing

### Password Management
todo: we are using pass as the password manager of choice and integrate with the desktop environment and browsers

#### Commandline
todo: how to store and retrieve passwords and how to utilize fzf for searching entries

#### Desktop Environment
todo: how to use tessen with fuzzel 

#### Browser Integration
todo: explain browserpass integration

## Geeneral security features

### full disk encryption
handled in base install

### yubikey integration
physical mfa for boot

### host firewall
default deny for incoming

### idle user logout
automatic screenlock and systemlock if user is idle

## todo: chapter title. dangers?

### Supply Chain Attacks
todo: we are utilizing paru. reference rcent overtake of aur packages by infostealers)



