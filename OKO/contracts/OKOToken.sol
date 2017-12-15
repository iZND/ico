pragma solidity ^0.4.18;

import "./UpgradeableToken.sol";

contract OKOToken is UpgradeableToken {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();


  address public allTokenOwnerOnStart;
  string public constant name = "OKOIN";
  string public constant symbol = "OKO";
  uint256 public constant decimals = 6;
  

  function OKOToken() public {
    allTokenOwnerOnStart = msg.sender;
    totalSupply = 240000000000000;
    balances[allTokenOwnerOnStart] = totalSupply;
    Mint(allTokenOwnerOnStart, totalSupply);
    Transfer(0x0, allTokenOwnerOnStart ,totalSupply);
    MintFinished();
  }
  


}

