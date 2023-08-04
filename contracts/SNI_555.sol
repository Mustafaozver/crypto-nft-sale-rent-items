// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIdCounter;

    // ERC-20 token address for USDT
    address public usdtTokenAddress;

    // Price of NFT in USDT
    uint256 public nftPriceInUSDT;

    // Struct to hold JSON metadata for each NFT
    struct SalesItemNFT {
        string data; // Replace with your desired JSON data
    }

    // Mapping from token ID to NFT metadata
    mapping(uint256 => SalesItemNFT) private tokenIdToMetadata;

    // Event triggered when NFT is purchased
    event NFTPurchased(address buyer, uint256 tokenId);

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {

    }

    // Function to mint a new NFT
    function mintNFT(address _to, string memory _metadata) external onlyOwner {
        tokenIdCounter.increment();
        uint256 newTokenId = tokenIdCounter.current();
        _mint(_to, newTokenId);
        tokenIdToMetadata[newTokenId] = SalesItemNFT(_metadata);
    }

    // Function to get NFT metadata by token ID
    function getMetadata(uint256 _tokenId) external view returns (string memory) {
        return tokenIdToMetadata[_tokenId].data;
    }

    // Function to purchase NFT with USDT
    function purchaseNFT(uint256 _tokenId) external {
        require(ownerOf(_tokenId) != msg.sender, "You cannot purchase your own NFT.");
        require(msg.sender != address(0), "Invalid buyer address.");
        require(nftPriceInUSDT > 0, "NFT price not set.");

        // Transfer USDT from buyer to contract
        IERC20 usdtToken = IERC20(usdtTokenAddress);
        uint256 amountToPay = nftPriceInUSDT;
        usdtToken.transferFrom(msg.sender, address(this), amountToPay);

        // Transfer NFT from contract to buyer
        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);

        emit NFTPurchased(msg.sender, _tokenId);
    }

    // Function to set the price of NFT in USDT
    function setNFTPriceInUSDT(uint256 _priceInUSDT) external onlyOwner {
        nftPriceInUSDT = _priceInUSDT;
    }
}
