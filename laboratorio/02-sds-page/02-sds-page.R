# ==========================================================================
# P2. SDS-PAGE: peso molecular a partir de la migracion
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 2. SDS-PAGE
#
# Descripcion: Se calcula el Rf de cada banda (distancia recorrida entre distancia del frente, 65 mm) y se ajusta log10(PM) contra Rf con el marcador de peso molecular. Con esa recta se estima el peso molecular de la albumina (BSA) a partir de su Rf medido.
#
# Objetivos de aprendizaje:
#   - Calcular el Rf de cada banda del gel.
#   - Ajustar log10(PM) contra Rf con el marcador.
#   - Estimar el peso molecular de la BSA desde su migracion.

# Datos: datos_sds_page.csv (distancia migrada de cada banda del marcador y de la BSA; frente del gel 65 mm).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Rf de cada banda
# --------------------------------------------------------------------------
# Rf = distancia recorrida por la banda / distancia recorrida por el
# frente del gel (65 mm, medido en el gel).
frente_mm <- 65

datos <- read_csv("datos_sds_page.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(rf = distancia_mm / frente_mm)

print(datos)

# --------------------------------------------------------------------------
# 2. Recta de calibracion log10(PM) contra Rf
# --------------------------------------------------------------------------
marcador <- filter(datos, carril == "Marcador")

ajuste <- lm(log10(peso_molecular_kda) ~ rf, data = marcador)
print(summary(ajuste))

# --------------------------------------------------------------------------
# 3. Peso molecular estimado de la BSA
# --------------------------------------------------------------------------
rf_bsa <- datos %>%
  filter(proteina == "BSA") %>%
  pull(rf)

pm_bsa <- 10^predict(ajuste, newdata = tibble(rf = rf_bsa))
print(tibble(rf_bsa = rf_bsa, peso_molecular_BSA_kda = pm_bsa))

# --------------------------------------------------------------------------
# 4. Grafica: calibracion y BSA
# --------------------------------------------------------------------------
grafica <- ggplot(marcador, aes(x = rf, y = log10(peso_molecular_kda))) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  geom_point(
    data = tibble(rf = rf_bsa, y = log10(pm_bsa)),
    aes(x = rf, y = y), color = "red", size = 3
  ) +
  labs(
    x = "Rf (distancia / frente)",
    y = "log10(peso molecular, kDa)",
    title = "SDS-PAGE: calibracion con marcador y BSA (punto rojo)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 5. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("02_sds_page.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - El Rf baja al subir el peso molecular: las proteinas grandes migran menos en el gel.
# - La BSA cae sobre la recta del marcador, cerca de 66 kDa, que es su peso molecular de referencia.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - En SDS-PAGE la separacion es por peso molecular, porque el SDS da la misma carga por unidad de longitud.
# - La recta log10(PM) contra Rf convierte una distancia medida en un peso molecular estimado.
