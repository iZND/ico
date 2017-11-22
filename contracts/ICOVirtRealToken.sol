pragma solidity ^0.4.16;

import "./VirtRealToken.sol";

// ============================================================================

contract ICOVirtRealToken is Ownable, SafeMath {
  address public wallet;
  bool public emergencyFlagAndHiddenCap = false;
  uint256 public startTime = 1507161601; // 05 Oct 2017 00:00:01 GMT
  uint256 public endTime = 1509840001; // 05 Nov 2017 00:00:01 GMT
                                // UNIX format
  uint256 public USDto1ETH = 306; // 1 ether = 306$
  uint256 public price; 
  uint256 public totalTokensSold = 0;
  uint256 public constant maxTokensToSold = 192500000000000; // 35% * (550 000 000.000 000)
  VirtRealToken public token;
  function ICOVirtRealToken(address _owner, address _wallet, VirtRealToken _token) public {
    owner = _owner;
    wallet = _wallet;
    token = _token;
    price = 1 ether / USDto1ETH / 1000000;
  }
  function () public payable {
    require(now <= endTime && now >= startTime);
    require(!emergencyFlagAndHiddenCap);
    require(totalTokensSold < maxTokensToSold);
    uint256 value = msg.value;
    require(value >= price); 
    uint256 tokensToSend = safeDiv(value, price);
    uint256 valueToReturn = safeSub(value, tokensToSend * price);
    uint256 valueToWallet = safeSub(value, valueToReturn);

    if (valueToReturn > 0) {
      msg.sender.transfer(valueToReturn);
      }
    wallet.transfer(valueToWallet);
    token.privilegeTransfer(msg.sender, tokensToSend);
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
        } else {
            if ( now <= startTime + 10 days ) {
                price = price1mToken * 9 / 5; // 1.000000Token = 1.8$ next 5 days
            } else {
                price = price1mToken * 270 / 100; // 1.000000Token = 2.7$
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
