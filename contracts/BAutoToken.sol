pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CarToken is ERC721 {
    using Counters for Counters.Counter;
    
    address _owner;
    Counters.Counter private _tokenIdTracker;

    string private _baseTokenURI;

    constructor(string memory baseTokenURI) ERC721("BAuto", "BAUTO") {
        _baseTokenURI = baseTokenURI;
        _owner = msg.sender;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function mint(address to) public returns (uint256)
    {
        require(_msgSender() == _owner, "not an owner");
        
        uint256 current = _tokenIdTracker.current();
        _safeMint(to, current);
        _tokenIdTracker.increment();

        return current;
    }
}