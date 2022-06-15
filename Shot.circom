pragma circom 2.0.3;

include "circomlib/poseidon.circom";
include "circomlib/mimcsponge.circom";
include "circomlib/comparators.circom";
include "circomlib/gates.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Shot () {
    signal input hasSpy[10][10];
    signal input salt;
    signal input boardId;
    signal input shotRow;
    signal input shotCol;

    signal output response;

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

    boardId === hash.outs[0];

    /*
    component isEq[10][10][2];
    var count = 0;
    for(var i = 0; i < 10; i++){
        for(var j = 0; j < 10; j++){
            isEq[i][j][0] = IsEqual();
            isEq[i][j][0].in[0] <== i;
            isEq[i][j][0].in[1] <== shotRow;
            isEq[i][j][1] = IsEqual();
            isEq[i][j][1].in[0] <== j;
            isEq[i][j][1].in[1] <== shotCol;

        }
    }
    */

    /*
    var count = 0;
    component isEq[10][10];
    component lessth[10][10];
    signal isSelected[10][10];
    signal isSelectedAndHasShip[10][10];
    component isZ1;
    
    
    for (var i = 0 + 1; i < 10; i++) {
        count += hasSpy[2][i];
    }
    isZ1 = IsZero();
    isZ1.in <== count;
    response <== isZ1.out;
    */

    /*
    //right
    for (var i = 0 ; i < 10; i++){
        for (var j = 0; j < 10; j++){
            isEq[i][j] = IsEqual();
            isEq[i][j].in[0] <== i;
            isEq[i][j].in[1] <== shotRow;
            lessth[i][j] = LessThan(3);
            lessth[i][j].in[0] <== shotCol;
            lessth[i][j].in[1] <== j;
            isSelected[i][j] <== isEq[i][j].out * lessth[i][j].out; 
            isSelectedAndHasShip[i][j] <== isSelected[i][j] * hasSpy[i][j];
            count += isSelectedAndHasShip[i][j];
        }
    }

    log(count);
    */

    
    var count[4] = [0,0,0,0];
    component isEq[10][10][4];
    component lessThan[10][10][4];
    signal isSelected[10][10][4];
    signal isSelectedAndHasSpy[10][10][4];
    for (var i = 0; i < 10; i++){
        for(var j = 0; j < 10; j++) {
            
            //get count of spy horizontal right
            isEq[i][j][0] = IsEqual();
            isEq[i][j][0].in[0] <== i;
            isEq[i][j][0].in[1] <== shotRow;

            lessThan[i][j][0] = LessThan(4);
            lessThan[i][j][0].in[0] <== shotCol;
            lessThan[i][j][0].in[1] <== j;

            //both condition must be true
            isSelected[i][j][0] <== isEq[i][j][0].out * lessThan[i][j][0].out;
            isSelectedAndHasSpy[i][j][0] <== isSelected[i][j][0] * hasSpy[i][j];
            count[0] += isSelectedAndHasSpy[i][j][0];

            
            //get count of spy horizontal left
            isEq[i][j][1] = IsEqual();
            isEq[i][j][1].in[0] <== i;
            isEq[i][j][1].in[1] <== shotRow;

            lessThan[i][j][1] = LessThan(4);
            lessThan[i][j][1].in[0] <== j;
            lessThan[i][j][1].in[1] <== shotCol;

            //both condition must be true
            isSelected[i][j][1] <== isEq[i][j][1].out * lessThan[i][j][1].out;
            isSelectedAndHasSpy[i][j][1] <== isSelected[i][j][1] * hasSpy[i][j];
            count[1] += isSelectedAndHasSpy[i][j][1];


            //get count of spy vertical up
            isEq[i][j][2] = IsEqual();
            isEq[i][j][2].in[0] <== j;
            isEq[i][j][2].in[1] <== shotCol;

            lessThan[i][j][2] = LessThan(4);
            lessThan[i][j][2].in[0] <== i;
            lessThan[i][j][2].in[1] <== shotRow;

            //both condition must be true
            isSelected[i][j][2] <== isEq[i][j][2].out * lessThan[i][j][2].out;
            isSelectedAndHasSpy[i][j][2] <== isSelected[i][j][2] * hasSpy[i][j];
            count[2] += isSelectedAndHasSpy[i][j][2];


            //get count of spy vertical down
            isEq[i][j][3] = IsEqual();
            isEq[i][j][3].in[0] <== j;
            isEq[i][j][3].in[1] <== shotCol;

            lessThan[i][j][3] = LessThan(4);
            lessThan[i][j][3].in[0] <== shotRow;
            lessThan[i][j][3].in[1] <== i;

            //both condition must be true
            isSelected[i][j][3] <== isEq[i][j][3].out * lessThan[i][j][3].out;
            isSelectedAndHasSpy[i][j][3] <== isSelected[i][j][3] * hasSpy[i][j];
            count[3] += isSelectedAndHasSpy[i][j][3];
            
        }
    }
    log(count[0]);
    log(count[1]);
    log(count[2]);
    log(count[3]);





    /*
    var count = 0;
    var count2 = 0;
    var count3 = 0;
    var count4 = 0;
    //left
    for (var i = shotCol - 1 ; i >= 0; i--){
        if(hasSpy[shotRow][i] == 1){
            count = 1;
        }
    }
    log(8008135);
    //right
    for (var i = shotCol + 1; i < 10; i++) {
        if(hasSpy[shotRow][i] == 1){
            count2 = 1;
        }
    }
    
    //top
    for (var i = shotRow - 1; i >= 0; i--) {
        if(hasSpy[i][shotCol] == 1){
            count3 = 1;
        }
    }

    //bottom
    for (var i = shotRow + 1; i < 10; i++) {
        if(hasSpy[i][shotCol] == 1){
            count4 = 1;
        }
    }
    */

    /*
    var k = shotRow;
    //upper right diagonal
    for(var i = shotCol ; i >=0 ; i--){
        for(var j = k; j < 1 + k; j++){
            log(hasSpy[i][j]);
        }
        k++;
    }
    */
   

}

component main = Shot();

/* INPUT = {
    "hasSpy": [[0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,1,0,0,0,0,1,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,1,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0],
                [0,0,0,1,0,0,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0]],
    "salt": "123456",
    "boardId": "13400440098403500820276529785580844669244081612900023152191161770654747719450",
    "shotRow": "2",
    "shotCol": "5"
} */