# ==========================================================================
# P8. Cromatografia de intercambio ionico
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 8. Intercambio ionico
#
# Descripcion: Recorrido por el laboratorio de la planta, estacion 8 y ultima del laboratorio: la columna de intercambio ionico. Aqui se analiza el cromatograma de intercambio ionico de albumina: a pH 8.0 la albumina esta por encima de su pI (4.7), asi que tiene carga negativa y se retiene en un intercambiador de aniones; la desorcion se hace subiendo la fuerza ionica con NaCl 500 mM. La masa por fraccion es concentracion por 0.5 mL y la suma da la recuperacion respecto a los 6 mg cargados. Lo que se aprende aqui cierra el laboratorio: el pH respecto al pI decide que intercambiador retiene a la proteina.
#
# Objetivos de aprendizaje:
#   - Predecir el signo de la carga de la albumina a pH 8.0 desde su pI.
#   - Identificar el pico de desorcion con NaCl 500 mM.
#   - Calcular la masa recuperada y su porcentaje respecto a lo cargado.

# Datos: datos_intercambio.csv (concentracion de proteina por fraccion, medida por Bradford; carga 3 mL a 2 mg/mL = 6 mg).
# Recorrido: llegamos a la ultima estacion del laboratorio, la columna de intercambio ionico, con la albumina caracterizada desde la primera parada de la teoria. Primera parada: la masa de proteina en cada fraccion. Segunda parada: la masa recuperada en la desorcion y su porcentaje. Tercera parada: el cromatograma. En cada parada calculamos y comentamos que significa el resultado, y aqui cerramos el recorrido por el laboratorio.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 8. Intercambio ionico)
# --------------------------------------------------------------------------
# Buffers y soluciones (manual): buffer de adsorcion (Tris 50 mM, pH 8.0, filtrado); buffer de desorcion (Tris 50 mM, NaCl 500 mM, pH 8.0, filtrado); agua filtrada; solucion acida (HCl 0.1 M, filtrado).
# Paso 1. Preparar una solucion de albumina (3 mL) en buffer de adsorcion a 2 mg/mL. Agitar suavemente para que se disuelvan los cristales.
# Paso 2. Con la columna conectada, alimentar agua por 5 min a un flujo de 0.5 mL/min.
# Paso 3. Detener la bomba y sustituir la alimentacion por la solucion acida. Arrancar la bomba y alimentar la solucion acida al mismo flujo por 10 min.
# Paso 4. Detener la bomba y sustituir la alimentacion por agua. Arrancar la bomba y lavar por 10 min o hasta que el pH de la solucion de salida de la columna sea neutro.
# Paso 5. Detener la bomba y sustituir la alimentacion por el buffer de adsorcion. Arrancar la bomba y alimentar el buffer de adsorcion por 10 min o hasta que el pH de la solucion que sale de la columna sea 8.0 (verificarlo con papel pH).
# Paso 6. Cuando el pH sea el deseado el sistema esta listo para alimentar la muestra. No apagar la bomba. Cargar la solucion de proteina en una jeringa de 3 mL y llenar el loop del sistema cromatografico evitando la introduccion de burbujas.
# Paso 7. Conectar la salida de la bomba al fraccionador, al que previamente se le han colocado tubos de ensayo. Seleccionar 1 min como intervalo de fraccionacion. Una vez que la solucion comience a caer en el primer tubo de ensayo del automuestreador, inyectar la muestra y arrancar el automuestreador (sin olvidar cambiar de tubo).
# Paso 8. Permitir que se fraccionen 10 tubos de muestra. Despues detener la bomba junto con el fraccionador y sustituir la alimentacion por buffer de desorcion. Arrancar la bomba y el fraccionador y alimentar el buffer de desorcion hasta que se colecten 20 tubos de muestra.
# Paso 9. Detener la bomba junto con el fraccionador y sustituir la alimentacion por la solucion acida. Arrancar la bomba y alimentar la solucion acida por 10 min sin fraccionar tubos.
# Paso 10. Detener la bomba y alimentar agua hasta que el pH de la solucion de salida de la columna sea neutro. No es necesario fraccionar mas tubos.
# Paso 11. Analizar los tubos fraccionados midiendo la absorbancia a 280 nm y mediante el ensayo de Bradford, y mediante SDS-PAGE (sesion 2).
# Sesion 2 (SDS-PAGE de las fracciones): el manual solo indica analizar las fracciones mediante SDS-PAGE en la sesion 2, sin detallar la preparacion de esas muestras. La indicacion para esa sesion es: calentar las muestras de las fracciones en microtubos 2 min antes de cargarlas, con buffer de carga 50/50 (50% muestra y 50% buffer de carga).
# Seguridad y reglas (manual): no introducir burbujas al llenar el loop; verificar el pH de salida con papel pH; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Leer las fracciones y calcular la masa por fraccion
# --------------------------------------------------------------------------
# Estamos frente a la columna de intercambio ionico. Antes de calcular recordamos la prediccion: el pI de la albumina es 4.7 y trabajamos a pH 8.0, por encima del pI, asi que su carga neta es negativa y se retiene en un intercambiador de aniones. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es la concentracion por 0.5 mL.
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
# pI de la albumina: 4.7. A pH 8.0 (por encima del pI) su carga neta es
# negativa, asi que se retiene en un intercambiador de aniones.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- read_csv("datos_intercambio.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_mg = concentracion_proteina_mg_ml * volumen_fraccion_ml)

