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
# Descripcion: Practica 0 del laboratorio: la planeacion. Se presenta el plan del semestre antes de empezar cada practica. Se ordena la planeacion del laboratorio del manual: las 9 practicas con sus fechas y sesiones, y la ponderacion de la evaluacion. Se comprueba que los porcentajes suman 100 y se grafica el peso de cada componente. Lo que se aprende aqui es el mapa del laboratorio: que practicas vamos a ver, en que orden y como se evalua cada una.
# Objetivo del curso (manual): reforzar las buenas practicas de laboratorio y aplicar la teoria a la purificacion de proteinas, con enfasis en el principio de cada procedimiento.
# Competencias del curso (manual): A2, aplicar conceptos de quimica y bioquimica en problemas de ingenieria de bioprocesos; B1, conducirse con seguridad al realizar experimentos.
#
# Objetivos de aprendizaje:
#   - Ordenar el calendario de practicas del manual.
#   - Comprobar que la ponderacion de evaluacion suma 100.
#   - Identificar que practicas ocupan dos sesiones.

# Datos: datos_planeacion.csv (practicas, fechas y sesiones del manual) y datos_evaluacion.csv (ponderacion del laboratorio).
# Desarrollo: estamos en la entrada del laboratorio, antes de empezar. Aqui se presenta el mapa completo: las 9 practicas con sus fechas y sesiones, y la ponderacion de la evaluacion. Despues de esta introduccion, cada practica se hace en el laboratorio.
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

# --------------------------------------------------------------------------
# Reglas del laboratorio (Manual de Practicas)
# --------------------------------------------------------------------------
# Antes de empezar las practicas, las reglas de la casa: la teoria y el laboratorio se cursan simultaneamente; cada alumno presenta su manual en las practicas; bata blanca de laboratorio obligatoria, con cubrebocas y guantes cuando se indique; cuestionario pre-laboratorio entregado antes de cada practica; la practica inicia 10 min despues de la hora indicada; limpiar la mesa de trabajo antes y despues de la practica; no fumar ni consumir alimentos o bebidas en el laboratorio. El laboratorio se acredita con al menos 75% de las practicas aprobadas.
# Reglamento (manual): si se reprueba la teoria pero se acredita el laboratorio, el resultado del laboratorio sigue valido; si no se acredita el laboratorio, se anula la calificacion de teoria y se cursan teoria y laboratorio de nuevo. Se requiere el 100% de asistencia a las sesiones practicas, incluyendo las sesiones de discusion. Cada practica lleva un reporte escrito con referencias, con preguntas de resultados y de conocimientos, y conclusiones.
# Manejo de residuos (manual): los cultivos liquidos de bacterias se tratan con hipoclorito de sodio al 10% por al menos 12 h antes de desecharlos; los cultivos en medio solido se esterilizan en autoclave 30 min a 121 C. La acrilamida es neurotoxica: sus residuos liquidos se almacenan etiquetados para disposicion especializada.

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

# Desglose del reporte (manual): el reporte vale 40% y se divide en
# cuestionario 5%, resultados 15% y conclusiones 20%. Lo comprobamos.
reporte <- tibble(
  parte = c("Cuestionario", "Resultados", "Conclusiones"),
  porcentaje = c(5, 15, 20)
)
print(reporte)
print(tibble(suma_reporte = sum(reporte$porcentaje)))

# --------------------------------------------------------------------------
# Parada 2. Grafica: peso de cada componente de la evaluacion
# --------------------------------------------------------------------------
# Graficamos el peso de cada componente de la evaluacion para ver de un vistazo que parte pesa mas en la calificacion; cada barra lleva su color y su valor anotado, y el subtitulo recuerda que el reporte se divide en cuestionario 5%, resultados 15% y conclusiones 20%.
grafica <- ggplot(
  evaluacion,
  aes(x = reorder(componente, porcentaje), y = porcentaje, fill = componente)
) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(porcentaje, "%")),
            hjust = -0.2, size = 4.5) +
  coord_flip() +
  ylim(0, 50) +
  scale_fill_manual(values = paleta) +
  labs(
    x = "Componente",
    y = "Peso en la calificacion (%)",
    title = "Evaluacion del laboratorio de Bioseparacion",
    subtitle = "La ponderacion suma 100; el reporte (40%) se divide en cuestionario 5%, resultados 15% y conclusiones 20%"
  ) +
  tema +
  theme(legend.position = "none")

print(grafica)

# Segunda grafica: el desglose del reporte (40% de la calificacion) en
# cuestionario 5%, resultados 15% y conclusiones 20%.
grafica_reporte <- ggplot(
  reporte,
  aes(x = reorder(parte, porcentaje), y = porcentaje, fill = parte)
) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(porcentaje, "%")),
            hjust = -0.2, size = 4.5) +
  coord_flip() +
  ylim(0, 25) +
  scale_fill_manual(values = paleta[3:5]) +
  labs(
    x = "Parte del reporte",
    y = "Peso en la calificacion (%)",
    title = "Desglose del reporte (40% de la calificacion)"
  ) +
  tema +
  theme(legend.position = "none")

print(grafica_reporte)

# --------------------------------------------------------------------------
# 3. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir de la entrada guardamos las graficas de la practica.
ggsave("00_evaluacion.png", grafica,
       width = 20, height = 12, units = "cm", dpi = 300)
ggsave("00_reporte.png", grafica_reporte,
       width = 20, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (peso de cada componente de la evaluacion): el eje x es el peso en la calificacion en % y el eje y es el componente de la evaluacion.
# - La ponderacion suma 100: pre-laboratorio 20%, desarrollo 40% y reporte 40%. Esto significa que el trabajo en la mesa y el reporte pesan lo mismo y juntos hacen el 80%, y por eso lo siguiente en cada practica es trabajar ordenado y reportar con calculos y conclusiones.
# - Cuatro practicas ocupan dos sesiones: acetona, FPLC, IMAC e intercambio ionico. Esto significa que esas practicas necesitan mas tiempo porque el procedimiento no cabe en una sola sesion, y por eso el calendario les da dos semanas.
# Grafica (desglose del reporte): el eje x es el peso en la calificacion en % y el eje y es la parte del reporte.
# - El reporte (40%) se divide en cuestionario 5%, resultados 15% y conclusiones 20%: las conclusiones pesan mas que los resultados. Esto significa que en el reporte lo que mas cuenta es interpretar los resultados y concluir, no solo presentarlos.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El laboratorio se acredita con al menos 75% de las practicas aprobadas y se cursa junto con la teoria.
# - Cada practica pide cuestionario previo, reporte con calculos y conclusiones, y trabajo ordenado en la mesa.
# - El reporte se divide en cuestionario 5%, resultados 15% y conclusiones 20%, y la asistencia a las sesiones es del 100%.
# Terminamos la introduccion en la entrada del laboratorio: ya tenemos el mapa del laboratorio. Seguimos a la primera practica: la mesa de preparacion de soluciones y ajuste de pH.
