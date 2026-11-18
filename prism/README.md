# Datos para GraphPad Prism

Esta carpeta trae los datos de las prácticas del laboratorio en archivos
`.tsv`, listos para copiar y pegar en GraphPad Prism. Cada archivo es una
tabla de Prism: se abre, se copia y se pega, sin reescribir nada. Los
valores son los mismos que calculan los scripts `.R` de cada práctica
(misma curva de calibración de Bradford, mismos factores de dilución,
mismas conversiones).

Cada archivo `.tsv` tiene su archivo de pasos `.md` con el mismo nombre
(por ejemplo, `P4-solubilidad.md` junto a `P4-solubilidad.tsv`), con
los pasos completos de esa tabla: cómo crear la tabla en Prism, qué
copiar y pegar, el análisis, el resultado esperado y qué revisar si no
sale. Con ese archivo no hace falta abrir este README.

## Cómo copiar y pegar en Prism

1. Abre el archivo `.tsv` (doble clic: se abre en Excel, LibreOffice o en
   un editor de texto).
2. La primera fila es el encabezado con el nombre de cada columna. Al
   copiar, selecciona desde la segunda fila (los datos) hasta el final;
   el encabezado no se pega en la tabla de Prism.
3. En Prism, crea una tabla nueva del tipo y tamaño que se indica para
   cada archivo (en New Table: XY, Column o Grouped).
4. Haz clic en la primera celda de datos de la tabla y pega
   (Ctrl+V en Windows/Linux, Cmd+V en Mac).
5. En los archivos P4 y P5, la primera columna es el título de fila:
   cópiala aparte y pégala en la columna de títulos de fila de la tabla
   de Prism (la columna de la izquierda, donde van los nombres de las
   filas).

Los números usan punto decimal (.). Si al pegar los valores se ven como
texto o las celdas no se separan, revisa que el separador decimal de tu
sistema y de Prism sea el punto: en una configuración regional en
español, el separador decimal suele ser la coma y el pegado no separa
bien las celdas. Cambia el separador decimal a punto antes de pegar.

## Archivos

| Archivo | Pasos | Práctica | Tabla de Prism | Análisis en Prism |
|---|---|---|---|---|
| P1-amortiguador.tsv | P1-amortiguador.md | P1 Soluciones y pH | XY | Regresión lineal |
| P1-nernst.tsv | P1-nernst.md | P1 Soluciones y pH | XY | Regresión lineal |
| P2-calibracion-sds-page.tsv | P2-calibracion-sds-page.md | P2 SDS-PAGE | XY | Regresión lineal + interpolar |
| P3-bradford.tsv | P3-bradford.md | P3 Bradford | XY, 3 subcolumnas | Regresión lineal (+ polinomio) |
| P3-muestra-problema.tsv | P3-muestra-problema.md | P3 Bradford | (valores para interpolar) | Interpolar curva estándar |
| P4-solubilidad.tsv | P4-solubilidad.md | P4 Sulfato de amonio | XY, 3 subcolumnas | Transformar Y a log10 + regresión lineal |
| P5-acetona.tsv | P5-acetona.md | P5 Acetona | Grouped, 3 columnas x 3 subcolumnas | ANOVA de dos vías |
| P6-fplc.tsv | P6-fplc.md | P6 FPLC | XY, 2 conjuntos de datos | Gráfica con doble eje Y |
| P7-imac-cromatograma.tsv | P7-imac-cromatograma.md | P7 IMAC | XY | Área bajo la curva |
| P7-imac-a280-vs-bradford.tsv | P7-imac-a280-vs-bradford.md | P7 IMAC | XY | Regresión lineal |
| P7-imac-gel.tsv | P7-imac-gel.md | P7 IMAC sesión 2 | XY | Regresión lineal + interpolar |
| P8-intercambio-cromatograma.tsv | P8-intercambio-cromatograma.md | P8 Intercambio iónico | XY | Área bajo la curva |
| P8-intercambio-a280-vs-bradford.tsv | P8-intercambio-a280-vs-bradford.md | P8 Intercambio iónico | XY | Regresión lineal |
| P8-intercambio-gel.tsv | P8-intercambio-gel.md | P8 Intercambio iónico sesión 2 | XY | Regresión lineal + interpolar |

## P1. Soluciones y pH

### P1-amortiguador.tsv

Tabla XY con 11 filas. X = log10 de la relación base/ácido,
Y = pH. Pega las dos columnas en una tabla XY (un conjunto de datos,
sin subcolumnas).

Análisis: Analyze → Linear regression. La ecuación de
Henderson-Hasselbalch es pH = pKa + log10([base]/[ácido]), así que el
intercepto en Y es el pKa y la pendiente es 1.

Resultado esperado: intercepto = 4.76 (pKa del acetato),
pendiente = 1.00, R² = 1.000.

### P1-nernst.tsv

