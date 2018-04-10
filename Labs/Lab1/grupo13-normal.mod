## grupo13-normal.mod ##

param N;
param num_jaulas;
param B {1..N,1..N};
param declaracion {1..num_jaulas,1..2};
param M {1..N,1..N};

set declaracion_0:={i in {1..num_jaulas}: declaracion[i,2]=0};
set declaracion_1:={i in {1..num_jaulas}: declaracion[i,2]=1};
set declaracion_2:={i in {1..num_jaulas}: declaracion[i,2]=2};
set declaracion_3:={i in {1..num_jaulas}: declaracion[i,2]=3};
set declaracion_4:={i in {1..num_jaulas}: declaracion[i,2]=4};

var x {1..N,1..N,1..N} binary;
var aux {j in {1..num_jaulas}} binary;

# unicidad en cada entrada de la solucion
s.t. unicidad {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} x[i,j,k] =1;

# restricciones filas
s.t. fila {(i,k) in {1..N} cross {1..N}}: sum {j in {1..N}} x[i,j,k]=1;

# restricciones columnas
s.t. columna {(j,k) in {1..N} cross {1..N}}: sum {i in {1..N}} x[i,j,k]=1;

# restricciones de tipo 1
s.t. suma { i in  declaracion_1}: sum {(p,j,h) in {1..N} cross {1..N} cross {1..N}: B[p,j]=i} x[p,j,h]*h =declaracion[i,1];

# restriccion de tipo 0
s.t. igualdad {i in declaracion_0}: card({(p,j) in {1..N} cross {1..N}: B[p,j]=i})=1 and sum {(p,j) in {1..N} cross {1..N}: B[p,j]=i} x[p,j,declaracion[i,1]]=1;

# restriccion para tipo 2
s.t. resta {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross {1..num_jaulas}: (i1,j1) in {(p,z) in {1..N} cross {1..N}: declaracion[j,2]=2 and B[p,z] = j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: declaracion[j,2]=2 and B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))} : sum {k in {1..N}} x[i1,j1,k]*k -sum {k in {1..N}} x[i2,j2,k]*k = declaracion[j,1] -2*aux[j]*declaracion[j,1];

# restriccion para tipo 3
s.t. producto {i in declaracion_3}: sum {(p,z) in {1..N} cross {1..N}: B[p,z]=i} sum {k in {1..N}} x[p,z,k]*log(k) = log(declaracion[i,1]);