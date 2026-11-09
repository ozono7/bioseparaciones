# ==========================================================================
# P6. Introduccion al FPLC (BioLogic LP)
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 6. FPLC
#
# Descripcion: Se reconstruye el registro del equipo BioLogic LP durante la carga de niquel y el equilibrio de la columna: absorbancia a 280 nm y conductividad contra tiempo, con flujo de 0.5 mL/min. El volumen acumulado se calcula de cero como flujo por tiempo, y cada fase del protocolo se identifica en el registro.
#
# Objetivos de aprendizaje:
#   - Identificar cada fase del protocolo en el registro del FPLC.
#   - Calcular el volumen acumulado a partir del flujo y el tiempo.
#   - Leer la conductividad como senal del cambio de buffer.

# Datos: datos_fplc.csv (absorbancia a 280 nm y conductividad registradas contra tiempo; flujo 0.5 mL/min).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Leer el registro y calcular el volumen acumulado
# --------------------------------------------------------------------------
# Flujo del protocolo: 0.5 mL/min. Volumen acumulado = flujo * tiempo.
flujo_ml_min <- 0.5

datos <- read_csv("datos_fplc.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(volumen_ml = flujo_ml_min * tiempo_min)

print(datos)

# Volumen total pasado por la columna en el registro.
print(tibble(volumen_total_ml = max(datos$volumen_ml)))

# Conductividad media por fase.
print(datos %>%
        group_by(fase) %>%
        summarise(conductividad_media = mean(conductividad_mS_cm),
                  absorbancia_280_media = mean(absorbancia_280),
                  .groups = "drop"))

# --------------------------------------------------------------------------
# 2. Grafica 1: absorbancia a 280 nm contra volumen
# --------------------------------------------------------------------------
grafica_uv <- ggplot(
  datos,
  aes(x = volumen_ml, y = absorbancia_280, color = fase)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Absorbancia a 280 nm",
    color = "Fase",
    title = "FPLC: absorbancia a 280 nm durante la preparacion"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_uv)

# --------------------------------------------------------------------------
# 3. Grafica 2: conductividad contra volumen
# --------------------------------------------------------------------------
grafica_cond <- ggplot(
  datos,
  aes(x = volumen_ml, y = conductividad_mS_cm, color = fase)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Conductividad (mS/cm)",
    color = "Fase",
    title = "FPLC: conductividad durante la preparacion"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_cond)

# --------------------------------------------------------------------------
# 4. Exportar las graficas
# --------------------------------------------------------------------------
ggsave("06_fplc_uv.png", grafica_uv,
       width = 20, height = 12, units = "cm", dpi = 300)
ggsave("06_fplc_conductividad.png", grafica_cond,
       width = 20, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La conductividad sube con cada cambio de solucion: marca la llegada del niquel, del buffer de adsorcion con 500 mM NaCl y del acido.
# - La absorbancia a 280 nm se mantiene en la linea base: en esta practica todavia no se carga proteina.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El detector UV sigue a la proteina y el de conductividad sigue a las sales del buffer.
# - El volumen acumulado sale del flujo por el tiempo y permite ubicar cada fase en el cromatograma.
