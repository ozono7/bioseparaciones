# P3-bradford — pasos para GraphPad Prism

Práctica 3, Bradford. Archivo de datos: `P3-bradford.tsv` (5 filas).
Trae la curva de calibración de Bradford: X es la concentración de
BSA en µg/mL (0, 2.5, 5, 10 y 20) y Y es la absorbancia a 595 nm,
por triplicado (réplica 1, 2 y 3).

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter 3
replicate values in side-by-side subcolumns"**, con el 3 en la
casilla. Dale a **Create**. La tabla se abre con la columna X y el
conjunto A con Y1, Y2 y Y3.

## 2. Copiar y pegar

Abre `P3-bradford.tsv` y copia las 4 columnas,
`Concentracion_ug_mL`, `Absorbancia_595_Rep1`,
`Absorbancia_595_Rep2` y `Absorbancia_595_Rep3`, desde la segunda
fila (sin el encabezado) hasta el final. En Prism haz clic en la
primera celda X de la tabla y pega (Cmd+V en Mac, Ctrl+V en
Windows). La concentración va a X y las 3 columnas de absorbancia
caen en Y1, Y2 y Y3. No hay columnas que excluir: las 4 van a la
tabla.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Analyze → Linear regression. Opcional: un polinomio de grado 2
(Analyze → Nonlinear regression → Polynomial, Second order) para
comparar con la recta.

## 4. Resultado esperado

Recta A595 = 0.052 + 0.0289 × C, R² = 0.999. El polinomio da un R²
apenas mayor; la recta basta para cuantificar en este rango.

## 5. Si no sale

Si al pegar las 3 columnas de absorbancia aparecen como 3 conjuntos
de datos separados (A, B y C) en vez de Y1, Y2 y Y3 de un solo
conjunto, la tabla se creó con un solo valor de Y: borra la tabla y
créala de nuevo eligiendo en Y "Enter 3 replicate values in
side-by-side subcolumns". Si al pegar todo cae en una sola columna,
revisa el separador decimal (punto, no coma).
