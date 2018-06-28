param alpha>=0, default 1;
set F;
set C;
param open {F} >=0;
param conn {C,F} >=0;

var x {C,F} >=0;
var y {F} binary;

minimize costototal: sum {f in F} open[f]*y[f] + alpha * sum {(c,f) in C cross F} conn[c,f]*x[c,f];

subject to escoger_fab {(c,f) in C cross F}: x[c,f] <= y[f];
subject to una_fab {c in C}: sum {f in F} x[c,f] = 1;
