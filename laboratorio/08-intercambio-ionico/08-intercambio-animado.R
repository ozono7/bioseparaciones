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
  tema +
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
