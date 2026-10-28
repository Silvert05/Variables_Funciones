// UNIBE · Trabajo grupal Dart: gestión de talleres

import 'dart:io';

// Actividad C: funciones y parámetros

void mostrarEncabezado(String universidad) {
  print('=== Talleres de $universidad ===');
}

int obtenerCupo(
  Map<String, int> cupos,
  String nombreTaller,
) {
  return cupos[nombreTaller] ?? 0;
}

bool puedeInscribirse(bool inscripcionesAbiertas, int cuposDisponibles) {
  return inscripcionesAbiertas && cuposDisponibles > 0;
}

String crearResumen({
  required String taller,
  required int cupos,
  bool incluirDetalle = true,
}) {
  if (incluirDetalle) {
    return 'Taller: $taller | Cupos disponibles: $cupos';
  }
  return taller;
}

// Actividad E: regla de negocio

String registrarParticipante(
  String nombre,
  Set<String> participantes, {
  required bool inscripcionesAbiertas,
  required int cuposDisponibles,
}) {
  String nombreLimpio = nombre.trim();

  if (nombreLimpio.isEmpty) {
    return 'Registro rechazado: el nombre no puede estar vacío.';
  }
  if (!inscripcionesAbiertas) {
    return 'Registro rechazado: las inscripciones están cerradas.';
  }
  if (cuposDisponibles <= 0) {
    return 'Registro rechazado: no hay cupos disponibles.';
  }
  if (participantes.contains(nombreLimpio)) {
    return 'Registro rechazado: $nombreLimpio ya está registrado/a.';
  }

  participantes.add(nombreLimpio);
  return 'Registro exitoso: $nombreLimpio fue inscrito/a. '
      'Total de participantes: ${participantes.length}.';
}

// Extensión opcional

int contarTalleresDiferentes(List<String> talleres) {
  return talleres.toSet().length;
}

Set<String> eliminarDuplicados(List<String> participantes) {
  return participantes.toSet();
}

// Menú de consola

String? leer(String mensaje) {
  stdout.write(mensaje);
  return stdin.readLineSync()?.trim();
}

bool pausar() {
  stdout.write('\nPresione Enter para volver al menú...');
  return stdin.readLineSync() != null;
}

void limpiarPantalla() {
  if (stdout.hasTerminal && stdout.supportsAnsiEscapes) {
    stdout.write('\x1B[2J\x1B[H');
  }
}

void mostrarTituloAccion(String titulo) {
  print('\n>>> $titulo');
  print('-' * (titulo.length + 4));
}

List<String> mostrarTalleres(
  List<String> talleres,
  Map<String, int> cuposPorTaller,
) {
  List<String> talleresUnicos = talleres.toSet().toList();
  print('\nTalleres disponibles:');
  for (int i = 0; i < talleresUnicos.length; i++) {
    String taller = talleresUnicos[i];
    print('  ${i + 1}. ${crearResumen(
      taller: taller,
      cupos: obtenerCupo(cuposPorTaller, taller),
    )}');
  }
  return talleresUnicos;
}

String? elegirTaller(
  List<String> talleres,
  Map<String, int> cuposPorTaller, {
  String mensaje = 'Elija el número o escriba el nombre del taller: ',
}) {
  List<String> opciones = mostrarTalleres(talleres, cuposPorTaller);
  String? entrada = leer(mensaje);
  if (entrada == null || entrada.isEmpty) return null;

  int? numero = int.tryParse(entrada);
  if (numero != null && numero >= 1 && numero <= opciones.length) {
    return opciones[numero - 1];
  }
  Iterable<String> coincidencias = opciones
      .where((taller) => taller.toLowerCase() == entrada.toLowerCase());
  return coincidencias.isEmpty ? entrada : coincidencias.first;
}

void consultarCupo(List<String> talleres, Map<String, int> cuposPorTaller) {
  String? taller = elegirTaller(talleres, cuposPorTaller);
  if (taller == null) {
    print('No se ingresó ningún taller.');
    return;
  }
  if (!cuposPorTaller.containsKey(taller)) {
    print('El taller "$taller" no existe (cupo: '
        '${obtenerCupo(cuposPorTaller, taller)}).');
    return;
  }
  print(crearResumen(taller: taller, cupos: obtenerCupo(cuposPorTaller, taller)));
}

