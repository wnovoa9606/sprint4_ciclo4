import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import "package:sqflite/sqflite.dart" as sql_libreria;

class peticiones_bases_datos {
  static Future<void> Crear_Tabla(sql_libreria.Database baseDeDatos) async {
    // se crea la instruccion para crear una tabla a travez del metodo "Crear_Tabla"
    await baseDeDatos.execute(""" CREATE TABLE posiciones(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
      coordenadas TEXT
      fecha TEXT
    )""");
  }

  static Future<sql_libreria.Database> crear_base_datos() async {
    // se crea la instruccion para la creación de la base de datos.
    return sql_libreria
        .openDatabase("Base_datos_geolocalización.db", version: 1,
            onCreate: (sql_libreria.Database BaseDatos, int version) async {
      // dentro de la base de datos, se crea el metodo "On Create" el cual trae el metodo de crear tabla dentro de la creación de la base de datos
      await Crear_Tabla(BaseDatos);
    });
  }

  static Future<List<Map<String, dynamic>>> mostrar_tabla_ubicaciones() async {
    // esta funcion devuelve la informacion en formato .JSON
    // este metodo trae la consulta a la base de datos
    final variable_conexion_base_datos = await peticiones_bases_datos
        .crear_base_datos(); // conexion a la base de datos, si no encuentra una base de datos, la crea
    return variable_conexion_base_datos.query("posiciones", orderBy: "fecha");
  }

  static Future<void> eliminar_datos(int ID_Posicion) async {
    final variable_conexion_base_datos = await peticiones_bases_datos
        .crear_base_datos(); // conexion a la base de datos, si no encuentra una base de datos, la crea
    variable_conexion_base_datos.delete("posiciones", where: "id?", whereArgs: [
      ID_Posicion
    ]); // la instruccion a la base de datos es que consulte el campo "id", y cuando encuentre este parametro de acuerdo a la variable "ID_posicion" indicada, que eliminine los datos de esa fila
  }

  static Future<void> eliminar_tabla() async {
    final variable_conexion_base_datos = await peticiones_bases_datos
        .crear_base_datos(); // conexion a la base de datos, si no encuentra una base de datos, la crea
    variable_conexion_base_datos.delete(
        "posiciones"); // la instruccion a la base de datos es que elimine la tabla posiciones
  }

  static Future<void> Guardar_Datos_Posicion(
      variable_coordenadas, variable_fecha) async {
    final variable_conexion_base_datos = await peticiones_bases_datos
        .crear_base_datos(); // conexion a la base de datos, si no encuentra una base de datos, la crea
    final datos = {
      // se genera una variable con la estructura .JSON para que reciba parametros de entrada y alimente la base de datos
      "coordenadas": variable_coordenadas,
      "fecha": variable_fecha
    };
    await variable_conexion_base_datos.insert("posiciones", datos,
        conflictAlgorithm: sql_libreria.ConflictAlgorithm
            .replace); // instruccione para conexion a la tabla "posiciones" e ingresar la variable datos
    // se añade "conflictAlgorithm" para que haga gestion de los conflictos al añadir información a la base de datos
  }

/////////////////////////////////////////// --> codigo para obtener la geolocalización del celular
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
