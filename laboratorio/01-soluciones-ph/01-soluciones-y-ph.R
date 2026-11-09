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
# Descripcion: Recorrido por el laboratorio de la planta, estacion 1: la mesa de preparacion de soluciones y ajuste de pH. Aqui se calcula la masa a pesar para cada solucion con masa = M * V * PM / pureza, y se calcula la relacion base/acido del amortiguador acetato con Henderson-Hasselbalch (pKa 4.76). Los datos de partida son las concentraciones y volumenes pedidos en la practica. Lo que se aprende aqui es lo primero que se hace en cada estacion que sigue: preparar bien las soluciones y dejar el pH donde lo pide el protocolo.
#
# Objetivos de aprendizaje:
#   - Calcular la masa a pesar con molaridad, volumen y pureza.
#   - Aplicar Henderson-Hasselbalch a un amortiguador acetato.
#   - Leer en la curva que relacion base/acido da cada pH.

# Datos: datos_preparaciones.csv (soluto, peso molecular, concentracion, volumen y pureza) y datos_amortiguador.csv (pH y relacion base/acido del amortiguador acetato).
# Recorrido: llegamos a la primera estacion del laboratorio, la mesa de preparacion. Primera parada: pesar cada reactivo con la balanza. Segunda parada: el amortiguador acetato y su curva contra pH. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 1. Soluciones y pH)
# --------------------------------------------------------------------------
# En esta estacion el trabajo es preparar soluciones, ajustar el pH y filtrar, con lo que se va a usar en las practicas que siguen. Las soluciones las indica el instructor (las soluciones para SDS-PAGE y el buffer de fosfatos).
# Paso 1. Preparacion de soluciones: se repasan molaridad, normalidad, porcentaje en peso, porcentaje en volumen y pureza de los reactivos, y se hacen los calculos para preparar las soluciones indicadas por el instructor.
# Paso 2. Ajuste de pH: se repasan los componentes y el funcionamiento del electrodo de pH, sus cuidados y su limpieza, la calibracion y el efecto de la temperatura. Cuando la molaridad debe ser precisa, el pH se ajusta con su acido o base conjugada; en los demas casos se ajusta con hidroxido de sodio o acido clorhidrico.
# Paso 3. Filtracion: el instructor revisa los componentes y el funcionamiento del sistema de filtracion y las membranas que se usan para filtrar solventes para cromatografia. Se practican filtraciones de agua y de las soluciones preparadas.
# Seguridad y reglas (manual): bata blanca de laboratorio obligatoria; cubrebocas y guantes cuando se indique; cuestionario pre-laboratorio entregado antes de empezar; limpiar la mesa de trabajo antes y despues de la practica; no fumar ni consumir alimentos o bebidas en el laboratorio.

# --------------------------------------------------------------------------
# Parada 1. Masa a pesar para cada solucion
# --------------------------------------------------------------------------
# Estamos en la mesa de preparacion con la balanza y los reactivos. Para cada solucion calculamos la masa a pesar con molaridad, volumen, peso molecular y pureza: la pureza corrige que el reactivo no es 100% puro.
# masa (g) = concentracion (mol/L) * volumen (L) * peso molecular (g/mol)
#   / pureza (fraccion). La pureza corrige que el reactivo no es 100% puro.
datos <- read_csv("datos_preparaciones.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_g = concentracion_M * volumen_L *
           peso_molecular_g_mol / pureza)

print(datos)

# --------------------------------------------------------------------------
# Parada 2. Amortiguador acetato: relacion base/acido contra pH
# --------------------------------------------------------------------------
# Seguimos en la mesa de preparacion: ahora armamos el amortiguador acetato. Con Henderson-Hasselbalch calculamos que relacion base/acido da cada pH, para mezclar el amortiguador al pH que pide el protocolo.
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
# Parada 3. Grafica: relacion base/acido contra pH
# --------------------------------------------------------------------------
# Graficamos la relacion base/acido contra el pH en escala logaritmica: la linea punteada marca el pKa 4.76, donde la relacion es 1.
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
# Antes de salir de la mesa de preparacion guardamos la grafica del recorrido.
ggsave("01_amortiguador.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (relacion base/acido contra pH): el eje x es el pH (adimensional) y el eje y es la relacion [base]/[acido] en escala log (adimensional).
# - La masa a pesar crece con la concentracion, el volumen y el peso molecular, y sube un poco al corregir por pureza. Esto significa que olvidar la pureza deja la solucion un poco diluida, y por eso lo siguiente en cada estacion es pesar con la formula completa.
# - En pH = pKa la relacion base/acido es 1; por debajo manda el acido y por encima manda la base. Esto significa que el pKa es el centro del amortiguador, y alrededor de el es donde el amortiguador resiste mejor los cambios de pH.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La formula masa = M * V * PM / pureza resuelve cualquier preparacion de la practica.
# - Henderson-Hasselbalch dice que proporcion de base y acido mezclar para un pH objetivo.
# Terminamos el recorrido en la mesa de preparacion: ya sabemos pesar cada reactivo y mezclar el amortiguador al pH pedido. Seguimos a la siguiente estacion del laboratorio: el gel de SDS-PAGE, donde se mide el peso molecular de la proteina.
