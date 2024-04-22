// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Script} from "forge-std/Script.sol";
import {Sphinx} from "@sphinx-labs/contracts/SphinxPlugin.sol";

contract Deploy is Sphinx, Script {
    function configureSphinx() public override {
        sphinxConfig.owners = [YOUR_EOA_ADDRESS];
        sphinxConfig.orgId = YOUR_SPHINX_ORG_ID_STRING;
        sphinxConfig.threshold = 1;
        sphinxConfig.projectName = "Multicaller";
    }

    function run() public sphinx {
        bytes32 multicallerSalt = 0x0000000000000000000000000000000000000000ef4834b251a91000a916248a;
        bytes memory multicallerInitCode = vm.envBytes("MULTICALLER_INITCODE");
        deployCreate2(multicallerSalt, multicallerInitCode);

        bytes32 multicallerWithSenderSalt =
            0x00000000000000000000000000000000000000006bfa48b413e5be01a8e9fe0c;
        bytes memory multicallerWithSenderInitCode = vm.envBytes("MULTICALLER_WITH_SENDER_INITCODE");
        deployCreate2(multicallerWithSenderSalt, multicallerWithSenderInitCode);

        bytes32 multicallerWithSignerSalt =
            0x0000000000000000000000000000000000000000d7eebd756f8ae3022dc33bdb;
        bytes memory multicallerWithSignerInitCode = vm.envBytes("MULTICALLER_WITH_SIGNER_INITCODE");
        deployCreate2(multicallerWithSignerSalt, multicallerWithSignerInitCode);
    }

    function deployCreate2(bytes32 salt, bytes memory initCode) internal {
        address c2f = 0x0000000000FFe8B47B3e2130213B802212439497;
        require(c2f.code.length > 0, "Create2 factory is not deployed");

        (, bytes memory retdata) = c2f.staticcall(
            abi.encodeWithSignature("findCreate2Address(bytes32,bytes)", salt, initCode)
        );
        address addr = abi.decode(retdata, (address));

        // The `findCreate2Address` function returns `address(0)` if the contract is already
        // deployed, so we only attempt to deploy the contract if the returned address isn't
        // `address(0)`.
        if (addr != address(0)) {
            (bool success,) =
                c2f.call(abi.encodeWithSignature("safeCreate2(bytes32,bytes)", salt, initCode));
            require(success, "Deployment failed");
        }
    }
}
