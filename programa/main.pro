/*
main.pro
Tarea 2
Lenguajes de programación
Jean Hunt
2018265223
*/


%Carga registros de vehiculos a la base de conocimiento
nuevoVehiculo(toyotaGroup,vehiculo(toyota, hilux2021, pickup, 2500, 700)).
nuevoVehiculo(toyotaGroup,vehiculo(toyota, hilux2022, pickup, 3000, 750)).
nuevoVehiculo(fca,vehiculo(jeep, compass2019, cross, 2000, 450)).
nuevoVehiculo(fca,vehiculo(jeep, compass2020, cross, 2000, 450)).
nuevoVehiculo(fca,vehiculo(maserati, levante2021, cross, 2000, 450)).
nuevoVehiculo(fca,vehiculo(maserati, levante2022, cross, 1500, 650)).
nuevoVehiculo(nissanMC,vehiculo(nissan, sentra2012, sedan, 1600, 500)).
nuevoVehiculo(nissanMC,vehiculo(nissan, sentra2013, sedan, 1600, 500)).
nuevoVehiculo(nissanMC,vehiculo(nissan, almera2014, sedan, 1500, 550)).
nuevoVehiculo(nissanMC,vehiculo(nissan, almera2015, sedan, 1600, 550)).
nuevoVehiculo(nissanMC,vehiculo(nissan, sentra2016, sedan, 1800, 500)).


%Relaciona dos vehiculos del mismo fabricante


relacionar(toyotaGroup, hilux2021, hilux2022).
relacionar(fca, compass2019,compass2020).
relacionar(fca, compass2020, levante2021).
relacionar(fca, levante2021,levante2022).
relacionar(nissanMC, sentra2012, sentra2013).
relacionar(nissanMC, sentra2013, almera2014).
relacionar(nissanMC, almera2014, almera2015).
relacionar(nissanMC, almera2015, sentra2016).


/*
Nombre: esEcoAmigable
E: Fabricante -> nombre de un fabricante, Modelo -> nombre de un modelo
S: true si es eco amigable, false si no 
R: Debe existir un vehiculo con los argumentos especificados, sino dará false como resultado
O: Determinar si un modelo es ecoAmigable o no
*/

esEcoAmigable(Fabricante, Modelo):-
    esEcoAmigableAux(Fabricante, Modelo),
    write("Es eco amigable").
esEcoAmigable(Fabricante, Modelo):-
    \+ esEcoAmigableAux(Fabricante, Modelo),
    write("Este vehiculo no existe o no es eco amigable"),
    fail.

esEcoAmigableAux(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante,vehiculo(_,Modelo,Estilo,Cilindraje,Autonomia)),
    Estilo == sedan, Cilindraje < 2000, Autonomia>500,
    write("Estilo: "),write(Estilo),write("    Cilindraje: "),write(Cilindraje),write("  Autonomia: "),write(Autonomia),nl.

esEcoAmigableAux(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante,vehiculo(_,Modelo,Estilo,Cilindraje,Autonomia)),
    Estilo == cross, Cilindraje < 2500, Autonomia>450,
    write("Estilo: "),write(Estilo),write("    Cilindraje: "),write(Cilindraje),write("  Autonomia: "),write(Autonomia),nl.

esEcoAmigableAux(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante,vehiculo(_,Modelo,Estilo,Cilindraje,Autonomia)),
    Estilo == pickup, Cilindraje < 3000, Autonomia>650,
    write("Estilo: "),write(Estilo),write("    Cilindraje: "),write(Cilindraje),write("  Autonomia: "),write(Autonomia),nl.

/***********************************************************************************************************************************/

/*
nombre: produccionTotal
E: Fabricante -> nombre de un fabricante, X->Cantidad de autos o predicado X
S: -Si se indica X ( true si X == cantidad de autos del fabricante, false si no)
    -Sin indicar X (Cantidad de autos del fabricante)
R: X debe ser X o un numero 
O: Saber cuántos modelos tiene un fabricante o validar si el número indicado es el correcto.
*/
produccionTotal(Fabricante, X):-
    aggregate_all(count, nuevoVehiculo(Fabricante, vehiculo(_,_,_,_,_)), X).

/*****************************************************************************************************************/

/*
nombre: esFinal
E: Fabricante -> nombre del fabricante, Modelo -> modelo del vehiculo
S: true si el vehiculo es final
R: El vehículo debe de existir
O: Determinar si un vehiculo es final (no tiene siguiente)
*/
esFinal(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante, vehiculo(_,Modelo,_,_,_)),
    \+ relacionar(Fabricante,Modelo,_),
    write("Es final").


/*
nombre: esBase
E: Fabricante -> nombre del fabricante, Modelo -> modelo del vehiculo
S: true si el vehiculo es base
R: El vehículo debe de existir
O: Determinar si un vehiculo es base (no tiene anterior)
*/
esBase(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante, vehiculo(_,Modelo,_,_,_)),
    \+ relacionar(Fabricante,_,Modelo),
    write("Es base").


