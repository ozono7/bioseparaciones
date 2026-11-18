# P8-intercambio-cromatograma — pasos para GraphPad Prism

Práctica 8, Intercambio iónico. Archivo de datos:
`P8-intercambio-cromatograma.tsv` (30 filas, una por fracción).
Trae el cromatograma de intercambio iónico: X es la fracción y Y es
la concentración de proteína en mg/mL (Bradford). Columnas:
`Fraccion`, `Concentracion_mg_mL` y `Fase`.

## 1. Crear la tabla en Prism

En la pantalla Welcome de Prism, en CREATE elige **XY**. En "Data
table" deja marcada la opción **"Enter or import data into a new
table"**. En Options, X: **Numbers**. En Y elige **"Enter and plot a
single Y value for each point"** (un solo valor de Y por punto, sin
subcolumnas). Dale a **Create**.

## 2. Copiar y pegar

Abre `P8-intercambio-cromatograma.tsv`. Copia desde la segunda fila
(sin el encabezado) las columnas `Fraccion` y `Concentracion_mg_mL`
(2 columnas). En Prism haz clic en la primera celda X de la tabla y
pega (Cmd+V en Mac, Ctrl+V en Windows).

La columna `Fase` NO se pega: es solo de referencia (fracciones 1 a
10 son carga y lavado en Tris pH 8.0 y 11 a 30 son desorción con
NaCl 500 mM). Si la pegas, entra como texto en la tabla y estorba.

Los números usan punto decimal (.). Si al pegar las celdas no se
separan o los valores se ven como texto, revisa que el separador
decimal sea el punto.

## 3. Análisis en Prism

El pico está en desorción (fracción 14, 0.88 mg/mL). Para la masa
recuperada, Analyze → Area under the curve sobre las fracciones de
desorción (11 a 30) y multiplica el área por 0.5 mL por fracción.

## 4. Resultado esperado

El área bajo la curva da unos 2.07 mg, que es la masa recuperada en
desorción (la suma de concentración × 0.5 mL por fracción da 2.11
mg). Eso es el 35.1% de los 6 mg cargados (3 mL a 2 mg/mL).

## 5. Si no sale

- Si el área da unos 4 mg, el doble de lo esperado, integraste
  todas las fracciones (1 a 30) en vez de solo la desorción (11 a
  30): repite el área solo con las fracciones 11 a 30.
- Si el área da un valor en mg/mL y no en mg, falta multiplicar por
  0.5 mL por fracción.
- Si aparece texto en la tabla, es la columna `Fase`: bórrala y
  pega solo las 2 columnas de números.
