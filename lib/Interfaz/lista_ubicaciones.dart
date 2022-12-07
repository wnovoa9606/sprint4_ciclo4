import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sprint4_ciclo4/controlador/controlador_principal.dart';
import 'package:sprint4_ciclo4/proceso/peticiones.dart';

class lista_ubicaciones extends StatefulWidget {
  const lista_ubicaciones({super.key});

  @override
  State<lista_ubicaciones> createState() => _lista_ubicacionesState();
}

class _lista_ubicacionesState extends State<lista_ubicaciones> {
  controlador_principal Control_listado_posiciones =
      Get.find(); // se llamada al controlador creado
  @override
  void initState() {
    super.initState();
    Control_listado_posiciones
        .cargar_base_datos(); // se llama al metodo del controlador que llama a la base de datos
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Obx(() => Container(
            // se encierra el contanier dentro de un obx dado que estoy manejando variables reactivas a través de un controlador
            child: Control_listado_posiciones.lista_posicion?.isEmpty == false
                ? ListView.builder(
                    itemCount: Control_listado_posiciones.lista_posicion!
                        .length, // se llama al numero de elementos de la lista
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: ListTile(
                              leading: Icon(Icons.location_searching_sharp),
                              trailing: IconButton(
                                onPressed: () {
                                  Alert(
                                          title: "Atención!",
                                          desc:
                                              "esta a punto de eliminar la ubicación, ¿esta seguro?",
                                          type: AlertType.info,
                                          buttons: [
                                            DialogButton(
                                                child: Text("Si"),
                                                color: Colors.greenAccent,
                                                onPressed: () {
                                                  peticiones_bases_datos.eliminar_datos(
                                                      Control_listado_posiciones
                                                                  .lista_posicion![
                                                              index][
                                                          "id"]); // se llama al id en la posicion index para eliminar la informaacion requerida
                                                  Control_listado_posiciones
                                                      .cargar_base_datos(); // se llama al metodo que actualiza la tabla en la base de datos
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
                                icon: Icon(Icons.delete_forever_sharp),
                              ),
                              title: Text(Control_listado_posiciones
                                      .lista_posicion![index][
                                  "coordenadas"]), // en los segundos corchetes, se coloca el nombre del campo que se quiere mostrar, dato que "lista_posicion" es un arry bidimendional
                              subtitle: Text(Control_listado_posiciones
                                  .lista_posicion![index]["fecha"])));
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ));
    } catch (e) {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
  }
}
