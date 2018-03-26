## Archivo (jigsaw-donoso.mod) ##
param N;
param Q {1..N,1..N}; # datos prescritos
param B {1..N,1..N}; # datos zonas cuadrantes

# definicion de variables y conjuntos
set indices:= {1..N} cross {1..N} cross {1..N};
set tabla:= {(i,j,k) in indices: Q[i,j] = k};
set Cuadrantes {K in {1..N}}:= {(i,j) in {1..N} cross {1..N}: B[i,j]=k}
var x {indices} binary;



# restricciones para que cada casilla tenga solo un numero
subject to M {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} = 1;

# restricciones para las filas
subject to fila {(i,k) in {1..N} cross {1..N}} : sum {j in {1..N}} x[i,j,k] = 1;

#restricciones para las columnas
subject to columna {(j,k) in {1..N} cross {1..N}} : sum {i in {1..N}} x[i,j,k] = 1;

# restricciones para los cuadrantes
subject to cuadrante {(k,K) in {1..N} cross {1..N} }: sum {(i,j) in Cuadrantes[K]} x[i,j,k] = 1;

# restricciones relativas a la tabla Q
subject to tabla_inicial {(i,j,k) in tabla}: x[i,j,k] = 1;


