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
# Graficamos el Kd contra el pH en escala logaritmica: los puntos son lo medido y la linea punteada es el modelo con pKa 4.5.
grafica_kd <- ggplot(datos, aes(x = ph, y = kd_medido)) +
  geom_line(aes(y = kd_modelo), linetype = "dashed", linewidth = 1) +
  geom_point(size = 2.5) +
  scale_y_log10() +
  labs(
    x = "pH de la fase acuosa",
    y = "Coeficiente de distribucion, Kd (escala log)",
    title = "Coeficiente de distribucion contra pH (pKa 4.5)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_kd)

# --------------------------------------------------------------------------
# Parada 3. Grafica 2: eficiencia de extraccion en una etapa contra pH
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la eficiencia de extraccion en una etapa contra el pH, con la linea del 50% marcada.
grafica_e <- ggplot(
  datos,
  aes(x = ph, y = eficiencia_una_etapa)
) +
  geom_hline(yintercept = 0.5, linetype = "dashed") +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "pH de la fase acuosa",
    y = "Eficiencia de extraccion en una etapa",
    title = "Eficiencia de extraccion en una etapa (Vorg = Vaq)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

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
