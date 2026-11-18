# ==========================================================================
# 08. Secado: curva de secado — version animada
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 8. Secado
#
# Descripcion: version animada de la curva de secado: la humedad se dibuja a medida que avanza el tiempo, como la registra el secador, y la linea punteada marca los 60 min donde termina el periodo de velocidad constante. Los datos y los calculos son los mismos de 08-secado-curva.R; aqui solo se agrega la transicion que revela la curva.
# Requiere los paquetes gganimate y gifski para guardar el GIF:
# install.packages(c("gganimate", "gifski"))
#
# Datos: datos_secado.csv (humedad en base seca medida contra tiempo).
# ==========================================================================

library(tidyverse)
library(gganimate)

# --------------------------------------------------------------------------
# Leer los datos
# --------------------------------------------------------------------------
datos <- read_csv("datos_secado.csv", show_col_types = FALSE)

print(datos)

# --------------------------------------------------------------------------
# Curva de secado animada: humedad contra tiempo
# --------------------------------------------------------------------------
# La curva se revela a medida que avanza el tiempo: en cada cuadro se dibuja la humedad medida hasta el tiempo de ese momento. La linea punteada marca los 60 min, donde termina el periodo de velocidad constante y empieza el periodo decreciente.
grafica_animada <- ggplot(
  datos,
  aes(x = tiempo_min, y = humedad_kg_kg_seco)
) +
  geom_vline(xintercept = 60, linetype = "dashed") +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Tiempo (min)",
    y = "Humedad (kg agua / kg solido seco)",
    title = "Curva de secado (humedad critica a 60 min)",
    subtitle = "Tiempo: {round(frame_along, 0)} min"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold")) +
  transition_reveal(tiempo_min)

animacion <- animate(
  grafica_animada,
  nframes = 100, fps = 10, width = 1200, height = 800,
  renderer = gifski_renderer()
)
anim_save("08_curva_secado_animado.gif", animation = animacion)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# La curva de secado baja con el tiempo: al principio la humedad cae a velocidad constante (el agua de la superficie se evapora como agua libre) y despues de la humedad critica, a los 60 min, la caida se hace mas lenta porque ya manda el agua interna del solido. La animacion muestra ese cambio de pendiente en el momento en que ocurre.
# Para guardar la animacion como video MP4 en vez de GIF, usa renderer = ffmpeg_renderer() en animate() (requiere el paquete av).
