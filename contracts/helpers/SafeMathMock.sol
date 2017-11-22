// Based on code by OpenZeppelin
// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/test/helpers/SafeMathMock.sol
// It is for tests purpos
pragma solidity ^0.4.16;

import '../SafeMath.sol';


contract SafeMathMock is SafeMath {
  uint256 public result;

  function multiply(uint256 a, uint256 b) public {
    result = safeMul(a, b);
  }

  function subtract(uint256 a, uint256 b) public {
    result = safeSub(a, b);
  }

  function add(uint256 a, uint256 b) public {
    result = safeAdd(a, b);
  }
// New
  function div(uint256 a, uint256 b) public {
    result = safeDiv(a, b);
  }
}
