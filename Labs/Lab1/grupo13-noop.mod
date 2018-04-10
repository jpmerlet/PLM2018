## grupo13-noop.mod ##
reset;

param N;
param num_jaulas;
param B {1..N,1..N};
param objetivo {1..num_jaulas};
param M;
param Q {1..N,1..N};

# recuperamos los indices de las jaulas de size mayor o igual a 3
set indices_jaulas_3:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})>2};

# recuperamos los indices de las jaulas de size 2
set indices_jaulas_2:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})=2};

# lo mismo para las jaulas de size 1
set indices_jaulas_1:={j in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=j})=1};

# variable que codificara el resultado
var x {1..N,1..N,1..N} binary;

# variables auxiliares
var aux_rest {indices_jaulas_2} binary;
var aux_div {indices_jaulas_2} binary;

# variables auxiliares para suma y producto
var aux_acti_sum {indices_jaulas_3 union indices_jaulas_2} binary;
var aux_acti_prod {indices_jaulas_3 union indices_jaulas_2} binary;
var aux_cota_sum {indices_jaulas_3 union indices_jaulas_2};
var aux_cota_prod {indices_jaulas_3 union indices_jaulas_2};

# variables auxiliares para resta y division
var aux_acti_rest {indices_jaulas_2} binary;
var aux_acti_div {indices_jaulas_2} binary;
var aux_cota_rest {indices_jaulas_2};
var aux_cota_div {indices_jaulas_2};

# restricciones para la suma y el producto en jaulas de size 3
s.t. suma {jaula in indices_jaulas_3}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*k - aux_acti_sum[jaula]*objetivo[jaula] - aux_cota_sum[jaula] = 0;
s.t. producto {jaula in indices_jaulas_3}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*log(k) - aux_acti_prod[jaula]*log(objetivo[jaula]) - aux_cota_prod[jaula] = 0;

# restricciones de activacion en jaulas de size 3
s.t. activacionProdSum {j in indices_jaulas_3}: aux_acti_sum[j] + aux_acti_prod[j] = 1;

# restricciones para las cotas de suma y producto en jaulas de size 3 o superior
s.t. cotaSuma_sup {j in indices_jaulas_3}: aux_cota_sum[j] <= M*(1-aux_acti_sum[j]);
s.t. cotaProd_sup {j in indices_jaulas_3}: aux_cota_prod[j] <= M*(1-aux_acti_prod[j]);
s.t. cotaSuma_inf {j in indices_jaulas_3}: aux_cota_sum[j] >= -M*(1-aux_acti_sum[j]);
s.t. cotaProd_inf {j in indices_jaulas_3}: aux_cota_prod[j] >= -M*(1-aux_acti_prod[j]);

# restricciones para la resta, la division, el producto y la suma en jaulas de size 2
s.t. resta {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross indices_jaulas_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]*k -sum {k in {1..N}} x[i2,j2,k]*k + 2*aux_rest[j]*objetivo[j] - aux_acti_rest[j]*objetivo[j]-aux_cota_rest[j] = 0;
s.t. division {(i1,j1,i2,j2,j) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross indices_jaulas_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=j} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z] = j} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]*log(k)-sum {k in {1..N}} x[i2,j2,k]*log(k)+2*aux_div[j]*log(objetivo[j]) - aux_acti_div[j]*log(objetivo[j]) - aux_cota_div[j] = 0;
s.t. suma2 {jaula in indices_jaulas_2}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*k - aux_acti_sum[jaula]*objetivo[jaula] - aux_cota_sum[jaula] = 0;
s.t. producto2 {jaula in indices_jaulas_2}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*log(k) - aux_acti_prod[jaula]*log(objetivo[jaula]) - aux_cota_prod[jaula] = 0;

# restriccion de activacion en jaulas de size 2
s.t. activacionRestDiv {j in indices_jaulas_2}: aux_acti_rest[j] + aux_acti_div[j] + aux_acti_prod[j] + aux_acti_sum[j] = 1;

# restricciones para las cotas de suma, resta, producto y division para jaulas de size 2
s.t. cotaResta_sup {j in indices_jaulas_2}: aux_cota_rest[j] <= M*(1-aux_acti_rest[j]);
s.t. cotaDiv_sup {j in indices_jaulas_2}: aux_cota_div[j] <= M*(1-aux_acti_div[j]);
s.t. cotaSuma2_sup {j in indices_jaulas_2}: aux_cota_sum[j] <= M*(1-aux_acti_sum[j]);
s.t. cotaProd2_sup {j in indices_jaulas_2}: aux_cota_prod[j] <= M*(1-aux_acti_prod[j]);
s.t. cotaResta_inf {j in indices_jaulas_2}: aux_cota_rest[j] >= -M*(1-aux_acti_rest[j]);
s.t. cotaDiv_inf {j in indices_jaulas_2}: aux_cota_div[j] >= -M*(1-aux_acti_div[j]);
s.t. cotaSuma2_inf {j in indices_jaulas_2}: aux_cota_sum[j] >= -M*(1-aux_acti_sum[j]);
s.t. cotaProd2_inf {j in indices_jaulas_2}: aux_cota_prod[j] >= -M*(1-aux_acti_prod[j]);

# restricciones para la igualdad
s.t. igualdad {jaula in indices_jaulas_1}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} x[i,j,objetivo[jaula]] = 1;

# restricciones para las filas
s.t. fila {(i,k) in {1..N} cross {1..N}}: sum {j in {1..N}} x[i,j,k]=1;

#restricciones para las columnas
s.t. columna {(j,k) in {1..N} cross {1..N}}: sum {i in {1..N}} x[i,j,k]=1;

# unicidad en cada entrada de la solucion
s.t. unicidad {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} x[i,j,k] =1;
