# ==========================================================================
# P7. Cromatografia de afinidad por metal inmovilizado (IMAC)
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 7. IMAC
#
# Descripcion: Se analiza el cromatograma de IMAC con niquel: albumina cargada en buffer de adsorcion (fosfato 20 mM, NaCl 500 mM, pH 7.0) y desorbida con buffer pH 4.0. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es concentracion por 0.5 mL; la suma da la masa recuperada y su porcentaje respecto a los 6 mg cargados.
#
# Objetivos de aprendizaje:
#   - Identificar el pico de desorcion en el cromatograma.
#   - Calcular la masa de proteina por fraccion y la masa total.
#   - Calcular el porcentaje de recuperacion respecto a lo cargado.

# Datos: datos_imac.csv (concentracion de proteina por fraccion, medida por Bradford; carga 3 mL a 2 mg/mL = 6 mg).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer las fracciones y calcular la masa por fraccion
# --------------------------------------------------------------------------
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- read_csv("datos_imac.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_mg = concentracion_proteina_mg_ml * volumen_fraccion_ml)

print(datos)

# --------------------------------------------------------------------------
# 2. Masa recuperada en la desorcion y porcentaje de recuperacion
# --------------------------------------------------------------------------
resumen <- datos %>%
  group_by(fase) %>%
  summarise(masa_mg = sum(masa_mg), .groups = "drop")

print(resumen)

masa_desorcion <- resumen %>%
  filter(fase == "Desorcion (pH 4.0)") %>%
  pull(masa_mg)
print(tibble(
  masa_recuperada_mg = masa_desorcion,
  recuperacion_porciento = masa_desorcion / masa_cargada_mg * 100
))

# --------------------------------------------------------------------------
# 3. Grafica: cromatograma IMAC
# --------------------------------------------------------------------------
grafica <- ggplot(
  datos,
  aes(x = fraccion, y = concentracion_proteina_mg_ml, fill = fase)
) +
  geom_col(width = 0.8) +
  labs(
    x = "Fraccion (1 min, 0.5 mL cada una)",
    y = "Concentracion de proteina (mg/mL)",
    fill = "Fase",
    title = "IMAC con Ni(II): cromatograma de albumina"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("07_imac.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - En carga y lavado casi no sale proteina: la albumina queda retenida en la columna con niquel a pH 7.0.
# - Al cambiar a pH 4.0 aparece el pico de desorcion entre las fracciones 13 y 17, donde sale la mayor parte de la proteina.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La histidina de la superficie se une al niquel a pH 7 y se protona a pH 4, lo que rompe la union y desorbe la proteina.
# - La masa recuperada es la suma de concentracion por volumen en cada fraccion de la desorcion.
