# Trabajo grupal: Fundamentos de Dart para aplicaciones móviles con Flutter

**UNIBE Ecuador · Aplicaciones móviles con Flutter**
**Tema:** Tipos de datos, colecciones, iterables, funciones y parámetros
**Archivo de código:** `gestion_talleres.dart`

**Integrantes y roles:**

| Rol | Integrante | Responsabilidad |
|---|---|---|
| Coordinador | Leonardo Coronel | Controla el tiempo de cada fase y verifica que todos participen. |
| Programador | Esteven Viracocha | Escribe e integra el código: funciones, filtros con `where` y el menú de consola. |
| Apoyo en pruebas y documentación | David Cocha | Revisa la regla de negocio, apoya al tester y redacta las respuestas del documento. |
| Analista | Paola Narváez | Define las estructuras de datos (List, Map, Set) y revisa que tengan sentido. |
| Tester | Isak Gomez | Ejecuta los casos de prueba y registra los resultados esperados y reales. |
| Vocero | Mateo Navas | Presenta la solución y la demostración final (2–3 minutos). |

---

## Funcionamiento del programa (enunciado del reto)

`gestion_talleres.dart` es un programa de consola con menú interactivo. Parte de los datos iniciales obligatorios (`talleres`, `cuposPorTaller`, `participantesRegistrados`, `inscripcionesAbiertas`, `nombreUniversidad`) y permite:

| Opción | Qué hace | Conceptos usados |
|---|---|---|
| 1. Consultar talleres | Lista los talleres sin repetidos, con sus cupos | List, Set (`toSet`), Map, `crearResumen` |
| 2. Consultar cupo | Muestra el cupo de un taller elegido por número o nombre; si no existe, avisa y muestra cupo 0 | Map, `obtenerCupo`, `??` |
| 3. Buscar talleres | Filtra los talleres por texto (ej. "Flutter") | Iterable, `where`, `toList` |
| 4. Registrar participante | Inscribe a una persona en un taller y descuenta un cupo | `registrarParticipante`, Set, Map |
| 5. Ver participantes | Muestra el Set de participantes | Set |
| 6. Abrir/cerrar inscripciones | Cambia el estado de las inscripciones | bool |
| 7. Ver resumen | Resumen básico: estado, cupos por taller, total de cupos, talleres sin cupo y participantes | `map`, `where`, `fold`, parámetros nombrados |
| 8. Demostración y pruebas | Recorre las actividades A–F y ejecuta los casos de prueba | Todos |
| 0. Salir | Termina el programa | — |

**Ejecutar:** `dart run gestion_talleres.dart` en la terminal. DartPad no permite leer del teclado (`stdin`), así que el menú interactivo debe ejecutarse en una terminal o en un proyecto Dart local.

**Ejemplo de uso real (verificado):** se registró a Carlos en "Flutter inicial" y el cupo bajó de 20 a 19. Al intentar registrar otra vez a "Ana", el registro se rechazó por duplicado. Con las inscripciones cerradas, el programa no permitió registrar. El resumen final mostró 59 cupos en total y 4 participantes.

## Actividad A: Variables y tipos (10 pts)

| Variable | Tipo | Valor | ¿Qué representa? |
|---|---|---|---|
| `nombreUniversidad` | `String` | `'UNIBE'` | Texto: el nombre de la universidad. |
| `tallerSeleccionado` | `String` | `'Flutter inicial'` | Texto: el nombre de un taller. |
| `cupoTaller` | `int` | `20` | Número entero: los cupos del taller. |
| `inscripcionesAbiertas` | `bool` | `true` | Valor lógico: si las inscripciones están abiertas (`true`) o cerradas (`false`). |

## Actividad B: List, Map y Set (15 pts)

- **List (`talleres`):** se muestran los 4 elementos en orden: Flutter inicial, Dart desde cero, Diseño UX, Flutter inicial.
- **Map (`cuposPorTaller`):** `cuposPorTaller['Flutter inicial']` devuelve **20**.
- **Cantidades:** la lista tiene **4** talleres y el Set tiene **3** participantes únicos (`{Ana, Luis, Marta}`).
- **¿Por qué la List admite repetidos y el Set no?** Una `List` es una colección ordenada en la que cada elemento ocupa una posición (índice), así que el mismo valor puede estar en dos posiciones distintas. Un `Set` es un conjunto: antes de agregar un elemento comprueba si ya existe (usando `==` y `hashCode`) y, si existe, no lo vuelve a agregar. Por eso `'Ana'` aparece dos veces en el literal pero el Set solo la guarda una vez.

## Actividad C: Funciones y parámetros (20 pts)

Funciones implementadas: `mostrarEncabezado`, `obtenerCupo`, `puedeInscribirse` y `crearResumen`. Se probaron así:

