# ==========================================================================
# 05. Ultrafiltracion: flux contra presion y diafiltracion
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 5. Ultrafiltracion
#
# Descripcion: Recorrido por la planta, quinta parada: el equipo de ultrafiltracion, con su membrana y su bomba. Aqui se analiza el flux medido contra la presion transmembrana (TMP): en la zona controlada por presion el flux es lineal y su pendiente es la permeabilidad hidraulica; a TMP alta el flux se estabiliza en el flux limite por polarizacion. Tambien se calcula la caida de sal en diafiltracion a volumen constante, C = C0 * exp(-Vd/V). Lo que se aprende aqui dice a que presion conviene operar y cuantos volumenes de diafiltracion hacen falta para lavar la sal.
#
# Objetivos de aprendizaje:
#   - Calcular la permeabilidad hidraulica en la zona lineal.
#   - Identificar el flux limite por polarizacion de concentracion.
#   - Calcular cuantos volumenes de diafiltracion hacen falta para bajar la sal a un valor dado.

# Datos: datos_flux.csv (flux medido contra TMP) y datos_diafiltracion.csv (sal relativa medida contra volumenes de diafiltracion).
# Recorrido: llegamos al equipo de ultrafiltracion con el sobrenadante clarificado de la centrifuga. Primera parada: el flux contra la TMP y el flux limite. Segunda parada: la caida de sal en diafiltracion. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
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
# Parada 1. Flux contra TMP: zona lineal y flux limite
# --------------------------------------------------------------------------
# Estamos frente a la membrana de ultrafiltracion con el manometro de TMP a la vista. Subimos la presion por pasos y medimos el flux: primero calculamos la permeabilidad hidraulica con los puntos de la zona lineal y despues el flux limite con los puntos donde el flux ya no sube.
datos <- read_csv("datos_flux.csv", show_col_types = FALSE)

# Zona controlada por presion: los tres primeros puntos (TMP hasta 1.5 bar).
# J = Lp * TMP; la pendiente de la recta es Lp.
ajuste_lp <- lm(flux_L_m2_h ~ tmp_bar - 1,
                data = filter(datos, tmp_bar <= 1.5))
lp <- coef(ajuste_lp)[["tmp_bar"]]
print(tibble(permeabilidad_L_m2_h_bar = lp))

# Flux limite: media de los dos ultimos puntos, donde el flux ya no sube.
flux_limite <- datos %>%
  filter(tmp_bar >= 2.5) %>%
  summarise(flux_limite = mean(flux_L_m2_h)) %>%
  pull(flux_limite)
print(tibble(flux_limite_L_m2_h = flux_limite))

# --------------------------------------------------------------------------
# Parada 2. Diafiltracion a volumen constante
# --------------------------------------------------------------------------
# Seguimos en el equipo de ultrafiltracion: ahora pasamos a la diafiltracion, donde se agrega agua al mismo ritmo que sale el permeado para lavar la sal sin concentrar la proteina. Comparamos la sal medida con el modelo.
# Modelo: C/C0 = exp(-Vd/V), donde Vd/V es el numero de volumenes de
# diafiltracion. Se compara el modelo con la sal medida.
datos_dia <- read_csv("datos_diafiltracion.csv", show_col_types = FALSE)

datos_dia <- datos_dia %>%
  mutate(concentracion_sal_relativa_modelo =
           exp(-volumenes_diafiltracion))

print(datos_dia)

# Volumenes para bajar la sal al 1% del valor inicial: -ln(0.01).
print(tibble(volumenes_para_1_porciento = -log(0.01)))

