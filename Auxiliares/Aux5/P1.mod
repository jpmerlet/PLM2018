set V ordered;
set E within {(i,j) in V cross V};
param w {E};
param n:= card(V);
var x {(i,j) in E} binary;
param m;
param S {0..m};

minimize Costo: sum {(i,j) in E} w[i,j]*x[i,j];

subject to arbol: sum {(i,j) in E} x[i,j] = n-1;

subject to conexidad {conjunto in {0..m}}: sum { (i,j) in E: (j in S[conjunto] and i not in )}