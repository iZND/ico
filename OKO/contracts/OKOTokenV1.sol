pragma solidity ^0.4.18;

import "./UpgradeableTokenV1.sol";


contract OKOTokenV1 is  MigrationAgent, UpgradeableToken {
  address public saleAgent;
  address public allTokenOwnerOnStart;
  string public constant name = "OKOIN v1";
  string public constant symbol = "OKOv1";
  uint256 public constant decimals = 6;
  


  function OKOTokenV1(address _allTokenOwnerOnStart) public {
    //???
    allTokenOwnerOnStart = _allTokenOwnerOnStart;
    //????
    //totalSupply = 240000000000000;
  }
  
 
}
