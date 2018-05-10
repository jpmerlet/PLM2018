## Archivo (MMI-donoso.mod) ##
set A;
set B;
set E within A cross B;
param c {(i,j) in E};
param n:= card(A);
set V:= A union B;
set I:= {i in {1..n}: 1 = i mod 2}; 

## forma 1 ##
## variables forma 2 ##
var x {(i,j) in E} >=0;

## parametro auxiliar ##
param k integer;

## funcion objetivo forma 1 ##
maximize pesoMatching: sum {(i,j) in E} c[i,j]*x[i,j];

## restricciones forma 1 ##
subject to cubrir {v in V}: sum {(i,j) in E: i==v or j==v} x[i,j] <= 1;
subject to paridad_1: sum {(i,j) in E} x[i,j] = k;

## forma 2 ##
## variables forma 2 ##
var lambda {kk in I} binary;
var y {(i,j,kk) in E cross I} >= 0;

## restricciones forma 2 ##
subject to unicidadK: sum {kk in I} lambda[kk] = 1;
subject to solucion {(i,j) in E}: x[i,j] = sum {kk in I} y[i,j,kk];
subject to cota_y {kk in I,(i,j) in E}: y[i,j,kk] <= lambda[kk];
subject to paridad_2: sum {(i,j) in E} x[i,j] = sum {kk in I} kk*lambda[kk];

## forma 3 ##
## variables forma 3 ##
var t integer;

## restricciones forma 3 ##
subject to  paridad_3: sum {(i,j) in E} x[i,j] = 2*t + 1;

problem forma1: pesoMatching, x, cubrir, paridad_1;
problem forma2: pesoMatching, x, lambda, y, cubrir, paridad_2, unicidadK, cota_y, solucion;
problem forma3: pesoMatching, x, t, cubrir, paridad_3;
