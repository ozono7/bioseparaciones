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
# Descripcion: Practica 6 del laboratorio: el equipo FPLC (BioLogic LP). Aqui se reconstruye el registro del equipo durante la carga de niquel y el equilibrio de la columna: absorbancia a 280 nm y conductividad contra tiempo, con flujo de 0.5 mL/min. El volumen acumulado se calcula de cero como flujo por tiempo, y cada fase del protocolo se identifica en el registro. Lo que se aprende aqui es a leer el registro del equipo: que detector sigue a la proteina y cual sigue a las sales, y donde empieza cada fase.
#
# Objetivos de aprendizaje:
#   - Identificar cada fase del protocolo en el registro del FPLC.
#   - Calcular el volumen acumulado a partir del flujo y el tiempo.
#   - Leer la conductividad como senal del cambio de buffer.

# Datos: datos_fplc.csv (absorbancia a 280 nm y conductividad registradas contra tiempo; flujo 0.5 mL/min).
# Desarrollo: llegamos al equipo FPLC, con su modulo de mezclado, sus detectores y su colector de fracciones. Primera parada: el registro completo con el volumen acumulado calculado de cero. Segunda y tercera parada: las graficas de absorbancia y de conductividad contra volumen. En cada parada leemos el registro y comentamos que significa antes de seguir.
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
# Protocolo (Manual de Practicas, Practica 6. FPLC, BioLogic LP)
# --------------------------------------------------------------------------
# El equipo BioLogic LP tiene: modulo/valvula de mezclado que proporciona dos buffers para la fase movil; detector UV con lampara de mercurio y filtros para 280 nm y 254 nm; detector de conductividad para monitorear gradientes de sales en linea; colector de fracciones controlado por el sistema electronico; y controlador que registra conductividad y UV y controla start/stop, flujo, seleccion de buffer y protocolos.
# Buffers y soluciones (manual): buffer de adsorcion (fosfato 20 mM, NaCl 500 mM, pH 7.0, filtrado); buffer de desorcion (fosfato 20 mM, NaCl 500 mM, pH 4.0, filtrado); agua filtrada; sulfato de niquel (20 mM, filtrado); solucion acida (HCl 0.1 M, filtrado).
# Paso 1. El instructor senala las partes del equipo e indica el proceso de instalacion de una columna y el encendido general de los sistemas, asi como las partes de los graficos que se registran en el software.
# Paso 2. Con la columna conectada, alimentar agua por 5 min a un flujo de 0.5 mL/min.
# Paso 3. Detener la bomba y sustituir la alimentacion por la solucion de sulfato de niquel. Arrancar la bomba y alimentar el sulfato de niquel al mismo flujo hasta que el frente verde alcance la parte superior de la columna.
# Paso 4. Detener la bomba y sustituir la alimentacion por agua. Arrancar la bomba y lavar por 10 min.
# Paso 5. Detener la bomba y sustituir la alimentacion por el buffer de adsorcion. Arrancar la bomba y alimentar el buffer de adsorcion por 10 min o hasta que el pH de la solucion que sale de la columna sea 7.0 (verificarlo con papel pH).
# Paso 6. Detener la bomba y sustituir la alimentacion por la solucion acida, hasta que la coloracion azul de la columna desaparezca.
# Paso 7. Detener la bomba y alimentar agua hasta que el pH de la solucion de salida de la columna sea neutro.
# Paso 8. Apagar el equipo y guardar el archivo del grafico obtenido en el software.
# En esta practica todavia no se carga proteina: el registro es el de la preparacion de la columna (lavado, carga de niquel, equilibrio y lavado acido), con flujo de 0.5 mL/min durante 40 min y 20.0 mL acumulados.
# Sesiones (manual): la practica ocupa dos semanas (12-23 de octubre). Sesion 1: instalacion de la columna, encendido del equipo y corrida de preparacion. Sesion 2: lectura del registro, senalamiento de las partes del grafico y conclusiones.
# El detector UV tiene filtros para 280 nm y 254 nm; en esta practica se usa 280 nm, donde absorben las proteinas por sus residuos aromaticos.
# Seguridad y reglas (manual): seguir las indicaciones del instructor para instalar la columna y encender el equipo; verificar el pH de salida con papel pH; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Leer el registro y calcular el volumen acumulado
# --------------------------------------------------------------------------
# Estamos frente al FPLC mientras corre el protocolo de preparacion de la columna. Leemos el registro de absorbancia y conductividad contra tiempo y calculamos el volumen acumulado como flujo por tiempo, para ubicar cada fase en el cromatograma.
# Flujo del protocolo: 0.5 mL/min. Volumen acumulado = flujo * tiempo.
flujo_ml_min <- 0.5

