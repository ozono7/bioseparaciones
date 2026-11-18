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
# Descripcion: Practica 1 del laboratorio: la mesa de preparacion de soluciones y ajuste de pH. Aqui se calcula la masa a pesar para cada solucion con masa = M * V * PM / pureza, y se calcula la relacion base/acido del amortiguador acetato con Henderson-Hasselbalch (pKa 4.76). Los datos de partida son las concentraciones y volumenes pedidos en la practica. Lo que se aprende aqui es lo primero que se hace en cada practica que sigue: preparar bien las soluciones y dejar el pH donde lo pide el protocolo.
#
# Objetivos de aprendizaje:
#   - Calcular la masa a pesar con molaridad, volumen y pureza.
#   - Aplicar Henderson-Hasselbalch a un amortiguador acetato.
#   - Leer en la curva que relacion base/acido da cada pH.

# Datos: datos_preparaciones.csv (soluto, peso molecular, concentracion, volumen y pureza) y datos_amortiguador.csv (pH y relacion base/acido del amortiguador acetato).
# Desarrollo: empezamos en la primera practica del laboratorio, la mesa de preparacion. Primera parada: pesar cada reactivo con la balanza. Segunda parada: el amortiguador acetato y su curva contra pH. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Carpeta de trabajo: la del propio script
# --------------------------------------------------------------------------
# El script resuelve solo la carpeta donde esta guardado y la pone como
# carpeta de trabajo, asi los archivos de datos se leen por su nombre y la
# grafica se guarda en la misma carpeta, sin editar rutas.
# Primero prueba la ruta del documento activo en RStudio o Positron, luego
# la ruta del archivo al correr con Rscript o source(), y si nada de eso
# da una ruta, se queda en la carpeta de trabajo actual.
ruta_script <- NULL
if (requireNamespace("rstudioapi", quietly = TRUE) &&
    rstudioapi::isAvailable()) {
  ruta_script <- tryCatch(
    rstudioapi::getActiveDocumentContext()$path,
    error = function(e) NULL
  )
}
if (is.null(ruta_script) || !nzchar(ruta_script)) {
  ruta_script <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
}
# Con Rscript el archivo no deja marco en la pila, asi que su ruta viene
# en los argumentos de la linea de comandos (--file=...).
if (is.null(ruta_script) || !nzchar(ruta_script)) {
  archivo <- grep("--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(archivo) > 0) {
    ruta_script <- sub("--file=", "", archivo[1])
  }
}
if (!is.null(ruta_script) && nzchar(ruta_script)) {
  setwd(dirname(normalizePath(ruta_script, mustWork = FALSE)))
}

# Estilo de graficas: tema claro y legible, paleta apta para daltonicos
# (Okabe-Ito) y tamano de fuente base mayor, para que las graficas se
# lean bien en el reporte y en la presentacion.
paleta <- c("#0072B2", "#E69F00", "#009E73", "#CC79A7", "#56B4E9", "#D55E00")
tema <- theme_bw(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 15),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 1. Soluciones y pH)
# --------------------------------------------------------------------------
# En esta practica el trabajo es preparar soluciones, ajustar el pH y filtrar, con lo que se va a usar en las practicas que siguen. Las soluciones las indica el instructor (las soluciones para SDS-PAGE y el buffer de fosfatos).
# Paso 1. Preparacion de soluciones: se repasan molaridad, normalidad, porcentaje en peso, porcentaje en volumen y pureza de los reactivos, y se hacen los calculos para preparar las soluciones indicadas por el instructor.
# Paso 2. Ajuste de pH: se repasan los componentes y el funcionamiento del electrodo de pH, sus cuidados y su limpieza, la calibracion y el efecto de la temperatura. Cuando la molaridad debe ser precisa, el pH se ajusta con su acido o base conjugada; en los demas casos se ajusta con hidroxido de sodio o acido clorhidrico.
# Paso 3. Filtracion: el instructor revisa los componentes y el funcionamiento del sistema de filtracion y las membranas que se usan para filtrar solventes para cromatografia. Se practican filtraciones de agua y de las soluciones preparadas.
# Ecuacion de filtracion convencional (pregunta pre-laboratorio del manual): t/V = (mu * alfa * c / (2 * A^2 * deltaP)) * V + (mu * Rm / (A * deltaP)). t es el tiempo de filtracion, V el volumen filtrado, mu la viscosidad del liquido, alfa la resistencia especifica de la torta, c la concentracion de solidos, A el area de filtracion, deltaP la caida de presion y Rm la resistencia del medio filtrante. La grafica de t/V contra V es una recta: su pendiente da la resistencia de la torta y su ordenada la resistencia del medio.
# Preparacion de acetato de sodio 10 mM (pregunta pre-laboratorio del manual): la tabla de abajo ya trae ese ejemplo trabajado (acetato de sodio 10 mM, 250 mL); la masa sale de la formula de la Parada 1 y el pH se fija con su acido o base conjugada segun Henderson-Hasselbalch.
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

