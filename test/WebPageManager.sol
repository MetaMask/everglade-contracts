// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {WebPageManager, Component} from "../src/WebPageManager.sol";

contract WebPageManagerTest is Test {
    WebPageManager public webPageManager;

    function setUp() public {
        webPageManager = new WebPageManager();
    }

    function test_component () public {
        uint256[] memory emptyUintArray = new uint256[](0);
        string[] memory emptyStringArray = new string[](0);
        string memory script = "<div>hello world</div>";
        webPageManager.registerComponent(
            script,
            emptyUintArray,
            emptyStringArray
        );

        Component memory component = webPageManager.getComponent(0);

        assertEq(component.script, script);
    }

    function test_child_component () public {
        uint256[] memory emptyUintArray = new uint256[](0);
        string[] memory emptyStringArray = new string[](0);
        string memory script = "<div>hello world</div>";
        webPageManager.registerComponent(
            script,
            emptyUintArray,
            emptyStringArray
        );

        uint256[] memory entryArray = new uint256[](1);
        string[] memory entryStringArray = new string[](1);
        entryArray[0] = 0;
        entryStringArray[0] = "Child";

        webPageManager.registerComponent(
            "<div><h1>My Site</h1><p>Check out this cool stuff from my friend: </p></div>",
            entryArray,
            entryStringArray
        );

        Component memory component;
        Component[] memory children;
        (component, children) = webPageManager.getComponentWithChildren(1);

        assertEq(script, children[0].script);
    }
}