- `mostrarEncabezado('UNIBE')` imprime `=== Talleres de UNIBE ===`.
- `obtenerCupo(cupos, 'Flutter inicial')` devuelve 20 y `obtenerCupo(cupos, 'Robótica')` devuelve 0.
- `puedeInscribirse`: (true, 5) → true; (true, 0) → false; (false, 5) → false; (false, 0) → false.
- `crearResumen(taller: 'Dart desde cero', cupos: 25)` usa el valor predeterminado `incluirDetalle = true` y devuelve `Taller: Dart desde cero | Cupos disponibles: 25`. Con `incluirDetalle: false` devuelve solo `Diseño UX`.

**¿Qué función devuelve un valor?**
`obtenerCupo` (devuelve un `int`), `puedeInscribirse` (devuelve un `bool`) y `crearResumen` (devuelve un `String`). `mostrarEncabezado` es `void`: solo imprime y no devuelve nada.

**¿Qué diferencia hay entre un parámetro posicional y uno nombrado?**
El posicional se pasa según su orden: en `puedeInscribirse(true, 5)` el primer valor siempre es el estado y el segundo los cupos. El nombrado se declara entre llaves `{}` y se pasa escribiendo su nombre (`crearResumen(taller: 'X', cupos: 10)`). Así el orden no importa y la llamada se entiende mejor al leerla.

**¿Para qué se usa `required`?**
Los parámetros nombrados son opcionales por defecto. `required` hace que uno sea obligatorio: si no se pasa `taller` o `cupos` a `crearResumen`, el programa no compila. Los parámetros que no son obligatorios pueden tener un valor predeterminado, como `incluirDetalle = true`.

## Actividad D: Iterables y filtrado (20 pts)

- Filtro "Flutter": `talleres.where((t) => t.contains('Flutter')).toList()` da `[Flutter inicial, Flutter inicial]`, con **2** resultados.
- Segundo filtro (más de 10 caracteres): `talleres.where((t) => t.length > 10).toList()` da `[Flutter inicial, Dart desde cero, Flutter inicial]`, con **3** resultados. "Diseño UX" tiene 9 caracteres y queda fuera.
- Además se usó `map(...).toList()` para convertir cada taller del Map en una línea de resumen.

**¿Qué hace `where`?**
Recorre cada elemento y le aplica una condición (una función que devuelve `bool`). Conserva solo los elementos que cumplen la condición. No modifica la lista original.

**¿Por qué la variable puede declararse como `Iterable<String>`?**
Porque `where` no devuelve una `List`, sino un `Iterable<String>`: una secuencia que se puede recorrer. Es perezoso (*lazy*), es decir, el filtro no se ejecuta hasta que se recorre el resultado (con un `for`, `toList()`, `length`, etc.). Para tener una lista concreta, con índices y que se pueda modificar, se llama a `.toList()`.

## Actividad E: Regla de negocio (20 pts)

La función `registrarParticipante(nombre, participantes, {required inscripcionesAbiertas, required cuposDisponibles})` valida en este orden:

1. Nombre vacío → `Registro rechazado: el nombre no puede estar vacío.`
2. Inscripciones cerradas → `Registro rechazado: las inscripciones están cerradas.`
3. Sin cupos → `Registro rechazado: no hay cupos disponibles.`
4. Persona ya registrada → `Registro rechazado: Ana ya está registrado/a.`
5. Registro válido → agrega a la persona al Set y devuelve `Registro exitoso: Carlos fue inscrito/a. Total de participantes: 4.`

## Actividad F: Integración y tabla de pruebas (15 pts)

Todo está integrado en `main()` de `gestion_talleres.dart`. El programa se ejecutó con `dart run gestion_talleres.dart` y terminó sin errores.

| N.º | Caso | Entrada | Resultado esperado | Resultado real | Estado |
|---|---|---|---|---|---|
| 1 | Consultar taller existente | `'Flutter inicial'` | 20 | 20 | ✅ |
| 2 | Consultar taller inexistente | `'Robótica'` | 0 | 0 | ✅ |
| 3 | Inscripción habilitada | abiertas=true, cupos=5 | true (sí puede) | true | ✅ |
| 4 | Inscripción sin cupos | abiertas=true, cupos=0 | false (no puede) | false | ✅ |
| 5 | Inscripción cerrada | abiertas=false, cupos=5 | false (no puede) | false | ✅ |
| 6 | Participante duplicado | `'Ana'` | el tamaño del Set no cambia (4) | 4 | ✅ |
| 7 | Filtro de talleres | contiene `'Flutter'` | `[Flutter inicial, Flutter inicial]` | `[Flutter inicial, Flutter inicial]` | ✅ |
| 8 | Talleres diferentes (extensión) | lista de talleres | 3 | 3 | ✅ |