void buscarTalleres(List<String> talleres) {
  String? texto = leer('Texto a buscar (ej. Flutter): ');
  if (texto == null || texto.isEmpty) {
    print('No se ingresó texto de búsqueda.');
    return;
  }
  Iterable<String> encontrados = talleres
      .toSet()
      .where((taller) => taller.toLowerCase().contains(texto.toLowerCase()));
  List<String> resultado = encontrados.toList();
  print('Resultados (${resultado.length}): $resultado');
}

void registrarEnTaller(
  List<String> talleres,
  Map<String, int> cuposPorTaller,
  Set<String> participantes,
  bool inscripcionesAbiertas,
) {
  print('Participantes ya registrados: $participantes');

  String? nombre = leer('\nPaso 1 - Escriba el nombre del participante: ');
  if (nombre == null) return;

  print('\nPaso 2 - ¿En qué taller desea inscribir a "$nombre"?');
  String? taller = elegirTaller(
    talleres,
    cuposPorTaller,
    mensaje: 'Número o nombre del taller: ',
  );
  if (taller == null || !cuposPorTaller.containsKey(taller)) {
    print('\nRegistro cancelado: el taller elegido no existe.');
    return;
  }

  int cuposDisponibles = obtenerCupo(cuposPorTaller, taller);
  String mensaje = registrarParticipante(
    nombre,
    participantes,
    inscripcionesAbiertas: inscripcionesAbiertas,
    cuposDisponibles: cuposDisponibles,
  );
  print('\nPaso 3 - Resultado:');
  print(mensaje);

  if (mensaje.startsWith('Registro exitoso')) {
    cuposPorTaller[taller] = cuposDisponibles - 1;
    print('Taller: $taller | Cupos antes: $cuposDisponibles | '
        'Cupos ahora: ${cuposPorTaller[taller]}');
    print('Participantes registrados: $participantes');
  }
}

void mostrarParticipantes(Set<String> participantes) {
  print('\nParticipantes registrados (${participantes.length}):');
  for (String nombre in participantes) {
    print('  - $nombre');
  }
}

void mostrarResumen({
  required String universidad,
  required List<String> talleres,
  required Map<String, int> cuposPorTaller,
  required Set<String> participantes,
  required bool inscripcionesAbiertas,
}) {
  int cuposTotales =
      cuposPorTaller.values.fold(0, (total, cupos) => total + cupos);
  List<String> sinCupo = cuposPorTaller.keys
      .where((taller) => obtenerCupo(cuposPorTaller, taller) == 0)
      .toList();

  print('\n======== RESUMEN $universidad ========');
  print('Inscripciones: ${inscripcionesAbiertas ? 'ABIERTAS' : 'CERRADAS'}');
  print('Talleres en la lista: ${talleres.length} '
      '(diferentes: ${contarTalleresDiferentes(talleres)})');
  for (String linea in cuposPorTaller.keys
      .map((t) => crearResumen(taller: t, cupos: obtenerCupo(cuposPorTaller, t)))) {
    print('  $linea');
  }
  print('Cupos disponibles en total: $cuposTotales');
  print('Talleres sin cupo: ${sinCupo.isEmpty ? 'ninguno' : sinCupo}');
  print('Participantes registrados: ${participantes.length} -> $participantes');
  print('=====================================');
}

// Demostración y pruebas (opción 8)

int pruebasAprobadas = 0;
int pruebasTotales = 0;

void verificar(String caso, Object? esperado, Object? real) {
  pruebasTotales++;
  bool ok = esperado.toString() == real.toString();
  if (ok) pruebasAprobadas++;
  print('[${ok ? 'OK ' : 'FALLA'}] $caso -> esperado: $esperado | real: $real');
}

