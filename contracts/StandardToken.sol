pragma solidity ^0.4.16;

import "./SafeMath.sol";
/**
 * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
 *
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is SafeMath {

  uint256 public totalSupply;

  /* Actual balances of token holders */
  mapping(address => uint) balances;

  /* approve() allowances */
// ????? maybe mapping (address => mapping (address => uint256)) internal allowed
  mapping (address => mapping (address => uint)) allowed;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  /**
   *
   * Fix for the ERC20 short address attack
   *
   * http://vessenes.com/the-erc20-short-address-attack-explained/
   */
  modifier onlyPayloadSize(uint256 size) {
     require(msg.data.length == size + 4);
     _;
  }

  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
    require(_to != 0);
    uint256 balanceFrom = balances[msg.sender];
    require(_value <= balanceFrom);

    // SafeMath safeSub will throw if there is not enough balance.
    balances[msg.sender] = safeSub(balanceFrom, _value);
    balances[_to] = safeAdd(balances[_to], _value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_to != 0);
    uint256 allowToTrans = allowed[_from][msg.sender];
    uint256 balanceFrom = balances[_from];
    require(_value <= balanceFrom);
    require(_value <= allowToTrans);

    balances[_to] = safeAdd(balances[_to], _value);
    balances[_from] = safeSub(balanceFrom, _value);
    allowed[_from][msg.sender] = safeSub(allowToTrans, _value);
    Transfer(_from, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
//???Chek this stuff
//    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
//    require();

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * Atomic increment of approved spending
   *
   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   */
  function addApproval(address _spender, uint256 _addedValue)
  onlyPayloadSize(2 * 32)
  public returns (bool success) {
      uint256 oldValue = allowed[msg.sender][_spender];
      allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue);
      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
  }

  /**
   * Atomic decrement of approved spending.
   *
   * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   */
  function subApproval(address _spender, uint256 _subtractedValue)
  onlyPayloadSize(2 * 32)
  public returns (bool success) {

      uint256 oldVal = allowed[msg.sender][_spender];

      if (_subtractedValue > oldVal) {
          allowed[msg.sender][_spender] = 0;
      } else {
          allowed[msg.sender][_spender] = safeSub(oldVal, _subtractedValue);
      }
      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
  }

}
