# ==========================================================================
# P7. Cromatografia de afinidad por metal inmovilizado (IMAC)
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 7. IMAC
#
# Descripcion: Recorrido por el laboratorio de la planta, estacion 7: la columna de afinidad IMAC con niquel. Aqui se analiza el cromatograma de IMAC con niquel: albumina cargada en buffer de adsorcion (fosfato 20 mM, NaCl 500 mM, pH 7.0) y desorbida con buffer pH 4.0. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es concentracion por 0.5 mL; la suma da la masa recuperada y su porcentaje respecto a los 6 mg cargados. Lo que se aprende aqui dice cuanta proteina se recupera en la desorcion y en que fracciones sale.
#
# Objetivos de aprendizaje:
#   - Identificar el pico de desorcion en el cromatograma.
#   - Calcular la masa de proteina por fraccion y la masa total.
#   - Calcular el porcentaje de recuperacion respecto a lo cargado.

# Datos: datos_imac.csv (concentracion de proteina por fraccion, medida por Bradford; carga 3 mL a 2 mg/mL = 6 mg).
# Recorrido: llegamos a la columna de IMAC ya preparada en la estacion del FPLC. Primera parada: la masa de proteina en cada fraccion. Segunda parada: la masa recuperada en la desorcion y su porcentaje. Tercera parada: el cromatograma. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 7. IMAC; pasos 9 a 19 del manual)
# --------------------------------------------------------------------------
# Buffers y soluciones (manual): buffer de adsorcion (fosfato 20 mM, NaCl 500 mM, pH 7.0, filtrado); buffer de desorcion (fosfato 20 mM, NaCl 500 mM, pH 4.0, filtrado); agua filtrada; sulfato de niquel (20 mM, filtrado); solucion acida (HCl 0.1 M, filtrado).
# Paso 9. Preparar una solucion de albumina (3 mL) en buffer de adsorcion a 2 mg/mL. Agitar suavemente para que se disuelvan los cristales.
# Paso 10. Con la columna conectada, alimentar agua por 5 min a un flujo de 0.5 mL/min.
# Paso 11. Detener la bomba y sustituir la alimentacion por la solucion de sulfato de niquel. Arrancar la bomba y alimentar el sulfato de niquel al mismo flujo hasta que el frente verde alcance la parte superior de la columna.
# Paso 12. Detener la bomba y sustituir la alimentacion por agua. Arrancar la bomba y lavar por 10 min.
# Paso 13. Detener la bomba y sustituir la alimentacion por el buffer de adsorcion. Arrancar la bomba y alimentar el buffer de adsorcion por 10 min o hasta que el pH de la solucion que sale de la columna sea 7.0 (verificarlo con papel pH).
# Paso 14. Cuando el pH sea el deseado el sistema esta listo para alimentar la muestra. No apagar la bomba. Cargar la solucion de proteina en una jeringa de 3 mL y llenar el loop del sistema cromatografico evitando la introduccion de burbujas.
# Paso 15. Conectar la salida de la bomba al fraccionador, al que previamente se le han colocado tubos de ensayo. Seleccionar 1 min como intervalo de fraccionacion. Una vez que la solucion comience a caer en el primer tubo de ensayo del automuestreador, inyectar la muestra y arrancar el automuestreador (sin olvidar cambiar de tubo).
# Paso 16. Permitir que se fraccionen 10 tubos de muestra. Despues detener la bomba junto con el fraccionador y sustituir la alimentacion por buffer de desorcion. Arrancar la bomba y el fraccionador y alimentar el buffer de desorcion hasta que se colecten 20 tubos de muestra.
# Paso 17. Detener la bomba junto con el fraccionador y sustituir la alimentacion por la solucion acida. Arrancar la bomba y el fraccionador y alimentar la solucion acida hasta que la coloracion azul de la columna desaparezca. Colectar cuantos tubos sean necesarios.
# Paso 18. Detener la bomba y el fraccionador y alimentar agua hasta que el pH de la solucion de salida de la columna sea neutro. No es necesario fraccionar mas tubos.
# Paso 19. Analizar los tubos fraccionados midiendo la absorbancia a 280 nm (a excepcion de los tubos que contienen niquel) y mediante SDS-PAGE (sesion 2).
# Sesion 2 (SDS-PAGE de las fracciones): el manual solo indica analizar las fracciones mediante SDS-PAGE en la sesion 2, sin detallar la preparacion de esas muestras. La indicacion para esa sesion es: calentar las muestras de las fracciones en microtubos 2 min antes de cargarlas, con buffer de carga 50/50 (50% muestra y 50% buffer de carga).
# Las concentraciones por fraccion del CSV se midieron por Bradford; el manual indica analizar las fracciones por absorbancia a 280 nm (excepto los tubos con niquel) y por SDS-PAGE en la sesion 2.
# Seguridad y reglas (manual): no introducir burbujas al llenar el loop; verificar el pH de salida con papel pH; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Leer las fracciones y calcular la masa por fraccion
# --------------------------------------------------------------------------
# Estamos frente a la columna de IMAC con el colector de fracciones. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es la concentracion medida por Bradford por 0.5 mL.
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- read_csv("datos_imac.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_mg = concentracion_proteina_mg_ml * volumen_fraccion_ml)

print(datos)

# --------------------------------------------------------------------------
# Parada 2. Masa recuperada en la desorcion y porcentaje de recuperacion
# --------------------------------------------------------------------------
# Seguimos en la columna: sumamos la masa por fase y calculamos la masa recuperada en la desorcion y su porcentaje respecto a los 6 mg cargados.
resumen <- datos %>%
  group_by(fase) %>%
  summarise(masa_mg = sum(masa_mg), .groups = "drop")

print(resumen)

masa_desorcion <- resumen %>%
  filter(fase == "Desorcion (pH 4.0)") %>%
  pull(masa_mg)
print(tibble(
  masa_recuperada_mg = masa_desorcion,
  recuperacion_porciento = masa_desorcion / masa_cargada_mg * 100
))

# --------------------------------------------------------------------------
# Parada 3. Grafica: cromatograma IMAC
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
    title = "IMAC con Ni(II): cromatograma de albumina"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la columna de IMAC guardamos la grafica del recorrido.
ggsave("07_imac.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (cromatograma IMAC): el eje x es la fraccion (1 min, 0.5 mL cada una) y el eje y es la concentracion de proteina en mg/mL; el color marca la fase.
# - En carga y lavado casi no sale proteina: la albumina queda retenida en la columna con niquel a pH 7.0. Esto significa que la histidina de la superficie se une al niquel a pH 7, y por eso lo siguiente es cambiar el buffer para desorberla.
# - Al cambiar a pH 4.0 aparece el pico de desorcion entre las fracciones 13 y 17, donde sale la mayor parte de la proteina. Esto significa que al protonarse la histidina a pH 4 la union se rompe y la proteina sale en pocas fracciones concentradas, que son las que se juntan.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La histidina de la superficie se une al niquel a pH 7 y se protona a pH 4, lo que rompe la union y desorbe la proteina.
# - La masa recuperada es la suma de concentracion por volumen en cada fraccion de la desorcion.
# Terminamos el recorrido en la columna de IMAC: ya sabemos en que fracciones sale la albumina y cuanta se recupera. Seguimos a la ultima estacion del laboratorio: la columna de intercambio ionico, donde la carga de la albumina decide si se retiene.
