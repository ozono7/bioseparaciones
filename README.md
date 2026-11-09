# Bioseparaciones

Material académico para estudiantes del curso **Procesos de Bioseparación**
(UASLP, Facultad de Ciencias Químicas, Ingeniería de Bioprocesos,
agosto–diciembre 2026).

- Teoría: Omar González Ortega.
- Laboratorio: Alejandra Wong Arce y José Juan Torres Martínez.

El objetivo del curso es modelar y diseñar procesos de separación aplicados
a la purificación de biomoléculas. El laboratorio refuerza las buenas
prácticas y aplica la teoría a la purificación de proteínas, con énfasis en
el principio de cada procedimiento.

## El formato: un recorrido por la planta

Cada lección es una parada de un recorrido por una planta industrial de
bioseparación (y, en el laboratorio, una estación del laboratorio de la
planta). En cada parada se comenta qué equipo o proceso estamos viendo,
qué se mide ahí y por qué, se hace el análisis con los datos y se da su
interpretación: qué significa el resultado y qué sigue. La teoría recorre
la línea de proceso en orden — caracterización, precipitación,
rompimiento celular, centrifugación, ultrafiltración, adsorción,
extracción y secado — y el laboratorio recorre sus estaciones en el orden
de las prácticas, de la planeación (P0) al intercambio iónico (P8).

Cada lección de laboratorio incluye además el protocolo completo de la
práctica tal como viene en el Manual de Prácticas (pasos, volúmenes,
concentraciones, tiempos y condiciones), narrado paso a paso dentro del
recorrido, antes del análisis de los datos. Las tablas de recetas y de
calibración del manual van como tablas de datos en el script.

## Cómo usar este repositorio

Cada lección es un script de R que lee sus datos de un archivo CSV en la
misma carpeta, calcula todo a partir de los datos y guarda sus gráficas
como PNG a 300 dpi con `ggsave()`. Para correr una lección, abre R o
RStudio en la carpeta de la lección y ejecuta el script. Los paquetes
necesarios son los de `tidyverse`.

Reglas de las lecciones:

- Los datos van primero, como mediciones en CSV.
- Todo se calcula de cero a partir de los datos: nada está pre-cocinado.
- Cada lección es una parada del recorrido: en cada paso se comenta qué se
  está haciendo, se hace el análisis con los datos y se da su interpretación.
- Cada lección de laboratorio lleva el protocolo completo del manual
  (pasos, volúmenes, concentraciones, tiempos y condiciones) antes del
  análisis de los datos.
- Cada script termina con Interpretación por gráfico y Qué aprendimos.
- Los modelos son los estándar de la bibliografía del curso (Cohn,
  Stokes, Langmuir, flux de ultrafiltración, coeficiente de partición).

## Teoría

| Unidad | Lección | Contenido |
| --- | --- | --- |
| 1 | `teoria/01-introduccion/` | Difusividad molecular (Stokes-Einstein) y carga neta contra pH, punto isoeléctrico |
| 2 | `teoria/02-precipitacion/` | Precipitación: ecuación de Cohn (salting-out) |
| 3 | `teoria/03-rompimiento-celular/` | Rompimiento celular: liberación de proteína por pasadas (molino de perlas y homogeneizador) |
| 4 | `teoria/04-centrifugacion-filtracion/` | Centrifugación: Ley de Stokes y fuerza centrífuga relativa (RCF) |
| 5 | `teoria/05-ultrafiltracion/` | Ultrafiltración: flux contra TMP, flux límite y diafiltración |
| 6 | `teoria/06-adsorcion/` | Adsorción: isoterma de Langmuir |
| 7 | `teoria/07-extraccion-liquido-liquido/` | Extracción líquido-líquido: coeficiente de partición y pH |
| 8 | `teoria/08-secado/` | Secado: curva de secado, velocidad de secado y calor de evaporación |

## Laboratorio

| Práctica | Lección | Contenido |
| --- | --- | --- |
| P0 | `laboratorio/00-introduccion/` | Planeación y evaluación del laboratorio |
| P1 | `laboratorio/01-soluciones-ph/` | Preparación de soluciones, filtración y ajuste de pH |
| P2 | `laboratorio/02-sds-page/` | SDS-PAGE: peso molecular a partir de la migración |
| P3 | `laboratorio/03-bradford/` | Ensayo de Bradford: curva de calibración |
| P4 | `laboratorio/04-sulfato-amonio/` | Precipitación de albúmina con sulfato de amonio (ecuación de Cohn) |
| P5 | `laboratorio/05-acetona/` | Precipitación de albúmina con acetona (efecto de la temperatura) |
| P6 | `laboratorio/06-fplc/` | Introducción al FPLC (BioLogic LP) |
| P7 | `laboratorio/07-imac/` | Cromatografía de afinidad por metal inmovilizado (IMAC) |
| P8 | `laboratorio/08-intercambio-ionico/` | Cromatografía de intercambio iónico |

## Próximas lecciones (planeadas)

