# ==========================================================================
# 02. Precipitacion: ecuacion de Cohn (salting-out)
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 2. Precipitacion
#
# Descripcion: Recorrido por la planta, segunda parada: el tanque de precipitacion. Aqui se agrega sulfato de amonio al caldo con albumina y se mide cuanta proteina queda disuelta a cada molaridad de sal. Se ajusta la ecuacion de Cohn, log10(S) = beta - Ks * C, a la solubilidad medida: la pendiente da Ks y la ordenada da beta, ambas calculadas por regresion a partir de los datos. Lo que se aprende aqui dice cuanta sal hay que agregar para precipitar la fraccion que se quiere.
#
# Objetivos de aprendizaje:
#   - Ajustar la ecuacion de Cohn por regresion lineal.
#   - Interpretar Ks como la sensibilidad de la solubilidad a la sal.
#   - Distinguir salting-in (solubilidad que sube con poca sal) de salting-out (solubilidad que cae con mucha sal).

# Datos: datos_cohn.csv (solubilidad de albumina medida, 3 replicas por molaridad de sulfato de amonio).
# Recorrido: llegamos al tanque de precipitacion con la albumina caracterizada en la parada anterior. Primera parada: resumir la solubilidad medida a cada molaridad de sal. Segunda parada: ajustar la ecuacion de Cohn y leer Ks y beta. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
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
# Parada 1. Leer los datos y resumir por molaridad
# --------------------------------------------------------------------------
# Estamos frente al tanque de precipitacion. Tomamos las muestras del tanque a cada molaridad de sal y resumimos la solubilidad medida con su desviacion estandar: esa tabla es la foto de como la sal va sacando a la albumina de la solucion.
datos <- read_csv("datos_cohn.csv", show_col_types = FALSE)

resumen <- datos %>%
  group_by(molaridad_sulfato_M) %>%
  summarise(
    solubilidad_media = mean(solubilidad_mg_ml),
    de = sd(solubilidad_mg_ml),
    .groups = "drop"
  )

print(resumen)

# --------------------------------------------------------------------------
# Parada 2. Ajuste de la ecuacion de Cohn
# --------------------------------------------------------------------------
# Seguimos en el tanque: ahora ajustamos la ecuacion de Cohn a los datos resumidos. La pendiente del ajuste es Ks, que dice que tan sensible es la solubilidad a la sal, y la ordenada es beta. Con esos dos numeros se predice a que concentracion de sal cae la solubilidad a 1 mg/mL.
# Ecuacion de Cohn: log10(S) = beta - Ks * C, donde S es la solubilidad
# en mg/mL y C la molaridad de la sal. Se ajusta log10(S) contra C.
ajuste <- lm(log10(solubilidad_media) ~ molaridad_sulfato_M, data = resumen)
print(summary(ajuste))

beta <- coef(ajuste)[["(Intercept)"]]
ks <- -coef(ajuste)[["molaridad_sulfato_M"]]

tabla_cohn <- tibble(beta = beta, ks_por_M = ks)
print(tabla_cohn)

# Concentracion de sal a la que la solubilidad cae a 1 mg/mL.
c_1mg_ml <- (beta - log10(1)) / ks
print(tibble(c_sal_1_mg_ml_M = c_1mg_ml))

# --------------------------------------------------------------------------
# Parada 3. Grafica 1: solubilidad contra molaridad de sal
# --------------------------------------------------------------------------
# Graficamos lo que pasa dentro del tanque: cada punto es la solubilidad media a una molaridad de sal, con su barra de desviacion estandar; la curva es el ajuste de Cohn y el texto marca la sal a la que la solubilidad cae a 1 mg/mL.
curva_cohn <- tibble(
  molaridad_sulfato_M = seq(min(resumen$molaridad_sulfato_M),
                            max(resumen$molaridad_sulfato_M), length.out = 100)
) %>%
  mutate(solubilidad_ajustada = 10^predict(ajuste, newdata = .))
grafica_s <- ggplot(
  resumen,
  aes(x = molaridad_sulfato_M, y = solubilidad_media)
) +
  geom_errorbar(aes(ymin = solubilidad_media - de,
                    ymax = solubilidad_media + de),
                width = 0.1, linewidth = 0.6, color = paleta[1]) +
  geom_line(data = curva_cohn,
            aes(x = molaridad_sulfato_M, y = solubilidad_ajustada),
            color = paleta[6], linewidth = 1) +
  geom_point(size = 3, color = paleta[1]) +
  geom_vline(xintercept = c_1mg_ml, linetype = "dotted", color = paleta[6]) +
  annotate("text", x = c_1mg_ml, y = max(resumen$solubilidad_media) * 0.9,
           label = paste0("S = 1 mg/mL a ", round(c_1mg_ml, 2), " M"),
           hjust = -0.1, size = 4.5, color = paleta[6]) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "Solubilidad de albumina (mg/mL)",
    title = "Salting-out de albumina con sulfato de amonio",
    subtitle = "La curva es el ajuste de Cohn"
  ) +
  tema

print(grafica_s)

# --------------------------------------------------------------------------
# Parada 4. Grafica 2: ajuste de Cohn (log10 S contra C)
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la misma solubilidad en escala logaritmica, donde el ajuste de Cohn se ve como una recta. Si los puntos caen sobre la recta, el modelo describe lo que pasa en el tanque.
ecuacion_cohn <- paste0(
  "log10(S) = ", round(beta, 2), " - ", round(ks, 2),
  " * C,  R2 = ", round(summary(ajuste)$r.squared, 3)
)
grafica_cohn <- ggplot(
  resumen,
  aes(x = molaridad_sulfato_M, y = log10(solubilidad_media))
) +
  geom_point(size = 3, color = paleta[1]) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1, color = paleta[1]) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "log10(solubilidad, mg/mL)",
    title = "Ecuacion de Cohn: log10(S) = beta - Ks * C",
    subtitle = ecuacion_cohn
  ) +
  tema

print(grafica_cohn)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir del tanque de precipitacion guardamos las dos graficas del recorrido.
ggsave("02_solubilidad.png", grafica_s,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("02_cohn.png", grafica_cohn,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (solubilidad contra molaridad): el eje x es la molaridad de sulfato de amonio en M y el eje y es la solubilidad de albumina en mg/mL.
# - La solubilidad cae de 15 mg/mL sin sal a menos de 1 mg/mL a 3 M: el salting-out es fuerte y monotono en este intervalo. Esto significa que en el tanque basta subir la sal para sacar casi toda la albumina de la solucion, y por eso lo siguiente es separar ese precipitado en la centrifuga.
# Grafica 2 (ajuste de Cohn): el eje x es la molaridad de sulfato de amonio en M y el eje y es log10 de la solubilidad en mg/mL (escala logaritmica).
# - El ajuste de Cohn es lineal en escala logaritmica; su pendiente Ks mide cuanto baja la solubilidad por cada mol por litro de sal. Esto significa que con Ks y beta se calcula la sal necesaria para cualquier fraccion que se quiera precipitar.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La ecuacion de Cohn se obtiene de los datos por regresion, no de un valor supuesto: beta y Ks salen del ajuste.
# - Con Ks y beta se predice a que concentracion de sal precipita una fraccion dada de la proteina.
# Terminamos el recorrido en el tanque de precipitacion: ya sabemos cuanta sal precipita la albumina y como calcularlo. Seguimos a la siguiente parada de la linea: el equipo de rompimiento celular, donde se libera la proteina que esta dentro de las celulas.
