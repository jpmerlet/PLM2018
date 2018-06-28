set F;
set C;
param open {F} >=0;
param conn {C,F} >=0;

var x {C,F} binary;
var y {F} binary;

minimize costo: sum {f in F} open[f]*y[f] + sum {(c,f) in C cross F} conn[c,f]*x[c,f];

subject to escoger_fab {(c,f) in C cross F}: x[c,f] <= y[f];
subject to una_fab {c in C}: sum {f in F} x[c,f] = 1;
