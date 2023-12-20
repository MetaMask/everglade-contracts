pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

struct Component {
    uint256 identifier;
    string script;
    uint256[] childComponentIds; // Array of child component identifiers
    string[] childComponentNames; // Corresponding local names for child components
}

contract WebPageManager is ERC721 {

    uint256 private itemCounter = 0;
    mapping(uint256 => Component) public components;

    constructor() ERC721("WebComponent", "WCOMP") {}

    function registerComponent(
        string memory script,
        uint256[] memory childComponentIds,
        string[] memory childComponentLocalNames
    ) public {
        require(childComponentIds.length == childComponentLocalNames.length, "Component IDs and names length mismatch");

        uint256 newItemId = itemCounter++;
        _mint(msg.sender, newItemId);

        components[newItemId] = Component({
            identifier: newItemId,
            script: script,
            childComponentIds: childComponentIds,
            childComponentNames: childComponentLocalNames
        });
    }

    function getComponent(uint256 identifier) public view returns (Component memory) {
        return components[identifier];
    }

    function updateComponent(
        uint256 identifier,
        string memory newScript,
        uint256[] memory newChildComponentIds,
        string[] memory newChildComponentLocalNames
    ) public {
        require(ownerOf(identifier) == msg.sender, "Not the owner");
        require(newChildComponentIds.length == newChildComponentLocalNames.length, "Component IDs and names length mismatch");

        Component storage component = components[identifier];
        component.script = newScript;
        component.childComponentIds = newChildComponentIds;
        component.childComponentNames = newChildComponentLocalNames;
    }

    function getComponentWithChildren(uint256 identifier) public view returns (Component memory, Component[] memory) {
        require(components[identifier].identifier != 0, "Component does not exist");

        Component storage parentComponent = components[identifier];
        Component[] memory children = new Component[](parentComponent.childComponentIds.length);

        for (uint i = 0; i < parentComponent.childComponentIds.length; i++) {
            children[i] = components[parentComponent.childComponentIds[i]];
        }

        return (parentComponent, children);
    }

}
