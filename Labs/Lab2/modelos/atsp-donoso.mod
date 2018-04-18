## Archivo (atsp-donoso.mod) ##
param n integer > 2; # Numero de nodos. set V:= {1..N};
set V := {1..n};
set E:= {(i,j) in V cross V: i<>j};
param c {E}; #costos
var x {(i,j) in E} >=0, binary;

minimize LargoTour: sum {(i,j) in E} c[i,j]*x[i,j];

subject to GradoSalida {i in V}: sum {(p,j) in E: p=i} x[p,j] = 1;
subject to GradoEntrada {i in V}: sum {(p,j) in E: j=i} x[p,j] = 1;

## modelo DFJ ##
set  INDICES := 0..(2**n - 1);
set CONJUNTO {k in INDICES} := {i in V: (k div 2**(i-1)) mod 2 = 1};
subject to subTourDFJ {k in INDICES: card(CONJUNTO[k])>=2 and card(CONJUNTO[k])<=n-1 and 1 not in CONJUNTO[k]}: sum {(i,j) in E: i in CONJUNTO[k] and j in CONJUNTO[k]} x[i,j] <= card(CONJUNTO[k])-1;

## modelo MTZ ##
set INDICES_u := 2..n; 
var u {INDICES_u} >=1;
subject to UperBound {i in INDICES_u}: u[i] <= n-1;
subject to subTourMTZ {(i,j) in E: i<>1 and j<>1}: u[i] - u[j] + (n-1)*x[i,j]<= n-2; 

## modelo Wong ##
var f {(i,j,k) in E cross {2..n}} >= 0;
var g {(i,j,k) in E cross {2..n}} >= 0;

subject to FLUJO_output_f {k in {2..n}}: sum {j in V: (1,j) in E} f[1,j,k] - sum {i in V: (i,1) in E} f[i,1,k] = 1;
subject to FLUJO_input_f {k in {2..n}}: sum {j in V: (k,j) in E} f[k,j,k] - sum {i in V: (i,k) in E} f[i,k,k] = -1;
subject to CONSERVACION_FLUJO_f {(k,p) in {2..n} cross {2..n}: p<>k}: sum {j in V: (p,j) in E} f[p,j,k] - sum {i in V: (i,p) in E} f[i,p,k] = 0;
subject to COTAS_f {(i,j) in E, k in {2..n}}: f[i,j,k] <= x[i,j];

subject to FLUJO_output_g {k in {2..n}}: sum {j in V: (1,j) in E} g[1,j,k] - sum {i in V: (i,1) in E} g[i,1,k] = -1;
subject to FLUJO_input_g {k in {2..n}}: sum {j in V: (k,j) in E} g[k,j,k] - sum {i in V: (i,k) in E} g[i,k,k] = 1;
subject to CONSERVACION_FLUJO_g {(k,p) in {2..n} cross {2..n}: p<>k}: sum {j in V: (p,j) in E} g[p,j,k] - sum {i in V: (i,p) in E} g[i,p,k] = 0;
subject to COTAS_g {(i,j) in E, k in {2..n}}: g[i,j,k] <= x[i,j];

## definicion de problemas ##
problem DFJmodel: x, LargoTour, GradoSalida, GradoEntrada, subTourDFJ;
problem MTZmodel: x, LargoTour, GradoSalida, GradoEntrada, u, UperBound, subTourMTZ;
problem WONGmodel: x, LargoTour, GradoSalida, GradoEntrada, f, g, FLUJO_input_f, FLUJO_output_f, CONSERVACION_FLUJO_f, COTAS_f, FLUJO_output_g, FLUJO_input_g, CONSERVACION_FLUJO_g, COTAS_g;  