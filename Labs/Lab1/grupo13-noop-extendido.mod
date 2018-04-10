## grupo13-normal.mod ##
reset;

param N;
param num_jaulas;
param B {1..N,1..N};
param objetivo {1..num_jaulas};
param M:= 100;

# recuperamos los indices de las jaulas de size mayor o igual a 3
set indices_jaulas_3:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})>2};

# recuperamos los indices de las jaulas de size 2
set indices_jaulas_2:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})=2};

# lo mismo para las jaulas de size 1
set indices_jaulas_1:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})=1};

# indices para celdas de size 2 o superior
set indices_jaulas_32:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})>=2};

# variable que codificara el resultado
var x {1..N,1..N,1..N} binary;

# variables auxiliares para suma y producto
var aux_acti_sum {indices_jaulas_32} binary;
var aux_acti_prod {indices_jaulas_32} binary;
var aux_cota_sum {indices_jaulas_32}>=0;
var aux_cota_prod {indices_jaulas_32}>=0;

# variables auxiliares para resta y division
var aux_acti_rest_pos {indices_jaulas_2} binary;
var aux_acti_rest_neg {indices_jaulas_2} binary;
var aux_acti_div_pos {indices_jaulas_2} binary;
var aux_acti_div_neg {indices_jaulas_2} binary;
var aux_cota_rest_pos {indices_jaulas_2}>=0;
var aux_cota_rest_neg {indices_jaulas_2}>=0;
var aux_cota_div_pos {indices_jaulas_2}>=0;
var aux_cota_div_neg {indices_jaulas_2}>=0;

# restricciones para la suma y el producto
# para celdas de size 3
s.t. suma {jaula in indices_jaulas_3}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*k = aux_acti_sum[jaula]*objetivo[jaula]+aux_cota_sum[jaula];
s.t. producto {jaula in indices_jaulas_3}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*log(k) = aux_acti_prod[jaula]*log(objetivo[jaula])+aux_cota_prod[jaula];
s.t. activacionProdSum {j in indices_jaulas_3}: aux_acti_sum[j] + aux_acti_prod[j] = 1;
s.t. cotaSuma {j in indices_jaulas_3}: aux_cota_sum[j] <= M*aux_acti_prod[j];
s.t. cotaProd {j in indices_jaulas_3}: aux_cota_prod[j] <= M*aux_acti_sum[j];


# restricciones para la resta, division, producto y suma
# para celdas de size 2
s.t. restaPos {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross indices_jaulas_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]*k -sum {k in {1..N}} x[i2,j2,k]*k = aux_acti_rest_pos[j]*objetivo[j]+aux_cota_rest_pos[j];
s.t. restaNeg {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross indices_jaulas_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]*k -sum {k in {1..N}} x[i2,j2,k]*k = aux_acti_rest_neg[j]*(-objetivo[j])+aux_cota_rest_neg[j];
s.t. divisionPos {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross indices_jaulas_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]*log(k)-sum {k in {1..N}} x[i2,j2,k]*log(k) = aux_acti_div_pos[j]*log(objetivo[j])+aux_cota_div_pos[j];
s.t. divisionNeg {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross indices_jaulas_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]*log(k)-sum {k in {1..N}} x[i2,j2,k]*log(k) = aux_acti_div_neg[j]*(-log(objetivo[j]))+aux_cota_div_neg[j];
s.t. suma2 {jaula in indices_jaulas_2}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*k = aux_acti_sum[jaula]*objetivo[jaula]+aux_cota_sum[jaula];
s.t. producto2 {jaula in indices_jaulas_2}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*log(k) = aux_acti_prod[jaula]*log(objetivo[jaula])+aux_cota_prod[jaula];

# restriccion para los segundos sumandos de la parte anterior
s.t. activacionRestDivProdSum {j in indices_jaulas_2}: aux_acti_rest_pos[j]+aux_acti_rest_neg[j] + aux_acti_div_pos[j]+aux_acti_div_neg[j]+ aux_acti_sum[j] + aux_acti_prod[j] = 1;

s.t. cotaResta_pos {j in indices_jaulas_2}: aux_cota_rest_pos[j] <= M*aux_acti_rest_neg[j]+M*aux_acti_div_pos[j]+M*aux_acti_div_neg[j]+M*aux_acti_sum[j]+M*aux_acti_prod[j];
s.t. cotaDiv_pos {j in indices_jaulas_2}: aux_cota_div_pos[j] <= M*aux_acti_rest_pos[j]+M*aux_acti_rest_neg[j]+M*aux_acti_div_neg[j]+M*aux_acti_sum[j]+M*aux_acti_prod[j];
s.t. cotaResta_neg {j in indices_jaulas_2}: aux_cota_rest_neg[j] <= M*aux_acti_rest_pos[j]+M*aux_acti_div_pos[j]+M*aux_acti_div_neg[j]+M*aux_acti_sum[j]+M*aux_acti_prod[j];
s.t. cotaDiv_neg {j in indices_jaulas_2}: aux_cota_div_neg[j] <= M*aux_acti_rest_pos[j]+M*aux_acti_div_pos[j]+M*aux_acti_rest_neg[j]+M*aux_acti_sum[j]+M*aux_acti_prod[j];
s.t. cotaSuma2 {j in indices_jaulas_2}: aux_cota_sum[j] <= M*aux_acti_rest_pos[j]+M*aux_acti_div_pos[j]+M*aux_acti_rest_neg[j]+M*aux_acti_div_neg[j]+M*aux_acti_prod[j];
s.t. cotaProd2 {j in indices_jaulas_2}: aux_cota_prod[j] <= M*aux_acti_rest_pos[j]+M*aux_acti_div_pos[j]+M*aux_acti_rest_neg[j]+M*aux_acti_sum[j]+M*aux_acti_div_neg[j];


# restricciones para la igualdad
s.t. igualdad {jaula in indices_jaulas_1}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} x[i,j,objetivo[jaula]] = 1;

# restricciones para las filas
s.t. fila {(i,k) in {1..N} cross {1..N}}: sum {j in {1..N}} x[i,j,k]=1;

#restricciones para las columnas
s.t. columna {(j,k) in {1..N} cross {1..N}}: sum {i in {1..N}} x[i,j,k]=1;

# unicidad en cada entrada de la solucion
s.t. unicidad {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} x[i,j,k] =1;