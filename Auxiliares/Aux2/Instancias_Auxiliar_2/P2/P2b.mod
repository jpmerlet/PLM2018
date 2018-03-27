set S;
param lambda;

var u {S} binary;
var v {S} binary;
var alpha binary;

s.t. restriccion1: sum {s in S} u[s]=1;
s.t. restriccion2: sum {s in S} v[s]=1;
s.t. restriccion3: sum {s in S} s*u[s]-s*v[s] = lambda-2*alpha*lambda;