print(datos)

# --------------------------------------------------------------------------
# Parada 2. Masa recuperada en la desorcion y porcentaje de recuperacion
# --------------------------------------------------------------------------
# Seguimos en la columna: sumamos la masa por fase y calculamos la masa recuperada en la desorcion con NaCl 500 mM y su porcentaje respecto a los 6 mg cargados.
resumen <- datos %>%
  group_by(fase) %>%
  summarise(masa_mg = sum(masa_mg), .groups = "drop")

print(resumen)

masa_desorcion <- resumen %>%
  filter(fase == "Desorcion (NaCl 500 mM)") %>%
  pull(masa_mg)
print(tibble(
  masa_recuperada_mg = masa_desorcion,
  recuperacion_porciento = masa_desorcion / masa_cargada_mg * 100
))

# --------------------------------------------------------------------------
# Parada 3. Grafica: cromatograma de intercambio ionico
# --------------------------------------------------------------------------
# Graficamos el cromatograma: cada barra es una fraccion y su color marca la fase, carga y lavado o desorcion. Aqui se ve donde sale la proteina.
grafica <- ggplot(
  datos,
  aes(x = fraccion, y = concentracion_proteina_mg_ml, fill = fase)
) +
  geom_col(width = 0.8) +
  labs(
    x = "Fraccion (1 min, 0.5 mL cada una)",
    y = "Concentracion de proteina (mg/mL)",
    fill = "Fase",
    title = "Intercambio ionico: cromatograma de albumina (pH 8.0)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la columna de intercambio ionico guardamos la grafica del recorrido.
ggsave("08_intercambio.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (cromatograma de intercambio ionico): el eje x es la fraccion (1 min, 0.5 mL cada una) y el eje y es la concentracion de proteina en mg/mL; el color marca la fase.
# - En carga y lavado casi no sale proteina: a pH 8.0 la albumina, con carga negativa, queda retenida en el intercambiador de aniones. Esto significa que la prediccion desde el pI se cumple en la columna, y por eso lo siguiente es subir la fuerza ionica para desorberla.
# - Al subir la fuerza ionica con NaCl 500 mM aparece el pico de desorcion entre las fracciones 12 y 16. Esto significa que la sal compite por los sitios del intercambiador y libera la proteina en pocas fracciones concentradas, que son las que se juntan.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El pH respecto al pI decide el signo de la carga y por tanto que intercambiador retiene a la proteina.
# - La sal compite por los sitios del intercambiador y desorbe la proteina; la masa recuperada sale de sumar las fracciones.
# Terminamos el recorrido en la columna de intercambio ionico, ultima estacion del laboratorio: la albumina quedo retenida por su carga y salio con la sal. Aqui se cierra el recorrido completo por el laboratorio de la planta, desde la preparacion de soluciones hasta la cromatografia.
