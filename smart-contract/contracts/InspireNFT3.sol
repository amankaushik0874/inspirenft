// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";

contract InspireNFT2 is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ERC721AUpgradeable
{
    using Counters for Counters.Counter;
    mapping(uint256 => Nft) public nfts;
    mapping(uint256 => Collection) public collections;
    uint8[] public collectionIdforToken;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _collectionIdCounter;
    string internal baseTokenUri;
    string internal baseTokenUriExt;
    struct Nft {
        uint256 id;
        uint256 uploadTime;
        string tokenURI;
        address minter;
    }
    struct Collection {
        uint256 id;
        string name;
        string description;
        string imgLink;
        address owner;
    }
    event MintedNFT(
        uint256 id,
        uint256 uploadTime,
        string tokenURI,
        address minter
    );
    event NewCollection(
        uint256 id,
        string name,
        string description,
        string imgLink,
        address owner
    );

    function initialize() public initializerERC721A initializer {
        __ERC721A_init("Inspire NFT", "INFT");
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function addCollection(
        string memory _name,
        string memory _description,
        string memory _imgLink,
        address _owner
    ) public onlyOwner returns (uint256) {
        _collectionIdCounter.increment();
        uint256 _collectionId = _collectionIdCounter.current();
        Collection memory col = Collection(
            _collectionId,
            _name,
            _description,
            _imgLink,
            _owner
        );
        collections[_collectionId] = col;
        emit NewCollection(
            _collectionId,
            _name,
            _description,
            _imgLink,
            _owner
        );
        return _collectionId;
    }

    function editCollection(
        string memory _name,
        string memory _description,
        string memory _imgLink,
        address _owner,
        uint256 _idCollection
    ) public onlyOwner {
        uint256 _collectionId = _idCollection;
        Collection memory col = Collection(
            _collectionId,
            _name,
            _description,
            _imgLink,
            _owner
        );
        collections[_collectionId] = col;
    }

    function deleteCollection(uint256 _collectionIdToDel) public onlyOwner {
        delete collections[_collectionIdToDel];
        for (uint256 i = 0; i < _tokenIdCounter.current(); i++) {
            if (collectionIdforToken[i] == _collectionIdToDel) {
                delete collectionIdforToken[i];
            }
        }
    }

    function tokenURI(uint256 tokenId_)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId_), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(tokenId_),
                    baseTokenUriExt
                )
            );
    }

    function setBaseTokenUri(string calldata newBaseTokenUri_)
        external
        onlyOwner
    {
        baseTokenUri = newBaseTokenUri_;
    }

    function setBaseTokenUriExt(string calldata newBaseTokenUriExt_)
        external
        onlyOwner
    {
        baseTokenUriExt = newBaseTokenUriExt_;
    }

    function batchMint(
        address _wallet,
        uint256 NFTamount,
        string memory _tokenURI
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        emit MintedNFT(tokenId, block.timestamp, _tokenURI, msg.sender);
        nfts[tokenId] = Nft(tokenId, block.timestamp, _tokenURI, msg.sender);
        for (uint256 j = tokenId; j < tokenId + NFTamount; j++) {
            collectionIdforToken.push(0);
        }
        for (uint256 i = 0; i < NFTamount; i++) {
            _tokenIdCounter.increment();
            tokenId++;
        }
        _mint(_wallet, NFTamount);
    }

    function batchMint(
        address _wallet,
        uint256 NFTamount,
        string memory _tokenURI,
        uint8 collectionID
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        emit MintedNFT(tokenId, block.timestamp, _tokenURI, msg.sender);
        nfts[tokenId] = Nft(tokenId, block.timestamp, _tokenURI, msg.sender);
        for (uint256 j = tokenId; j < tokenId + NFTamount; j++) {
            collectionIdforToken.push(collectionID);
        }
        for (uint256 i = 0; i < NFTamount; i++) {
            _tokenIdCounter.increment();
            tokenId++;
        }
        _mint(_wallet, NFTamount);
    }

    function showData(uint256 tokenID) public view returns (uint256) {
        for (uint256 i = 0; i <= _tokenIdCounter.current(); i++) {
            if (tokenID == i) {
                return collectionIdforToken[i];
            }
        }
    }
}
