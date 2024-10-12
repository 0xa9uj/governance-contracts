Script ran successfully.

== Logs ==
  Factory addresss: 0x03F7f254cC7442045cbBbC16b268cbF87608659D

## Setting up 1 EVM.
==========================
Simulated On-chain Traces:

  [4156919] → new MyGovernor@0xAe4163D0cABE4A513BdBEcb26Bf6a69Beb0b4824
    ├─ emit Initialized(version: 18446744073709551615 [1.844e19])
    └─ ← [Return] 20643 bytes of code

  [3143543] → new GovernanceBeaconProxyFactory@0x03F7f254cC7442045cbBbC16b268cbF87608659D
    ├─ [179041] → new UpgradeableBeacon@0xb23D369B368BB305cfcA4Ce707d19fa5A850eb95
    │   ├─ emit OwnershipTransferred(previousOwner: 0x0000000000000000000000000000000000000000, newOwner: 0x641BB2596D8c0b32471260712566BF933a2f1a8e)
    │   ├─ emit Upgraded(implementation: MyGovernor: [0xAe4163D0cABE4A513BdBEcb26Bf6a69Beb0b4824])
    │   └─ ← [Return] 644 bytes of code
    └─ ← [Return] 14533 bytes of code


==========================

Chain 84532

Estimated gas price: 0.281739232 gwei

Estimated total gas used for script: 10389638

Estimated amount required: 0.002927168630878016 ETH

==========================

##### base-sepolia
✅  [Success]Hash: 0xe9edf0d2a8b1fce18568fdd6b00b175ce0cffb090a2809991c80119b0874553c
Contract Address: 0xAe4163D0cABE4A513BdBEcb26Bf6a69Beb0b4824
Block: 16499028
Paid: 0.000641606862887875 ETH (4543625 gas * 0.141210347 gwei)


##### base-sepolia
✅  [Success]Hash: 0x5017928f1c24878967068534d5fc607331e14badcaeffbc4a2c72c7c1650778a
Contract Address: 0x03F7f254cC7442045cbBbC16b268cbF87608659D
Block: 16499028
Paid: 0.000486950466646535 ETH (3448405 gas * 0.141210347 gwei)

✅ Sequence #1 on base-sepolia | Total Paid: 0.00112855732953441 ETH (7992030 gas * avg 0.141210347 gwei)
                                                                                                                                                           

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
##
Start verification for (3) contracts
Start verifying contract `0xAe4163D0cABE4A513BdBEcb26Bf6a69Beb0b4824` deployed on base-sepolia

Submitting verification for [src/governance/Governance.sol:MyGovernor] 0xAe4163D0cABE4A513BdBEcb26Bf6a69Beb0b4824.
Submitted contract for verification:
        Response: `OK`
        GUID: `9a5bekxqhvissi29krffrzmgky9jztvhtd2smtewekcnmvvtuw`
        URL: https://sepolia.basescan.org/address/0xae4163d0cabe4a513bdbecb26bf6a69beb0b4824
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
Start verifying contract `0x03F7f254cC7442045cbBbC16b268cbF87608659D` deployed on base-sepolia

Submitting verification for [src/GovernanceBeaconProxyFactory.sol:GovernanceBeaconProxyFactory] 0x03F7f254cC7442045cbBbC16b268cbF87608659D.
Submitted contract for verification:
        Response: `OK`
        GUID: `cl1f6bnprgcegp1brfganscks6wykqtgp4hahm8repcxi14enk`
        URL: https://sepolia.basescan.org/address/0x03f7f254cc7442045cbbbc16b268cbf87608659d
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
Start verifying contract `0xb23D369B368BB305cfcA4Ce707d19fa5A850eb95` deployed on base-sepolia

Submitting verification for [lib/openzeppelin-contracts/contracts/proxy/beacon/UpgradeableBeacon.sol:UpgradeableBeacon] 0xb23D369B368BB305cfcA4Ce707d19fa5A850eb95.
Submitted contract for verification:
        Response: `OK`
        GUID: `5rck8jafezfq41pwqd7rudyrwygesr3icakbewvzbty8lpkb8n`
        URL: https://sepolia.basescan.org/address/0xb23d369b368bb305cfca4ce707d19fa5a850eb95
Contract verification status:
Response: `NOTOK`
Details: `Pending in queue`
Contract verification status:
Response: `OK`
Details: `Pass - Verified`
Contract successfully verified
All (3) contracts were verified!