- Teoría 1: equilibrio de un soluto en dos fases y equilibrio sólido-líquido; potencial ζ y bioafinidad.
- Teoría 2: precipitación por pH, solventes y polímeros; precipitación por desnaturalización selectiva y por afinidad.
- Teoría 3: métodos químicos de rompimiento (choque osmótico, digestión enzimática, tratamiento alcalino); diseño de molino de perlas en continuo, microfluidizador y ultrasonicador.
- Teoría 4: centrifugación diferencial y con gradiente de densidad; diseño de centrífuga tubular y de discos; escalamiento; filtración intermitente, continua y centrífuga.
- Teoría 5: concentración intermitente y continua; diafiltración repetida y en cascada; diálisis.
- Teoría 6: diseño de adsorbedores por lotes (estacionario y no estacionario); lecho fijo por platos teóricos y por transferencia de masa; lecho a contracorriente.
- Teoría 7: cambios en el soluto por par iónico; diseño de extractor continuo; extracción diferencial.
- Teoría 8: diseño de secadores adiabáticos y no adiabáticos.
- P1: filtración convencional (ecuación de filtración) y calibración del pH-metro.
- P2: gel separador al 7.5% (cálculo de volúmenes de reactivos).
- P3: interferencias del ensayo de Bradford y ley de Beer-Lambert.
- P4: redisolución de los precipitados y máxima solubilidad del sulfato de amonio.
- P5: modelo de solubilidad contra constante dieléctrica del solvente.
- P6: comparación HPLC contra FPLC y funcionamiento del colector de fracciones.
- P7: análisis por SDS-PAGE de las fracciones de IMAC (segunda sesión).
- P8: análisis por SDS-PAGE de las fracciones de intercambio iónico (segunda sesión).

## Bibliografía

- Forciniti, D. (2008). *Industrial Bioseparations*. Wiley-Blackwell.
- Tejeda, A., Montesinos, R. M., & Guzman, R. (2011). *Bioseparaciones*. Pearson.
- Belter, P., Cussler, E. L., & Hu, W. (1988). *Bioseparations*. Wiley Interscience.

Fuentes del curso: Manual de Prácticas del Laboratorio de Procesos de
Bioseparación (FCQ-UASLP, agosto 2026) y Planeación Semestral de la
asignatura (agosto–diciembre 2026).

## Datos y normas por verificar

- **Práctica 4 (sulfato de amonio):** los gramos por vial (1.53, 1.95,
  2.49 y 3.03 g por 5 mL para 49, 60, 73 y 85% de saturación) son los
  indicados en el manual. Las molaridades de este repositorio se
  calculan directamente de esos gramos (2.32, 2.95, 3.77 y 4.59 M).
  El porcentaje de saturación nominal depende de la temperatura y del
  aumento de volumen al disolver la sal, por lo que la correspondencia
  gramos–porcentaje debe comprobarse con la tabla de referencia citada
  en el manual: http://www.encorbio.com/protocols/AM-SO4.htm
- **Práctica 3 (Bradford):** el manual indica en el texto el rango
  1.25–20 µg/mL y en su Tabla 1 los estándares 0, 2.5, 5, 10 y 20
  µg/mL. Este repositorio usa la Tabla 1 del manual.
- **Práctica 2 (SDS-PAGE), gel concentrador:** la Tabla 2 del manual dice
  "Buffer Tris-base 8.8", aunque la lista de reactivos de la misma
  práctica incluye el buffer Tris pH 6.8. La receta se reproduce como
  viene en el manual; conviene confirmarlo con el instructor antes de
  preparar el gel.
- **Práctica 2 (SDS-PAGE), muestras:** se preparan 20 µl (15 µl de stock
  + 5 µl de buffer de carga) y se cargan 15 µl en el gel, como indica el
  manual.
- **Prácticas 7 y 8, sesión 2 (SDS-PAGE de las fracciones):** el manual
  solo indica analizar las fracciones "mediante SDS PAGE (sesión 2)",
  sin detallar la preparación de esas muestras. La indicación de
  calentarlas 2 min en microtubos y cargarlas con buffer de carga 50/50
  (50% muestra y 50% buffer) es la indicación del curso para esa sesión,
  no un paso del manual.
- **Práctica 7 (IMAC):** el manual indica analizar las fracciones por
  absorbancia a 280 nm (excepto los tubos con níquel) y por SDS-PAGE en
  la sesión 2; las concentraciones por fracción de este repositorio son
  las mediciones de ejemplo del CSV (Bradford).
- **Albúmina (BSA):** peso molecular 66.5 kDa y punto isoeléctrico 4.7
  son los valores de referencia habituales para la albúmina de suero
  bovino (UniProt P02769): https://www.uniprot.org/uniprotkb/P02769/entry
- **Carga neta contra pH (Teoría 1):** los valores de carga neta son un
  modelo lineal simplificado alrededor del pI, para enseñar a leer el
  punto isoeléctrico; no son cargas medidas residuo por residuo.
- **Datos de laboratorio:** las absorbancias, concentraciones y
  porcentajes de recuperación de las prácticas son mediciones de
  ejemplo consistentes con los protocolos del manual, para que cada
  script corra completo. Al usarlos en clase, se sustituyen por los
  datos medidos por cada equipo.

## Autor

Dr. José Juan Torres Martínez — Docente de Ciencias Químicas, UASLP, México.
Material académico para estudiantes.
