# ==========================================================================
# 06. Adsorcion: isoterma de Langmuir
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 6. Adsorcion
#
# Descripcion: Recorrido por la planta, sexta parada: la columna de adsorcion. Aqui se ajusta la isoterma de Langmuir, q = qmax * K * C / (1 + K * C), a la cantidad adsorbida medida contra la concentracion en equilibrio. La forma linealizada 1/q contra 1/C da qmax y K por regresion, y con ellos se predice la capacidad a cualquier concentracion. Lo que se aprende aqui dice cuanta proteina retiene la columna antes de saturarse.
#
# Objetivos de aprendizaje:
#   - Ajustar la isoterma de Langmuir por su forma linealizada.
#   - Interpretar qmax como la capacidad maxima del adsorbente.
#   - Interpretar K como la afinidad entre soluto y adsorbente.

# Datos: datos_langmuir.csv (cantidad adsorbida medida contra concentracion en equilibrio).
# Recorrido: llegamos a la columna de adsorcion con la corriente ya concentrada y lavada. Primera parada: linealizar la isoterma y ajustar qmax y K. Segunda parada: trazar la curva de Langmuir con los parametros ajustados. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
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
# Parada 1. Leer los datos y linealizar la isoterma
# --------------------------------------------------------------------------
# Estamos frente a la columna de adsorcion. Medimos cuanta proteina queda retenida por gramo de adsorbente a cada concentracion en equilibrio, y linealizamos la isoterma para sacar qmax y K por regresion.
# Langmuir: q = qmax * K * C / (1 + K * C).
# Forma lineal: 1/q = 1/qmax + (1 / (qmax * K)) * (1/C).
datos <- read_csv("datos_langmuir.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(inv_c = 1 / concentracion_equilibrio_mg_ml,
         inv_q = 1 / q_mg_g)

ajuste <- lm(inv_q ~ inv_c, data = datos)
print(summary(ajuste))

qmax <- 1 / coef(ajuste)[["(Intercept)"]]
k_langmuir <- coef(ajuste)[["(Intercept)"]] / coef(ajuste)[["inv_c"]]

tabla_langmuir <- tibble(qmax_mg_g = qmax, k_por_mg_ml = k_langmuir)
print(tabla_langmuir)

# --------------------------------------------------------------------------
# Parada 2. Curva de Langmuir con los parametros ajustados
# --------------------------------------------------------------------------
# Seguimos en la columna: con qmax y K ya calculados trazamos la curva de Langmuir completa, para predecir la capacidad a cualquier concentracion.
curva <- tibble(
  concentracion_equilibrio_mg_ml = seq(0.05, 2.0, by = 0.05)
) %>%
  mutate(q_modelo = qmax * k_langmuir *
           concentracion_equilibrio_mg_ml /
           (1 + k_langmuir * concentracion_equilibrio_mg_ml))

# --------------------------------------------------------------------------
# Parada 3. Grafica 1: isoterma medida y modelo ajustado
# --------------------------------------------------------------------------
# Graficamos la isoterma: los puntos son lo medido en la columna y la linea es el modelo de Langmuir con qmax y K del ajuste; la linea punteada es qmax, la capacidad maxima del adsorbente.
grafica_iso <- ggplot() +
  geom_hline(yintercept = qmax, linetype = "dotted", color = paleta[6],
             linewidth = 1) +
  annotate("text", x = 1.9, y = qmax,
           label = paste0("qmax = ", round(qmax, 1), " mg/g"),
           hjust = 1, vjust = -0.6, size = 4.5, color = paleta[6]) +
  geom_line(data = curva,
            aes(x = concentracion_equilibrio_mg_ml, y = q_modelo),
            linewidth = 1, color = paleta[1]) +
  geom_point(data = datos,
             aes(x = concentracion_equilibrio_mg_ml, y = q_mg_g),
             size = 3, color = paleta[1]) +
  labs(
    x = "Concentracion en equilibrio, C (mg/mL)",
    y = "Cantidad adsorbida, q (mg/g)",
    title = "Isoterma de Langmuir (puntos medidos, linea ajustada)",
    subtitle = paste0("qmax = ", round(qmax, 1), " mg/g,  K = ",
                      round(k_langmuir, 2), " mL/mg")
  ) +
  tema

print(grafica_iso)

# --------------------------------------------------------------------------
# Parada 4. Grafica 2: forma linealizada 1/q contra 1/C
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la forma linealizada, donde los mismos datos se ven como una recta y se comprueba que siguen la isoterma de Langmuir.
ecuacion_langmuir <- paste0(
  "1/q = ", round(coef(ajuste)[["(Intercept)"]], 3),
  " + ", round(coef(ajuste)[["inv_c"]], 3), " * (1/C),  R2 = ",
  round(summary(ajuste)$r.squared, 3)
)
grafica_lin <- ggplot(datos, aes(x = inv_c, y = inv_q)) +
  geom_point(size = 3, color = paleta[1]) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1, color = paleta[1]) +
  labs(
    x = "1/C (mL/mg)",
    y = "1/q (g/mg)",
    title = "Langmuir linealizado: 1/q contra 1/C",
    subtitle = ecuacion_langmuir
  ) +
  tema

print(grafica_lin)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir de la columna de adsorcion guardamos las dos graficas del recorrido.
ggsave("06_langmuir.png", grafica_iso,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("06_langmuir_lineal.png", grafica_lin,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (isoterma de Langmuir): el eje x es la concentracion en equilibrio C en mg/mL y el eje y es la cantidad adsorbida q en mg/g.
# - La cantidad adsorbida sube rapido a concentracion baja y se acerca a un techo: ese techo es qmax, la capacidad maxima del adsorbente. Esto significa que por encima de cierta concentracion la columna ya no retiene mas proteina, y por eso lo siguiente es dimensionar la columna con qmax y no con la concentracion de entrada.
# Grafica 2 (forma linealizada): el eje x es 1/C en mL/mg y el eje y es 1/q en g/mg.
# - La forma linealizada es recta, lo que confirma que los datos siguen la isoterma de Langmuir en este intervalo. Esto significa que qmax y K del ajuste describen bien la columna y se pueden usar para disenar el adsorbedor.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - qmax y K salen de la regresion de 1/q contra 1/C, no de valores supuestos.
# - Con qmax y K se calcula cuanta proteina retiene el adsorbente a cualquier concentracion, que es el dato para disenar el adsorbedor.
# Terminamos el recorrido en la columna de adsorcion: ya sabemos cuanta proteina retiene y con que afinidad. Seguimos a la siguiente parada de la linea: el extractor liquido-liquido, donde el soluto pasa de una fase a otra segun el pH.
