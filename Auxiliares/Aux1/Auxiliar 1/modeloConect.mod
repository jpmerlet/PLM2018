set V ordered;
param n := card {V};
set E within {i in V, j in V: ord(i)<ord(j)};
param m := card {E};

set VV := 0 .. (2**n - 1);
set S {k in VV} := {i in V: (k div 2**(ord(i)-1)) mod 2 = 1};


param w {E};

var x {E} integer >=0;


minimize peso : sum {(i,j) in E} w[i,j]*x[i,j];
s.t. numeroElem : sum {(i,j) in E} x[i,j] = n-1 ;
s.t. cotaSup {(i,j) in E}: x[i,j]<=1;
s.t. cortes {k in VV : card{S[k]}>0 and card{S[k]}<n} :
sum{(i,j) in E : (i in S[k] and j in (V diff S[k])) or (i in (V diff S[k]) and j in S[k])}x[i,j]>=1 ;
