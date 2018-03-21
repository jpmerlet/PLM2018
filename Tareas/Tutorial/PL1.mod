# Declarar variables y cotas
var a >= 0;
var b <= 0;
var c;

# Descripcion PL
minimize valor: a + 12*b;
subject to restriccion1: 13*a + 12*c <= 5-2*b;
subject to restriccion2: a + c >= 1;
subject to restriccion3: 15*a + b = 14+3*b;