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
# Descripcion: Se ajusta la ecuacion de Cohn, log10(S) = beta - Ks * C, a la solubilidad medida de albumina contra la molaridad de sulfato de amonio. La pendiente da Ks y la ordenada da beta, ambas calculadas por regresion a partir de los datos.
#
# Objetivos de aprendizaje:
#   - Ajustar la ecuacion de Cohn por regresion lineal.
#   - Interpretar Ks como la sensibilidad de la solubilidad a la sal.
#   - Distinguir salting-in (solubilidad que sube con poca sal) de salting-out (solubilidad que cae con mucha sal).

# Datos: datos_cohn.csv (solubilidad de albumina medida, 3 replicas por molaridad de sulfato de amonio).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer los datos y resumir por molaridad
# --------------------------------------------------------------------------
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
# 2. Ajuste de la ecuacion de Cohn
# --------------------------------------------------------------------------
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
# 3. Grafica 1: solubilidad contra molaridad de sal
# --------------------------------------------------------------------------
grafica_s <- ggplot(
  resumen,
  aes(x = molaridad_sulfato_M, y = solubilidad_media)
) +
  geom_errorbar(aes(ymin = solubilidad_media - de,
                    ymax = solubilidad_media + de),
                width = 0.1, linewidth = 0.6) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "Solubilidad de albumina (mg/mL)",
    title = "Salting-out de albumina con sulfato de amonio"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_s)

# --------------------------------------------------------------------------
# 4. Grafica 2: ajuste de Cohn (log10 S contra C)
# --------------------------------------------------------------------------
grafica_cohn <- ggplot(
  resumen,
  aes(x = molaridad_sulfato_M, y = log10(solubilidad_media))
) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "log10(solubilidad, mg/mL)",
    title = "Ecuacion de Cohn: log10(S) = beta - Ks * C"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_cohn)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
ggsave("02_solubilidad.png", grafica_s,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("02_cohn.png", grafica_cohn,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La solubilidad cae de 15 mg/mL sin sal a menos de 1 mg/mL a 3 M: el salting-out es fuerte y monotono en este intervalo.
# - El ajuste de Cohn es lineal en escala logaritmica; su pendiente Ks mide cuanto baja la solubilidad por cada mol por litro de sal.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La ecuacion de Cohn se obtiene de los datos por regresion, no de un valor supuesto: beta y Ks salen del ajuste.
# - Con Ks y beta se predice a que concentracion de sal precipita una fraccion dada de la proteina.
