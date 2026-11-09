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
# Descripcion: Se estudia como el pH cambia el coeficiente de particion de un acido debil (pKa 4.5): solo la forma neutra pasa a la fase organica, asi que el coeficiente de distribucion cae cuando el pH sube y el soluto se ioniza. Con Kd se calcula la eficiencia de extraccion en una etapa con volumenes iguales.
#
# Objetivos de aprendizaje:
#   - Calcular la fraccion neutra de un acido debil a cada pH.
#   - Relacionar el coeficiente de distribucion con el pH.
#   - Calcular la eficiencia de extraccion en una etapa.

# Datos: datos_particion.csv (coeficiente de distribucion medido contra pH; pKa 4.5, Kd de la forma neutra 8.0).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer los datos y calcular fraccion neutra y eficiencia
# --------------------------------------------------------------------------
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

# pH al que la eficiencia en una etapa cae a 50% (Kd = 1).
ph_50 <- datos %>%
  filter(kd_medido >= 1) %>%
  summarise(ph_max_50 = max(ph)) %>%
  pull(ph_max_50)
print(tibble(ph_hasta_el_cual_E_mayor_50 = ph_50))

# --------------------------------------------------------------------------
# 2. Grafica 1: Kd contra pH (medido y modelo)
# --------------------------------------------------------------------------
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
# 3. Grafica 2: eficiencia de extraccion en una etapa contra pH
# --------------------------------------------------------------------------
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
ggsave("07_kd_ph.png", grafica_kd,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("07_eficiencia.png", grafica_e,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - El Kd es alto a pH acido, donde el soluto esta neutro, y cae mas de cien veces al subir el pH: la forma ionizada no pasa a la fase organica.
# - La eficiencia en una etapa sigue al Kd: por encima de pH 5 ya no llega al 50% con volumenes iguales.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El pH es la palanca de la extraccion de solutos ionizables: se extrae a pH bajo y se reextrae a pH alto.
# - Con Kd y la relacion de volumenes se calcula la eficiencia antes de montar el extractor.
