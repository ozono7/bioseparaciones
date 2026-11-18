# P6-fplc — pasos para GraphPad Prism

Práctica 6, FPLC. Archivo de datos: `P6-fplc.tsv` (21 filas). Trae
el registro del FPLC: X es el volumen en mL (tiempo × 0.5 mL/min) y
hay dos variables Y, la absorbancia a 280 nm y la conductividad en
mS/cm. Columnas: `Volumen_mL`, `Absorbancia_280`,
`Conductividad_mS_cm` y `Fase`.

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter and plot a
single Y value for each point"** (un solo valor de Y por punto, sin
subcolumnas). Dale a **Create**.

## 2. Copiar y pegar

Abre `P6-fplc.tsv`. Copia desde la segunda fila (sin el encabezado)
las columnas `Volumen_mL`, `Absorbancia_280` y
`Conductividad_mS_cm` (3 columnas). En Prism haz clic en la primera
celda X de la tabla y pega (Cmd+V en Mac, Ctrl+V en Windows). El
volumen va a X, la absorbancia al conjunto A y la conductividad al
conjunto B. Si la tabla solo trae un conjunto de datos, Prism agrega
el segundo (B) al pegar; si no lo agrega, créalo antes con Insert →
New Data Set y pega la tercera columna ahí.

La columna `Fase` NO se pega: es solo de referencia e indica en qué
fase está cada punto. Si la pegas, entra como texto en la tabla y
estorba.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Gráfica en Prism

Pon la conductividad en el eje Y derecho (Format Axes → Right Y
axis, conjunto B), porque sus valores son mucho mayores que los de
absorbancia.

## 4. Resultado esperado

La absorbancia se mantiene baja en el lavado y el equilibrio; la
conductividad sube con el NiSO4 (unos 8 mS/cm), luego con el buffer
de equilibrio (unos 45 mS/cm), baja con el HCl 0.1 M (unos 29
mS/cm) y vuelve a unos 0.5 mS/cm en el lavado final. Los límites
entre fases están en 2.5, 4.5, 9.5, 14.5 y 17.5 mL.

## 5. Si no sale

- Si la gráfica muestra una línea plana abajo y otra que lo tapa
  todo, es que la conductividad y la absorbancia comparten el mismo
  eje Y: pon la conductividad en el eje Y derecho.
- Si al pegar aparece texto en las celdas, es la columna `Fase`:
  bórrala y pega solo las 3 columnas de números.
- Si al pegar todo cae en una sola columna, revisa el separador
  decimal (punto, no coma).