void ejecutarDemostracion({
  required String nombreUniversidad,
  required List<String> talleres,
  required Map<String, int> cuposOriginales,
  required Set<String> participantesOriginales,
  required bool inscripcionesAbiertas,
}) {
  Map<String, int> cuposPorTaller = Map.of(cuposOriginales);
  Set<String> participantesRegistrados = Set.of(participantesOriginales);
  pruebasAprobadas = 0;
  pruebasTotales = 0;

  // Actividad A
  String tallerSeleccionado = 'Flutter inicial';
  int cupoTaller = 20;
  print('\n--- Actividad A: Variables y tipos ---');
  print('Universidad (String): $nombreUniversidad');
  print('Taller seleccionado (String): $tallerSeleccionado');
  print('Cupo del taller (int): $cupoTaller');
  print('Inscripciones abiertas (bool): $inscripcionesAbiertas');
  print('String representa texto, int representa números enteros '
      'y bool representa un valor lógico verdadero/falso.');

  // Actividad B
  print('\n--- Actividad B: List, Map y Set ---');
  print('Talleres en la lista:');
  for (int i = 0; i < talleres.length; i++) {
    print('  ${i + 1}. ${talleres[i]}');
  }
  print('Cupo de Flutter inicial (desde el Map): '
      '${cuposPorTaller['Flutter inicial']}');
  print('Cantidad de talleres en la lista: ${talleres.length}');
  print('Participantes únicos en el Set: ${participantesRegistrados.length} '
      '-> $participantesRegistrados');
  print('Explicación: la List conserva el orden y admite repetidos '
      '("Flutter inicial" aparece 2 veces); el Set solo guarda valores '
      'únicos, por eso "Ana" aparece una sola vez.');

  // Actividad C
  print('\n--- Actividad C: Funciones y parámetros ---');
  mostrarEncabezado(nombreUniversidad);
  print('obtenerCupo("Flutter inicial") = '
      '${obtenerCupo(cuposPorTaller, 'Flutter inicial')}');
  print('obtenerCupo("Robótica") = '
      '${obtenerCupo(cuposPorTaller, 'Robótica')} (taller no encontrado)');
  print('puedeInscribirse(true, 5)  = ${puedeInscribirse(true, 5)}');
  print('puedeInscribirse(true, 0)  = ${puedeInscribirse(true, 0)}');
  print('puedeInscribirse(false, 5) = ${puedeInscribirse(false, 5)}');
  print('puedeInscribirse(false, 0) = ${puedeInscribirse(false, 0)}');
  print(crearResumen(taller: 'Dart desde cero', cupos: 25));
  print(crearResumen(cupos: 15, taller: 'Diseño UX', incluirDetalle: false));

  // Actividad D
  print('\n--- Actividad D: Iterables y filtrado ---');
  Iterable<String> talleresFlutter =
      talleres.where((taller) => taller.contains('Flutter'));
  List<String> resultado = talleresFlutter.toList();
  print('Talleres que contienen "Flutter": $resultado');
  print('Cantidad de resultados: ${resultado.length}');
  Iterable<String> talleresNombreLargo =
      talleres.where((taller) => taller.length > 10);
  List<String> resultadoLargo = talleresNombreLargo.toList();
  print('Talleres con más de 10 caracteres: $resultadoLargo');
  print('Cantidad de resultados: ${resultadoLargo.length}');

  // Actividad E
  print('\n--- Actividad E: Regla de negocio ---');
  int cuposFlutter = obtenerCupo(cuposPorTaller, 'Flutter inicial');
  print(registrarParticipante('Carlos', participantesRegistrados,
      inscripcionesAbiertas: true, cuposDisponibles: cuposFlutter));
  print(registrarParticipante('Ana', participantesRegistrados,
      inscripcionesAbiertas: true, cuposDisponibles: cuposFlutter));
  print(registrarParticipante('Sofía', participantesRegistrados,
      inscripcionesAbiertas: false, cuposDisponibles: cuposFlutter));
  print(registrarParticipante('Pedro', participantesRegistrados,
      inscripcionesAbiertas: true, cuposDisponibles: 0));
  print(registrarParticipante('   ', participantesRegistrados,
      inscripcionesAbiertas: true, cuposDisponibles: 5));
  print('Participantes: $participantesRegistrados');

  // Extensión opcional
  print('\n--- Extensión opcional ---');
  print('Talleres diferentes: ${contarTalleresDiferentes(talleres)}');
  List<String> listaConRepetidos = ['Ana', 'Luis', 'Ana', 'Marta', 'Luis'];
  print('Set sin duplicados de $listaConRepetidos: '
      '${eliminarDuplicados(listaConRepetidos)}');

  // Actividad F
  print('\n--- Actividad F: Casos de prueba ---');
  verificar('1. Consultar taller existente "Flutter inicial"', 20,
      obtenerCupo(cuposPorTaller, 'Flutter inicial'));
  verificar('2. Consultar taller inexistente "Robótica"', 0,
      obtenerCupo(cuposPorTaller, 'Robótica'));
  verificar('3. Inscripción habilitada (true, 5)', true,
      puedeInscribirse(true, 5));
  verificar('4. Inscripción sin cupos (true, 0)', false,
      puedeInscribirse(true, 0));
  verificar('5. Inscripción cerrada (false, 5)', false,
      puedeInscribirse(false, 5));
  int tamanoAntes = participantesRegistrados.length;
  registrarParticipante('Ana', participantesRegistrados,
      inscripcionesAbiertas: true, cuposDisponibles: 5);
  verificar('6. Participante duplicado "Ana" (tamaño del Set)', tamanoAntes,
      participantesRegistrados.length);
  verificar('7. Filtro de talleres que contienen "Flutter"',
      ['Flutter inicial', 'Flutter inicial'],
      talleres.where((t) => t.contains('Flutter')).toList());
  verificar('8. Talleres diferentes en la lista', 3,
      contarTalleresDiferentes(talleres));
  print('\nPruebas aprobadas: $pruebasAprobadas de $pruebasTotales');
}

