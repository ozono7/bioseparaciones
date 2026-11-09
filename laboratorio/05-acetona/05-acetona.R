# ==========================================================================
# P5. Precipitacion de albumina con acetona
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 5. Acetona
#
# Descripcion: Recorrido por el laboratorio de la planta, estacion 5: la mesa de precipitacion con acetona, con el solvente frio. Aqui se calcula el porcentaje de albumina recuperada en solucion despues de precipitar con acetona a -20, 4 y 25 C, para tres concentraciones iniciales (10, 20 y 30 ug/mL). Se compara la recuperacion entre temperaturas y se grafica el porcentaje recuperado contra la temperatura del solvente. Lo que se aprende aqui dice a que temperatura conviene precipitar con acetona para recuperar mas proteina.
#
# Objetivos de aprendizaje:
#   - Calcular el porcentaje de proteina recuperada por condicion.
#   - Comparar la recuperacion a -20, 4 y 25 C.
#   - Relacionar la temperatura baja con menor desnaturalizacion.

# Datos: datos_acetona.csv (porcentaje de albumina recuperada medido por Bradford, 3 replicas por temperatura y concentracion inicial).
# Recorrido: llegamos a la mesa de precipitacion con acetona, con el congelador a -20 C al lado. Primera parada: resumir la recuperacion por temperatura y por concentracion inicial. Segunda parada: la grafica de recuperacion contra temperatura. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 5. Acetona)
# --------------------------------------------------------------------------
# Paso 1. En 4 tubos de centrifuga diluir la solucion de albumina (100 ug/mL) con el buffer de fosfato para obtener 10 ug/mL en un volumen final de 200 uL.
# Paso 2. Repetir lo anterior para obtener 4 tubos con 20 ug/mL y 4 mas con 30 ug/mL. En total son 12 tubos: 4 por concentracion.
# Paso 3. A 3 tubos (uno de cada concentracion) adicionar 800 uL de acetona a -20 C, agregando de 200 uL en 200 uL. Mezclar los tubos.
# Paso 4. Repetir lo anterior con acetona a 4 C y a 25 C, en 3 tubos con distintas concentraciones cada vez.
# Paso 5. Incubar los tubos 45 min a la temperatura correspondiente. Mantener los 3 tubos restantes a 25 C (a los que no se les adiciono acetona) como controles.
# Paso 6. Sedimentar el precipitado centrifugando los tubos a 15000g por 5 min a 4 C.
# Paso 7. Retirar el sobrenadante con mucho cuidado, sin perturbar el precipitado, y colocar el sobrenadante de todos los tubos en un mismo recipiente.
# Paso 8. Secar el precipitado 5 min a temperatura ambiente invirtiendo los tubos sobre una toalla de papel, sin perturbar el precipitado.
# Paso 9. Resuspender el precipitado de cada tubo en 200 uL de buffer de fosfato agitando suavemente. Cuantificar la concentracion de albumina en los 12 tubos (Bradford) y determinar el porcentaje de proteina recuperada en solucion para los tubos tratados con acetona. Centrifugar los tubos para separar la solucion del material que no se haya disuelto; diluir la muestra si hace falta.
# Nota: el manual trabaja con 12 tubos en total (uno por condicion) y los 3 tubos sin acetona son los controles a 25 C; los porcentajes de este script son las mediciones de ejemplo del CSV (3 replicas por temperatura y concentracion).
# Seguridad y reglas (manual): adicionar el solvente lentamente, en porciones de 200 uL; no perturbar el precipitado al retirar el sobrenadante ni al secar; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Leer los datos y resumir por temperatura y concentracion
# --------------------------------------------------------------------------
# Estamos en la mesa con la acetona a tres temperaturas. Precipitamos la albumina, la redisolvemos y medimos por Bradford cuanta se recupero: resumimos el porcentaje por temperatura y por concentracion inicial, y despues la media por temperatura.
datos <- read_csv("datos_acetona.csv", show_col_types = FALSE)

resumen <- datos %>%
  group_by(temperatura_C, concentracion_inicial_ug_ml) %>%
  summarise(
    recuperacion_media = mean(porcentaje_recuperado),
    de = sd(porcentaje_recuperado),
    .groups = "drop"
  )

print(resumen)

# Recuperacion media por temperatura (todas las concentraciones).
por_temp <- resumen %>%
  group_by(temperatura_C) %>%
  summarise(
    recuperacion_media = mean(recuperacion_media),
    .groups = "drop"
  )
print(por_temp)

# --------------------------------------------------------------------------
# Parada 2. Grafica: porcentaje recuperado contra temperatura
# --------------------------------------------------------------------------
# Graficamos el porcentaje recuperado contra la temperatura de la acetona: cada curva es una concentracion inicial y cada punto lleva su barra de desviacion.
grafica <- ggplot(
  resumen,
  aes(x = temperatura_C, y = recuperacion_media,
      color = factor(concentracion_inicial_ug_ml),
      group = concentracion_inicial_ug_ml)
) +
  geom_errorbar(aes(ymin = recuperacion_media - de,
                    ymax = recuperacion_media + de),
                width = 1.5, linewidth = 0.6) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Temperatura de la acetona (C)",
    y = "Albumina recuperada en solucion (%)",
    color = "Concentracion inicial (ug/mL)",
    title = "Precipitacion con acetona: recuperacion contra temperatura"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 3. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la mesa de precipitacion con acetona guardamos la grafica del recorrido.
ggsave("05_acetona.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (porcentaje recuperado contra temperatura): el eje x es la temperatura de la acetona en C y el eje y es la albumina recuperada en solucion en %.
# - La recuperacion es mayor con acetona fria: cerca de 92% a -20 C contra cerca de 69% a 25 C. Esto significa que el frio protege la estructura de la proteina para redisolverla despues, y por eso lo siguiente es precipitar con acetona fria.
# - La concentracion inicial cambia poco la recuperacion: la temperatura es el factor que manda. Esto significa que al planear la precipitacion lo primero que se fija es la temperatura, no la concentracion de partida.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El solvente organico precipita la proteina y el frio protege su estructura para redisolverla despues.
# - El porcentaje recuperado se mide con Bradford antes y despues de la precipitacion.
# Terminamos el recorrido en la mesa de precipitacion con acetona: ya sabemos que el frio da la mejor recuperacion. Seguimos a la siguiente estacion del laboratorio: el equipo FPLC, donde se prepara la columna para la cromatografia.