/*
nombre: esIntermedio
E: Fabricante -> nombre del fabricante, Modelo -> modelo del vehiculo
S: true si el vehiculo es intermedio
R: El vehículo debe de existir
O: Determinar si un vehiculo es intermedio (tiene siguiente y anterior)
*/
esIntermedio(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante, vehiculo(_,Modelo,_,_,_)),
    relacionar(Fabricante,Modelo,_),
    relacionar(Fabricante,_,Modelo),
    write("Es intermedio").

/*********************************************************************************/

/*
nombre: relacionados + relacionadosAux
E: Fabricante -> nombre del fabricante, (Modelo1, Modelo2) -> nombre de los modelos
S: Ruta de la relación si están relacionados
R: El fabricante y los modelos deben existir en la base de conocimiento
O: Determinar si dos modelos están relacionados
*/
relacionados(Fabricante, Modelo1, Modelo2):-
    relacionadosAux(Fabricante, Modelo1, Modelo2, Res),
    write("Estan relacionados y esta es su ruta: "),
    write(Res).
relacionados(Fabricante, Modelo1, Modelo2):-
    \+ relacionadosAux(Fabricante, Modelo1, Modelo2, _),
    write("No estan relacionados."),
    fail.

relacionadosAux(Fabricante, Modelo1, Modelo2, Res):-
    (calcularRelacion(Fabricante, Modelo1, Modelo2,"",Res2) ; calcularRelacion(Fabricante, Modelo2, Modelo1,"",Res2)),
    Res = Res2.


/*
nombre: calcularRelacion
E: Fabricante -> nombre del fabricante, (Modelo1, Modelo2) -> nombre de los modelos
    S-> String con la cadena de la ruta
    Res ->almacenará la ruta final
S: Ruta de la relación si existe una
R: El fabricante y los modelos deben existir en la base de conocimiento
O: Calcular la ruta de relación entre dos vehiculos
*/
calcularRelacion(Fabricante, Modelo1, Modelo2,S,Res) :-
    relacionar(Fabricante,Modelo1,X),
    X == Modelo2,
    string_concat(Modelo1,' -> ',String1),
    string_concat(String1, Modelo2, String2),
    string_concat(S, String2, String3),
    Res = String3.
calcularRelacion(Fabricante, Modelo1, Modelo2,S,Res) :-
    relacionar(Fabricante,Modelo1,X),
    X \== Modelo2,
    string_concat(Modelo1,' -> ',String1),
    string_concat(S, String1, String2),
    calcularRelacion(Fabricante,X,Modelo2,String2,Res).
/***************************************************************************************************************/

/*
Nombre: esConglomerado
E: Fabricante -> Nombre de un fabricante
S: Indica si es conglomerado o no 
R: El fabricante debe existir
O: Determinar si un fabricante es conglomerado (fabrica más de una marca)
*/
esConglomerado(Fabricante):-
    nuevoVehiculo(Fabricante, vehiculo(Marca,_,_,_,_)),
    esConglomeradoAux(Fabricante, Marca),
    write("No es conglomerado"),nl.

esConglomerado(Fabricante):-
    nuevoVehiculo(Fabricante, vehiculo(Marca,_,_,_,_)),
    \+ esConglomeradoAux(Fabricante, Marca),
    write("Es conglomerado"),nl.

/*
Nombre: esConglomeradoAux
E: Fabricante -> Nombre de un fabricante, Marca1 -> primera marca registrada del fabricante
S: True si todas las marcas son iguales, False si no 
R: El fabricante debe existir y la Marca1 debe ser una marca producida por dicho fabricante
O: Compara todos los registros del fabricante para identificar si existe una marca diferente a la indicada
    esto significa que produce más de un vehiculo
*/
esConglomeradoAux(Fabricante, Marca1):-
    forall(nuevoVehiculo(Fabricante, vehiculo(Marca2,_,_,_,_)),
        (
            Marca1 == Marca2
        )
    ).


/****************************************************************************************************************/

/*
nombre: muestraVehiculo
E: Fabricante -> nombre del fabricante, Modelo->modelo del vehiculo
S: Información del vehiculo
R: Debe existir un vehiculo con los valores indicados
O: Imprimir la información de un vehiculo
*/
muestraVehiculo(Fabricante, Modelo):-
    \+ nuevoVehiculo(Fabricante,vehiculo(_,Modelo,_,_,_)),
    write("El vehiculo no existe"),nl,fail.
muestraVehiculo(Fabricante, Modelo):-
    nuevoVehiculo(Fabricante,vehiculo(Marca,Modelo,Estilo,Cilindraje,Autonomia)),
    write("----- Informacion del vehiculo -----"),nl,nl,
    write("Fabricante: "),write(Fabricante), nl,
    write("Marca: "),write(Marca),nl,
    write("Modelo: "),write(Modelo),nl,
    write("Estilo: "),write(Estilo),nl,
    write("Cilindraje: "),write(Cilindraje),nl,
    write("Autonomia: "),write(Autonomia),nl,
    write("------------------------------------").
/************************************************************************************************************/
