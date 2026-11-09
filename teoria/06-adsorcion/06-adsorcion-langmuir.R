# ==========================================================================
# 06. Adsorcion: isoterma de Langmuir
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 6. Adsorcion
#
# Descripcion: Se ajusta la isoterma de Langmuir, q = qmax * K * C / (1 + K * C), a la cantidad adsorbida medida contra la concentracion en equilibrio. La forma linealizada 1/q contra 1/C da qmax y K por regresion, y con ellos se predice la capacidad a cualquier concentracion.
#
# Objetivos de aprendizaje:
#   - Ajustar la isoterma de Langmuir por su forma linealizada.
#   - Interpretar qmax como la capacidad maxima del adsorbente.
#   - Interpretar K como la afinidad entre soluto y adsorbente.

# Datos: datos_langmuir.csv (cantidad adsorbida medida contra concentracion en equilibrio).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer los datos y linealizar la isoterma
# --------------------------------------------------------------------------
# Langmuir: q = qmax * K * C / (1 + K * C).
# Forma lineal: 1/q = 1/qmax + (1 / (qmax * K)) * (1/C).
datos <- read_csv("datos_langmuir.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(inv_c = 1 / concentracion_equilibrio_mg_ml,
         inv_q = 1 / q_mg_g)

ajuste <- lm(inv_q ~ inv_c, data = datos)
print(summary(ajuste))

qmax <- 1 / coef(ajuste)[["(Intercept)"]]
k_langmuir <- coef(ajuste)[["(Intercept)"]] / coef(ajuste)[["inv_c"]]

tabla_langmuir <- tibble(qmax_mg_g = qmax, k_por_mg_ml = k_langmuir)
print(tabla_langmuir)

# --------------------------------------------------------------------------
# 2. Curva de Langmuir con los parametros ajustados
# --------------------------------------------------------------------------
curva <- tibble(
  concentracion_equilibrio_mg_ml = seq(0.05, 2.0, by = 0.05)
) %>%
  mutate(q_modelo = qmax * k_langmuir *
           concentracion_equilibrio_mg_ml /
           (1 + k_langmuir * concentracion_equilibrio_mg_ml))

# --------------------------------------------------------------------------
# 3. Grafica 1: isoterma medida y modelo ajustado
# --------------------------------------------------------------------------
grafica_iso <- ggplot() +
  geom_line(data = curva,
            aes(x = concentracion_equilibrio_mg_ml, y = q_modelo),
            linewidth = 1) +
  geom_point(data = datos,
             aes(x = concentracion_equilibrio_mg_ml, y = q_mg_g),
             size = 2.5) +
  labs(
    x = "Concentracion en equilibrio, C (mg/mL)",
    y = "Cantidad adsorbida, q (mg/g)",
    title = "Isoterma de Langmuir (puntos medidos, linea ajustada)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_iso)

# --------------------------------------------------------------------------
# 4. Grafica 2: forma linealizada 1/q contra 1/C
# --------------------------------------------------------------------------
grafica_lin <- ggplot(datos, aes(x = inv_c, y = inv_q)) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    x = "1/C (mL/mg)",
    y = "1/q (g/mg)",
    title = "Langmuir linealizado: 1/q contra 1/C"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_lin)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
ggsave("06_langmuir.png", grafica_iso,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("06_langmuir_lineal.png", grafica_lin,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La cantidad adsorbida sube rapido a concentracion baja y se acerca a un techo: ese techo es qmax, la capacidad maxima del adsorbente.
# - La forma linealizada es recta, lo que confirma que los datos siguen la isoterma de Langmuir en este intervalo.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - qmax y K salen de la regresion de 1/q contra 1/C, no de valores supuestos.
# - Con qmax y K se calcula cuanta proteina retiene el adsorbente a cualquier concentracion, que es el dato para disenar el adsorbedor.