datos <- read_csv("datos_fplc.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(volumen_ml = flujo_ml_min * tiempo_min)

print(datos)

# Volumen total pasado por la columna en el registro.
print(tibble(volumen_total_ml = max(datos$volumen_ml)))

# Limites entre fases (post-laboratorio 1: senalar las partes del grafico).
# La fase "Lavado con agua" aparece dos veces, asi que los tramos se
# separan por cambios consecutivos y no por el nombre de la fase. El
# limite entre dos tramos es el punto medio entre el ultimo volumen de
# un tramo y el primero del siguiente.
datos <- datos %>%
  mutate(tramo = cumsum(fase != lag(fase, default = first(fase))))

limites_fase <- datos %>%
  group_by(tramo, fase) %>%
  summarise(inicio_ml = min(volumen_ml), fin_ml = max(volumen_ml),
            .groups = "drop") %>%
  arrange(inicio_ml) %>%
  mutate(limite_ml = (fin_ml + lead(inicio_ml)) / 2) %>%
  filter(!is.na(limite_ml))

print(limites_fase)

# Aqui resumimos la conductividad y la absorbancia medias por fase: ese resumen dice que solucion estaba pasando en cada tramo del registro.
# Conductividad media por fase.
print(datos %>%
        group_by(fase) %>%
        summarise(conductividad_media = mean(conductividad_mS_cm),
                  absorbancia_280_media = mean(absorbancia_280),
                  .groups = "drop"))

# Bandas de cada tramo del protocolo (para sombrear las fases en las
# graficas): el inicio y el fin de cada tramo en volumen acumulado.
bandas_fase <- datos %>%
  group_by(tramo, fase) %>%
  summarise(inicio_ml = min(volumen_ml), fin_ml = max(volumen_ml),
            .groups = "drop") %>%
  arrange(inicio_ml)

# --------------------------------------------------------------------------
# Parada 2. Grafica 1: absorbancia a 280 nm contra volumen
# --------------------------------------------------------------------------
# Graficamos la absorbancia a 280 nm contra el volumen acumulado, con cada fase en un color y sombreada en su tramo: asi se ve si pasa proteina por el detector en la preparacion.
grafica_uv <- ggplot(
  datos,
  aes(x = volumen_ml, y = absorbancia_280, color = fase)
) +
  geom_rect(data = bandas_fase,
            aes(xmin = inicio_ml, xmax = fin_ml,
                ymin = -Inf, ymax = Inf, fill = fase),
            alpha = 0.10, inherit.aes = FALSE) +
  geom_vline(data = limites_fase, aes(xintercept = limite_ml),
             linetype = "dashed", color = "grey40") +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = paleta) +
  scale_fill_manual(values = paleta) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Absorbancia a 280 nm",
    color = "Fase",
    fill = "Fase",
    title = "FPLC: absorbancia a 280 nm durante la preparacion",
    subtitle = "Cada tramo sombreado es una fase; las lineas punteadas marcan los limites"
  ) +
  tema

print(grafica_uv)

# --------------------------------------------------------------------------
# Parada 3. Grafica 2: conductividad contra volumen
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la conductividad contra el volumen acumulado, con cada fase en un color y sombreada en su tramo. Aqui se ve cada cambio de solucion del protocolo.
grafica_cond <- ggplot(
  datos,
  aes(x = volumen_ml, y = conductividad_mS_cm, color = fase)
) +
  geom_rect(data = bandas_fase,
            aes(xmin = inicio_ml, xmax = fin_ml,
                ymin = -Inf, ymax = Inf, fill = fase),
            alpha = 0.10, inherit.aes = FALSE) +
  geom_vline(data = limites_fase, aes(xintercept = limite_ml),
             linetype = "dashed", color = "grey40") +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = paleta) +
  scale_fill_manual(values = paleta) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Conductividad (mS/cm)",
    color = "Fase",
    fill = "Fase",
    title = "FPLC: conductividad durante la preparacion",
    subtitle = "Cada tramo sombreado es una fase; las lineas punteadas marcan los limites"
  ) +
  tema

print(grafica_cond)

# --------------------------------------------------------------------------
# 4. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir del equipo FPLC guardamos las dos graficas de la practica.
ggsave("06_fplc_uv.png", grafica_uv,
       width = 20, height = 12, units = "cm", dpi = 300)
ggsave("06_fplc_conductividad.png", grafica_cond,
       width = 20, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (absorbancia a 280 nm contra volumen): el eje x es el volumen acumulado en mL y el eje y es la absorbancia a 280 nm (adimensional); cada tramo sombreado es una fase del protocolo.
# - La absorbancia a 280 nm se mantiene en la linea base: en esta practica todavia no se carga proteina. Esto significa que el detector UV no ve proteina durante la preparacion, y por eso lo siguiente, en la practica de IMAC, es cargar la albumina y ver su pico.
# Grafica 2 (conductividad contra volumen): el eje x es el volumen acumulado en mL y el eje y es la conductividad en mS/cm; cada tramo sombreado es una fase del protocolo.
# - La conductividad marca cada cambio de solucion: sube con la llegada del niquel y del buffer de adsorcion con 500 mM NaCl, y cambia de nuevo con el acido. Esto significa que el detector de conductividad sigue a las sales del buffer, y con el se sabe en que fase del protocolo esta la columna en cada momento.
# - Las lineas punteadas marcan los limites entre fases (2.5, 4.5, 9.5, 14.5 y 17.5 mL): a la izquierda de cada linea esta la solucion anterior y a la derecha la siguiente. Esto significa que cada tramo del registro corresponde a un paso del protocolo y se lee en orden.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El detector UV sigue a la proteina y el de conductividad sigue a las sales del buffer.
# - El volumen acumulado sale del flujo por el tiempo y permite ubicar cada fase en el cromatograma.
# Terminamos la practica en el equipo FPLC: ya sabemos leer su registro y preparar la columna. Seguimos a la siguiente practica: la columna de IMAC con niquel, donde la albumina se retiene y se desorbe.
