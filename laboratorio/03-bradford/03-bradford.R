# ==========================================================================
# P3. Ensayo de Bradford: curva de calibracion de proteina
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 3. Ensayo de Bradford
#
# Descripcion: Se construye la curva de calibracion del ensayo de Bradford con los estandares del manual (BSA 0, 2.5, 5, 10 y 20 ug/mL, por triplicado, absorbancia a 595 nm). Se ajusta una recta y un polinomio de segundo orden, se comparan, y se cuantifica una muestra problema con la recta.
#
# Objetivos de aprendizaje:
#   - Construir la curva de calibracion con estandares por triplicado.
#   - Comparar el ajuste lineal con el polinomial de segundo orden.
#   - Cuantificar una muestra problema a partir de su absorbancia.

# Datos: datos_bradford.csv (estandares de BSA del manual, absorbancia a 595 nm) y datos_bradford_muestra.csv (muestra problema).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer los estandares y resumir por concentracion
# --------------------------------------------------------------------------
datos <- read_csv("datos_bradford.csv", show_col_types = FALSE)

resumen <- datos %>%
  group_by(concentracion_ug_ml) %>%
  summarise(
    absorbancia_media = mean(absorbancia_595),
    de = sd(absorbancia_595),
    .groups = "drop"
  )

print(resumen)

# --------------------------------------------------------------------------
# 2. Ajuste lineal y ajuste polinomial de segundo orden
# --------------------------------------------------------------------------
ajuste_lineal <- lm(absorbancia_595 ~ concentracion_ug_ml, data = datos)
ajuste_poli <- lm(absorbancia_595 ~ concentracion_ug_ml +
                    I(concentracion_ug_ml^2), data = datos)

print(summary(ajuste_lineal))
print(summary(ajuste_poli))

tabla_r2 <- tibble(
  modelo = c("Lineal", "Polinomial grado 2"),
  r_cuadrado = c(summary(ajuste_lineal)$r.squared,
                 summary(ajuste_poli)$r.squared)
)
print(tabla_r2)

# --------------------------------------------------------------------------
# 3. Cuantificacion de la muestra problema con la recta
# --------------------------------------------------------------------------
muestra <- read_csv("datos_bradford_muestra.csv", show_col_types = FALSE)

muestra <- muestra %>%
  mutate(concentracion_ug_ml =
           (absorbancia_595 - coef(ajuste_lineal)[["(Intercept)"]]) /
           coef(ajuste_lineal)[["concentracion_ug_ml"]])

print(muestra)
print(muestra %>%
        summarise(concentracion_media = mean(concentracion_ug_ml),
                  de = sd(concentracion_ug_ml)))

# --------------------------------------------------------------------------
# 4. Grafica: curva de calibracion
# --------------------------------------------------------------------------
grafica <- ggplot(
  resumen,
  aes(x = concentracion_ug_ml, y = absorbancia_media)
) +
  geom_errorbar(aes(ymin = absorbancia_media - de,
                    ymax = absorbancia_media + de),
                width = 0.5, linewidth = 0.6) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    x = "Concentracion de BSA (ug/mL)",
    y = "Absorbancia a 595 nm",
    title = "Bradford: curva de calibracion de BSA"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 5. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("03_bradford.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La absorbancia sube con la concentracion de proteina en todo el intervalo de 0 a 20 ug/mL.
# - El polinomio de segundo orden ajusta un poco mejor que la recta, porque la respuesta del colorante no es perfectamente lineal.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La curva de calibracion se construye cada vez que se cuantifica, con la misma proteina que se va a medir.
# - La recta convierte la absorbancia de una muestra en concentracion; el polinomio muestra hasta donde la linealidad alcanza.
