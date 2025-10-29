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
