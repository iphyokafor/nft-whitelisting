//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; // OZ: MerkleProof
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // tokenUri
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTWhitelist is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // merkleRoot to validate the proof
    bytes32 public merkleRoot;

    // mapping of address who have claimed;
    mapping (address => bool) public claimed;

    error AlreadyClaimed();
    error NotWhitelisted();

    event Claimed(address indexed claimer, uint256 indexed tokenId);

    constructor( string memory _name, string memory _symbol, bytes32 _merkleRoot) ERC721(_name, _symbol) {
        merkleRoot = _merkleRoot;
    }

    function claim(address to, string memory _tokenURI, bytes32[] calldata proof) external {
        require( to != address(0), "to is the zero address");
       uint256 newItemId = _tokenIds.current();
       if(claimed[to]) revert AlreadyClaimed();

       // verify merkle proof
       bytes32 leaf = keccak256(abi.encodePacked(to));
       bool isValid = MerkleProof.verify(proof, leaf, merkleRoot);
       if(!isValid) revert  NotWhitelisted();

       claimed[to] = true;

       _safeMint(to, newItemId);
       _setTokenURI(newItemId, _tokenURI);

       _tokenIds.increment();
        emit Claimed(to, newItemId);
    }

    function changeMerkleRoot(bytes32 _merkleRoot) external {
        require( _merkleRoot != bytes32(0), "merkleRoot is the zero address");
        merkleRoot = _merkleRoot;
    }


}
