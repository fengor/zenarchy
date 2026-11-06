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

**Crucial Boundary:** Zenarchy's primary goal is to **streamline initial system provisioning and hardening**. It is a setup framework, not a Day-2 management platform. Ongoing device management, configuration drift tracking, and runtime monitoring are strictly out of scope; once provisioned, the system is maintained by the user.

## BSI Alignment
This project aligns technical controls with the BSI IT-Grundschutz Compendium where applicable:

- **SYS.2.1:** General Client (Primary focus for workstations and laptops)
- **SYS.1.3:** Linux/Unix Server (As applicable to headless nodes)
- **CON.1:** Cryptography Concept (As applicable to system-wide crypto policies)

Relevant BSI requirements are explicitly referenced where implemented. Requirements not explicitly mentioned are considered out of scope for this project.

# Boot and Disk Protection

## UEFI and Secure Boot
Zenarchy assumes that initial provisioning has secured the UEFI interface with an administrative password and enabled Secure Boot.

- **SYS.2.1.A8:** Securing the boot process against unauthorized modifications and unverified boot sources.

## Full Disk Encryption with YubiKey
Initial provisioning establishes Full Disk Encryption (LUKS2) using a secure passphrase, which serves as the emergency backup unlock option. The primary daily unlocking mechanism for Zenarchy leverages the FIDO2 element of a YubiKey.

Enrollment of the token into the LUKS header is performed via:
```
sudo systemd-cryptenroll --fido2-device=auto /dev/sdaX
```

- **SYS.2.1.A28:** Full disk encryption with YubiKey and emergency backup passphrase.
- **SYS.2.1.A37:** Multi-factor authentication integration using hardware tokens.
- **CON.1.A2:** Secure key generation and storage using tamper-resistant hardware security elements.

## Recovery Considerations
Store the initial emergency passphrase physically isolated from the host (e.g., in a tamper-evident sealed envelope inside a safe).

- **SYS.2.1.A38:** Definition and management of emergency break-glass recovery options.
- **CON.1.A2:** Secure physical handling and storage of cryptographic recovery keys.

# Identity, Authentication, and Key Management

## Password Policy
Zenarchy deploys `libpwquality (pam_pwquality.so)` to enforce system-wide password rules. The policy dynamically accommodates both long, low-complexity passphrases and shorter, highly complex passwords using credit-based scoring or stacked PAM rules.

- **ORP.4.A8:** Regulation and enforcement of secure password usage across local accounts.
- **ORP.4.A22:** Compliance with password quality criteria, leveraging hardware MFA compensation to allow reduced password lengths without sacrificing security.

## Multi-Factor Authentication
YubiKeys supporting FIDO2/CTAP2 and PIV/OpenPGP interfaces are integrated across the operating stack. Recommended usage points include:

- **FDE Volume Unlock:** LUKS2 via `systemd-cryptenroll` (FIDO2)
- **User Authentication:** PAM stack via `pam_u2f.so` (FIDO2)
- **Secret & Credential Storage:** `pass` CLI backed by OpenPGP subkeys
- **Transport & Code Integrity:** SSH authentication and Git commit signing via OpenPGP / PIV smart card applet

Note: Initial provisioning and key generation on the YubiKey itself are out of scope for Zenarchy. We recommend following the [DrDuh YubiKey Guide](https://github.com/drduh/yubikey-guide).

## User Directories
Zenarchy does not mandate centralized user directory integration. Where identity delegation to centralized directory services (e.g., Microsoft Entra ID or Active Directory) is required, it must be declared within a dedicated `zenarchy-profile` module.

# Privilege and Host Hardening

## sudo and least privilege model

Zenarchy enforces strict separation of privileges. Daily taks are executed under a unprivileged user account. Administrative escalation is handlet via `sudo`.  Sudo requires password and/or yubikey touch. sudo commands will be logged to an audit log.

- **SYS.1.3.A2:** Restrictive account management and application of least-privilege administrative access controls.
- **SYS.1.3.A12:** Audit and logging of privileged command execution.

## Root account policy

Direct interaction with the `root` account is disabled. The `root` password is locked to disable local passwor dlogins and ssh is configured with `PermitRootLogin No`).

- **SYS.1.3.A1:** Hardening user authentication  by eliminating default root accounts.
- **SYS.1.3.A7:** Disable root login over network

