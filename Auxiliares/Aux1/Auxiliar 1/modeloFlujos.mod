set V ordered;
param n := card {V};
set E within {i in V, j in V: ord(i)<ord(j)};
param m := card {E};
set A := {(i,j) in V cross V : (i,j) in E or (j,i) in E};

param w {E};

var x {E} >=0;
var y {A} integer ;
var f {A} >=0;

minimize peso : sum {(i,j) in E} w[i,j]*x[i,j];
s.t. numeroElem : sum {(i,j) in E} x[i,j] = n-1 ;
s.t. duplicacion {(i,j) in E}: y[i,j]+y[j,i] = x[i,j];
s.t. conservacion {v in V diff {1}}: sum{(v,i) in A} f[v,i] - sum{(i,v) in A} f[i,v] = 1;
s.t. cotaSup {(i,j) in A}: f[i,j] <= (n-1)*y[i,j];
 