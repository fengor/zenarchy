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
Zenarchy assumes a pre-existing base installation of Arch Linux. Configuration tasks handled during the base installation are out of scope. However, Zenarchy relies on the following mandatory pre-requisites:

- Full Disk Encryption (FDE) via LUKS is enabled.
- Secure Boot is enforced.
- A user account with administrative (`sudo`) privileges exists.

Zenarchy's primary goal is to **streamline initial system provisioning** to a hardened baseline, not to manage day-to-day device operations. Ongoing device management and configuration drift tracking are strictly out of scope.

## BSI Alignment
This project aligns technical controls with the BSI IT-Grundschutz Compendium where applicable:

- **SYS.2.1:** General Client (Primary focus for workstations and laptops)
- **SYS.1.3:** Linux/Unix Server (As applicable to headless nodes)
- **CON.1:** Cryptography Concept (As applicable to system-wide crypto policies)

Relevant BSI requirements are explicitly referenced where implemented. Requirements not explicitly mentioned are considered out of scope for this project.







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