## service minimaztion
The package based approach of zenarchy allows finetuning of installed system daemons. Instead of a blanket approach we install only the relevant system daemons for the selected profile. In addition we stop sshd on laptop devices due to their higher exposure. User can enable it temporarily when needed.

- **SYS.1.3.A6:** Disabling unsecure protocols, unneeded background services and legacy daemons.

## Host firewall baseline
Zenarchy provides stateful host firewall with a default-deny ingress. Outgoing traffic is allowed and loopback interfaces are exempt. the only port we explicitly allow in zenarchy is Port 22

- **SYS.2.1.A31:** Implementation of local packet filtering with default-deny

## idle lock
User sessions are locked after a configured amount of time. this includes graphical environments like sway as well as headless shell sessions.

- **SYS.2.1.A1:** user session lock triggered by idle timeout

## (optional) kernel, sysctl and mac hardening
Due to the wide range of scenarios Zenarchy covers a generic hardening seems impossible. Instead we use a usecase based approach. Zenarchy profiles that require hardening implement it with the specific options inside their package.

# Software Supply Chain and Updates

## Pacman trust model and keyring

Zenarchy relies on Arch Linux’s cryptographic trust model, governed by `pacman` and `pacman-key`. Official repository packages are digitally signed by developers using PGP keys. The local keyring is maintained and verified by the package `archlinux-keyring` to prevent package spoofing or man-in-the-middle attacks during downloads.

- **OPS.1.1.3.A1:** Defining software sources and validating digital signatures
- **CON.1.A3:** Ensuring secure, authenticated transport channels and cryptographic verification of downloaded assets.

## AUR/paru risk model

The Arch User Repository (AUR) contains community-submitted build scripts (`PKGBUILD`). Unlike official repositories, AUR packages are **not** officially vetted, signed, or audited by Arch Linux developers. Using `paru` to build and install AUR packages introduces a distinct supply chain risk: executing arbitrary build instructions and untrusted code on the host system.

Zenarchy relies on several AUR packages to function. PKGBUILDs are vetted at time of inclusion into a zenarchy package but users are still responsible vor reviewing PKGBUILDs when using paru. Zenarchy is focused on system setup not day2day operations.

- **OPS.1.1.3.A2:** Risk assessment and controlled approval processes for third-party or external software sources.

## PKGBUILD reviews

To mitigate AUR and external supply chain risks, Zenarchy recommends a mandatory code-review workflow prior to package compilation. Administrators or users must inspect the `PKGBUILD` and any associated `.install` scripts for malicious commands, suspicious network requests, or unauthorized binary downloads before running `paru -S`.

- **OPS.1.1.3.A3:** Verification and safety testing of software packages before deployment into production environments.

## Safe system upgrade strategy

Because Arch Linux is a rolling-release distribution, partial upgrades are unsupported. Updating individual packages without syncing the entire repository breaks library compatibility and system stability. Zenarchy recommends full-system updates (`paru -Syu`) as a single operational transaction.

Zenarchy recommends to update regularly and often and includes a waybar widget to inform the user of the number of packaged with outstanding updates.

- **OPS.1.1.3.A4:** update and patch management

## change and rollback approach

If a package update introduces regressions or system instability, Zenarchy relies on local package caching and system recovery options:

Package Downgrading: Utilizing local archives in `/var/cache/pacman/pkg/` and `~/.cache/paru/clone` to roll back specific packages to known-good states using `paru -U`.

- **OPS.1.1.3.:** Safe Rollback / Change Management Maintaining rollback capabilities to recover from faulty updates or configuration changes.

# Secrets and Data Protection

## Password Manager Baseline (pass)
Zenarchy provisions the standard Unix password manager (`pass`) as the default credential store. Secrets are managed inside a Git-backed directory structure (`~/.password-store/`) where every individual secret is stored as an independent file encrypted with OpenPGP.

Primary keys and subkeys reside directly on the user's YubiKey (via OpenPGP smartcard applet), ensuring that raw decryption keys never hit local storage or system memory.

- **CON.1.A1:** Establishment of unified, cryptographic secret management policies.

- **CON.1.A2:** Key protection backed by hardware security elements.

## CLI, Desktop, and Browser Integration
To avoid manual decryption commands during daily operation, Zenarchy configures lightweight, native interfaces across all user layers:

**Command Line (CLI):** Direct interaction via `pass` combined with `fzf` for fuzzy searching across credential paths and secret keys without rendering plaintext passwords to standard output.

