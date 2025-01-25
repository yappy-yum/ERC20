// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DeployYAPPY_TOKEN} from "../script/YAPPY_TOKEN.s.sol";
import {YAPPY_TOKEN} from "../src/YAPPY_TOKEN.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract TestYAPPY_TOKEN is Test {
    
    YAPPY_TOKEN yappy;
    uint public constant INITIAL_SUPPLY = 100 ether;
    
    /*//////////////////////////////////////////////////////////////
                                  user
    //////////////////////////////////////////////////////////////*/
    
    address public constant Owner = address(123);
    
    address public Alice = makeAddr("Alice");
    address public Bob = makeAddr("Bob");
    address public Charlie = makeAddr("Charlie");
    
    /*//////////////////////////////////////////////////////////////
                                 setUp
    //////////////////////////////////////////////////////////////*/
    
    function setUp() external {
        DeployYAPPY_TOKEN deployYAPPY = new DeployYAPPY_TOKEN();
        yappy = deployYAPPY.run();
    }

    /*//////////////////////////////////////////////////////////////
                             test settings
    //////////////////////////////////////////////////////////////*/

    function testTokenSetting() public view {      
        // Token Name
        assertEq(yappy.name(), "YAPPY");

        // Token Symbol
        assertEq(yappy.symbol(), "YAP");

        // Token Decimals
        // 1 YAP == 1e18 WEI
        // 1 YAP == 1 ETH
        assertEq(yappy.decimals(), 18);

        // Total Supply from Constructor
        assertEq(yappy.totalSupply(), INITIAL_SUPPLY);

        // since owner has initialized the contract
        // with the total supply of 100 YAP
        // owner should have 100 YAP
        assertEq(yappy.balanceOf(Owner), 100 ether);
    }

    /*//////////////////////////////////////////////////////////////
                               flow event
    //////////////////////////////////////////////////////////////*/

    function testFlowEvent() public {
        // transfer token from owner to Alice
        vm.prank(Owner);
        yappy.transfer(Alice, 70 ether);

        // Alice has 70 YAP
        // Owner has 30 YAP (100-70)
        assertEq(yappy.balanceOf(Alice), 70 ether);
        assertEq(yappy.balanceOf(Owner), 30 ether);

        // Alice transfers her 10 Yap to Bob
        vm.prank(Alice);
        yappy.transfer(Bob, 10 ether);

        // Bob has 10 YAP
        // Alice has 60 YAP (70-10)
        assertEq(yappy.balanceOf(Bob), 10 ether);
        assertEq(yappy.balanceOf(Alice), 60 ether);

        // Alice allows his 20 YAP to be spent by Owner 
        vm.prank(Alice);
        yappy.approve(Owner, 20 ether);

        // since its just an approval, all the users balance unchanged
        assertEq(yappy.balanceOf(Alice), 60 ether);
        assertEq(yappy.balanceOf(Owner), 30 ether);
        assertEq(yappy.balanceOf(Bob), 10 ether);
        assertEq(yappy.balanceOf(Charlie), 0 ether);

        // ensures that approval has approved
        assertEq(yappy.allowance(Alice, Owner), 20 ether);

        // Owner transfers 15 YAP (belongs to Alice) to Charlie
        vm.prank(Owner);
        yappy.transferFrom(Alice, Charlie, 15 ether);

        // check balance that allows Owner to spend Alice's YAP token
        assertEq(yappy.allowance(Alice, Owner), 5 ether);

        // check all the user total balance
        assertEq(yappy.balanceOf(Alice), 45 ether);
        assertEq(yappy.balanceOf(Owner), 30 ether);
        assertEq(yappy.balanceOf(Bob), 10 ether);
        assertEq(yappy.balanceOf(Charlie), 15 ether);

        // ensures that spending amount shouldnt exceed allowance amount
        // Owner has spent 15 YAP from Alice
        // Owner can only spend 5 YAP from Alice
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector, 
                Owner, // spender
                5 ether, // allowed amount
                6 ether // amount requested to send
            )
        );
        vm.prank(Owner);
        yappy.transferFrom(Alice, Bob, 6 ether);

    }



}