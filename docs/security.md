# Security Overview

## Threat Model
Zenarchy utilizes a centralized meta-package architecture to enforce a uniform security baseline and configuration standard across diverse endpoints, including laptops, workstations, and headless servers.

From this architecture follows a specific set of threats:

- **Loss or Theft of Physical Devices:** Laptops are inherently prone to theft, but workstations and headless servers also remain vulnerable to physical tampering or burglary.
- **Credential & Secret Compromise:** API keys, tokens, and local secrets become high-value targets if an attacker gains initial system access.
- **Untrusted Network Exposure:** Environments must assume an active adversary is present on the local network segment.
- **Fleet-Wide Blast Radius (Uniformity Risk):** Because all devices share a centralized baseline configuration, a single undiscovered design flaw or vulnerability can affect all managed systems simultaneously.
- **Supply Chain & Pipeline Compromise:** 
  - *Internal:* Unauthorized modification of Zenarchy's own source repository, build pipelines, or packaging keys.
  - *External:* Malicious or compromised packages pulled from official repositories or the Arch User Repository (AUR) during deployment.

## Security Goals
Zenarchy provides a security configuration that balances usability with defense-in-depth, serving as a baseline that users can adjust to fit their individual threat models.

## Scope and Non-Goals
Zenarchy assumes a pre-existing base installation of Arch Linux. Configuration tasks handled during the base installation are out of scope. However, Zenarchys security model relies on the following mandatory pre-requisites:

- Full Disk Encryption (FDE) via LUKS2 is enabled.
- Secure Boot is enforced.
- A user account with administrative (`sudo`) privileges exists.
- A Yubikey will be used for MFA.

Zenarchy's primary goal is to **streamline initial system provisioning** to a hardened baseline, not to manage day-to-day device operations. Ongoing device management and configuration drift tracking are strictly out of scope.

## BSI Alignment
This project aligns technical controls with the BSI IT-Grundschutz Compendium where applicable:

- **SYS.2.1:** General Client (Primary focus for workstations and laptops)
- **SYS.1.3:** Linux/Unix Server (As applicable to headless nodes)
- **CON.1:** Cryptography Concept (As applicable to system-wide crypto policies)

Relevant BSI requirements are explicitly referenced where implemented. Requirements not explicitly mentioned are considered out of scope for this project.

# Boot and Disk protection

## UEFI and Secure Boot

Zenarchy assumes that the provisioning secured UEFI with a password and enabled secure boot.

- **SYS.2.1.A8:** Securing the boot process

## Full Disk Enccryption with Yubikey
Provisioning set up full disk encryption with a secure passphrase. This will become the emergency backup unlock option. The main method of unlocking for zenarchy will be utilizing the FIDO2 element of the Yubikey. 

You can enroll the key with the following commeand `sudo systemd-cryptenroll --fido2-device=auto /dev/sdaX`

- **SYS.2.1.A28:** Full disk encryption with yubikey and meergency backup phrase.
- **SYS.2.1.A37:** Multifactor with Yubikey
- **CON.1.A2:** Yubikey cryptographic parts cannot be read out.

## Reconvery considerations 
Store the initial secure passphrase in a secure way like a sealed envelope for emergencies.

- **SYS.2.1.A38:** defines emergency break-glass unlock option
 
# Identity, Authentication and Key Management

## Password Policy

Zenarchy uses `libpwquality` to ensure either passphrases or shorter but complex enough passwords.

## Multifactor Authentication

Yubikeys with support for FIDO2/U2f and PIV/OpenPGP are supported. It is recommended to use them for:

- FDE unlock (via LUKS2 and U2F)
- User unlock (via libpam and U2F)
- Credential storage (via pass and OpenPGP)
- SSH / GPGP / Git commit signing(via OpenPGP)

Secure setup of a yubikey is out of scope of this project. We recommend the following guide: [DrDuh Yubikey Guide](https://github.com/drduh/yubikey-guide)

## User Directories

Zenarchy does not assume central user directories are mandatory. If password delegation to a centralized directory like Entra or Active Directory is needed it needs to be set up in the dedicated zenarchy-profile.







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



