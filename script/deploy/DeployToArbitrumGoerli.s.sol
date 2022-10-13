// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

import { Script } from "forge-std/Script.sol";
import { IInbox } from "@arbitrum/nitro-contracts/src/bridge/IInbox.sol";
import { DeployedContracts } from "../helpers/DeployedContracts.sol";

import { CrossChainExecutorArbitrum } from "../../src/executors/CrossChainExecutorArbitrum.sol";
import { CrossChainRelayerArbitrum } from "../../src/relayers/CrossChainRelayerArbitrum.sol";
import { Greeter } from "../../test/contracts/Greeter.sol";

contract DeployCrossChainRelayerToGoerli is Script {
  address public delayedInbox = 0x4Dbd4fc535Ac27206064B68FfCf827b0A60BAB3f;

  function run() public {
    vm.broadcast();

    new CrossChainRelayerArbitrum(IInbox(delayedInbox), 32000000);

    vm.stopBroadcast();
  }
}

contract DeployCrossChainExecutorToArbitrumGoerli is Script {
  function run() public {
    vm.broadcast();

    new CrossChainExecutorArbitrum();

    vm.stopBroadcast();
  }
}

/// @dev Needs to be run after deploying CrossChainRelayer and CrossChainExecutor
contract SetCrossChainExecutor is DeployedContracts {
  function setCrossChainExecutor() public {
    CrossChainRelayerArbitrum _crossChainRelayer = _getCrossChainRelayerArbitrum();
    CrossChainExecutorArbitrum _crossChainExecutor = _getCrossChainExecutorArbitrum();

    _crossChainRelayer.setExecutor(_crossChainExecutor);
  }

  function run() public {
    vm.broadcast();

    setCrossChainExecutor();

    vm.stopBroadcast();
  }
}

/// @dev Needs to be run after deploying CrossChainRelayer and CrossChainExecutor
contract SetCrossChainRelayer is DeployedContracts {
  function setCrossChainRelayer() public {
    CrossChainRelayerArbitrum _crossChainRelayer = _getCrossChainRelayerArbitrum();
    CrossChainExecutorArbitrum _crossChainExecutor = _getCrossChainExecutorArbitrum();

    _crossChainExecutor.setRelayer(_crossChainRelayer);
  }

  function run() public {
    vm.broadcast();

    setCrossChainRelayer();

    vm.stopBroadcast();
  }
}

contract DeployGreeterToArbitrumGoerli is DeployedContracts {
  function deployGreeter() public {
    CrossChainExecutorArbitrum _crossChainExecutor = _getCrossChainExecutorArbitrum();
    new Greeter(address(_crossChainExecutor), "Hello from L2");
  }

  function run() public {
    vm.broadcast();

    deployGreeter();

    vm.stopBroadcast();
  }
}
