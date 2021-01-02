pragma solidity 0.7.6;
pragma abicoder v2;

contract Message {
    address public owner;
    string  public author;

    enum Language {PT, EN, ES}

    mapping (Language => string[]) public messages;

    constructor() {
        owner = msg.sender;
        author = "Solange Gueiros";
    }
    
    event MessageChange(string language, string message);

    modifier onlyOwner {
        require(msg.sender == owner,"Only owner");
        _;
    }
    
    function setMessage(Language _language, string memory _message) public onlyOwner returns (uint index) {
        messages[_language].push(_message);
        string memory lang = getLanguage (_language);
        emit MessageChange(lang, _message);
        index = lengthMessage(_language);
    }
    
    function setMessage(string memory _language, string memory _message) public onlyOwner returns (uint index) {
        Language lang = toLanguage (_language);
        messages[lang].push(_message);
        emit MessageChange(_language, _message);
        index = lengthMessage(lang);
    }
    
    function getMessage(Language _language) public view returns (string memory) {
        uint index = lengthMessage(_language);
        return (messages[_language][index]);
    }
    
    function getMessage(string memory _language) public view returns (string memory) {
        Language lang = toLanguage (_language);
        uint index = lengthMessage(lang);
        return (messages[lang][index]);
    }
    
    
    function allMessages(Language _language) public view returns (string[] memory) {
        return (messages[_language]);
    }
    
    function allMessages(string memory _language) public view returns (string[] memory) {
        Language lang = toLanguage (_language);
        return (messages[lang]);
    }
    
    function lengthMessage(Language _language) public view returns (uint) {
        return messages[_language].length - 1;
    }
    
    function lengthMessage(string memory _language) public view returns (uint) {
        Language lang = toLanguage (_language);
        return messages[lang].length - 1;
    }    
    
    function toLanguage(string memory _language) internal pure returns (Language) {
        // keccak256() only accept bytes as arguments, so we need explicit conversion
        bytes memory lang = bytes(_language);
        bytes32 hash = keccak256(lang);    

        // Loop to check
        if (hash == keccak256("PT") || hash == keccak256("pt") || hash == keccak256("Pt") ) return Language.PT;
        if (hash == keccak256("EN") || hash == keccak256("en") || hash == keccak256("En") ) return Language.EN;        
        if (hash == keccak256("ES") || hash == keccak256("es") || hash == keccak256("Es") ) return Language.ES;
        revert("Invalid language");
    }

    function getLanguage(Language _language) public pure returns (string memory) {
        //require(uint8(_language) <= 2, "Invalid language");
        
        // Loop through possible options
        if (Language.PT == _language) return "Portugues";
        if (Language.EN == _language) return "English";
        if (Language.ES == _language) return "Espanol";
        revert("Invalid language");
    }    
}