# --------------------------------------------------------------------------
# Parada 3. Grafica 1: flux contra TMP
# --------------------------------------------------------------------------
# Graficamos el flux contra la TMP: la linea punteada marca el flux limite, el techo que la membrana alcanza por polarizacion, y la linea de puntos es la recta de la zona lineal, con su pendiente Lp anotada.
grafica_flux <- ggplot(datos, aes(x = tmp_bar, y = flux_L_m2_h)) +
  geom_hline(yintercept = flux_limite, linetype = "dashed",
             color = "grey40") +
  annotate("text", x = max(datos$tmp_bar) * 0.95, y = flux_limite,
           label = paste0("Flux limite: ", round(flux_limite, 1), " L/m2/h"),
           hjust = 1, vjust = -0.6, size = 4.5) +
  geom_abline(slope = lp, intercept = 0, linetype = "dotted",
              color = paleta[6], linewidth = 1) +
  annotate("text", x = 0.2, y = max(datos$flux_L_m2_h) * 0.9,
           label = paste0("Lp = ", round(lp, 1), " L/m2/h/bar"),
           hjust = 0, size = 4.5, color = paleta[6]) +
  geom_line(linewidth = 1, color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  labs(
    x = "Presion transmembrana, TMP (bar)",
    y = "Flux (L/m2/h)",
    title = "Ultrafiltracion: flux contra TMP (flux limite marcado)"
  ) +
  tema

print(grafica_flux)

# --------------------------------------------------------------------------
# Parada 4. Grafica 2: sal relativa en diafiltracion
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la sal relativa contra los volumenes de diafiltracion, con los puntos medidos y la linea del modelo en escala logaritmica; la linea de puntos marca el 1% de sal, que se alcanza a 4.61 volumenes.
grafica_dia <- ggplot(
  datos_dia,
  aes(x = volumenes_diafiltracion,
      y = concentracion_sal_relativa_medida)
) +
  geom_hline(yintercept = 0.01, linetype = "dotted", color = paleta[6],
             linewidth = 1) +
  geom_vline(xintercept = -log(0.01), linetype = "dotted", color = paleta[6]) +
  annotate("text", x = -log(0.01), y = 0.5,
           label = "1% de sal: 4.61 volumenes", hjust = -0.1, size = 4.5,
           color = paleta[6]) +
  geom_line(aes(y = concentracion_sal_relativa_modelo),
            linetype = "dashed", linewidth = 1, color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  scale_y_log10() +
  labs(
    x = "Volumenes de diafiltracion (Vd/V)",
    y = "Sal relativa C/C0 (escala log)",
    title = "Diafiltracion: sal relativa (puntos medidos, linea modelo)",
    subtitle = "C/C0 = exp(-Vd/V)"
  ) +
  tema

print(grafica_dia)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir del equipo de ultrafiltracion guardamos las dos graficas del recorrido.
ggsave("05_flux.png", grafica_flux,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("05_diafiltracion.png", grafica_dia,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (flux contra TMP): el eje x es la presion transmembrana en bar y el eje y es el flux en L/m2/h.
# - El flux sube lineal con la TMP hasta 1.5 bar y luego se estabiliza cerca del flux limite: subir mas la presion ya no aumenta el flux. Esto significa que operar por encima del punto donde se aplana la curva gasta energia sin producir mas, y por eso lo siguiente es trabajar en la zona lineal o cerca del flux limite.
# Grafica 2 (sal relativa en diafiltracion): el eje x es el numero de volumenes de diafiltracion Vd/V (adimensional) y el eje y es la sal relativa C/C0 en escala log (adimensional).
# - La sal cae de forma exponencial con los volumenes de diafiltracion; los puntos medidos siguen el modelo C = C0 * exp(-Vd/V). Esto significa que con el modelo se calcula cuantos volumenes hacen falta para llegar a la sal objetivo, y por eso la diafiltracion se programa con ese numero y no a ciegas.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La permeabilidad hidraulica sale de la pendiente en la zona lineal y el flux limite de la zona plana.
# - La diafiltracion lava la sal sin concentrar la proteina, y el modelo dice cuantos volumenes hacen falta para un objetivo dado.
# Terminamos el recorrido en el equipo de ultrafiltracion: ya sabemos a que presion operar y cuantos volumenes lavan la sal. Seguimos a la siguiente parada de la linea: la columna de adsorcion, donde la proteina se retiene y se purifica.
