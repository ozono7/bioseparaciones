# P1-amortiguador — pasos para GraphPad Prism

Práctica 1, Soluciones y pH. Archivo de datos: `P1-amortiguador.tsv`
(11 filas). Trae la curva del amortiguador de acetato: X es el log10
de la relación base/ácido y Y es el pH.

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter and plot a
single Y value for each point"** (un solo valor de Y por punto, sin
subcolumnas). Dale a **Create**.

## 2. Copiar y pegar

Abre `P1-amortiguador.tsv` y copia las dos columnas,
`Log10_Relacion_Base_Acido` y `pH`, desde la segunda fila (sin el
encabezado) hasta el final. En Prism haz clic en la primera celda X
de la tabla y pega (Cmd+V en Mac, Ctrl+V en Windows). No hay
columnas que excluir: las dos van a la tabla.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Analyze → Linear regression. La ecuación de Henderson-Hasselbalch
es pH = pKa + log10([base]/[ácido]), así que el intercepto en Y es
el pKa y la pendiente es 1.

## 4. Resultado esperado

Intercepto = 4.76 (pKa del acetato), pendiente = 1.00, R² = 1.000.

## 5. Si no sale

Si la pendiente sale distinta de 1 o el intercepto no es 4.76,
revisa que pegaste X = `Log10_Relacion_Base_Acido` (la primera
columna del archivo, que ya trae el logaritmo) y no la relación sin
logaritmo. Si intercambiaste X e Y, la pendiente sigue cerca de 1
pero el intercepto cambia. Si al pegar todo cae en una sola columna,
revisa el separador decimal (punto, no coma).