**Resultado: 8 de 8 pruebas aprobadas.**

### Extensión opcional (realizada)

- `contarTalleresDiferentes(talleres)` devuelve **3**.
- `eliminarDuplicados(['Ana','Luis','Ana','Marta','Luis'])` devuelve `{Ana, Luis, Marta}`.

---

## Preguntas de reflexión

**1. ¿Qué diferencia práctica existe entre List y Set?**
La `List` mantiene el orden, permite acceder por índice (`talleres[0]`) y admite repetidos. Sirve, por ejemplo, para un historial o una lista de mensajes. El `Set` no admite duplicados y comprueba muy rápido si un elemento existe (`contains`). Sirve para participantes inscritos, etiquetas o IDs únicos.

**2. ¿Cuándo resulta útil un Map en una aplicación móvil?**
Cuando hay que buscar un valor a partir de una clave: cupos por taller, configuración de la app (`'tema': 'oscuro'`), traducciones por idioma, o datos JSON que llegan de una API. Estos últimos en Dart se convierten en `Map<String, dynamic>`.

**3. ¿Qué ventaja tiene encapsular una operación en una función en lugar de repetir código?**
La lógica se escribe una sola vez y se reutiliza. Si hay que cambiar una regla, se corrige en un solo lugar. Además el código se lee mejor, porque el nombre de la función explica lo que hace, y la función se puede probar por separado, como hicimos con los casos de prueba.

**4. ¿Qué ocurre cuando una función devuelve un valor y qué ocurre cuando su tipo de retorno es void?**
Si devuelve un valor (`int`, `bool`, `String`…), `return` envía ese resultado a quien la llamó, que puede guardarlo en una variable o usarlo en otra expresión. Si es `void`, solo ejecuta una acción (por ejemplo, imprimir) y no entrega ningún resultado que se pueda usar.

**5. ¿Por qué puede ser útil declarar una variable como Iterable en lugar de convertir inmediatamente el resultado a List?**
Porque el `Iterable` es perezoso: no crea una lista nueva en memoria y solo procesa los elementos cuando se recorren. Se pueden encadenar varias operaciones (`where`, `map`, `take`) sin crear listas intermedias. Si al final solo se necesita, por ejemplo, el primer elemento (`first`), se evita procesar todo. Se convierte a `List` solo cuando hace falta usar índices, modificar la colección o recorrerla varias veces.

**6. ¿Qué validaciones agregarían si esta lógica se conectara a una pantalla de registro real?**
- Nombre no vacío, sin espacios sobrantes y con longitud mínima y máxima.
- Detectar duplicados sin importar mayúsculas y minúsculas (`'ana'` = `'Ana'`).
- Correo institucional con formato válido (por ejemplo `@unibe.edu.ec`) y cédula ecuatoriana válida.
- Que el taller seleccionado exista y que sus cupos se descuenten de verdad al inscribir a alguien.
- Evitar que una persona se inscriba dos veces en el mismo taller o en talleres con el mismo horario.
- Mensajes de error claros en pantalla y botón deshabilitado si las inscripciones están cerradas.

---

## Reparto de explicación por integrante

Regla de colaboración: cada integrante explica al menos una variable, una colección y una función.

| Integrante | Variable | Colección | Función |
|---|---|---|---|
| Leonardo Coronel | `nombreUniversidad` (String) | `talleres` (List) | `mostrarEncabezado` |
| Paola Narváez | `cupoTaller` (int) | `cuposPorTaller` (Map) | `obtenerCupo` |
| Isak Gomez | `inscripcionesAbiertas` (bool) | `participantesRegistrados` (Set) | `puedeInscribirse` |
| Esteven Viracocha | `tallerSeleccionado` (String) | `talleresFlutter` (Iterable con `where`) | `crearResumen` |
| David Cocha | `cuposDisponibles` (int) | `participantes` (Set dentro del registro) | `registrarParticipante` |
| Mateo Navas | `cuposTotales` (int) | `sinCupo` (List obtenida con `where` y `toList`) | `mostrarResumen` |

### Lo que entendió cada integrante

**Leonardo Coronel (Coordinador)**
"A mí me tocó la parte del inicio del programa. La variable `nombreUniversidad` es un String, que básicamente es texto. Ahí guardamos 'UNIBE' para no escribirlo a mano cada vez. Los talleres los pusimos en una List, que es como una lista normal: tiene un orden y se puede repetir algo. Por eso 'Flutter inicial' aparece dos veces y no da error. La función `mostrarEncabezado` es la más sencilla: le pasas el nombre de la universidad e imprime el título. No devuelve nada, solo muestra el mensaje. Por eso es `void`. Me pareció útil porque si mañana cambiamos el nombre, solo se cambia en un lugar."

