pragma solidity ^0.4.17;

import "../deploy/AbstractRecoverer.sol";
import "../ens/ENS.sol";

/**
 * @title GitPivotRecoverer
 * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH) 
 * @dev Common Recoverer for GitPivot. 
 * address resolved from ens recover.gitpivot.eth can set new system.
 */
contract StatusRecoverer is BasicSystemStorage {
    
     /**
     * @dev will be callable in emergency state of RecorverableSystem
     */
    function recoverSystem(address newSystem) public {
        require(msg.sender == consensusContract());
        system = newSystem;
    }
    
     /**
     * @dev resolves recoverer.statusnet.eth ->  this method trust that ENS is safe.
     */
    function consensusContract() public constant returns(address) {
        bytes32 node = 0x0; //recover.statusnet.eth //bytes32 node = keccak256("recoverer", keccak256("gitpivot", keccak256("eth")));
        address ensAddress = 0x314159265dD8dbb310642f98f50C066173C1259b;
        if (codeSize(ensAddress) == 0) {
           ensAddress = 0x112234455C3a32FD11230C42E7Bccd4A84e02010;    
        }
        return ENS(ensAddress).resolver(node).addr(node);
    }

    function codeSize(address _addr) internal constant returns(uint size) {
        if (_addr == 0) { 
            return 0; 
        }
        assembly {
            size := extcodesize(_addr)
        }
    }

}