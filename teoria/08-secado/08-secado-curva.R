# ==========================================================================
# 08. Secado: curva de secado y velocidad de secado
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 8. Secado
#
# Descripcion: Se calcula la velocidad de secado como -dX/dt a partir de la humedad medida contra el tiempo, se identifica la humedad critica donde termina el periodo de velocidad constante, y se calcula el calor para evaporar el agua retirada con el calor latente de vaporizacion.
#
# Objetivos de aprendizaje:
#   - Calcular la velocidad de secado a partir de datos de humedad.
#   - Identificar la humedad critica y los dos periodos de secado.
#   - Calcular el calor necesario para evaporar el agua retirada.

# Datos: datos_secado.csv (humedad en base seca medida contra tiempo).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer los datos y calcular la velocidad de secado
# --------------------------------------------------------------------------
# Velocidad de secado R = -dX/dt, calculada por diferencias entre
# mediciones consecutivas de humedad X contra tiempo t.
datos <- read_csv("datos_secado.csv", show_col_types = FALSE)

velocidad <- datos %>%
  mutate(
    velocidad_kg_kg_min =
      -c(NA, diff(humedad_kg_kg_seco)) / c(NA, diff(tiempo_min)),
    humedad_media =
      c(NA, (humedad_kg_kg_seco[-1] + humedad_kg_kg_seco[-n()]) / 2)
  ) %>%
  filter(!is.na(velocidad_kg_kg_min))

print(velocidad)

# Humedad critica: la humedad media del ultimo intervalo con velocidad
# todavia cercana a la velocidad constante inicial.
velocidad_constante <- velocidad %>%
  filter(tiempo_min <= 60) %>%
  summarise(v = mean(velocidad_kg_kg_min)) %>%
  pull(v)
print(tibble(velocidad_constante_kg_kg_min = velocidad_constante))

# --------------------------------------------------------------------------
# 2. Calor para evaporar el agua retirada
# --------------------------------------------------------------------------
# Agua retirada por kg de solido seco: X inicial - X final.
# Calor latente de vaporizacion del agua: 2257 kJ/kg.
agua_retirada <- first(datos$humedad_kg_kg_seco) -
  last(datos$humedad_kg_kg_seco)
calor_kj_por_kg_seco <- agua_retirada * 2257
print(tibble(
  agua_retirada_kg_por_kg_seco = agua_retirada,
  calor_kj_por_kg_seco = calor_kj_por_kg_seco
))

# --------------------------------------------------------------------------
# 3. Grafica 1: humedad contra tiempo
# --------------------------------------------------------------------------
grafica_x <- ggplot(
  datos,
  aes(x = tiempo_min, y = humedad_kg_kg_seco)
) +
  geom_vline(xintercept = 60, linetype = "dashed") +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Tiempo (min)",
    y = "Humedad (kg agua / kg solido seco)",
    title = "Curva de secado (humedad critica a 60 min)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_x)

# --------------------------------------------------------------------------
# 4. Grafica 2: velocidad de secado contra humedad
# --------------------------------------------------------------------------
grafica_r <- ggplot(
  velocidad,
  aes(x = humedad_media, y = velocidad_kg_kg_min)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Humedad media (kg/kg seco)",
    y = "Velocidad de secado (kg/kg/min)",
    title = "Velocidad de secado contra humedad"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_r)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
ggsave("08_curva_secado.png", grafica_x,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("08_velocidad_secado.png", grafica_r,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La humedad baja lineal hasta los 60 min y luego cada vez mas lento: el periodo de velocidad constante termina en la humedad critica.
# - La velocidad de secado es constante mientras la superficie sigue mojada y cae cuando el agua interna manda en el proceso.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La velocidad de secado se calcula por diferencias a partir de la curva medida, sin suponer su forma.
# - Con el agua retirada y el calor latente se calcula el calor que debe aportar el secador.
