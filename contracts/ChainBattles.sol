// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Deployed here:
// https://mumbai.polygonscan.com/address/0x44465d81DD317B78c69D3d44379345a68dA550E2

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    uint256 randomnessSeed;

    struct Stats {
        uint256 level;
        uint256 hp;
        uint256 strength;
        uint256 speed;
    }

    mapping(uint256 => Stats) public tokenId_stats;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle" font-weight="bold">',
            "Warrior - level ",
            getLevel(tokenId),
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "-----------------"
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "HP ",
            getHp(tokenId),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength ",
            getStrength(tokenId),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed ",
            getSpeed(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        return tokenId_stats[tokenId].level.toString();
    }

    function getHp(uint256 tokenId) public view returns (string memory) {
        return tokenId_stats[tokenId].hp.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        return tokenId_stats[tokenId].strength.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        return tokenId_stats[tokenId].speed.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        uint256 currentId = _tokenIds.current();
        _safeMint(msg.sender, currentId);
        Stats memory newStats = Stats(0, random(100), random(10), random(10));
        tokenId_stats[currentId] = newStats;
        _setTokenURI(currentId, getTokenURI(currentId));

        _tokenIds.increment();
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "The token doesn't exists");
        require(ownerOf(tokenId) == msg.sender, "You don't own this token");
        tokenId_stats[tokenId].level++;
        tokenId_stats[tokenId].hp += random(50);
        tokenId_stats[tokenId].strength += random(5);
        tokenId_stats[tokenId].speed += random(5);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // returns a number between 1 and max (both included)
    // [1, max]
    function random(uint256 max) public returns (uint256) {
        return
            (uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender,
                        randomnessSeed++
                    )
                )
            ) % max) + 1;
    }
}
