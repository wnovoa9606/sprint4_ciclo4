import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sprint4_ciclo4/Interfaz/lista_ubicaciones.dart';
import 'package:sprint4_ciclo4/controlador/controlador_principal.dart';
import 'package:sprint4_ciclo4/proceso/peticiones.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sprint4_Ciclo4',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Geolocalización'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  controlador_principal control_home = Get.find();

  void metodo_obtener_posicion() async {
    Position Posicion = await peticiones_bases_datos.determinePosition();
    control_home.cargar_posicion(Posicion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        title: "Atención",
                        desc:
                            "esta a punto de borrar todas las ubicaciones almacenadas, ¿esta seguro?",
                        type: AlertType.warning,
                        buttons: [
                          DialogButton(
                              color: Colors.greenAccent,
                              child: Text("Si"),
                              onPressed: () {
                                Navigator.pop(context);
                                peticiones_bases_datos.eliminar_tabla();
                                control_home.cargar_base_datos();
                              }),
                          DialogButton(
                              color: Colors.greenAccent,
                              child: Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        context: context)
                    .show();
              },
              icon: Icon(Icons.delete_rounded))
        ],
      ),
      body: lista_ubicaciones(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          metodo_obtener_posicion();
          Alert(
                  title: "Atención!",
                  desc: "La Ubicacion" +
                      control_home.posicion +
                      "sera almacenada en nuestra base de datos, ¿está seguro?",
                  type: AlertType.info,
                  buttons: [
                    DialogButton(
                        child: Text("Si"),
                        color: Colors.greenAccent,
                        onPressed: () {
                          peticiones_bases_datos.Guardar_Datos_Posicion(
                              // llama a los metodos de conexion con la base de datos para guardar información
                              control_home.posicion,
                              DateTime.now().toString());
                          control_home
                              .cargar_base_datos(); // se llama al metodo en el controlador que actualiza la base de datos
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        child: Text("No"),
                        color: Colors.redAccent,
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  context: context)
              .show();
        },
        child: Icon(Icons.location_on_outlined),
      ),
    );
  }
}
