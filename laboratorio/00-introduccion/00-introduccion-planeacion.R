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
# Descripcion: Recorrido por la planta, punto de partida: la entrada del laboratorio, donde se presenta el plan del semestre antes de visitar cada estacion. Se ordena la planeacion del laboratorio del manual: las 9 practicas con sus fechas y sesiones, y la ponderacion de la evaluacion. Se comprueba que los porcentajes suman 100 y se grafica el peso de cada componente. Lo que se aprende aqui es el mapa del recorrido: que estaciones vamos a visitar, en que orden y como se evalua cada una.
#
# Objetivos de aprendizaje:
#   - Ordenar el calendario de practicas del manual.
#   - Comprobar que la ponderacion de evaluacion suma 100.
#   - Identificar que practicas ocupan dos sesiones.

# Datos: datos_planeacion.csv (practicas, fechas y sesiones del manual) y datos_evaluacion.csv (ponderacion del laboratorio).
# Recorrido: estamos en la entrada del laboratorio, antes de empezar. Aqui se presenta el mapa completo: las 9 practicas con sus fechas y sesiones, y la ponderacion de la evaluacion. Despues de esta introduccion, cada practica es una estacion del laboratorio de la planta.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Reglas del laboratorio (Manual de Practicas)
# --------------------------------------------------------------------------
# Antes de visitar las estaciones, las reglas de la casa: la teoria y el laboratorio se cursan simultaneamente; cada alumno presenta su manual en las practicas; bata blanca de laboratorio obligatoria, con cubrebocas y guantes cuando se indique; cuestionario pre-laboratorio entregado antes de cada practica; la practica inicia 10 min despues de la hora indicada; limpiar la mesa de trabajo antes y despues de la practica; no fumar ni consumir alimentos o bebidas en el laboratorio. El laboratorio se acredita con al menos 75% de las practicas aprobadas.

# --------------------------------------------------------------------------
# Parada 1. Leer la planeacion y la evaluacion
# --------------------------------------------------------------------------
# En la entrada revisamos el calendario del manual: que practica toca cada semana y cuantas sesiones ocupa cada una. Despues comprobamos que la ponderacion de la evaluacion suma 100.
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
# Parada 2. Grafica: peso de cada componente de la evaluacion
# --------------------------------------------------------------------------
# Graficamos el peso de cada componente de la evaluacion para ver de un vistazo que parte pesa mas en la calificacion.
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
# Antes de salir de la entrada guardamos la grafica del recorrido.
ggsave("00_evaluacion.png", grafica,
       width = 20, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (peso de cada componente de la evaluacion): el eje x es el peso en la calificacion en % y el eje y es el componente de la evaluacion.
# - La ponderacion suma 100: pre-laboratorio 20%, desarrollo 40% y reporte 40%. Esto significa que el trabajo en la mesa y el reporte pesan lo mismo y juntos hacen el 80%, y por eso lo siguiente en cada estacion es trabajar ordenado y reportar con calculos y conclusiones.
# - Tres practicas ocupan dos sesiones: acetona, FPLC e IMAC, y el intercambio ionico tambien se programa en dos semanas. Esto significa que esas estaciones necesitan mas tiempo porque el procedimiento no cabe en una sola sesion, y por eso el calendario les da dos semanas.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El laboratorio se acredita con al menos 75% de las practicas aprobadas y se cursa junto con la teoria.
# - Cada practica pide cuestionario previo, reporte con calculos y conclusiones, y trabajo ordenado en la mesa.
# Terminamos la introduccion en la entrada del laboratorio: ya tenemos el mapa del recorrido. Seguimos a la primera estacion: la mesa de preparacion de soluciones y ajuste de pH.
