// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ILenteQuartzo {
    function checkMembro(address usuario) external view returns (bool);
}

contract FarolDAO {
    ILenteQuartzo public immutable nftContract;

    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    constructor(address nftContractAddress) {
        nftContract = ILenteQuartzo(nftContractAddress);
        proposals.push(Proposal({
            description: "Aumentar recompensas do Farol Protocol?",
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        }));
    }

    modifier onlyMember() {
        require(nftContract.checkMembro(msg.sender), "Apenas membros podem votar");
        _;
    }

    function vote(uint256 proposalId, uint8 voteType) public onlyMember {
        require(proposalId < proposals.length, "Proposta nao existe");
        require(!hasVoted[proposalId][msg.sender], "Voce ja votou");

        if (voteType == 1) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }

        hasVoted[proposalId][msg.sender] = true;
    }

    function getProposal(uint256 proposalId) public view returns (string memory description, uint256 forVotes, uint256 againstVotes) {
        require(proposalId < proposals.length, "Proposta nao existe");
        Proposal storage p = proposals[proposalId];
        return (p.description, p.votesFor, p.votesAgainst);
    }
}