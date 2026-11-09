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
# Descripcion: Se calcula el porcentaje de albumina recuperada en solucion despues de precipitar con acetona a -20, 4 y 25 C, para tres concentraciones iniciales (10, 20 y 30 ug/mL). Se compara la recuperacion entre temperaturas y se grafica el porcentaje recuperado contra la temperatura del solvente.
#
# Objetivos de aprendizaje:
#   - Calcular el porcentaje de proteina recuperada por condicion.
#   - Comparar la recuperacion a -20, 4 y 25 C.
#   - Relacionar la temperatura baja con menor desnaturalizacion.

# Datos: datos_acetona.csv (porcentaje de albumina recuperada medido por Bradford, 3 replicas por temperatura y concentracion inicial).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer los datos y resumir por temperatura y concentracion
# --------------------------------------------------------------------------
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
# 2. Grafica: porcentaje recuperado contra temperatura
# --------------------------------------------------------------------------
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
ggsave("05_acetona.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La recuperacion es mayor con acetona fria: cerca de 92% a -20 C contra cerca de 69% a 25 C.
# - La concentracion inicial cambia poco la recuperacion: la temperatura es el factor que manda.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El solvente organico precipita la proteina y el frio protege su estructura para redisolverla despues.
# - El porcentaje recuperado se mide con Bradford antes y despues de la precipitacion.
