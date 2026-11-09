# ==========================================================================
# P8. Cromatografia de intercambio ionico
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 8. Intercambio ionico
#
# Descripcion: Se analiza el cromatograma de intercambio ionico de albumina: a pH 8.0 la albumina esta por encima de su pI (4.7), asi que tiene carga negativa y se retiene en un intercambiador de aniones; la desorcion se hace subiendo la fuerza ionica con NaCl 500 mM. La masa por fraccion es concentracion por 0.5 mL y la suma da la recuperacion respecto a los 6 mg cargados.
#
# Objetivos de aprendizaje:
#   - Predecir el signo de la carga de la albumina a pH 8.0 desde su pI.
#   - Identificar el pico de desorcion con NaCl 500 mM.
#   - Calcular la masa recuperada y su porcentaje respecto a lo cargado.

# Datos: datos_intercambio.csv (concentracion de proteina por fraccion, medida por Bradford; carga 3 mL a 2 mg/mL = 6 mg).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer las fracciones y calcular la masa por fraccion
# --------------------------------------------------------------------------
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
# pI de la albumina: 4.7. A pH 8.0 (por encima del pI) su carga neta es
# negativa, asi que se retiene en un intercambiador de aniones.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- read_csv("datos_intercambio.csv", show_col_types = FALSE)

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
  filter(fase == "Desorcion (NaCl 500 mM)") %>%
  pull(masa_mg)
print(tibble(
  masa_recuperada_mg = masa_desorcion,
  recuperacion_porciento = masa_desorcion / masa_cargada_mg * 100
))

# --------------------------------------------------------------------------
# 3. Grafica: cromatograma de intercambio ionico
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
    title = "Intercambio ionico: cromatograma de albumina (pH 8.0)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("08_intercambio.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - En carga y lavado casi no sale proteina: a pH 8.0 la albumina, con carga negativa, queda retenida en el intercambiador de aniones.
# - Al subir la fuerza ionica con NaCl 500 mM aparece el pico de desorcion entre las fracciones 12 y 16.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El pH respecto al pI decide el signo de la carga y por tanto que intercambiador retiene a la proteina.
# - La sal compite por los sitios del intercambiador y desorbe la proteina; la masa recuperada sale de sumar las fracciones.
