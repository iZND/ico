pragma solidity ^0.4.16;

import "./UpgradeableTokenV1.sol";


contract VirtRealTokenV1 is  MigrationAgent, UpgradeableToken {
  address public saleAgent;
  address public allTokenOwnerOnStart;
  string public constant name = "Virtual Reality Token v1";
  string public constant symbol = "VRTv1";
  uint256 public constant decimals = 6;
  

  
 modifier onlySaleAgent() {
    require(msg.sender == saleAgent);
    require(saleAgent != 0);
    _;
  }

  function VirtRealTokenV1(address _owner, address _allTokenOwnerOnStart) public {
     // save the owner
    owner = _owner;
    allTokenOwnerOnStart = _allTokenOwnerOnStart;
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
