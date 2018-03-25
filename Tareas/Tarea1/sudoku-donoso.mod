## Archivo (sudoku-donoso.mod) ##
param n;
param N:=n*n;
param Q {1..N, 1..N}; #datos prescritos

# definicion de conjuntos y variables
set indices:= {1..N} cross {1..N} cross {1..N};
set indices_cuadrantes:= {0..n-1} cross {0..n-1};
# set cuadrantes {(i,j) in {0..n-1} cross {0..n-1}}:= {(n*i+a,n*j+b):};
set cuadrantes {(i,j) in {0..n-1} cross {0..n-1}}:=union {a in {1..n},b in {1..n}} {(n*i+a,n*j+b)};
set tabla:= {(i,j,k) in indices: Q[i,j] = k};
var x {indices} binary;

# restricciones para que una casilla haya solo un numero
subject to M {(i,j) in {1..N} cross {1..N}} : sum {k in {1..N}} x[i,j,k] = 1;

# restricciones para las filas
subject to fila {(i,k) in {1..N} cross {1..N}} : sum {j in {1..N}} x[i,j,k] = 1;

#restricciones para las columnas
subject to columna {(j,k) in {1..N} cross {1..N}} : sum {i in {1..N}} x[i,j,k] = 1;

# restricciones para los cuadrantes
subject to cuadrante {(k,i,j) in {1..N} cross {0..n-1} cross {0..n-1}}: sum {(p,q) in cuadrantes[i,j]} x[p,q,k] = 1;

# restricciones relativas a la tabla Q
subject to tabla_inicial {(i,j,k) in tabla}: x[i,j,k] = 1;