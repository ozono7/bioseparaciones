# ==========================================================================
# P4. Precipitacion de albumina con sulfato de amonio
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 4. Sulfato de amonio
#
# Descripcion: Se convierte a molaridad la masa de sulfato de amonio indicada en el manual para cada saturacion (49, 60, 73 y 85%, gramos por vial de 5 mL), y se ajusta la ecuacion de Cohn a la solubilidad de albumina medida en el sobrenadante por Bradford.
#
# Objetivos de aprendizaje:
#   - Convertir los gramos del manual a molaridad de sulfato de amonio.
#   - Construir la tabla de solubilidad contra concentracion molar.
#   - Ajustar la ecuacion de Cohn a los datos de la practica.

# Datos: datos_sulfato.csv (saturacion y gramos del manual, solubilidad en el sobrenadante medida por Bradford, 3 replicas).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Gramos del manual a molaridad
# --------------------------------------------------------------------------
# Peso molecular del sulfato de amonio: 132.14 g/mol.
# Cada vial tiene 5 mL de solucion de albumina (15 mg/mL en fosfato
# 50 mM, pH 7, segun el manual).
datos <- read_csv("datos_sulfato.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(molaridad_M = gramos_5ml / 132.14 / 0.005)

resumen <- datos %>%
  group_by(saturacion_pct, gramos_5ml, molaridad_M) %>%
  summarise(
    solubilidad_media = mean(solubilidad_sobrenadante_mg_ml),
    de = sd(solubilidad_sobrenadante_mg_ml),
    .groups = "drop"
  )

print(resumen)

# --------------------------------------------------------------------------
# 2. Ajuste de Cohn a la solubilidad en el sobrenadante
# --------------------------------------------------------------------------
ajuste <- lm(log10(solubilidad_media) ~ molaridad_M, data = resumen)
print(summary(ajuste))

tabla_cohn <- tibble(
  beta = coef(ajuste)[["(Intercept)"]],
  ks_por_M = -coef(ajuste)[["molaridad_M"]]
)
print(tabla_cohn)

# Fraccion de albumina que queda soluble a cada saturacion, respecto a
# los 15 mg/mL iniciales.
resumen <- resumen %>%
  mutate(fraccion_soluble = solubilidad_media / 15.0)
print(resumen)

# --------------------------------------------------------------------------
# 3. Grafica: solubilidad en el sobrenadante contra molaridad
# --------------------------------------------------------------------------
grafica <- ggplot(
  resumen,
  aes(x = molaridad_M, y = solubilidad_media)
) +
  geom_errorbar(aes(ymin = solubilidad_media - de,
                    ymax = solubilidad_media + de),
                width = 0.1, linewidth = 0.6) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "Albumina soluble en el sobrenadante (mg/mL)",
    title = "Salting-out: albumina soluble contra molaridad de sal"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("04_sulfato.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La albumina soluble en el sobrenadante cae de 12.5 mg/mL a 49% de saturacion a menos de 1 mg/mL a 85%: la proteina pasa al precipitado.
# - El logaritmo de la solubilidad es lineal con la molaridad, como pide la ecuacion de Cohn.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - Los gramos del manual se convierten a molaridad con el peso molecular y el volumen del vial.
# - La tabla de solubilidad contra molaridad es el resultado que pide el manual para esta practica.
