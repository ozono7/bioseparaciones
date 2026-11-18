# P2-calibracion-sds-page — pasos para GraphPad Prism

Práctica 2, SDS-PAGE. Archivo de datos:
`P2-calibracion-sds-page.tsv` (10 filas, las bandas del marcador).
Trae la calibración del gel: X es el Rf (distancia de la banda
entre 65 mm, el frente del gel) y Y es el log10 del peso molecular
en kDa.

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter and plot a
single Y value for each point"** (un solo valor de Y por punto, sin
subcolumnas). Dale a **Create**.

## 2. Copiar y pegar

Abre `P2-calibracion-sds-page.tsv` y copia las dos columnas, `Rf` y
`Log10_PM_kDa`, desde la segunda fila (sin el encabezado) hasta el
final. En Prism haz clic en la primera celda X de la tabla y pega
(Cmd+V en Mac, Ctrl+V en Windows). No hay columnas que excluir: las
dos van a la tabla.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

Analyze → Linear regression. Después, Analyze → Interpolate a
standard curve, con X = 0.369 (el Rf de la banda de BSA, a 24 mm).
Prism devuelve log10(PM); el peso molecular es 10 elevado a ese
valor.

## 4. Resultado esperado

R² = 0.994. La BSA interpola a 65.9 kDa, cercano a su valor de
referencia (66.5 kDa).

## 5. Si no sale

Si la interpolación da un peso muy distinto de 65.9 kDa, revisa que
X sea el Rf (ya calculado en el archivo) y no la distancia en mm:
si pegaste la distancia en mm, el Rf queda mal y la interpolación
también. Si R² sale bajo, revisa que no intercambiaste X e Y.
