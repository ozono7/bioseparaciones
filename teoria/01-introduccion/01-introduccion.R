# ==========================================================================
# 01. Introduccion: difusividad molecular y carga neta contra pH
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 1. Introduccion
#
# Descripcion: Recorrido por la planta, primera parada: el area de caracterizacion de la materia prima, antes de que el proceso empiece. Aqui miramos las proteinas que van a entrar a la linea: primero medimos que tan rapido difunde cada una con la ecuacion de Stokes-Einstein a partir de su radio hidrodinamico medido, y despues vemos como cambia la carga neta de la albumina con el pH alrededor de su punto isoelectrico (pI 4.7). Lo que se aprende aqui decide lo que pasa despues: la difusividad manda en la transferencia de masa, y la carga manda en la adsorcion y en la precipitacion.
#
# Objetivos de aprendizaje:
#   - Calcular la difusividad con Stokes-Einstein a partir de datos medidos.
#   - Relacionar el radio hidrodinamico con la velocidad de difusion.
#   - Leer el punto isoelectrico en una curva de carga neta contra pH.

# Datos: datos_difusividad.csv (radio hidrodinamico medido) y datos_carga_ph.csv (carga neta de albumina contra pH).
# Recorrido: entramos a la planta por el area de caracterizacion. Primera parada: la mesa donde se mide el radio hidrodinamico de cada proteina. Segunda parada: la curva de carga neta de la albumina contra pH. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir al siguiente equipo.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Parada 1. Difusividad molecular (Stokes-Einstein)
# --------------------------------------------------------------------------
# Llegamos a la mesa de caracterizacion y lo primero que medimos es el radio hidrodinamico de cada proteina. Con ese radio calculamos que tan rapido difunde cada una: esa velocidad es la que despues limita que tan rapido una proteina llega a una superficie o atraviesa una membrana.
# D = k_B * T / (6 * pi * eta * r)
# k_B = 1.380649e-23 J/K, T = 298.15 K (25 C), eta = 0.00089 Pa s (agua a 25 C).
# El radio r viene del CSV, en nm; se convierte a m antes de calcular.
datos_d <- read_csv("datos_difusividad.csv", show_col_types = FALSE)

k_b <- 1.380649e-23
temperatura_k <- 298.15
viscosidad <- 0.00089

datos_d <- datos_d %>%
  mutate(
    radio_m = radio_nm * 1e-9,
    difusividad_m2_s = k_b * temperatura_k / (6 * pi * viscosidad * radio_m),
    difusividad_um2_s = difusividad_m2_s * 1e12
  )

print(datos_d)

# --------------------------------------------------------------------------
# Parada 2. Carga neta contra pH y punto isoelectrico
# --------------------------------------------------------------------------
# Seguimos a la siguiente mesa, donde se mide la carga de la albumina a distintos pH. Aqui buscamos el pH donde la carga se hace cero: ese es el punto isoelectrico, y nos dice a que pH la proteina deja de repelerse a si misma y se puede precipitar, y que intercambiador ionico la retiene.
datos_ph <- read_csv("datos_carga_ph.csv", show_col_types = FALSE)

# El pI es el pH donde la carga neta cruza cero. Se interpola entre los
# dos puntos que cambian de signo.
puntos_cruce <- datos_ph %>%
  mutate(signo = sign(carga_neta)) %>%
  filter(signo != lag(signo, default = first(signo)) | carga_neta == 0)
print(puntos_cruce)

# --------------------------------------------------------------------------
# Parada 3. Grafica 1: difusividad contra radio hidrodinamico
# --------------------------------------------------------------------------
# Ahora graficamos lo medido en la primera parada para ver el patron de un vistazo: cada punto es una proteina y su nombre esta escrito junto a el.
grafica_d <- ggplot(datos_d, aes(x = radio_nm, y = difusividad_um2_s)) +
  geom_point(size = 3) +
  geom_text(aes(label = proteina), vjust = -1, size = 3.5) +
  labs(
    x = "Radio hidrodinamico (nm)",
    y = "Difusividad (um2/s)",
    title = "Difusividad molecular (Stokes-Einstein, 25 C)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_d)

# --------------------------------------------------------------------------
# Parada 4. Grafica 2: carga neta de la albumina contra pH
# --------------------------------------------------------------------------
# Seguimos a la grafica de la segunda parada: la curva de carga contra pH, con la linea de carga cero y el pI 4.7 marcados. Aqui se lee directo el punto isoelectrico.
grafica_ph <- ggplot(datos_ph, aes(x = ph, y = carga_neta)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 4.7, linetype = "dashed") +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "pH",
    y = "Carga neta (unidades de carga)",
    title = "Carga neta de la albumina contra pH (pI = 4.7)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_ph)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir del area de caracterizacion guardamos las dos graficas del recorrido, para llevarlas a la siguiente parada.
ggsave("01_difusividad.png", grafica_d,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("01_carga_ph.png", grafica_ph,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (difusividad contra radio): el eje x es el radio hidrodinamico en nm y el eje y es la difusividad en um2/s. Cada punto es una proteina.
# - La difusividad disminuye al aumentar el radio: la ferritina difunde cerca de tres veces mas lento que la lisozima. Esto significa que las proteinas grandes tardan mas en llegar a donde tienen que actuar, y por eso lo siguiente en la linea es trabajar con tiempos de contacto suficientes.
# Grafica 2 (carga neta contra pH): el eje x es el pH (adimensional) y el eje y es la carga neta en unidades de carga.
# - La carga neta de la albumina es positiva por debajo del pI, cero en pH 4.7 y negativa por encima; el signo de la carga decide que intercambiador ionico retiene a la proteina. Esto significa que con el pH elegimos si la albumina se queda pegada o pasa de largo, y por eso el pH es la primera palanca que se ajusta en las paradas que siguen.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La ecuacion de Stokes-Einstein convierte un radio medido en una difusividad, sin suponer el valor final.
# - El punto isoelectrico se lee donde la curva de carga cruza cero, y explica por que el pH controla la adsorcion y la precipitacion.
# Terminamos el recorrido en el area de caracterizacion: ya sabemos que tan rapido se mueve cada proteina y a que pH la albumina queda sin carga. Con eso en la mano seguimos a la siguiente parada de la linea: el tanque de precipitacion.
