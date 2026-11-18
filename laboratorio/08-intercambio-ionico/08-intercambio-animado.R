# ==========================================================================
# P8. Cromatografia de intercambio ionico — version animada
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 8. Intercambio ionico
#
# Descripcion: version animada del cromatograma de intercambio ionico: las barras aparecen fraccion por fraccion, en el orden en que salen del colector, hasta completar el cromatograma. Los datos y los calculos son los mismos de 08-intercambio-ionico.R; aqui solo se agrega la transicion que revela cada fraccion.
# Requiere los paquetes gganimate y gifski para guardar el GIF:
# install.packages(c("gganimate", "gifski"))
#
# Datos: datos_intercambio.csv (concentracion de proteina por fraccion, medida por Bradford; carga 3 mL a 2 mg/mL = 6 mg).
# ==========================================================================

library(tidyverse)
library(gganimate)

# --------------------------------------------------------------------------
# Leer las fracciones y calcular la masa por fraccion
# --------------------------------------------------------------------------
# Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es la concentracion medida por Bradford por 0.5 mL.
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- read_csv("datos_intercambio.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_mg = concentracion_proteina_mg_ml * volumen_fraccion_ml)

print(datos)

# --------------------------------------------------------------------------
# Cromatograma animado
# --------------------------------------------------------------------------
# Cada barra es una fraccion y su color marca la fase, carga y lavado o desorcion. La animacion agrega una fraccion a la vez: las barras que ya salieron quedan fijas y la nueva crece desde la linea base. El subtitulo marca la fraccion que se esta agregando.
grafica_animada <- ggplot(
  datos,
  aes(x = fraccion, y = concentracion_proteina_mg_ml, fill = fase)
) +
  geom_col(width = 0.8) +
  labs(
    x = "Fraccion (1 min, 0.5 mL cada una)",
    y = "Concentracion de proteina (mg/mL)",
    fill = "Fase",
    title = "Intercambio ionico: cromatograma de albumina (pH 8.0)",
    subtitle = "Fraccion: {closest_state}"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold")) +
  transition_states(fraccion, transition_length = 1, state_length = 1) +
  shadow_mark(past = TRUE, future = FALSE) +
  enter_grow()

animacion <- animate(
  grafica_animada,
  nframes = 120, fps = 12, width = 1200, height = 800,
  renderer = gifski_renderer()
)
anim_save("08_intercambio_animado.gif", animation = animacion)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# El cromatograma se construye fraccion por fraccion: en carga y lavado la concentracion se mantiene cerca de cero porque la albumina, con carga negativa a pH 8.0, queda retenida en el intercambiador de aniones, y en la desorcion con NaCl 500 mM aparece el pico. La animacion muestra en que fracciones sale la proteina y que la masa recuperada es la suma de las barras de la desorcion.
# Para guardar la animacion como video MP4 en vez de GIF, usa renderer = ffmpeg_renderer() en animate() (requiere el paquete av).