Tabla XY con 3 filas. X = temperatura en °C (20, 25, 30),
Y = pendiente de Nernst en mV/pH. Pega las dos columnas en una tabla
XY.

Análisis: Analyze → Linear regression.

Resultado esperado: la pendiente sube con la temperatura, unos
0.20 mV/pH por cada °C. El valor a 25 °C, la temperatura de trabajo,
es 59.17 mV/pH (58.17 a 20 °C y 60.16 a 30 °C).

## P2. SDS-PAGE

### P2-calibracion-sds-page.tsv

Tabla XY con 10 filas (las bandas del marcador). X = Rf
(distancia de la banda entre 65 mm, el frente del gel),
Y = log10 del peso molecular en kDa. Pega las dos columnas en una
tabla XY.

Análisis: Analyze → Linear regression. Después, Analyze →
Interpolate a standard curve, con X = 0.369 (el Rf de la banda de
BSA, a 24 mm). Prism devuelve log10(PM); el peso molecular es
10 elevado a ese valor.

Resultado esperado: R² = 0.994. La BSA interpola a 65.9 kDa,
cercano a su valor de referencia (66.5 kDa).

## P3. Bradford

### P3-bradford.tsv

Tabla XY con 5 filas y 3 subcolumnas de réplicas. X = concentración
de BSA en µg/mL (0, 2.5, 5, 10 y 20), Y = absorbancia a 595 nm
(réplica 1, 2 y 3). Crea una tabla XY con 3 subcolumnas en Y y pega
las 4 columnas.

Análisis: Analyze → Linear regression. Opcional: un polinomio de
grado 2 (Analyze → Nonlinear regression → Polynomial, Second order)
para comparar con la recta.

Resultado esperado: recta A595 = 0.052 + 0.0289 × C, R² = 0.999.
El polinomio da un R² apenas mayor; la recta basta para cuantificar
en este rango.

### P3-muestra-problema.tsv

Una sola columna con los 3 valores de A595 de la muestra problema
(0.382, 0.375 y 0.390). No es una tabla aparte: son los valores
desconocidos que se interpolan en la curva de P3-bradford.tsv.

Análisis: con la regresión lineal de la curva ya hecha, Analyze →
Interpolate a standard curve. En el cuadro, pega los 3 valores de
A595 como valores Y desconocidos; Prism devuelve la concentración
(X) de cada uno.

Resultado esperado: 11.4 µg/mL de media (11.2 a 11.7 por réplica).

## P4. Sulfato de amonio

### P4-solubilidad.tsv

Tabla XY con 4 filas y 3 subcolumnas de réplicas. X = molaridad de
sulfato de amonio en M, Y = solubilidad de albúmina en el
sobrenadante en mg/mL (réplica 1, 2 y 3). La primera columna,
Saturacion_pct, es el título de fila: pega las columnas Molaridad_M
y las 3 de solubilidad en la tabla XY (con 3 subcolumnas en Y) y la
saturación en la columna de títulos de fila.

Análisis: primero transforma Y a log10 (Analyze → Transform,
Y = Log10(Y)) y después Analyze → Linear regression. La ecuación de
Cohn es log10(S) = beta − Ks × C, así que el intercepto es beta y
la pendiente es −Ks.

Resultado esperado: beta = 2.40, Ks = 0.528, R² = 0.970. Las medias
de solubilidad por saturación son 12.7 mg/mL (49%), 7.71 mg/mL
(60%), 3.28 mg/mL (73%) y 0.79 mg/mL (85%).

Gráfica simple: para ver la solubilidad contra la saturación en %,
crea otra tabla XY con X = Saturacion_pct y las mismas 3 columnas
de réplicas; la solubilidad cae al subir la saturación.

## P5. Acetona

### P5-acetona.tsv

Tabla Grouped con 3 filas (temperaturas −20, 4 y 25 °C) y 3
columnas de datos (concentración inicial 10, 20 y 30 µg/mL), cada
una con 3 subcolumnas de réplicas. Pega las 9 columnas de datos en
el área de datos de la tabla Grouped y la columna Temperatura_C en
la columna de títulos de fila.

Análisis: Analyze → Two-way ANOVA. Factor de fila: temperatura.
Factor de columna: concentración inicial.

Resultado esperado: la temperatura es el factor que manda
(p < 0.001): la recuperación media es 91.7% a −20 °C, 85.0% a 4 °C
y 69.3% a 25 °C. La concentración inicial tiene un efecto mucho
menor (las medias por concentración cambian pocos puntos
porcentuales) y la interacción temperatura × concentración no es
significativa (p ≈ 0.11). El frío protege la proteína para
redisolverla después.

## P6. FPLC

### P6-fplc.tsv

Tabla XY con 21 filas y 2 conjuntos de datos. X = volumen en mL
(tiempo × 0.5 mL/min), Y = absorbancia a 280 nm (conjunto A) y
conductividad en mS/cm (conjunto B). Crea una tabla XY con 2
conjuntos de datos y pega las columnas Volumen_mL, Absorbancia_280
y Conductividad_mS_cm. La columna Fase es solo de referencia: indica
en qué fase está cada punto.

