# ==========================================================================
# P0. Introduccion: planeacion y evaluacion del laboratorio
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 0. Introduccion
#
# Descripcion: Se ordena la planeacion del laboratorio del manual: las 9 practicas con sus fechas y sesiones, y la ponderacion de la evaluacion. Se comprueba que los porcentajes suman 100 y se grafica el peso de cada componente.
#
# Objetivos de aprendizaje:
#   - Ordenar el calendario de practicas del manual.
#   - Comprobar que la ponderacion de evaluacion suma 100.
#   - Identificar que practicas ocupan dos sesiones.

# Datos: datos_planeacion.csv (practicas, fechas y sesiones del manual) y datos_evaluacion.csv (ponderacion del laboratorio).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer la planeacion y la evaluacion
# --------------------------------------------------------------------------
planeacion <- read_csv("datos_planeacion.csv", show_col_types = FALSE)
evaluacion <- read_csv("datos_evaluacion.csv", show_col_types = FALSE)

print(planeacion)
print(evaluacion)

# Comprobacion: la ponderacion debe sumar 100.
total <- sum(evaluacion$porcentaje)
print(tibble(suma_ponderacion = total))

# Practicas de dos sesiones.
print(filter(planeacion, sesiones == 2))

# --------------------------------------------------------------------------
# 2. Grafica: peso de cada componente de la evaluacion
# --------------------------------------------------------------------------
grafica <- ggplot(
  evaluacion,
  aes(x = reorder(componente, porcentaje), y = porcentaje)
) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(porcentaje, "%")),
            hjust = -0.2, size = 4.5) +
  coord_flip() +
  ylim(0, 50) +
  labs(
    x = "Componente",
    y = "Peso en la calificacion (%)",
    title = "Evaluacion del laboratorio de Bioseparacion"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 3. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("00_evaluacion.png", grafica,
       width = 20, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La ponderacion suma 100: pre-laboratorio 20%, desarrollo 40% y reporte 40%.
# - Tres practicas ocupan dos sesiones: acetona, FPLC e IMAC, y el intercambio ionico tambien se programa en dos semanas.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El laboratorio se acredita con al menos 75% de las practicas aprobadas y se cursa junto con la teoria.
# - Cada practica pide cuestionario previo, reporte con calculos y conclusiones, y trabajo ordenado en la mesa.
