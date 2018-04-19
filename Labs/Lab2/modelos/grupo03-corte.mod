## Archivo (grupo03-corte.mod). Entregado por Grupo (03): (Juan Donoso Camila Zarate) ##
var y {(i,j) in E}>=0;
var pi {i in V}>=0;
param s in V, default 1; #origen 
param t in V, default 2; #destino

minimize ValorCorte: sum {(i,j) in E} y[i,j]*x[i,j];

subject to restriccPi: pi[s] - pi[t] >= 1;
subject to restriccVar {(i,j) in E}: y[i,j] >= pi[i]-pi[j];