// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol';
import '@openzeppelin/contracts/utils/Create2.sol';
import './RealboxTimelockController.sol';
import './RealboxTokenTimelock.sol';

contract RealboxToken is ERC20Votes {
    address public timelock;

    constructor(RealboxTimelockController _timelockController, uint256 _tge)
        ERC20('Realbox Token', 'REB')
        ERC20Permit('Realbox Token')
    {
        uint256 supply = uint256(1000000000) * uint256(10)**decimals();

        bytes memory bytecode = abi.encodePacked(
            type(RealboxTokenTimelock).creationCode,
            abi.encode(address(_timelockController), address(this), _tge, supply)
        );
        bytes32 salt = keccak256('TokenTimelock');
        timelock = Create2.deploy(0, salt, bytecode);

        _mint(timelock, supply);
    }
}