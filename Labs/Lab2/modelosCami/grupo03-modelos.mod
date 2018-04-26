

## variables generales ##

param n integer, > 2; # Numero de nodos.
set V:= {1..n};
set E:= {(i,j) in V cross V: i<>j};
param c {E}; #costos
var x {(i,j) in E} >=0, binary;
set J := {2..n};

## problema ##

minimize LargoTour: sum {(i,j) in E} c[i,j]*x[i,j];

## restricciones generales ##

subject to GradoSalida {i in V}: 
	sum {(p,j) in E: p=i} x[p,j] = 1;
	
subject to GradoEntrada {i in V}: 
	sum {(p,j) in E: j=i} x[p,j] = 1;


### DFJ ###

## maestro

# variables, conjuntos

param numerocortes integer, >=0;

set CORTE {1..numerocortes} within V;

# restricciones

subject to DesigualdadCorte {k in 1..numerocortes: 
	card(CORTE[k])<n and 1 in CORTE[k] and card(CORTE[k])>=1}: sum {(i,j) in E: (i in CORTE[k] and j not in CORTE[k])} x[i,j] >= 1;
	
## corte

# variables y conjuntos

var y {(i,j) in E}>=0;
var pi {i in V}>=0;
param s in V, default 1; #origen 
param t in V, default 2; #destino

# problema

minimize ValorCorte: sum {(i,j) in E} y[i,j]*x[i,j];

# restricciones

subject to restriccPi: 
	pi[s] - pi[t] >= 1;
	
subject to restriccVar 
	{(i,j) in E}: y[i,j] >= pi[i]-pi[j];
		
	
### MTZ ###

# variables y conjuntos

var u{V} >= 1, integer;

# restricciones

s.t. restMTZ1 {i in J}:
	u[i] <= n-1;

s.t. restMTZ2 {(i,j) in E: i != 1 && j != 1}:
	(u[i] - u[j] + 1) <= n*(1-x[i,j]);

s.t. restMTZ3 {(i,j) in E: i != 1 && j != 1}:
	(u[i] - u[j] + 1) >= -n*(1-x[i,j]);


### WONG ###

# variables y conjuntos

var f{E cross J} >= 0;
var g{E cross J} >= 0;

# restricciones

s.t. restWONG1 {k in J}:
	sum{j in J} f[1,j,k] - sum{i in J} f[i,1,k] = 1;
	
s.t. restWONG2 {k in J}:
	sum{j in V: j != k} f[k,j,k] - sum{i in V: i != k} f[i,k,k] = -1;
	
s.t. restWONG3 {k in J, i in J: i != k}:
	sum{(i,j) in E} f[i,j,k] - sum{(j,i) in E} f[j,i,k] = 0;
	
s.t. restWONG4 {k in J}:
	sum{j in J} g[1,j,k] - sum{i in J} g[i,1,k] = -1;
	 
s.t. restWONG5 {k in J}:
	sum{j in V: j != k} g[k,j,k] - sum{i in V: i != k} g[i,k,k] = 1;

s.t. restWONG6 {k in J, i in J: i != k}:
	sum{(i,j) in E} g[i,j,k] - sum{(j,i) in E} g[j,i,k] = 0;

s.t. restWONG7 {(i,j) in E, k in J}:
	f[i,j,k] <= x[i,j];

s.t. restWONG8 {(i,j) in E, k in J}:
	g[i,j,k] <= x[i,j];