# Normalidad y porcentaje en peso (manual: molaridad, normalidad,
# porcentaje en peso y pureza). Normalidad N = molaridad * equivalentes
# por mol: para estas preparaciones acido-base se intercambia un
# equivalente por mol (NaCl, acetato de sodio, fosfato disodico como
# HPO4 2- / H2PO4 - y Tris). Porcentaje en peso/volumen: gramos de
# soluto por 100 mL de solucion.
datos <- datos %>%
  mutate(
    equivalentes_por_mol = 1,
    normalidad_N = concentracion_M * equivalentes_por_mol,
    porcentaje_p_v = masa_g / (volumen_L * 1000) * 100
  )

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
# Graficamos la relacion base/acido contra el pH en escala logaritmica: la zona sombreada es la zona amortiguadora (pKa +- 1), la linea punteada marca el pKa 4.76, donde la relacion es 1, y el texto trae la ecuacion de Henderson-Hasselbalch.
grafica <- ggplot(
  datos_am,
  aes(x = ph, y = relacion_calculada)
) +
  annotate("rect", xmin = pka - 1, xmax = pka + 1,
           ymin = -Inf, ymax = Inf, fill = paleta[3], alpha = 0.15) +
  annotate("text", x = pka, y = 8,
           label = "Zona amortiguadora\n(pKa +- 1)", size = 4.5,
           color = paleta[3]) +
  geom_vline(xintercept = pka, linetype = "dashed", color = "grey40") +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey40") +
  geom_line(linewidth = 1, color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  geom_point(aes(x = pka, y = 1), color = paleta[6], size = 4) +
  annotate("text", x = pka + 0.3, y = 1.4,
           label = "pKa 4.76, relacion = 1", hjust = 0, size = 4.5,
           color = paleta[6]) +
  annotate("text", x = min(datos_am$ph), y = 0.02,
           label = "pH = 4.76 + log10([base]/[acido])", hjust = 0,
           size = 4.5) +
  scale_y_log10() +
  labs(
    x = "pH",
    y = "Relacion [base]/[acido] (escala log)",
    title = "Amortiguador acetato: relacion base/acido contra pH (pKa 4.76)"
  ) +
  tema

print(grafica)

# --------------------------------------------------------------------------
# Parada 4. Efecto de la temperatura en la calibracion del pH-metro
# --------------------------------------------------------------------------
# El electrodo de pH sigue la ecuacion de Nernst: su pendiente es
# 2.303 * R * T / F. Al subir la temperatura sube la pendiente, por eso
# el manual pide revisar el efecto de la temperatura en la calibracion
# y calibrar a la temperatura de trabajo. R = 8.314 J/mol/K,
# F = 96485 C/mol, T en kelvin.
pendiente_nernst <- tibble(
  temperatura_C = c(20, 25, 30),
  temperatura_K = temperatura_C + 273.15
) %>%
  mutate(pendiente_mV_pH = 2.303 * 8.314 * temperatura_K / 96485 * 1000)

print(pendiente_nernst)

grafica_pendiente <- ggplot(
  pendiente_nernst,
  aes(x = temperatura_C, y = pendiente_mV_pH)
) +
  geom_vline(xintercept = 25, linetype = "dashed", color = "grey40") +
  annotate("text", x = 25.5, y = 58.5,
           label = "25 C, temperatura de trabajo", hjust = 0, size = 4.5) +
  geom_line(linewidth = 1, color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  geom_text(aes(label = paste0(round(pendiente_mV_pH, 2), " mV/pH")),
            nudge_y = 0.5, size = 4.5) +
  annotate("text", x = 20, y = 60.3,
           label = "Pendiente = 2.303 * R * T / F", hjust = 0, size = 4.5) +
  labs(
    x = "Temperatura (C)",
    y = "Pendiente de Nernst (mV/pH)",
    title = "pH-metro: pendiente de Nernst contra temperatura"
  ) +
  tema

print(grafica_pendiente)

ggsave("01_pendiente_nernst.png", grafica_pendiente,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# 5. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la mesa de preparacion guardamos la grafica de la practica.
ggsave("01_amortiguador.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (pendiente de Nernst contra temperatura): el eje x es la temperatura en C y el eje y es la pendiente en mV/pH; cada punto trae su valor y la linea punteada es 25 C, la temperatura de trabajo.
# - La pendiente sube con la temperatura: 58.17 mV/pH a 20 C, 59.16 mV/pH a 25 C y 60.15 mV/pH a 30 C. Esto significa que un pH-metro calibrado a una temperatura mide mal a otra, y por eso se calibra a la temperatura de trabajo.
# Grafica (relacion base/acido contra pH): el eje x es el pH (adimensional) y el eje y es la relacion [base]/[acido] en escala log (adimensional); la zona sombreada es la zona amortiguadora (pKa +- 1) y el punto marcado es el pKa, donde la relacion es 1.
# - La masa a pesar crece con la concentracion, el volumen y el peso molecular, y sube un poco al corregir por pureza. Esto significa que olvidar la pureza deja la solucion un poco diluida, y por eso lo siguiente en cada practica es pesar con la formula completa.
# - En pH = pKa la relacion base/acido es 1; por debajo manda el acido y por encima manda la base. Esto significa que el pKa es el centro del amortiguador, y alrededor de el es donde el amortiguador resiste mejor los cambios de pH.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La formula masa = M * V * PM / pureza resuelve cualquier preparacion de la practica.
# - Henderson-Hasselbalch dice que proporcion de base y acido mezclar para un pH objetivo.
# - Los errores sistematicos desvian siempre en el mismo sentido (por ejemplo, una balanza mal calibrada) y se corrigen calibrando; los errores al azar varian en cada medida y se reducen repitiendo y promediando.
# Terminamos la practica en la mesa de preparacion: ya sabemos pesar cada reactivo y mezclar el amortiguador al pH pedido. Seguimos a la siguiente practica: el gel de SDS-PAGE, donde se mide el peso molecular de la proteina.
