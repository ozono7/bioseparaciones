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

# --------------------------------------------------------------------------
# Carpeta de trabajo: la del propio script
# --------------------------------------------------------------------------
# El script resuelve solo la carpeta donde esta guardado y la pone como
# carpeta de trabajo, asi los archivos de datos se leen por su nombre y la
# grafica se guarda en la misma carpeta, sin editar rutas.
# Primero prueba la ruta del documento activo en RStudio o Positron, luego
# la ruta del archivo al correr con Rscript o source(), y si nada de eso
# da una ruta, se queda en la carpeta de trabajo actual.
ruta_script <- NULL
if (requireNamespace("rstudioapi", quietly = TRUE) &&
    rstudioapi::isAvailable()) {
  ruta_script <- tryCatch(
    rstudioapi::getActiveDocumentContext()$path,
    error = function(e) NULL
  )
}
if (is.null(ruta_script) || !nzchar(ruta_script)) {
  ruta_script <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
}
# Con Rscript el archivo no deja marco en la pila, asi que su ruta viene
# en los argumentos de la linea de comandos (--file=...).
if (is.null(ruta_script) || !nzchar(ruta_script)) {
  archivo <- grep("--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(archivo) > 0) {
    ruta_script <- sub("--file=", "", archivo[1])
  }
}
if (!is.null(ruta_script) && nzchar(ruta_script)) {
  setwd(dirname(normalizePath(ruta_script, mustWork = FALSE)))
}

# Estilo de graficas: tema claro y legible, paleta apta para daltonicos
# (Okabe-Ito) y tamano de fuente base mayor, para que las graficas se
# lean bien en el reporte y en la presentacion.
paleta <- c("#0072B2", "#E69F00", "#009E73", "#CC79A7", "#56B4E9", "#D55E00")
tema <- theme_bw(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )
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
  tema +
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
