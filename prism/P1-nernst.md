# P1-nernst — pasos para GraphPad Prism

Práctica 1, Soluciones y pH. Archivo de datos: `P1-nernst.tsv`
(3 filas). Trae la pendiente de Nernst del electrodo de pH a tres
temperaturas: X es la temperatura en °C (20, 25 y 30) y Y es la
pendiente en mV/pH (58.17, 59.17 y 60.16).

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter and plot a
single Y value for each point"** (un solo valor de Y por punto, sin
subcolumnas). Dale a **Create**.

## 2. Copiar y pegar

Abre `P1-nernst.tsv` y copia las dos columnas, `Temperatura_C` y
`Pendiente_mV_pH`, desde la segunda fila (sin el encabezado) hasta
el final. En Prism haz clic en la primera celda X de la tabla y pega
(Cmd+V en Mac, Ctrl+V en Windows). No hay columnas que excluir: las
dos van a la tabla.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Analyze → Linear regression.

## 4. Resultado esperado

La pendiente sube con la temperatura, unos 0.20 mV/pH por cada °C.
El valor a 25 °C, la temperatura de trabajo, es 59.17 mV/pH
(58.17 a 20 °C y 60.16 a 30 °C).

## 5. Si no sale

Si los valores se ven sin decimales o como texto, revisa el
separador decimal (punto, no coma). Si la recta no sube con la
temperatura, revisa que X sea la temperatura en °C y no la
pendiente.
