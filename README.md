# 🩺 ChainHealth

![ChainHealth Architecture](https://publications.computer.org/cloud-computing/wp-content/uploads/sites/31/2018/04/A-conceptual-blockchain-based-EMR-EHR-PHR-ecosystem.png)

![Blockchain in Healthcare](https://www.researchgate.net/publication/326441059/figure/fig1/AS%3A654549731799041%401533068225129/Blockchain-utilization-in-various-healthcare-applications.png)

![EHR Blockchain Flow](https://www.mdpi.com/technologies/technologies-12-00168/article_deploy/html/images/technologies-12-00168-g001.png)

---

## 🧩 Overview

**ChainHealth** is a simple **verifiable medical data ledger** for individuals.  
It allows users to **register themselves** and **store verifiable hashes** of medical records on-chain for audit and verification — without exposing private data.

Built using **Solidity** (compiled to **Solana** via [Solang](https://solang.readthedocs.io/en/latest/)), it provides a privacy-preserving, tamper-proof registry for patient health record hashes.

---

## ✨ Features

- 🔐 **Privacy-Preserving:** Only stores cryptographic hashes (no raw medical data).
- 🧾 **Verifiable:** Records can be verified against off-chain data.
- 👤 **User-Centric:** Each wallet controls its own medical record set.
- 📜 **Event Logging:** Emits events for registration and record addition.
- 🌐 **Compatible with Solana via Solang.**

---

## 🧠 Smart Contract

### `chain_health.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChainHealth
 * @dev A verifiable medical data ledger for individuals on Solana (via Solang)
 * Stores only hashes of medical records to preserve privacy.
 */
contract ChainHealth {
    struct Individual {
        address owner;
        string name;
        string[] recordHashes;
    }

    mapping(address => Individual) private individuals;

    event IndividualRegistered(address indexed owner, string name);
    event RecordAdded(address indexed owner, string recordHash);

    /// Register a new individual (each address can only register once)
    function registerIndividual(string memory name) public {
        require(individuals[msg.sender].owner == address(0), "Already registered");

        Individual storage newUser = individuals[msg.sender];
        newUser.owner = msg.sender;
        newUser.name = name;

        emit IndividualRegistered(msg.sender, name);
    }

    /// Add a new medical record hash (e.g., SHA-256 hash of encrypted data)
    function addMedicalRecord(string memory recordHash) public {
        require(individuals[msg.sender].owner == msg.sender, "Not registered");

        individuals[msg.sender].recordHashes.push(recordHash);

        emit RecordAdded(msg.sender, recordHash);
    }

    /// Retrieve all medical record hashes for an individual
    function getMedicalRecords(address user) public view returns (string[] memory) {
        return individuals[user].recordHashes;
    }

    /// Retrieve name and owner address
    function getIndividual(address user) public view returns (string memory name, address owner) {
        Individual storage ind = individuals[user];
        return (ind.name, ind.owner);
    }

    /// Verify if a record hash exists for a user
    function verifyRecord(address user, string memory recordHash) public view returns (bool) {
        string[] storage records = individuals[user].recordHashes;
        for (uint i = 0; i < records.length; i++) {
            if (keccak256(bytes(records[i])) == keccak256(bytes(recordHash))) {
                return true;
            }
        }
        return false;
    }
}

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/d7b344e5-12f1-4bf0-8dd6-d6166487db0d" />


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/f4bd394b-352e-415b-837c-5ff832bb0ed3" />



