# P8-intercambio-a280-vs-bradford — pasos para GraphPad Prism

Práctica 8, Intercambio iónico. Archivo de datos:
`P8-intercambio-a280-vs-bradford.tsv` (30 filas, una por fracción).
Trae la comparación de los dos métodos de cuantificación: X es la
concentración por Bradford en mg/mL y Y es la concentración por
A280 en mg/mL (A280 / 0.667).

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter and plot a
single Y value for each point"** (un solo valor de Y por punto, sin
subcolumnas). Dale a **Create**.

## 2. Copiar y pegar

Abre `P8-intercambio-a280-vs-bradford.tsv` y copia las dos
columnas, `Concentracion_Bradford_mg_mL` y
`Concentracion_A280_mg_mL`, desde la segunda fila (sin el
encabezado) hasta el final. En Prism haz clic en la primera celda X
de la tabla y pega (Cmd+V en Mac, Ctrl+V en Windows). No hay
columnas que excluir: las dos van a la tabla.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Analyze → Linear regression. Agrega la recta identidad Y = X como
referencia (un segundo conjunto de datos con los puntos (0, 0) y
(1, 1)) y compárala con la recta ajustada.

## 4. Resultado esperado

Pendiente = 1.00, intercepto ≈ 0, R² = 0.9998. La diferencia media
entre los dos métodos es −0.0002 mg/mL y la máxima es 0.006 mg/mL:
los dos métodos coinciden.

## 5. Si no sale

Si la pendiente no es ≈ 1.00, revisa que X sea Bradford y Y sea
A280: si las intercambiaste, la pendiente sigue cerca de 1 pero el
intercepto cambia de signo. Si R² sale bajo, revisa que pegaste las
dos columnas de concentración y no la absorbancia a 280 sin
convertir.
