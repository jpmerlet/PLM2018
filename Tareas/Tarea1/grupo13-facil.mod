param N;
param num_jaulas;
param B {1..N,1..N};
param declaracion {1..num_jaulas,1..2};

set declaracion_0:={i in {1..num_jaulas}: declaracion[i,2]=0}
set declaracion_1:={i in {1..num_jaulas}: declaracion[i,2]=1}
set declaracion_2:={i in {1..num_jaulas}: declaracion[i,2]=2}
set declaracion_3:={i in {1..num_jaulas}: declaracion[i,2]=3}
set declaracion_4:={i in {1..num_jaulas}: declaracion[i,2]=4}

var x {1..N,1..N,1..N} binary;
# unicidad en cada entrada de la solucion
s.t. unicidad {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} x[i,j,k] =1

# restricciones filas
s.t. fila {(i,k) in {1..N} cross {1..N}}: sum {j in {1..N}} x[i,j,k]=1

# restricciones columnas
s.t. columna {(j,k) in {1..N} cross {1..N}}: sum {i in {1..N}} x[i,j,k]=1

# restricciones de tipo 1
s.t. suma { i in  declaracion_1}: sum {(p,j,h) in {1..N} cross {1..N} cross {1..N}: B[p,j]=i} x[p,j,h]*h =declaracion[i,1];

# restriccion de tipo 0
s.t. igualdad {i in declaracion_0}: card({(p,j) in {1..N} cross {1..N}: B[p,j]=i})=1 and sum {(p,j) in {1..N} cross {1..N}: B[p,j]=i} x[p,j,declaracion[i,1]]=1;

# restriccion de tipo 2
#s.t. resta {i in declaracion_2}: card({(p,j) in {1..N} cross {1..N}: B[p,j]=i})=2 and 

# restriccion de tipo 3
#s.t. producto {i in declaracion_3}: prod {(p,j,k) in {1..N} cross {1..N} cross {1..N}: B[p,j]=i} x[i,j,k]*k=declaracion[i,1];

# restriccion de tipo 4
#s.t. division {i in declaracion_4}: card({(p,j) in {1..N} cross {1..N}: B[p,j]=i})=2 and 
