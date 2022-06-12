pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EnglishAuction {
    event Start();
    event End(address buyer, uint amount);
    event Close();

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    uint public sellPrice;

    constructor(
        address _nft,
        uint _nftId,
        uint _sellPrice
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        sellPrice = _sellPrice;
    }

    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    function buy() external payable {
        require(started, "not started");
        require(!ended, "ended");
        require(block.timestamp < endAt, "ended");
        require(msg.value > sellPrice, "value < price");

        ended = true;
        nft.safeTransferFrom(address(this), msg.sender, nftId);
        seller.transfer(msg.value);

        emit End(msg.sender, msg.value);
    }

    function close() external {
        require(msg.sender == seller, "not a seller");
        require(started, "not started");
        require(!ended, "ended");

        ended = true;
        nft.safeTransferFrom(address(this), msg.sender, nftId);

        emit Close();
    }
}