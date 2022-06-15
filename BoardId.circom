pragma circom 2.0.3;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";
include "circomlib/bitify.circom";
include "circomlib/binsum.circom";
include "circomlib/mimcsponge.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template BoardId () {
    signal input hasSpy[10][10];
    signal input salt;
    signal output boardId;
    
    // constraint that board has 4 spy placed
    var spyCount = 0;
    var boardBitstring = 0;
    for (var i = 0; i < 10; i++ ){
        for (var j = 0; j < 10; j++){
            spyCount += hasSpy[i][j];
            boardBitstring += 2 ** (10 * i + j) * hasSpy[i][j];
            //constraint that hasSpy has either 1 or 0
            hasSpy[i][j] * (hasSpy[i][j] - 1) === 0;

        }
    }
    log(boardBitstring);
    spyCount === 4;

    component hash = MiMCSponge(2, 220, 1);
    hash.ins[0] <== boardBitstring;
    hash.ins[1] <== salt;
    hash.k <== 0;

    boardId <== hash.outs[0];

    


}

component main = BoardId ();

/* INPUT = {
    "hasSpy": [[0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,1,0],
                [0,0,0,1,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,1,0,0,0,0],
                [0,1,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0]],
    "salt": "123456"
} */