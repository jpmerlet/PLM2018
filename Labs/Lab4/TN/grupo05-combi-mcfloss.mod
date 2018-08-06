## Archivo (grupo05-combi-mcfloss.mod). Entregado por grupo 05: JP Donoso Emir Chacra ##
param n;
set V:= {1..n};
set A within V cross V;
param n_d;
param s{1..n_d}; 
param t{1..n_d}; 
param d{1..n_d}; 
param loss{1..n_d};
param c{A}; 
param u{A};

set K:= {1..n_d};

### Datos usados para generacion de columnas

param n_p;         		# numero de caminos usados
set P := 1..n_p;		# caminos actuales (columnas)
set Path {P} within A;  # cada camino es un conjunto de arcos

param servicio {P};		# Servicio[p] guarda el servicio (k en K) asociado. 
param costocamino {P};  # Costo del camino p-esimo

param beta {K};  		# parametro auxiliar util para problema de pricing
param iter default 0;   # Numero de iteraciones (nuevas columnas agregadas)
param flag default 0;   # Indica si se encontro una nueva columna para agregar.

#-----------------
# MASTER PROBLEM
#-----------------

var y {P} >= 0;
var q {K} >= 0;

minimize CostoTotalCaminos: sum {k in K} sum {p in P: servicio[p]==k} ( sum {(i,j) in Path[p]} c[i,j])*y[p] +  sum{k in K} loss[k]*q[k];

s.t. CapacidadCaminos {(i,j) in A}: sum {k in K} sum {p in P: servicio[p]==k and ((i,j) in Path[p])} y[p] <= u[i,j];
s.t. DemandaCaminos {k in K}: sum {p in P: servicio[p]==k}y[p] + q[k]  = d[k];

#-----------------
# PRICING PROBLEM
#-----------------
# Escriba el problema de camino mas corto para un par de nodos
# "origen" y "destino" con funcion de costo arbitrario "g"

param origen;
param destino;
param g {A} default 1;
param distancia {V};
param predecesor {V};
param aux;
set Q within V;
set minimos ordered;
set camino within A;

# Declarar problemas

problem master:  y, q, CostoTotalCaminos, CapacidadCaminos, DemandaCaminos; 