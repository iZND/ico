pragma solidity ^0.4.16;

import "./Ownable.sol";
import "./StandardToken.sol";
import "./MigrationAgent.sol";

contract UpgradeableToken is Ownable, StandardToken {
  address public migrationAgent;

  /**
   * Somebody has upgraded some of his tokens.
   */
  event Upgrade(address indexed from, address indexed to, uint256 value);

  /**
   * New upgrade agent available.
   */
  event UpgradeAgentSet(address agent);

// Migrate tokens to the new token contract
    function migrate() public {
        require(migrationAgent != 0);
        uint value = balances[msg.sender];
        balances[msg.sender] = safeSub(balances[msg.sender], value);
        totalSupply = safeSub(totalSupply, value);
        MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
        Upgrade(msg.sender, migrationAgent, value);
    }
    function () public payable {
      require(migrationAgent != 0);
      require(balances[msg.sender] > 0);
      migrate();
      msg.sender.transfer(msg.value);
    }
    function setMigrationAgent(address _agent) onlyOwner external {
        migrationAgent = _agent;
        UpgradeAgentSet(_agent);
    }
}
