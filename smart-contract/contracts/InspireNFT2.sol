// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "hardhat/console.sol";

contract InspireNFT2 is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ERC721AUpgradeable
{
    using Counters for Counters.Counter;
    mapping(uint256 => Nft) public nfts;
    mapping(uint256 => Collection) public collections;
    mapping(uint256 => Nft[]) public collectionNfts;
    mapping(uint256 => Collection) public nftCollection;
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
        _collectionIdCounter.increment();
        return _collectionId;
    }

    function addNftToCollection(uint256 _idNft, uint256 _idCollection)
        public
        onlyOwner
    {
        require(
            msg.sender == ownerOf(nfts[_idNft].id),
            "Caller is not owner of NFT"
        );
        require(
            msg.sender == collections[_idCollection].owner,
            "Caller is not owner of Collection"
        );
        nftCollection[_idNft] = collections[_idCollection];
        collectionNfts[_idCollection].push(nfts[_idNft]);
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
        delete collectionNfts[_collectionIdToDel];
        for (uint256 i = 0; i < _collectionIdCounter.current(); i++) {
            if (nftCollection[i].id == _collectionIdToDel) {
                delete nftCollection[i];
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
        string memory _tokenURI,
        uint256 collectionID
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        emit MintedNFT(tokenId, block.timestamp, _tokenURI, msg.sender);
        nfts[tokenId] = Nft(tokenId, block.timestamp, _tokenURI, msg.sender);
        _mint(_wallet, NFTamount);
        for (uint256 i = 0; i < NFTamount; i++) {
            collectionNfts[collectionID].push(nfts[tokenId]);
            //i can try, didnt try it yet
            _tokenIdCounter.increment();
            tokenId++;
        }
    }
}
