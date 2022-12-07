import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprint4_ciclo4/controlador/controlador_principal.dart';

import 'Interfaz/home.dart';

void main() {
  Get.put(controlador_principal());
  runApp(const MyApp());
}
