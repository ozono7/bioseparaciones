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
  tema +
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
  tema +
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
