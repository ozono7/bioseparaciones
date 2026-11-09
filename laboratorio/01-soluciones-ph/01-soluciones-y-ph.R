# ==========================================================================
# P1. Preparacion de soluciones, filtracion y ajuste de pH
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 1. Soluciones y pH
#
# Descripcion: Se calcula la masa a pesar para cada solucion con masa = M * V * PM / pureza, y se calcula la relacion base/acido del amortiguador acetato con Henderson-Hasselbalch (pKa 4.76). Los datos de partida son las concentraciones y volumenes pedidos en la practica.
#
# Objetivos de aprendizaje:
#   - Calcular la masa a pesar con molaridad, volumen y pureza.
#   - Aplicar Henderson-Hasselbalch a un amortiguador acetato.
#   - Leer en la curva que relacion base/acido da cada pH.

# Datos: datos_preparaciones.csv (soluto, peso molecular, concentracion, volumen y pureza) y datos_amortiguador.csv (pH y relacion base/acido del amortiguador acetato).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Masa a pesar para cada solucion
# --------------------------------------------------------------------------
# masa (g) = concentracion (mol/L) * volumen (L) * peso molecular (g/mol)
#   / pureza (fraccion). La pureza corrige que el reactivo no es 100% puro.
datos <- read_csv("datos_preparaciones.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_g = concentracion_M * volumen_L *
           peso_molecular_g_mol / pureza)

print(datos)

# --------------------------------------------------------------------------
# 2. Amortiguador acetato: relacion base/acido contra pH
# --------------------------------------------------------------------------
# Henderson-Hasselbalch: pH = pKa + log10([base]/[acido]), pKa = 4.76.
# La relacion se calcula de cero: [base]/[acido] = 10^(pH - pKa).
pka <- 4.76

datos_am <- read_csv("datos_amortiguador.csv", show_col_types = FALSE)

datos_am <- datos_am %>%
  mutate(
    relacion_calculada = 10^(ph - pka),
    fraccion_base = relacion_calculada / (1 + relacion_calculada)
  )

print(datos_am)

# --------------------------------------------------------------------------
# 3. Grafica: relacion base/acido contra pH
# --------------------------------------------------------------------------
grafica <- ggplot(
  datos_am,
  aes(x = ph, y = relacion_calculada)
) +
  geom_vline(xintercept = pka, linetype = "dashed") +
  geom_hline(yintercept = 1, linetype = "dashed") +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  scale_y_log10() +
  labs(
    x = "pH",
    y = "Relacion [base]/[acido] (escala log)",
    title = "Amortiguador acetato: relacion base/acido contra pH (pKa 4.76)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
ggsave("01_amortiguador.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - La masa a pesar crece con la concentracion, el volumen y el peso molecular, y sube un poco al corregir por pureza.
# - En pH = pKa la relacion base/acido es 1; por debajo manda el acido y por encima manda la base.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La formula masa = M * V * PM / pureza resuelve cualquier preparacion de la practica.
# - Henderson-Hasselbalch dice que proporcion de base y acido mezclar para un pH objetivo.
