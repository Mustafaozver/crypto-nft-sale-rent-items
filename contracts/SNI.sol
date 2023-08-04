// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// imports
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract SNI is ERC721Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable{
	using CountersUpgradeable for CountersUpgradeable.Counter;
	CountersUpgradeable.Counter private _tokenIds;

	address admin;

	mapping (uint256 => TokenMeta) private _tokenMeta;

	struct TokenMeta {
		uint256 id;

		string data;
		address owner;

		uint256 price;
		address token;
	}

    function initialize() public initializer {
        OwnableUpgradeable.__Ownable_init();
        ReentrancyGuardUpgradeable.__ReentrancyGuard_init();
        ERC721Upgradeable.__ERC721_init("SNI", "SNI");
        admin = msg.sender;
    }

    function listItem(string memory _metadata, uint256 _price, address _token) external onlyOwner returns (uint256) {
		_tokenIds.increment();
		uint256 newItemId = _tokenIds.current();
		_mint(admin, newItemId);
		TokenMeta memory meta = TokenMeta(newItemId, _metadata, admin, _price, _token);
		return newItemId;
    }

}