**Paola Narváez (Analista)**
"Yo me encargué de pensar cómo guardar los datos. Para los cupos usé un Map, que lo entendí como un diccionario: buscas la palabra (el nombre del taller) y te da su significado (el número de cupos). Así, si pregunto por 'Flutter inicial', me dice 20 directamente. El cupo es un int porque los cupos son números enteros, no hay medio cupo. La función `obtenerCupo` busca el taller en el Map y, si no lo encuentra, devuelve 0 en vez de dañar el programa. Eso lo probamos con 'Robótica', que no existe, y salió 0, que es lo que esperábamos."

**Isak Gomez (Tester)**
"Mi parte fue probar que todo funcione. La variable `inscripcionesAbiertas` es un bool, o sea, solo puede ser verdadero o falso, como un interruptor de prendido y apagado. Los participantes están en un Set, y lo que más me llamó la atención es que, aunque escribimos 'Ana' dos veces, el Set solo la guardó una vez, porque no acepta repetidos. La función `puedeInscribirse` revisa dos cosas: que las inscripciones estén abiertas y que haya cupos. Si falta una de las dos, dice que no. La probé con abiertas y cupos 5 (sí), con cupos 0 (no) y con inscripciones cerradas (no), y salió todo como esperábamos. En total pasaron las 8 pruebas."

**Esteven Viracocha (Programador)**
"Yo me encargué de armar el código y juntar todo en el menú. Con `where` le dices a la lista: 'dame solo los que cumplan esto'. Por ejemplo, los talleres que tengan la palabra 'Flutter'. Lo que devuelve es un Iterable, que entendí como una lista 'en espera': todavía no se ha armado del todo hasta que la recorres o la conviertes con `toList()`. La función `crearResumen` tiene algo interesante: los parámetros van con nombre, entonces al llamarla escribes `taller:` y `cupos:` y queda clarísimo qué es cada cosa. Además, como tienen `required`, si te olvidas de alguno el programa ni siquiera arranca. Y `incluirDetalle` ya viene en `true` por defecto, así que no hace falta ponerlo siempre."

**David Cocha (Apoyo en pruebas y documentación)**
"A mí me tocó revisar la regla de negocio, que es la parte de registrar a una persona, y ayudar a escribir las respuestas del documento. La función `registrarParticipante` funciona como un guardia en la puerta: primero revisa que el nombre no esté vacío, luego que las inscripciones estén abiertas, después que haya cupos (`cuposDisponibles`, que es un int) y al final que la persona no esté ya registrada. Si pasa todos los filtros, se agrega al Set y te dice 'Registro exitoso'. Si falla en alguno, te explica por qué no se pudo. Me gustó que el Set ayuda solito a evitar duplicados, y además en el menú, cuando alguien se inscribe, el cupo del taller baja de uno en uno, por ejemplo de 20 a 19."

**Mateo Navas (Vocero)**
"Mi parte es el resumen, que junta todo lo que hicieron mis compañeros. En `cuposTotales` sumamos los cupos de todos los talleres, y es un int porque es un número entero. Para saber qué talleres ya no tienen cupo usamos `where` para filtrar los que están en cero y `toList()` para tenerlos como lista. Así se guarda en `sinCupo`. La función `mostrarResumen` muestra en pantalla si las inscripciones están abiertas, cuántos cupos quedan en cada taller y quiénes están inscritos. Es como el reporte final que vería el encargado de los talleres."

## Guion del vocero: Mateo Navas (2–3 minutos)

> "Nuestro programa `gestion_talleres.dart` maneja los talleres de la UNIBE.
> Usamos **String** para textos como el nombre de la universidad y de los talleres, **int** para los cupos y **bool** para saber si las inscripciones están abiertas.
> Guardamos los talleres en una **List**, que mantiene el orden y permite repetidos: por eso 'Flutter inicial' aparece dos veces. Para consultar los cupos usamos un **Map**, que asocia cada taller con su número de cupos. Los participantes van en un **Set**, que elimina duplicados: aunque escribimos 'Ana' dos veces, solo se guarda una.
> Con **where** obtenemos un **Iterable** con los talleres que contienen 'Flutter' o que tienen más de 10 caracteres, y con **toList** lo convertimos en lista.
> Creamos **funciones** con parámetros posicionales, como `obtenerCupo` y `puedeInscribirse`, y con parámetros nombrados, como `crearResumen`, que usa `required` y un valor predeterminado.
> Por último, `registrarParticipante` aplica la regla de negocio: rechaza el registro si las inscripciones están cerradas, si no hay cupos o si la persona ya está inscrita. Si todo está bien, agrega a la persona al Set.
> Ejecutamos 8 pruebas y las 8 dieron el resultado esperado."
