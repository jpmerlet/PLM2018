reset;

param N;
param num_jaulas;
param B {1..N,1..N};
param objetivo {1..num_jaulas};
param M:= 100;

# indices de jaulas de size 1
set jaulas_size_1:= {i in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=i})=1};

# indices de jaulas de size 2
set jaulas_size_2:= {i in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=i})=2};

# indices de jaulas de size 3 o superior
set jaulas_size_3:= {i in {1..num_jaulas}: card({(p,z) in {1..N} cross {1..N}: B[p,z]=i})>2};

# variable del problema
var x {1..N,1..N,1..N} binary;

# variables auxiliares de activacion para jaulas de size 2
var aux_sum_2 {jaulas_size_2} binary;
var aux_prod_2 {jaulas_size_2} binary;
var aux_resta_pos {jaulas_size_2} binary;
var aux_resta_neg {jaulas_size_2} binary;
var aux_div_pos {jaulas_size_2} binary;
var aux_div_neg {jaulas_size_2} binary;

# variables auxiliares de relajacion para jaulas de size 2
var aux_sum_2_rel {jaulas_size_2} >= 0;
var aux_prod_2_rel {jaulas_size_2} >=0;
var aux_resta_pos_rel {jaulas_size_2} <= 0;
var aux_resta_neg_rel {jaulas_size_2}>= 0;
var aux_div_pos_rel {jaulas_size_2} <= 0;
var aux_div_neg_rel {jaulas_size_2} >= 0;

# variables auxiliares de activacion para jaulas de size 3 o superior
var aux_sum_3 {jaulas_size_3} binary;
var aux_prod_3 {jaulas_size_3} binary;

# variables auxiliares de relajacion para jaulas de size 3 o superior
var aux_sum_3_rel {jaulas_size_3} >=0;
var aux_prod_3_rel {jaulas_size_3} >=0;


# restricciones para las filas
subject to filas {(i,k) in {1..N} cross {1..N}}: sum {j in {1..N}} x[i,j,k]=1;

# restricciones para las columnas
subject to columnas {(j,k) in {1..N} cross {1..N}}: sum {i in {1..N}} x[i,j,k]=1;

# restricciones para unicidad de valor en la tabla
subject to unicidad {(i,j) in {1..N} cross {1..N}}: sum {k in {1..N}} x[i,j,k]=1;

# restricciones para jaulas de size 1
subject to igualdad {jaula in jaulas_size_1}: sum {(i,j) in {1..N} cross {1..N}: B[i,j] = jaula} x[i,j,objetivo[jaula]] = 1;

# restricciones para las jaulas de size 2
subject to suma_2 {jaula in jaulas_size_2}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*k = aux_sum_2[jaula]*objetivo[jaula] + aux_sum_2_rel[jaula];
subject to prod_2 {jaula in jaulas_size_2}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*log(k) = aux_prod_2[jaula]*log(objetivo[jaula]) + aux_prod_2_rel[jaula];
subject to resta_pos {(i1,j1,i2,j2,jaula) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross jaulas_size_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]-sum {k in {1..N}} x[i2,j2,k] = aux_resta_pos[jaula]*objetivo[jaula]+aux_resta_pos_rel[jaula];
subject to resta_neg {(i1,j1,i2,j2,jaula) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross jaulas_size_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]-sum {k in {1..N}} x[i2,j2,k] = aux_resta_neg[jaula]*(-objetivo[jaula])+aux_resta_neg_rel[jaula];
subject to div_pos {(i1,j1,i2,j2,jaula) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross jaulas_size_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and ((i1=i2 and j1<j2) or (i1<i2))}: sum {k in {1..N}} x[i1,j1,k]-sum {k in {1..N}} x[i2,j2,k] = aux_div_pos[jaula]*log(objetivo[jaula])+aux_div_pos_rel[jaula];
subject to div_neg {(i1,j1,i2,j2,jaula) in {1..N} cross {1..N} cross {1..N} cross {1..N} cross jaulas_size_2: (i1,j1) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and (i2,j2) in {(p,z) in {1..N} cross {1..N}: B[p,z]=jaula} and ((i1=i2 and j1<j2) or (i1<i2))}: 	sum {k in {1..N}} x[i1,j1,k]-sum {k in {1..N}} x[i2,j2,k] = aux_div_neg[jaula]*(-log(objetivo[jaula]))+aux_div_neg_rel[jaula];

subject to activacion_jaula_2 {jaula in jaulas_size_2}: aux_sum_2[jaula] + aux_prod_2[jaula] + aux_resta_pos[jaula] + aux_resta_neg[jaula] + aux_div_pos[jaula] + aux_div_neg[jaula]  = 1;

subject to rel_jaula_2_sum {jaula in jaulas_size_2}:aux_sum_2_rel[jaula] <= M*(aux_prod_2[jaula]+aux_resta_pos[jaula]+aux_resta_neg[jaula]+aux_div_pos[jaula]+aux_div_neg[jaula]);
subject to rel_jaula_2_prod {jaula in jaulas_size_2}:aux_prod_2_rel[jaula] <= M*(aux_sum_2[jaula]+aux_resta_pos[jaula]+aux_resta_neg[jaula]+aux_div_pos[jaula]+aux_div_neg[jaula]);
subject to rel_jaula_2_resta_pos {jaula in jaulas_size_2}:aux_resta_pos_rel[jaula] >= -M*(aux_prod_2[jaula]+aux_sum_2[jaula]+aux_resta_neg[jaula]+aux_div_pos[jaula]+aux_div_neg[jaula]);
subject to rel_jaula_2_resta_neg {jaula in jaulas_size_2}:aux_resta_neg_rel[jaula] <= M*(aux_prod_2[jaula]+aux_resta_pos[jaula]+aux_sum_2[jaula]+aux_div_pos[jaula]+aux_div_neg[jaula]);
subject to rel_jaula_2_div_pos {jaula in jaulas_size_2}:aux_div_pos_rel[jaula] >= -M*(aux_prod_2[jaula]+aux_resta_pos[jaula]+aux_resta_neg[jaula]+aux_sum_2[jaula]+aux_div_neg[jaula]);
subject to rel_jaula_2_div_neg {jaula in jaulas_size_2}:aux_div_neg_rel[jaula] <= M*(aux_prod_2[jaula]+aux_resta_pos[jaula]+aux_resta_neg[jaula]+aux_div_pos[jaula]+aux_sum_2[jaula]);

# restricciones para las jaulas de size 3 o superior
subject to suma_3 {jaula in jaulas_size_3}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*k = aux_sum_3[jaula]*objetivo[jaula] + aux_sum_3_rel[jaula];
subject to prod_3 {jaula in jaulas_size_3}: sum {(i,j) in {1..N} cross {1..N}: B[i,j]=jaula} sum {k in {1..N}} x[i,j,k]*log(k) = aux_prod_3[jaula]*log(objetivo[jaula]) + aux_prod_3_rel[jaula];

subject to activacion_jaula_3 {jaula in jaulas_size_3}: aux_sum_3[jaula] + aux_prod_3[jaula] = 1;

subject to rel_jaula_3_sum {jaula in jaulas_size_3}: aux_sum_3_rel[jaula] <= M*aux_prod_3[jaula];
subject to rel_jaula_3_prod {jaula in jaulas_size_3}: aux_prod_3_rel[jaula] <= M*aux_sum_3[jaula];
