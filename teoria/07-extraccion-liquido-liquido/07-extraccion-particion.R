# ==========================================================================
# 07. Extraccion liquido-liquido: coeficiente de particion y pH
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 7. Extraccion liquido-liquido
#
# Descripcion: Recorrido por la planta, septima parada: el extractor liquido-liquido. Aqui se estudia como el pH cambia el coeficiente de particion de un acido debil (pKa 4.5): solo la forma neutra pasa a la fase organica, asi que el coeficiente de distribucion cae cuando el pH sube y el soluto se ioniza. Con Kd se calcula la eficiencia de extraccion en una etapa con volumenes iguales. Lo que se aprende aqui dice a que pH extraer y a que pH reextraer.
#
# Objetivos de aprendizaje:
#   - Calcular la fraccion neutra de un acido debil a cada pH.
#   - Relacionar el coeficiente de distribucion con el pH.
#   - Calcular la eficiencia de extraccion en una etapa.

# Datos: datos_particion.csv (coeficiente de distribucion medido contra pH; pKa 4.5, Kd de la forma neutra 8.0).
# Recorrido: llegamos al extractor con las dos fases a la vista, la acuosa y la organica. Primera parada: la fraccion neutra, el Kd y la eficiencia a cada pH. Segunda parada: las graficas de Kd y de eficiencia contra pH. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
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
# Parada 1. Leer los datos y calcular fraccion neutra y eficiencia
# --------------------------------------------------------------------------
# Estamos frente al extractor. Para cada pH calculamos que fraccion del soluto esta neutra, cuanto vale el Kd del modelo y que eficiencia da una etapa con volumenes iguales: esa eficiencia es la que decide si una etapa basta o hacen falta mas.
# Acido debil, pKa = 4.5. Fraccion neutra = 1 / (1 + 10^(pH - pKa)).
# Eficiencia en una etapa con Vorg = Vaq: E = Kd / (1 + Kd).
pka <- 4.5

datos <- read_csv("datos_particion.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(
    fraccion_neutra = 1 / (1 + 10^(ph - pka)),
    kd_modelo = 8.0 * fraccion_neutra,
    eficiencia_una_etapa = kd_medido / (1 + kd_medido)
  )

print(datos)

# Antes de seguir buscamos hasta que pH la eficiencia en una etapa se mantiene por encima del 50% (Kd = 1): ese es el limite de operacion de una sola etapa.
# pH al que la eficiencia en una etapa cae a 50% (Kd = 1).
ph_50 <- datos %>%
  filter(kd_medido >= 1) %>%
  summarise(ph_max_50 = max(ph)) %>%
  pull(ph_max_50)
print(tibble(ph_hasta_el_cual_E_mayor_50 = ph_50))

# --------------------------------------------------------------------------
# Parada 2. Grafica 1: Kd contra pH (medido y modelo)
# --------------------------------------------------------------------------
# Graficamos el Kd contra el pH en escala logaritmica: los puntos son lo medido y la linea punteada es el modelo con pKa 4.5; la linea vertical marca el pKa y la horizontal el Kd = 1.
grafica_kd <- ggplot(datos, aes(x = ph, y = kd_medido)) +
  geom_vline(xintercept = pka, linetype = "dotted", color = paleta[6],
             linewidth = 1) +
  annotate("text", x = pka, y = max(datos$kd_medido) * 0.8,
           label = "pKa 4.5", hjust = -0.2, size = 4.5, color = paleta[6]) +
  geom_hline(yintercept = 1, linetype = "dotted", color = "grey40") +
  annotate("text", x = min(datos$ph) + 0.2, y = 1.3,
           label = "Kd = 1", hjust = 0, size = 4.5) +
  geom_line(aes(y = kd_modelo), linetype = "dashed", linewidth = 1,
            color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  scale_y_log10() +
  labs(
    x = "pH de la fase acuosa",
    y = "Coeficiente de distribucion, Kd (escala log)",
    title = "Coeficiente de distribucion contra pH (pKa 4.5)"
  ) +
  tema

print(grafica_kd)

# --------------------------------------------------------------------------
# Parada 3. Grafica 2: eficiencia de extraccion en una etapa contra pH
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la eficiencia de extraccion en una etapa contra el pH, con la linea del 50% marcada y la vertical en el pH hasta el cual una etapa todavia llega al 50%.
grafica_e <- ggplot(
  datos,
  aes(x = ph, y = eficiencia_una_etapa)
) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey40") +
  geom_vline(xintercept = ph_50, linetype = "dotted", color = paleta[6],
             linewidth = 1) +
  annotate("text", x = ph_50, y = 0.9,
           label = paste0("E = 50% hasta pH ", ph_50),
           hjust = -0.1, size = 4.5, color = paleta[6]) +
  geom_line(linewidth = 1, color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  labs(
    x = "pH de la fase acuosa",
    y = "Eficiencia de extraccion en una etapa",
    title = "Eficiencia de extraccion en una etapa (Vorg = Vaq)"
  ) +
  tema

print(grafica_e)

# --------------------------------------------------------------------------
# 4. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir del extractor guardamos las dos graficas del recorrido.
ggsave("07_kd_ph.png", grafica_kd,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("07_eficiencia.png", grafica_e,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (Kd contra pH): el eje x es el pH de la fase acuosa (adimensional) y el eje y es el coeficiente de distribucion Kd en escala log (adimensional).
# - El Kd es alto a pH acido, donde el soluto esta neutro, y cae mas de cien veces al subir el pH: la forma ionizada no pasa a la fase organica. Esto significa que el pH decide de que lado queda el soluto, y por eso lo siguiente es extraer a pH bajo y reextraer a pH alto.
# Grafica 2 (eficiencia contra pH): el eje x es el pH de la fase acuosa (adimensional) y el eje y es la eficiencia de extraccion en una etapa (adimensional, fraccion de 0 a 1).
# - La eficiencia en una etapa sigue al Kd: por encima de pH 5 ya no llega al 50% con volumenes iguales. Esto significa que a pH alto una sola etapa no basta y habria que agregar etapas o cambiar la relacion de volumenes.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El pH es la palanca de la extraccion de solutos ionizables: se extrae a pH bajo y se reextrae a pH alto.
# - Con Kd y la relacion de volumenes se calcula la eficiencia antes de montar el extractor.
# Terminamos el recorrido en el extractor: ya sabemos a que pH extraer y a que pH reextraer. Seguimos a la ultima parada de la linea: el secador, donde el producto se seca para guardarlo.
