## Archivo (sudoku-donoso.mod) ##
param n;
param N:=n*n;
param Q {1..N, 1..N}; #datos prescritos

# definicion de conjuntos y variables
set indices:= {1..N} cross {1..N} cross {1..N};
set cuadrantes:=  
var x {indices} binary;

# restricciones para que una casilla haya solo un numero
subject to M {(i,j) in {1..N} cross {1..N}} : sum {k in {1..N}} = 1; 

# restricciones para las filas
subject to fila {(i,k) in {1..N} cross {1..N}} : sum {j in {1..N}} = 1;

#restricciones para las columnas
subject to columna {(j,k) in {1..N} cross {1..N}} : sum {i in {1..N}} = 1;

# restricciones para los cuadrantes
subject to cuadrante {(i,j) in {1..N} cross {1..N}}: 