void main() {
  // Datos iniciales obligatorios
  List<String> talleres = [
    'Flutter inicial',
    'Dart desde cero',
    'Diseño UX',
    'Flutter inicial',
  ];

  Map<String, int> cuposPorTaller = {
    'Flutter inicial': 20,
    'Dart desde cero': 25,
    'Diseño UX': 15,
  };

  // ignore: equal_elements_in_set
  Set<String> participantesRegistrados = {'Ana', 'Luis', 'Marta', 'Ana'};

  bool inscripcionesAbiertas = true;
  String nombreUniversidad = 'UNIBE';

  Map<String, int> cuposIniciales = Map.of(cuposPorTaller);
  Set<String> participantesIniciales = Set.of(participantesRegistrados);

  bool salir = false;
  while (!salir) {
    limpiarPantalla();
    mostrarEncabezado(nombreUniversidad);
    print('\n----------- MENÚ -----------');
    print('1. Consultar talleres');
    print('2. Consultar cupo de un taller');
    print('3. Buscar talleres por texto');
    print('4. Registrar participante');
    print('5. Ver participantes registrados');
    print('6. ${inscripcionesAbiertas ? 'Cerrar' : 'Abrir'} inscripciones');
    print('7. Ver resumen');
    print('8. Ejecutar demostración y pruebas (actividades A–F)');
    print('0. Salir');

    String? opcion = leer('Seleccione una opción: ');
    switch (opcion) {
      case '1':
        mostrarTituloAccion('CONSULTAR TALLERES');
        mostrarTalleres(talleres, cuposPorTaller);
      case '2':
        mostrarTituloAccion('CONSULTAR CUPO DE UN TALLER');
        consultarCupo(talleres, cuposPorTaller);
      case '3':
        mostrarTituloAccion('BUSCAR TALLERES POR TEXTO');
        buscarTalleres(talleres);
      case '4':
        mostrarTituloAccion('REGISTRAR PARTICIPANTE');
        registrarEnTaller(talleres, cuposPorTaller, participantesRegistrados,
            inscripcionesAbiertas);
      case '5':
        mostrarTituloAccion('PARTICIPANTES REGISTRADOS');
        mostrarParticipantes(participantesRegistrados);
      case '6':
        mostrarTituloAccion('ABRIR / CERRAR INSCRIPCIONES');
        inscripcionesAbiertas = !inscripcionesAbiertas;
        print('Inscripciones '
            '${inscripcionesAbiertas ? 'ABIERTAS' : 'CERRADAS'}.');
      case '7':
        mostrarTituloAccion('RESUMEN');
        mostrarResumen(
          universidad: nombreUniversidad,
          talleres: talleres,
          cuposPorTaller: cuposPorTaller,
          participantes: participantesRegistrados,
          inscripcionesAbiertas: inscripcionesAbiertas,
        );
      case '8':
        mostrarTituloAccion('DEMOSTRACIÓN Y PRUEBAS (ACTIVIDADES A–F)');
        ejecutarDemostracion(
          nombreUniversidad: nombreUniversidad,
          talleres: talleres,
          cuposOriginales: cuposIniciales,
          participantesOriginales: participantesIniciales,
          inscripcionesAbiertas: true,
        );
      case '0' || null:
        salir = true;
      default:
        print('Opción no válida. Intente de nuevo.');
    }

    if (!salir && !pausar()) {
      salir = true;
    }
  }
  print('\nGracias por usar el sistema de talleres de $nombreUniversidad.');
}