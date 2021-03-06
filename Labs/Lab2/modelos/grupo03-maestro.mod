## Archivo (grupo03-maestro.mod). Entregado por Grupo (03): (Juan Donoso Camila Zarate) ##
param n integer, > 2; # Numero de nodos.
set V:= {1..n};
set E:= {(i,j) in V cross V: i<>j};
param c {E}; #costos
param numerocortes integer, >=0;

set CORTE {1..numerocortes} within V;
var x {(i,j) in E} >=0, binary; #eliminaremos la parte binaria despues.

minimize LargoTour: sum {(i,j) in E} c[i,j]*x[i,j];

subject to GradoSalida {i in V}: sum {(p,j) in E: p=i} x[p,j] = 1;
subject to GradoEntrada {i in V}: sum {(p,j) in E: j=i} x[p,j] = 1;

subject to DesigualdadCorte {k in 1..numerocortes: card(CORTE[k])<n and 1 in CORTE[k] and card(CORTE[k])>=1}: sum {(i,j) in E: (i in CORTE[k] and j not in CORTE[k])} x[i,j] >= 1;