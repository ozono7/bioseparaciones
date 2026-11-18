# P5-acetona — pasos para GraphPad Prism

Práctica 5, Acetona. Archivo de datos: `P5-acetona.tsv` (3 filas,
una por temperatura: −20, 4 y 25 °C). Trae el porcentaje de albúmina
recuperada en solución por temperatura y por concentración inicial
(10, 20 y 30 µg/mL), por triplicado. Columnas: `Temperatura_C` y 9
columnas de datos: `Recuperacion_pct_10ug_mL_Rep1`,
`Recuperacion_pct_10ug_mL_Rep2`, `Recuperacion_pct_10ug_mL_Rep3`,
`Recuperacion_pct_20ug_mL_Rep1`, `Recuperacion_pct_20ug_mL_Rep2`,
`Recuperacion_pct_20ug_mL_Rep3`, `Recuperacion_pct_30ug_mL_Rep1`,
`Recuperacion_pct_30ug_mL_Rep2` y `Recuperacion_pct_30ug_mL_Rep3`.

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **Grouped**. En
"Data table" deja marcada la opción **"Enter or import data into a
new table"**. Pon 3 conjuntos de datos (las 3 concentraciones
iniciales) y 3 réplicas por conjunto. Dale a **Create**. La tabla se
abre con 3 columnas de datos, cada una con 3 subcolumnas.

## 2. Copiar y pegar

Abre `P5-acetona.tsv`. Copia desde la segunda fila (sin el
encabezado) las 9 columnas de datos (las de `Recuperacion_pct`) y
pégalas en el área de datos de la tabla Grouped, empezando en la
primera celda de datos (Cmd+V en Mac, Ctrl+V en Windows). Las 3
primeras columnas caen en el primer grupo (10 µg/mL), las 3
siguientes en el segundo (20 µg/mL) y las 3 últimas en el tercero
(30 µg/mL).

La columna `Temperatura_C` NO se pega en el área de datos: va en la
columna de títulos de fila (la de la izquierda). Copia los valores
−20, 4 y 25 y pégalos ahí, o anótalos a mano. Si pegas
`Temperatura_C` junto con los datos, queda como una columna de
datos más y el ANOVA sale mal.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Analyze → Two-way ANOVA. Factor de fila: temperatura. Factor de
columna: concentración inicial.

## 4. Resultado esperado

La temperatura es el factor que manda (p < 0.001): la recuperación
media es 91.7% a −20 °C, 85.0% a 4 °C y 69.3% a 25 °C. La
concentración inicial tiene un efecto mucho menor (las medias por
concentración cambian pocos puntos porcentuales) y la interacción
temperatura × concentración no es significativa (p ≈ 0.11). El frío
protege la proteína para redisolverla después.

## 5. Si no sale

- Si el ANOVA no da nada significativo o la tabla tiene 9 columnas
  de datos separadas en vez de 3 grupos con 3 réplicas, la tabla se
  creó con el formato equivocado: créala de nuevo como Grouped con
  3 conjuntos de datos y 3 réplicas.
- Si la temperatura quedó como columna de datos, bórrala de ahí y
  ponla en los títulos de fila.
- Si al pegar todo cae en una sola columna, revisa el separador
  decimal (punto, no coma).
