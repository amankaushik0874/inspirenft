// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract InspireNFT is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable
{
    using Counters for Counters.Counter;
    mapping(uint256 => Nft) public nfts;
    mapping(uint256 => Collection) public collections;
    mapping(uint256 => Nft[]) public collectionNfts;
    mapping(uint256 => Collection) public nftCollection;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _collectionIdCounter;
    struct Nft {
        uint256 id;
        string _tokenURI;
        string fileHash;
        uint256 fileSize;
        string fileType;
        string fileName;
        string name;
        string description;
        uint256 uploadTime;
        string externalId;
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
        string _tokenURI,
        string fileHash,
        uint256 fileSize,
        string fileType,
        string fileName,
        string name,
        string description,
        uint256 uploadTime,
        string externalId,
        address minter
    );
    event NewCollection(
        uint256 id,
        string name,
        string description,
        string imgLink,
        address owner
    );

    function initialize() public initializer {
        __ERC721_init("Inspire NFT", "INFT");
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

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
            msg.sender == nfts[_idNft].minter,
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

    function mint(
        address _wallet,
        string memory _tokenURI,
        string memory _fileHash,
        uint256 _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _name,
        string memory _description,
        string memory _externalId
    ) public onlyOwner returns (uint256) {
        // Make sure the file hash exists
        require(bytes(_fileHash).length > 0);
        // Make sure file type exists
        require(bytes(_fileType).length > 0);
        // Make sure file description exists
        require(bytes(_name).length > 0);
        // Make sure file description exists
        require(bytes(_description).length > 0);
        // Make sure file fileName exists
        require(bytes(_fileName).length > 0);
        // Make sure uploader address exists
        require(msg.sender != address(0));
        // Make sure file size is more than 0
        require(_fileSize > 0);
        uint256 tokenId = _tokenIdCounter.current();
        // Add NFT to the contract
        nfts[tokenId] = Nft(
            tokenId,
            _tokenURI,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _name,
            _description,
            block.timestamp,
            _externalId,
            msg.sender
        );
        _safeMint(_wallet, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        emit MintedNFT(
            tokenId,
            _tokenURI,
            _fileHash,
            _fileSize,
            _fileType,
            _fileName,
            _name,
            _description,
            block.timestamp,
            _externalId,
            msg.sender
        );
        //increment token id
        _tokenIdCounter.increment();
        return tokenId;
    }
}