**Desktop Environment (Wayland):** Selection and secret retrieval driven by `tessen` running inside `fuzzel`. This delivers a keyboard-driven application launcher experience under Sway, instantly querying pass and routing output directly to the Wayland selection buffer.

**Browser Integration:** Secure auto-fill supplied by `browserpass`, communicating directly with the native `pass` binary via a local messaging host interface. Browser extensions never store or cache master credentials directly.

- **SYS.2.1.A37:** Secure, integrated secret retrieval workflows minimizing plaintext credential handling.

## Secret Handling Rules
Zenarchy deploys system-level configurations to mitigate credential leakage across memory, buffers, and shell environments:

**Clipboard Sanitization:** Integrations with `wl-clipboard` (via `pass -c` or `tessen`) automatically wipe clipboard buffers 45 seconds after copying sensitive data.

**GnuPG Agent Caching:** gpg-agent cache TTLs (default-cache-ttl / max-cache-ttl) are set to short intervals, requiring hardware touch or PIN re-entry for secret operations past idle thresholds.

**Shell History Exclusions:** Shell environments omit space-prefixed execution commands (`HISTCONTROL=ignoreboth`) and set explicit patterns (`HISTIGNORE="*pass*"`) to prevent accidental secret logging.

- **ORP.4.A8:** Enforcement of rules governing plaintext password handling and temporary buffer isolation.

# Network Security and Privacy

## Network Exposure Defaults
Zenarchy establishes a strict default-deny network posture across all host profiles. Inbound connection requests on external physical interfaces are dropped by default via `nftables` baseline rules. Stateful connection tracking permits outbound traffic and related response packets, while loopback interfaces (`lo`) remain explicitly isolated to local processes.

- **SYS.2.1.A31:** Implementation of local packet filtering (firewall) with default-deny inbound rules.

- **NET.1.1.A1:** Network segmentation and interface exposure minimization.

## DNS Privacy and Resolver Choices
To prevent cleartext DNS queries, domain hijacking, and ISP-level eavesdropping, Zenarchy configures local DNS resolution using DNS over TLS (DoT) or DNS over HTTPS (DoH) via `systemd-resolved`. Unencrypted port 53 traffic is blocked or redirected, and DNSSEC validation is enforced to guarantee response authenticity.

- **CON.1.A3:** Cryptographic protection of network transport protocols and name resolution.

- **NET.3.2.A12:** Secure DNS resolution and verification of response integrity.

## VPN and Public Wi-Fi Guidance
When connecting to untrusted or public network segments (e.g., public Wi-Fi), all non-local traffic should be routed through an encrypted tunnel (e.g., Tailscale, SSH, WireGuard or OpenVPN). Zenarchy provides pre-configured nftables kill-switch rules that drop all non-tunneled egress traffic should the VPN interface disconnect, preventing cleartext leaks.

- **SYS.2.1.A33:** Protection of mobile clients on untrusted networks via encrypted VPN tunnels.

- **CON.1.A4:** Transport security for remote data transfer.

## Bluetooth and MAC Randomization Policy
To mitigate tracking across wireless networks, Zenarchy enforces MAC address randomization for both Wi-Fi scan requests and active associations within NetworkManager or iwd. Wireless interfaces revert to randomized addresses on every reconnect. Bluetooth interfaces are disabled by default at boot via rfkill or systemd unit configuration, and must be explicitly enabled by the user when required.

- **SYS.2.1.A11:** Minimizing wireless attack surfaces and mitigating physical tracking risks.

## Remote Access Hardening (If Enabled)
Remote access via SSH (sshd) is disabled by default on mobile profiles (laptops) and strictly hardened on server/workstation nodes when enabled:

**Authentication:** Password authentication is completely disabled (`PasswordAuthentication no`); access is strictly restricted to hardware-backed SSH keys (YubiKey via OpenPGP / FIDO2 ed25519-sk).

**Access Control:** Root logins are forbidden (`PermitRootLogin no`), and access is limited to specific local users (`AllowGroups`).

**Cryptographic Suite:** Legacy ciphers and key exchange algorithms are disabled in favor of modern, secure primitives (KexAlgorithms, Ciphers, MACs).

- **SYS.1.3.A7:** Secure configuration and cryptographic hardening of remote administration services.

- **ORP.4.A21:** Multi-factor authentication for remote system access.


