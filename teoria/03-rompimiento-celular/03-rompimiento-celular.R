# ==========================================================================
# 03. Rompimiento celular: liberacion de proteina por pasadas
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 3. Rompimiento celular
#
# Descripcion: Recorrido por la planta, tercera parada: el area de rompimiento celular, con el molino de perlas y el homogeneizador. Aqui se compara la liberacion de proteina soluble en los dos equipos al aumentar el numero de pasadas. El modelo es de primer orden: la fraccion liberada crece como 1 - exp(-k * N), y la constante k de cada metodo se calcula por regresion a partir de los datos, con la proteina total medida en 8.0 mg/mL. Lo que se aprende aqui dice cuantas pasadas necesita cada equipo para liberar la proteina.
#
# Objetivos de aprendizaje:
#   - Comparar dos metodos mecanicos de rompimiento con el mismo modelo.
#   - Calcular la constante de rompimiento k por regresion.
#   - Leer en la curva cuantas pasadas hacen falta para liberar el 90%.

# Datos: datos_rompimiento.csv (proteina liberada medida, 3 replicas por numero de pasadas y metodo; proteina total 8.0 mg/mL).
# Recorrido: llegamos al area de rompimiento celular con el caldo de celulas enteras. Primera parada: resumir la proteina liberada por metodo y por pasadas. Segunda parada: calcular la constante k de cada equipo y las pasadas para liberar el 90%. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Parada 1. Leer los datos y resumir por metodo y pasadas
# --------------------------------------------------------------------------
# Estamos frente al molino de perlas y al homogeneizador. Tomamos muestras despues de cada pasada y resumimos la proteina liberada: la fraccion liberada se calcula contra la proteina total medida de 8.0 mg/mL.
datos <- read_csv("datos_rompimiento.csv", show_col_types = FALSE)

proteina_total <- 8.0

resumen <- datos %>%
  group_by(metodo, pasadas) %>%
  summarise(
    liberada_media = mean(proteina_liberada_mg_ml),
    de = sd(proteina_liberada_mg_ml),
    .groups = "drop"
  ) %>%
  mutate(fraccion_liberada = liberada_media / proteina_total)

print(resumen)

# --------------------------------------------------------------------------
# Parada 2. Constante de rompimiento k por metodo
# --------------------------------------------------------------------------
# Seguimos en el area de rompimiento: ahora calculamos la constante k de cada equipo con el modelo de primer orden. La k dice que tan rapido rompe cada equipo por pasada, y con ella se calcula el numero de pasadas para liberar el 90%.
# Modelo de primer orden: R = Rmax * (1 - exp(-k * N)).
# Con Rmax = proteina total: ln(1 - R/Rmax) = -k * N. La pendiente de
# esa recta contra N es -k. Se excluye N = 0 (logaritmo de cero).
ajuste_k <- resumen %>%
  filter(pasadas > 0, fraccion_liberada < 1) %>%
  mutate(y = log(1 - fraccion_liberada)) %>%
  group_by(metodo) %>%
  summarise(
    k_por_pasada = -coef(lm(y ~ pasadas - 1))[["pasadas"]],
    .groups = "drop"
  )

print(ajuste_k)

# Pasadas para liberar el 90% con cada k: N90 = -ln(0.1) / k.
tabla_n90 <- ajuste_k %>%
  mutate(pasadas_90_porciento = -log(0.1) / k_por_pasada)
print(tabla_n90)

# --------------------------------------------------------------------------
# Parada 3. Grafica: proteina liberada contra pasadas
# --------------------------------------------------------------------------
# Graficamos lo que pasa en los dos equipos: cada curva es un metodo y la linea punteada marca la proteina total de 8.0 mg/mL, el techo que no se puede pasar.
grafica <- ggplot(
  resumen,
  aes(x = pasadas, y = liberada_media, color = metodo, group = metodo)
) +
  geom_errorbar(aes(ymin = liberada_media - de,
                    ymax = liberada_media + de),
                width = 0.15, linewidth = 0.6) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  geom_hline(yintercept = proteina_total, linetype = "dashed") +
  labs(
    x = "Numero de pasadas",
    y = "Proteina liberada (mg/mL)",
    color = "Metodo",
    title = "Rompimiento celular: proteina liberada por pasadas"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir del area de rompimiento guardamos la grafica del recorrido.
ggsave("03_rompimiento.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (proteina liberada contra pasadas): el eje x es el numero de pasadas (adimensional) y el eje y es la proteina liberada en mg/mL; cada color es un metodo.
# - El molino de perlas libera proteina mas rapido por pasada que el homogeneizador: su curva sube antes y se acerca antes al total. Esto significa que el molino necesita menos pasadas para el mismo resultado, y por eso lo siguiente es llevar el lisado al tanque de precipitacion con menos tiempo de proceso.
# - Ambas curvas se aplanan cerca de 8.0 mg/mL, la proteina total medida: pasadas extra despues del aplanamiento aportan poco. Esto significa que seguir pasando el material gasta energia y tiempo sin liberar mas proteina.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El modelo de primer orden convierte pasadas en una constante k comparable entre equipos.
# - Con k se calcula el numero de pasadas para liberar una fraccion dada, que es el dato que pide el diseno del equipo.
# Terminamos el recorrido en el area de rompimiento celular: ya sabemos que equipo rompe mas rapido y cuantas pasadas hacen falta. Seguimos a la siguiente parada de la linea: la centrifuga, donde se separan los restos celulares del lisado.
