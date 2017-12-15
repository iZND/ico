pragma solidity ^0.4.18;

import "./OKOToken.sol";

// ============================================================================

contract IcoOKOToken is Ownable, SafeMath {
  address public wallet;
  address public allTokenAddress;
  bool public emergencyFlagAndHiddenCap = false;
  // UNIX format
  uint256 public startTime = 1513278000; // 14 Dec 2017 19:00:00 GMT
  uint256 public endTime =   1515870000; // 13 Jan 2018 19:00:00 GMT

  uint256 public USDto1ETH = 654; // 1 ether = 654$
  uint256 public price; 
  uint256 public totalTokensSold = 0;
  uint256 public constant maxTokensToSold = 84000000000000; // 35% * (240 000 000.000 000)
  OKOToken public token;

  function IcoOKOToken(address _wallet, OKOToken _token) public {
    wallet = _wallet;
    token = _token;
    allTokenAddress = token.allTokenOwnerOnStart();
    price = 1 ether / USDto1ETH / 1000000;
  }

  function () public payable {
    require(now <= endTime && now >= startTime);
    require(!emergencyFlagAndHiddenCap);
    require(totalTokensSold < maxTokensToSold);
    uint256 value = msg.value;
    uint256 tokensToSend = safeDiv(value, price);
    require(tokensToSend >= 1000000 && tokensToSend <= 350000000000);
    uint256 valueToReturn = safeSub(value, tokensToSend * price);
    uint256 valueToWallet = safeSub(value, valueToReturn);

    wallet.transfer(valueToWallet);
    if (valueToReturn > 0) {
      msg.sender.transfer(valueToReturn);
    }
    token.transferFrom(allTokenAddress, msg.sender, tokensToSend);
    totalTokensSold += tokensToSend;
  }

    function ChangeUSDto1ETH(uint256 _USDto1ETH) onlyOwner public {
        USDto1ETH = _USDto1ETH;
        ChangePrice();
    }

  function ChangePrice() onlyOwner public {
    uint256 priceWeiToUSD = 1 ether / USDto1ETH;
    uint256 price1mToken = priceWeiToUSD / 1000000; // decimals = 6
    if ( now <= startTime + 5 days) {
      price = price1mToken; // 1.000000Token = 1$ first 5 days
    } 
    else {
      if ( now <= startTime + 10 days ) {
        price = price1mToken * 9 / 5; // 1.000000Token = 1.8$ next
      } 
      else {
        price = price1mToken * 27 / 10; // 1.000000Token = 2.7$ to end
      }
    }

  }

    function ChangeStart(uint _startTime) onlyOwner public {
        startTime = _startTime;
    }

    function ChangeEnd(uint _endTime) onlyOwner public {
        endTime = _endTime;
    }


  function emergencyAndHiddenCapToggle() onlyOwner public {
    emergencyFlagAndHiddenCap = !emergencyFlagAndHiddenCap;
  }

}
