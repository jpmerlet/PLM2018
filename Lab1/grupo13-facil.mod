## grupo 13-facil.mod. Entregado por grupo 13: Pablo Araya - Juan Pablo Donoso

param N;
param num_jaulas;
param B {1..N,1..N};
param declaracion {1..num_jaulas,1..2};
param M {1..N,1..N};

# Conjuntos para cada tipo de jaulas {(k,=),(k,+)}

set declaracion_0:={i in {1..num_jaulas}: declaracion[i,2]=0};
set declaracion_1:={i in {1..num_jaulas}: declaracion[i,2]=1};

var x {1..N,1..N,1..N} binary;

# unicidad en cada entrada de la solucion
s.t. unicidad {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} x[i,j,k] =1;

# restricciones filas
s.t. fila {(i,k) in {1..N} cross {1..N}}: sum {j in {1..N}} x[i,j,k]=1;

# restricciones columnas
s.t. columna {(j,k) in {1..N} cross {1..N}}: sum {i in {1..N}} x[i,j,k]=1;

# restriccion de tipo 0
s.t. igualdad {i in declaracion_0}: card({(p,j) in {1..N} cross {1..N}: B[p,j]=i})=1 and sum {(p,j) in {1..N} cross {1..N}: B[p,j]=i} x[p,j,declaracion[i,1]]=1;

# restricciones de tipo 1
s.t. suma { i in  declaracion_1}: sum {(p,j,h) in {1..N} cross {1..N} cross {1..N}: B[p,j]=i} x[p,j,h]*h =declaracion[i,1];