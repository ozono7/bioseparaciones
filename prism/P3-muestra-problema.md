# P3-muestra-problema — pasos para GraphPad Prism

Práctica 3, Bradford. Archivo de datos: `P3-muestra-problema.tsv`
(una sola columna con 3 valores). Trae los 3 valores de A595 de la
muestra problema (0.382, 0.375 y 0.390). Este archivo NO es una
tabla aparte: son los valores desconocidos que se interpolan en la
curva de `P3-bradford.tsv`.

## 1. Crear la tabla en Prism

No se crea una tabla nueva para este archivo. Primero haz la
regresión lineal de la curva de Bradford siguiendo los pasos de
`P3-bradford.md`; la interpolación usa esa recta.

## 2. Copiar y pegar

Abre `P3-muestra-problema.tsv` y copia los 3 valores de
`Absorbancia_595` desde la segunda fila (sin el encabezado). No se
pegan en una tabla: se pegan en el cuadro de diálogo de la
interpolación (paso 3).

Los números usan punto decimal (.). Si al pegar los valores se ven
como texto, revisa que el separador decimal sea el punto.

## 3. Análisis en Prism

Con la regresión lineal de la curva ya hecha, Analyze →
Interpolate a standard curve. En el cuadro, pega los 3 valores de
A595 como valores Y desconocidos; Prism devuelve la concentración
(X) de cada uno.

## 4. Resultado esperado

11.4 µg/mL de media (11.2 a 11.7 por réplica).

## 5. Si no sale

Si Prism no deja interpolar o devuelve un error, revisa que la
regresión lineal de la curva esté hecha antes: la interpolación usa
esa recta. Si el valor sale fuera del rango 0–20 µg/mL, revisa que
pegaste los valores como Y desconocidos y no como X.
