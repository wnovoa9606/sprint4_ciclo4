import "package:get/get.dart";
import 'package:sprint4_ciclo4/proceso/peticiones.dart';

class controlador_principal extends GetxController {
  final Rxn<List<Map<String, dynamic>>>
      _lista_posicion = // esta variable adminstra las posiciones de localización
      Rxn<List<Map<String, dynamic>>>();
  final _posicion = "".obs; // se genera la variable que almacena las posiciones
  //////////////////////////////////////////////////
  void cargar_posicion(String variable_posicion) {
    // metodo para asignacion de dentro del proyecto a variables obervables
    _posicion.value = variable_posicion;
  }

  String get posicion => _posicion.value; // metodo get
/////////////////////////////////////////////////
  void Cargar_Lista_Posiciones(
      List<Map<String, dynamic>> variable_lista_posiciones) {
    // metodo que llama a la tabla del archivo peticiones.dart, el cual a su vez realiza la conexión con la base de datos para traer la tabla, se sabe que se llamma a la tabla al invocar de manera List<Map<String, dynamic>>
    _lista_posicion.value = variable_lista_posiciones;
  }

  List<Map<String, dynamic>>? get lista_posicion => _lista_posicion.value;
/////////////////////////////////////////////////
  Future<void> cargar_base_datos() async {
    final datos = await peticiones_bases_datos
        .mostrar_tabla_ubicaciones(); // metodo que llama a la clase petiiciones y al metodo de mostrar tabla dentro de esta para alimentar los metodos de posición
    Cargar_Lista_Posiciones(datos);
  }
}
