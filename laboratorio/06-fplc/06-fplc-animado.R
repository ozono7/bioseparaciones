# ==========================================================================
# P6. Introduccion al FPLC (BioLogic LP) — version animada
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 6. FPLC
#
# Descripcion: version animada de las graficas del FPLC: la absorbancia a 280 nm y la conductividad se dibujan a medida que avanza el volumen acumulado, como las traza el registrador del equipo. Los datos y los calculos son los mismos de 06-fplc.R; aqui solo se agrega la transicion que revela la curva.
# Requiere los paquetes gganimate y gifski para guardar el GIF:
# install.packages(c("gganimate", "gifski"))
#
# Datos: datos_fplc.csv (absorbancia a 280 nm y conductividad registradas contra tiempo; flujo 0.5 mL/min).
# ==========================================================================

library(tidyverse)
library(gganimate)

# --------------------------------------------------------------------------
# Leer el registro y calcular el volumen acumulado
# --------------------------------------------------------------------------
# Flujo del protocolo: 0.5 mL/min. Volumen acumulado = flujo * tiempo.
flujo_ml_min <- 0.5

datos <- read_csv("datos_fplc.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(volumen_ml = flujo_ml_min * tiempo_min)

print(datos)

# --------------------------------------------------------------------------
# Grafica 1 animada: absorbancia a 280 nm contra volumen
# --------------------------------------------------------------------------
# La curva se revela a medida que avanza el volumen acumulado: en cada cuadro se dibuja el registro hasta el volumen de ese momento.
grafica_uv_animada <- ggplot(
  datos,
  aes(x = volumen_ml, y = absorbancia_280, color = fase)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Absorbancia a 280 nm",
    color = "Fase",
    title = "FPLC: absorbancia a 280 nm durante la preparacion",
    subtitle = "Volumen acumulado: {round(frame_along, 1)} mL"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold")) +
  transition_reveal(volumen_ml)

animacion_uv <- animate(
  grafica_uv_animada,
  nframes = 100, fps = 10, width = 1200, height = 720,
  renderer = gifski_renderer()
)
anim_save("06_fplc_uv_animado.gif", animation = animacion_uv)

# --------------------------------------------------------------------------
# Grafica 2 animada: conductividad contra volumen
# --------------------------------------------------------------------------
# La conductividad tambien se revela con el volumen: asi se ve en que momento llega cada solucion del protocolo.
grafica_cond_animada <- ggplot(
  datos,
  aes(x = volumen_ml, y = conductividad_mS_cm, color = fase)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Conductividad (mS/cm)",
    color = "Fase",
    title = "FPLC: conductividad durante la preparacion",
    subtitle = "Volumen acumulado: {round(frame_along, 1)} mL"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold")) +
  transition_reveal(volumen_ml)

animacion_cond <- animate(
  grafica_cond_animada,
  nframes = 100, fps = 10, width = 1200, height = 720,
  renderer = gifski_renderer()
)
anim_save("06_fplc_conductividad_animado.gif", animation = animacion_cond)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (absorbancia a 280 nm contra volumen): la linea se mantiene en la linea base porque en esta practica todavia no se carga proteina; la animacion muestra que el registro avanza sin que aparezca ningun pico.
# Grafica 2 (conductividad contra volumen): la animacion muestra cada cambio de solucion en el momento en que llega: la conductividad sube con el niquel y con el buffer de adsorcion, y cambia de nuevo con el acido. El subtitulo marca el volumen acumulado en cada cuadro.
# Para guardar la animacion como video MP4 en vez de GIF, usa renderer = ffmpeg_renderer() en animate() (requiere el paquete av).
