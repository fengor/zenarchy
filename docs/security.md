# Security Overview

## Threat Model
Zenarchy utilizes a centralized meta-package architecture to enforce a uniform security baseline and configuration standard across diverse endpoints, including laptops, workstations, and headless servers.

From this follows a set of threats that need to be considered:

- Loss or Theft of the physical device
  Some classes of devices like laptops are more prone to being stolen or lost than others but even workstations and servers can be victim to burglary.
- Compromise of credentials
  Credentials, API keys and other secrets are high value targets if an attacker compromises a system.
- Untrusted network exposure
  Always assume an attacker can be on the same network as you.
- Blast radius expansion through uniformity
  Since we form a baseline configuration a potential attack based on this baseline can affect potentially alll devices using this baseline.
- Supply Chain attacks
  The metapackage approach means we will be installing packages from the official repos and Arch User Repository. If an attacker manages to compromises one of the packages we use our devices can be compromised

## Security goals

Our goal is to provide a configuration that balances the user experience with the secuity concerns from which a user can adjust based on their personal threat model.

## Scope and Non-Goals

Zenarchy needs a baseinstall of archlinux as a requirement. As such everything that is setup during baseinstall is out ofthe scope for zenarchy itself. But we rely on the following assumptions:

- Full Disk Encryption via LUKS is enabled
- Secure Boot is used
- A user with sudo priviliges exists

Zenarchy aims to streamline the setup of a device after a fresh install. Its primary goal is to get a device to a baseline not manage the device. Ongoing device management is out of scope.

## BSI Alignment

This projects tries to adress the following components of the IT-Grundschutz

- SYS.2.1 General client (primarily)
- SYS.1.3 Linux/Unix server (as applicable)
- CON.1 Crypto concept (as applicable)

Relevant requirements will be mentioned  where they are addressed. If a requirement is not explicitely mentioned we a re considering it out of scope for this project.





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



