# 🛡️ PROJECT KAVACH
> **Advanced Tactical C++/Qt6 Engine for OSINT, Memory Forensics, & Network Posture Assessment**

![Version](https://img.shields.io/badge/Version-1.1.0_Stable-blue.svg)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen.svg)
![C++](https://img.shields.io/badge/Standard-C++17%2F20-blue.svg)
![Framework](https://img.shields.io/badge/Framework-Qt6%20%7C%20QML-green.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Kali-orange.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

---

## 📑 Executive Table of Contents
1. [Strategic Vision & Operational Doctrine](#-1-strategic-vision--operational-doctrine)
2. [The Core Philosophy: Why Native C++?](#-2-the-core-philosophy-why-native-c)
3. [Reconnaissance & Intelligence Acquisition Modules](#-3-reconnaissance--intelligence-acquisition-modules)
4. [Memory Forensics & Anti-Scraping Mechanisms](#-4-memory-forensics--anti-scraping-mechanisms)
5. [Internal Architecture & Execution Flow](#-5-internal-architecture--execution-flow)
6. [Secure Data Containment & Storage](#-6-secure-data-containment--storage)
7. [Tactical Technology Stack](#️-7-tactical-technology-stack)
8. [Advanced Deployment & Compilation Directives](#-8-advanced-deployment--compilation-directives)
9. [Operational Unit & Attribution](#-9-operational-unit--attribution)
10. [Future Strategic Expansions](#-10-future-strategic-expansions)

---

## 🌐 1. Strategic Vision & Operational Doctrine

In the realm of national security, advanced red-teaming, and tactical cyber-defense, operators require tools that execute with absolute precision, zero telemetry, and maximum stealth. **PROJECT KAVACH** is engineered specifically for these high-stakes, air-gapped environments. 

Modern cyber warfare dictates that security assessment tools must not leave forensic artifacts. Where commercial scanners (often built on Java, Python, or Go) suffer from heavy runtime environments, memory bloat, and loud network signatures that trigger Intrusion Detection Systems (IDS), Kavach is built from the ground up using native **C++**. It is designed to simulate Advanced Persistent Threat (APT) behavior, allowing security officers to audit digital infrastructure while maintaining strict **Operational Security (OPSEC)**.

### Target Audience & Deployment Scenarios
* **Intelligence Agencies & Cyber Commands:** For discrete mapping of adversary infrastructure without alerting foreign SOCs (Security Operations Centers).
* **Advanced Red Teams:** For executing low-and-slow perimeter audits that evade modern Endpoint Detection and Response (EDR) platforms.
* **Air-Gapped Auditing:** Operating flawlessly in environments with zero internet access, relying entirely on local processing and encrypted storage.

---

## ⚡ 2. The Core Philosophy: Why Native C++?

The decision to architect Kavach in C++17/20 was not arbitrary; it was driven by three uncompromising requirements:

* **Absolute Hardware Control:** By interacting directly with the Linux kernel and utilizing raw network sockets, C++ allows Kavach to bypass high-level OS bottlenecks. This results in microsecond-level packet delivery and processing, essential for handling high-bandwidth asynchronous scanning.
* **Zero Telemetry & Runtime Independence:** Kavach does not rely on third-party cloud APIs, external dependency servers, JVMs, or Python interpreters. It compiles down to a stripped, optimized native binary, ensuring that the tool itself does not become a vector for data leakage.
* **Compiler-Level Optimization:** Utilizing aggressive compiler flags (`-O3`, `-march=native`), Kavach optimizes its execution loop to match the specific CPU architecture of the host machine, maximizing throughput while minimizing CPU footprint.

---

## 🧠 3. Reconnaissance & Intelligence Acquisition Modules

Real intelligence work relies on correlating fragmented data points. Kavach splits its reconnaissance into three distinct tactical phases to maintain a low operational profile while extracting maximum intelligence.

### 🤫 Phase Alpha: Passive Intelligence (Zero-Touch OSINT)
This phase maps the external attack surface without sending a single packet to the target's primary servers, ensuring firewalls and WAFs remain un-triggered.
* **Certificate Transparency (CT) Mapping:** Queries public `crt.sh` and JSON certificate logs to unearth hidden subdomains, internal staging servers, and forgotten legacy infrastructure.
* **Automated Endpoint Auditing:** Silently scrapes and parses `robots.txt`, `sitemap.xml`, and `security.txt` from public internet archives, mapping out restricted web directories.
* **HTTP Header Forensics:** Analyzes server response headers to detect missing security configurations (HSTS, X-Frame-Options, Content Security Policies, Server Signature leaks), revealing the defensive maturity of the target infrastructure.

### 🗡️ Phase Beta: Active Engagement (Direct Probing)
Once the passive map is formulated, Kavach engages the target directly using highly optimized, low-level networking techniques.
* **Raw TCP Socket Probing:** Drops the standard OS-level TCP three-way handshake overhead. By crafting custom SYN packets via raw sockets, Kavach can scan thousands of ports rapidly while evading basic stateful firewalls.
* **Direct DNS Routing:** Bypasses local ISP or enterprise DNS caching by routing queries directly through external resolvers (`8.8.8.8` / `1.1.1.1`). This prevents the local network from logging the operator's targets.

### 🔐 Phase Gamma: Cryptographic Analysis
* **Deep TLS/SSL Extraction:** Forces detailed SSL/TLS handshakes to extract x509 certificates.
* **Cipher Suite Auditing:** Identifies deprecated protocols (e.g., SSLv3, TLS 1.0/1.1) and flags weak cryptographic cipher suites (e.g., RC4, DES, 3DES) that are vulnerable to attacks like POODLE or SWEET32.

---

## 🛡️ 4. Memory Forensics & Anti-Scraping Mechanisms

One of Kavach's most advanced features is its defense against memory scraping. Intelligence data (target IPs, open ports, vulnerability flags) must be protected even while the program is running.

* **Destructor-Level Shredding:** When a scanning task completes, the C++ objects holding sensitive data do not just deallocate. The custom destructors explicitly overwrite the allocated memory blocks with null bytes (`0x00`) or random junk data (`0xFF`).
* **Bypassing Compiler Optimization:** Modern C++ compilers often skip memory wiping if they detect the variable is no longer used. Kavach utilizes `volatile` pointers and `explicit_bzero` (or secure `memset` wrappers) to force the CPU to execute the shredding instruction.
* **Prevention of RAM Dumping:** This ensures that if an adversary or a local EDR solution performs a memory dump (e.g., via Volatility or ProcDump), the intelligence gathered by Kavach cannot be recovered from the heap or stack.

---

## ⚙️ 5. Internal Architecture & Execution Flow

Kavach is designed with a strictly isolated **Three-Tier Architecture**, decoupling the graphical interface from the heavy-lifting network engine.

1. **Target Ingestion:** The operator inputs the target parameters into the QML Dashboard.
2. **Thread Spawning (Concurrency):** The C++ `ScannerEngine` leverages `std::thread`, `std::async`, and mutex locks to spawn multiple independent worker threads, maximizing network throughput without causing race conditions.
3. **Optimized Data Structures:** As network packets return, data is ingested into high-speed, custom-built **C++ Deques (Double-Ended Queues)** and Linked Lists. Deques were specifically chosen over standard Vectors to prevent massive memory reallocation and copying during prolonged, heavy-duty scans.
4. **Signal-Slot UI Binding:** The backend emits asynchronous Qt signals across thread boundaries. The Qt6 UI catches these signals and dynamically updates the dark-mode dashboard at 60 FPS, providing a live tactical map without ever freezing the main UI thread.

---

## 🗄️ 6. Secure Data Containment & Storage

* **Air-Gapped Local Vault:** Kavach utilizes a locally isolated **SQLite3 database** (`kavach_vault.db`) for storing session logs and target histories. The database is configured with `PRAGMA journal_mode=WAL` for high-speed concurrent writes.
* **Cryptographic Wrappers:** While the database handles the relational mapping, the data inserted into it is obfuscated using a custom **XOR-based cryptographic layer**, ensuring that even if the host machine is compromised, the local database cannot be read in plaintext.
* **Zero Cloud Transmissions:** Kavach guarantees that scan histories and intelligence reports never leave the host machine, making it safe for deployment in highly classified SCIF (Sensitive Compartmented Information Facility) environments.

---

## 🛠️ 7. Tactical Technology Stack

| Architecture Layer | Technology Deployed | Tactical Purpose |
| :--- | :--- | :--- |
| **Core Engine** | `C++17 / C++20` | Raw socket manipulation, memory shredding, and multithreading. |
| **Graphical Interface** | `Qt6 / QML` | Hardware-accelerated, reactive, military-grade dark-mode UI. |
| **Build System** | `CMake` | Robust cross-platform compilation and dependency linking. |
| **Data Structures** | `STL Deques & Custom Lists` | O(1) insertion times, preventing memory reallocation latency. |
| **Data Containment** | `SQLite3` | Secure, offline, lightweight database for session history logging. |
| **Primary OS Target** | `Linux (Kali/Parrot)` | Natively optimized for standard cyber-defense operating environments. |

---

## 💻 8. Advanced Deployment & Compilation Directives

Kavach requires a Linux environment with Qt6 and essential build tools. To deploy Kavach on a secure terminal (`vaibhav@kali`), execute the following directives:

```bash
# 1. Install prerequisites (Debian/Kali based)
sudo apt update && sudo apt install build-essential cmake qt6-base-dev qt6-declarative-dev libsqlite3-dev

# 2. Clone the master repository to the local secure machine
git clone [https://github.com/vaibhavjoshi00110-bit/PROJECT-KAVACH.git](https://github.com/vaibhavjoshi00110-bit/PROJECT-KAVACH.git)
cd PROJECT-KAVACH

# 3. Initialize an isolated build environment
mkdir build && cd build

# 4. Generate CMake Makefiles (Release Mode for Maximum Optimization)
cmake -DCMAKE_BUILD_TYPE=Release ..

# 5. Compile utilizing all available CPU threads (-O3 optimization applied)
make -j$(nproc)

# 6. Execute the Kavach Engine locally
./PROJECT_KAVACH
