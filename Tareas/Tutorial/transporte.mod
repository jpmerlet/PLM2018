# Declarar conjuntos
set ORIG;
set DEST;
set E within ORIG cross DEST; #E es un subconjunto del producto cartesiano.

#  Declarar como parametros los vectores P, Q y la matriz c.
param P {ORIG} >= 0;
param Q {DEST} >= 0;
param c {E} >= 0;

# Agregar una instruccion de control.
check: sum {a in ORIG} P[a] = sum {b in DEST} Q[b];

# Declarar variables.
var x {E} >=0;

#PL
minimize costo_total: sum {(a,b) in E} c[a,b]*x[a,b];
subject to oferta {a in ORIG} : sum {(a,b) in E} x[a,b] = P[a];
subject to demanda {b in DEST} : sum {(a,b) in E} x[a,b] = Q[b];