Gráfica: pon la conductividad en el eje Y derecho (Format Axes →
Right Y axis, conjunto B), porque sus valores son mucho mayores que
los de absorbancia.

Resultado esperado: la absorbancia se mantiene baja en el lavado y
el equilibrio; la conductividad sube con el NiSO4 (unos 8 mS/cm),
luego con el buffer de equilibrio (unos 45 mS/cm), baja con el HCl
0.1 M (unos 29 mS/cm) y vuelve a unos 0.5 mS/cm en el lavado final.
Los límites entre fases están en 2.5, 4.5, 9.5, 14.5 y 17.5 mL.

## P7. IMAC

### P7-imac-cromatograma.tsv

Tabla XY con 30 filas (una por fracción). X = fracción,
Y = concentración de proteína en mg/mL (Bradford). Pega las
columnas Fraccion y Concentracion_mg_mL. La columna Fase es solo de
referencia: fracciones 1 a 10 son carga y lavado (pH 7.0) y 11 a 30
son desorción (pH 4.0).

Análisis: el pico está en desorción (fracción 15, 0.97 mg/mL).
Para la masa recuperada, Analyze → Area under the curve sobre las
fracciones de desorción (11 a 30) y multiplica el área por 0.5 mL
por fracción.

Resultado esperado: el área bajo la curva da unos 2.57 mg, que es
la masa recuperada en desorción (la suma de concentración × 0.5 mL
por fracción da 2.63 mg; la diferencia es la aproximación del
trapezoide del área). Eso es el 43.8% de los 6 mg cargados
(3 mL a 2 mg/mL).

### P7-imac-a280-vs-bradford.tsv

Tabla XY con 30 filas. X = concentración por Bradford en mg/mL,
Y = concentración por A280 en mg/mL (A280 / 0.667). Pega las dos
columnas en una tabla XY.

Análisis: Analyze → Linear regression. Agrega la recta identidad
Y = X como referencia (un segundo conjunto de datos con los puntos
(0, 0) y (1, 1)) y compárala con la recta ajustada.

Resultado esperado: pendiente = 1.00, intercepto ≈ 0, R² = 0.9998.
La diferencia media entre los dos métodos es −0.0014 mg/mL y la
máxima es 0.0056 mg/mL: los dos métodos coinciden.

### P7-imac-gel.tsv

Tabla XY con 10 filas (las bandas del marcador de la sesión 2).
X = Rf (distancia entre 65 mm, el frente del gel),
Y = log10 del peso molecular en kDa. Pega las dos columnas en una
tabla XY.

Análisis: Analyze → Linear regression. Después, Analyze →
Interpolate a standard curve, con X = 0.369 (el Rf de las bandas de
BSA, a 24 mm). Prism devuelve log10(PM); el peso molecular es
10 elevado a ese valor.

Resultado esperado: R² = 0.994. Las bandas de BSA interpolan a
65.9 kDa, cercano a su valor de referencia (66.5 kDa).

## P8. Intercambio iónico

### P8-intercambio-cromatograma.tsv

Igual que P7-imac-cromatograma.tsv, con los datos de intercambio
iónico. Tabla XY con 30 filas. X = fracción,
Y = concentración de proteína en mg/mL (Bradford). La columna Fase
es solo de referencia: fracciones 1 a 10 son carga y lavado
(Tris pH 8.0) y 11 a 30 son desorción (NaCl 500 mM).

Análisis: el pico está en desorción (fracción 14, 0.88 mg/mL).
Analyze → Area under the curve sobre las fracciones de desorción
(11 a 30) y multiplica el área por 0.5 mL por fracción.

Resultado esperado: el área bajo la curva da unos 2.07 mg, que es
la masa recuperada en desorción (la suma da 2.11 mg). Eso es el
35.1% de los 6 mg cargados.

### P8-intercambio-a280-vs-bradford.tsv

Igual que P7-imac-a280-vs-bradford.tsv. Tabla XY con 30 filas.
X = concentración por Bradford en mg/mL,
Y = concentración por A280 en mg/mL. Agrega la recta identidad
Y = X como referencia.

Resultado esperado: pendiente = 1.00, intercepto ≈ 0, R² = 0.9998.
La diferencia media entre los dos métodos es −0.0002 mg/mL y la
máxima es 0.006 mg/mL.

### P8-intercambio-gel.tsv

Igual que P7-imac-gel.tsv. Tabla XY con 10 filas (marcador de la
sesión 2). Interpola con X = 0.369 (bandas de BSA a 24 mm).

Resultado esperado: R² = 0.994. Las bandas de BSA interpolan a
65.9 kDa, cercano a su valor de referencia (66.5 kDa).
