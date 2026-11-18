# P4-solubilidad — pasos para GraphPad Prism

Práctica 4, Sulfato de amonio. Archivo de datos:
`P4-solubilidad.tsv` (4 filas). Trae la solubilidad de la albúmina
en el sobrenadante contra la saturación de sulfato de amonio, por
triplicado. Columnas: `Saturacion_pct`, `Molaridad_M`,
`Solubilidad_mg_mL_Rep1`, `Solubilidad_mg_mL_Rep2` y
`Solubilidad_mg_mL_Rep3`.

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter 3
replicate values in side-by-side subcolumns"**, con el 3 en la
casilla. Dale a **Create**. La tabla se abre con la columna X y el
conjunto A con Y1, Y2 y Y3.

## 2. Copiar y pegar

Abre `P4-solubilidad.tsv`. Copia desde la segunda fila (sin el
encabezado) SOLO las columnas `Molaridad_M`,
`Solubilidad_mg_mL_Rep1`, `Solubilidad_mg_mL_Rep2` y
`Solubilidad_mg_mL_Rep3` (4 columnas). En Prism haz clic en la
primera celda X de la tabla y pega (Cmd+V en Mac, Ctrl+V en
Windows). La molaridad va a X y las 3 columnas de solubilidad caen
en Y1, Y2 y Y3.

La columna `Saturacion_pct` NO se pega en la tabla: va en la columna
de títulos de fila (la de la izquierda, donde dice "Title"). Copia
los valores 49, 60, 73 y 85 y pégalos ahí, o anótalos a mano. Si
pegas las 5 columnas, la X queda con la saturación (49, 60, 73, 85)
en vez de la molaridad (2.32, 2.95, 3.77, 4.59) y el ajuste de Cohn
sale mal.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Primero transforma Y a log10: Analyze → Transform, Y = Log10(Y).
Eso crea una tabla nueva con el logaritmo de la solubilidad.
Después, sobre esa tabla nueva, Analyze → Linear regression. La
ecuación de Cohn es log10(S) = beta − Ks × C, así que el intercepto
es beta y la pendiente es −Ks.

Gráfica simple: para ver la solubilidad contra la saturación en %,
crea otra tabla XY con X = `Saturacion_pct` y las mismas 3 columnas
de réplicas; la solubilidad cae al subir la saturación.

## 4. Resultado esperado

Beta = 2.40, Ks = 0.528, R² = 0.970. Las medias de solubilidad por
saturación son 12.7 mg/mL (49%), 7.71 mg/mL (60%), 3.28 mg/mL (73%)
y 0.79 mg/mL (85%).

## 5. Si no sale

- Si la X tiene 49, 60, 73 y 85 en vez de 2.32, 2.95, 3.77 y 4.59,
  borra la tabla y pega solo `Molaridad_M` + las 3 réplicas.
- Si la regresión da una pendiente cercana a 0 o un R² muy distinto
  de 0.970, revisa que transformaste Y a log10 ANTES de la
  regresión: si haces la regresión sobre la solubilidad sin
  transformar, la recta no es la de Cohn.
- Si al pegar todo cae en una sola columna, revisa el separador
  decimal (punto, no coma).
