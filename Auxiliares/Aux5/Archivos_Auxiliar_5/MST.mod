set V ordered;
param n := card {V};
set E within {i in V, j in V: ord(i)<ord(j)};
param m;
set M := {1..m};
set S {M};

param w {E};

var x {E} binary;


minimize peso : sum {(i,j) in E} w[i,j]*x[i,j];
s.t. numeroElem : sum {(i,j) in E} x[i,j] = n-1;
s.t. cortes {k in M : card{S[k]}>0 and card{S[k]}<n} : sum{(i,j) in E : (i in S[k] and j in (V diff S[k])) or (i in (V diff S[k]) and j in S[k])}x[i,j]>=1 ;
