pragma solidity ^0.4.16;

import "./UpgradeableToken.sol";

contract VirtRealToken is UpgradeableToken {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();
  address public saleAgent;
  address public allTokenOwnerOnStart;
  string public constant name = "Virtual Reality Token";
  string public constant symbol = "VRT";
  uint256 public constant decimals = 6;
  

  
 modifier onlySaleAgent() {
    require(msg.sender == saleAgent);
    require(saleAgent != 0);
    _;
  }

  function VirtRealToken(address _owner, address _allTokenOwnerOnStart) public {
     // save the owner
    owner = _owner;
    allTokenOwnerOnStart = _allTokenOwnerOnStart;
    totalSupply = 550000000000000;
    balances[allTokenOwnerOnStart] = totalSupply;
    Mint(allTokenOwnerOnStart, totalSupply);
    Transfer(0x0, allTokenOwnerOnStart ,totalSupply);
    MintFinished();
  }
  
  
  
  function privilegeTransfer(address _to, uint256 _amount) onlySaleAgent public returns (bool) {
      require(balances[allTokenOwnerOnStart] > _amount);
      balances[allTokenOwnerOnStart] = safeSub(balances[allTokenOwnerOnStart], _amount);
      balances[_to] = safeAdd(balances[_to], _amount);
      Transfer(allTokenOwnerOnStart, _to, _amount);
      return true;
  }
  function changeSaleAgent(address _saleAgent) onlyOwner public returns (bool) {
  saleAgent = _saleAgent;
  }
}

