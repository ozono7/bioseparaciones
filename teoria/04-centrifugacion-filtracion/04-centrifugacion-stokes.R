# ==========================================================================
# 04. Centrifugacion: Ley de Stokes y fuerza centrifuga relativa
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 4. Centrifugacion y filtracion
#
# Descripcion: Se calcula la velocidad de sedimentacion con la Ley de Stokes a partir del diametro y la densidad medidos de cada particula, y la fuerza centrifuga relativa (RCF) a partir de las rpm y el radio del rotor. Con ambas se estima el tiempo para sedimentar 10 cm.
#
# Objetivos de aprendizaje:
#   - Calcular la velocidad de sedimentacion con la Ley de Stokes.
#   - Calcular la RCF a partir de rpm y radio del rotor.
#   - Explicar por que el diametro manda en la separacion: la velocidad depende del diametro al cuadrado.

# Datos: datos_sedimentacion.csv (diametro y densidad de cada particula) y datos_rcf.csv (rpm y radio del rotor).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Velocidad de sedimentacion (Ley de Stokes)
# --------------------------------------------------------------------------
# v = d^2 * (rho_p - rho_f) * g / (18 * eta)
# Fluido: agua, rho_f = 1000 kg/m3, eta = 0.001 Pa s, g = 9.81 m/s2.
datos <- read_csv("datos_sedimentacion.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(
    diametro_m = diametro_um * 1e-6,
    densidad_kg_m3 = densidad_g_ml * 1000,
    velocidad_m_s = diametro_m^2 * (densidad_kg_m3 - 1000) * 9.81 /
      (18 * 0.001),
    velocidad_um_s = velocidad_m_s * 1e6,
    tiempo_10cm_h = 0.1 / velocidad_m_s / 3600
  )

print(datos)

# --------------------------------------------------------------------------
# 2. Fuerza centrifuga relativa (RCF)
# --------------------------------------------------------------------------
# RCF = 1.118e-5 * r(cm) * rpm^2, en multiplos de g.
datos_rcf <- read_csv("datos_rcf.csv", show_col_types = FALSE)

datos_rcf <- datos_rcf %>%
  mutate(rcf_g = 1.118e-5 * radio_cm * rpm^2)

print(datos_rcf)

# Tiempo de sedimentacion de la levadura a 10000 rpm (RCF 11180 g):
# el tiempo a 1 g se divide entre la RCF.
tiempo_levadura_1g <- datos %>%
  filter(particula == "Levadura") %>%
  pull(tiempo_10cm_h)
rcf_10000 <- datos_rcf %>%
  filter(rpm == 10000) %>%
  pull(rcf_g)
print(tibble(
  tiempo_levadura_10cm_10000rpm_min =
    tiempo_levadura_1g / rcf_10000 * 60
))

# --------------------------------------------------------------------------
# 3. Grafica 1: velocidad de sedimentacion contra diametro
# --------------------------------------------------------------------------
grafica_v <- ggplot(
  datos,
  aes(x = diametro_um, y = velocidad_um_s)
) +
  geom_point(size = 3) +
  geom_text(aes(label = particula), vjust = -1, size = 3.5) +
  scale_x_log10() +
  scale_y_log10() +
  labs(
    x = "Diametro (um, escala log)",
    y = "Velocidad de sedimentacion (um/s, escala log)",
    title = "Ley de Stokes: velocidad de sedimentacion a 1 g"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_v)

# --------------------------------------------------------------------------
# 4. Grafica 2: RCF contra rpm
# --------------------------------------------------------------------------
grafica_rcf <- ggplot(datos_rcf, aes(x = rpm, y = rcf_g)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Velocidad del rotor (rpm)",
    y = "Fuerza centrifuga relativa (x g)",
    title = "RCF contra rpm (radio del rotor 10 cm)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_rcf)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
ggsave("04_stokes.png", grafica_v,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("04_rcf.png", grafica_rcf,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La velocidad crece con el cuadrado del diametro: una levadura de 5 um sedimenta mas de 100 veces mas rapido que una bacteria de 1 um.
# - La RCF crece con el cuadrado de las rpm: duplicar las rpm multiplica la fuerza por cuatro.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La Ley de Stokes explica la centrifugacion diferencial: cada fraccion sedimenta a su tiempo segun su tamano y su densidad.
# - Con la RCF se pasa de rpm, que dependen del rotor, a multiplos de g, que permiten comparar equipos y escalar el proceso.
