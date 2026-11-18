# ==========================================================================
# P5. Precipitacion de albumina con acetona
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 5. Acetona
#
# Descripcion: Practica 5 del laboratorio: la mesa de precipitacion con acetona, con el solvente frio. Aqui se mide por Bradford la albumina resuspendida de cada tubo: la absorbancia a 595 nm es la medicion y la concentracion sale de la curva de calibracion, con una dilucion 1:2 que deja la lectura dentro de la curva. El porcentaje recuperado es la concentracion medida entre la concentracion inicial del tubo. Se compara la recuperacion entre temperaturas y se grafica el porcentaje recuperado contra la temperatura del solvente, por concentracion inicial. Lo que se aprende aqui dice a que temperatura conviene precipitar con acetona para recuperar mas proteina.
#
# Objetivos de aprendizaje:
#   - Convertir la absorbancia a 595 nm en concentracion con la curva de Bradford.
#   - Calcular el porcentaje de proteina recuperada por condicion.
#   - Comparar la recuperacion a -20, 4 y 25 C.
#   - Relacionar la temperatura baja con menor desnaturalizacion.

# Datos: datos_acetona.csv (estandares de Bradford y muestras resuspendidas con su absorbancia a 595 nm y su factor de dilucion; 3 replicas por temperatura y concentracion inicial).
# Desarrollo: llegamos a la mesa de precipitacion con acetona, con el congelador a -20 C al lado. Primera parada: la curva de Bradford y la conversion de la absorbancia a concentracion. Segunda parada: resumir la recuperacion por temperatura y por concentracion inicial. Tercera parada: la grafica de recuperacion contra temperatura, por concentracion inicial. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
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
# Protocolo (Manual de Practicas, Practica 5. Acetona)
# --------------------------------------------------------------------------
# Paso 1. En 4 tubos de centrifuga diluir la solucion de albumina (100 ug/mL) con el buffer de fosfato para obtener 10 ug/mL en un volumen final de 200 uL.
# Paso 2. Repetir lo anterior para obtener 4 tubos con 20 ug/mL y 4 mas con 30 ug/mL. En total son 12 tubos: 4 por concentracion.
# Paso 3. A 3 tubos (uno de cada concentracion) adicionar 800 uL de acetona a -20 C, agregando de 200 uL en 200 uL. Mezclar los tubos.
# Paso 4. Repetir lo anterior con acetona a 4 C y a 25 C, en 3 tubos con distintas concentraciones cada vez.
# Paso 5. Incubar los tubos 45 min a la temperatura correspondiente. Mantener los 3 tubos restantes a 25 C (a los que no se les adiciono acetona) como controles.
# Paso 6. Sedimentar el precipitado centrifugando los tubos a 15000g por 5 min a 4 C.
# Paso 7. Retirar el sobrenadante con mucho cuidado, sin perturbar el precipitado, y colocar el sobrenadante de todos los tubos en un mismo recipiente.
# Paso 8. Secar el precipitado 5 min a temperatura ambiente invirtiendo los tubos sobre una toalla de papel, sin perturbar el precipitado.
# Paso 9. Resuspender el precipitado de cada tubo en 200 uL de buffer de fosfato agitando suavemente. Cuantificar la concentracion de albumina en los 12 tubos (Bradford) y determinar el porcentaje de proteina recuperada en solucion para los tubos tratados con acetona. Centrifugar los tubos para separar la solucion del material que no se haya disuelto; diluir la muestra si hace falta.
# Nota: el manual trabaja con 12 tubos en total (uno por condicion) y los 3 tubos sin acetona son los controles a 25 C; los porcentajes se resumen por temperatura y concentracion a partir de las 3 replicas del CSV.
# Sesiones (manual): la practica ocupa dos semanas. Sesion 1: precipitacion, incubacion de 45 min, centrifugacion y secado del precipitado. Sesion 2: resuspension en buffer, cuantificacion por Bradford, porcentaje recuperado y grafica.
# Controles: los 3 tubos sin acetona a 25 C son la referencia del 100% (sin precipitacion no hay perdida); el porcentaje recuperado se calcula contra la concentracion inicial de cada tubo.
# Principio (manual): el solvente organico debe ser miscible con el agua (etanol y acetona son los mas comunes) y baja la constante dielectrica del medio, lo que reduce la solubilidad de la proteina y la precipita. Se trabaja en frio para reducir la desnaturalizacion por la interaccion con el solvente, de modo que la proteina precipitada se pueda redisolver en solvente acuoso.
# Seguridad y reglas (manual): adicionar el solvente lentamente, en porciones de 200 uL; no perturbar el precipitado al retirar el sobrenadante ni al secar; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Curva de Bradford y conversion de la absorbancia a concentracion
# --------------------------------------------------------------------------
# La albumina resuspendida de cada tubo se mide por Bradford: la absorbancia
# a 595 nm es la medicion y la concentracion sale de la curva de calibracion.
# El CSV trae los estandares de Bradford (0, 2.5, 5, 10 y 20 ug/mL, por
# triplicado, los mismos valores de la practica 3) y las muestras con su
# absorbancia y su factor de dilucion. Ajustamos la recta y el polinomio a
# los estandares y convertimos cada absorbancia en concentracion con la recta.
# Dilucion: la concentracion resuspendida llega hasta unos 27 ug/mL (30 ug/mL
# inicial con alrededor de 90% recuperado), por encima del estandar mas alto
# (20 ug/mL), asi que todas las muestras se diluyen 1:2 para leerlas dentro
# de la curva. El porcentaje recuperado es la concentracion medida entre la
# concentracion inicial del tubo, por 100.
datos <- read_csv("datos_acetona.csv", show_col_types = FALSE)

estandares <- filter(datos, tipo == "estandar")
ajuste_lineal <- lm(absorbancia_595 ~ concentracion_ug_ml, data = estandares)
ajuste_poli <- lm(absorbancia_595 ~ concentracion_ug_ml +
                    I(concentracion_ug_ml^2), data = estandares)
print(tibble(
  modelo = c("Lineal", "Polinomial grado 2"),
  r_cuadrado = c(summary(ajuste_lineal)$r.squared,
                 summary(ajuste_poli)$r.squared)
))

muestras <- filter(datos, tipo == "muestra") %>%
  mutate(
    concentracion_diluida_ug_ml =
      (absorbancia_595 - coef(ajuste_lineal)[["(Intercept)"]]) /
      coef(ajuste_lineal)[["concentracion_ug_ml"]],
    concentracion_recuperada_ug_ml =
      concentracion_diluida_ug_ml * factor_dilucion,
    porcentaje_recuperado =
      concentracion_recuperada_ug_ml / concentracion_inicial_ug_ml * 100
  )
print(muestras %>%
        select(temperatura_C, concentracion_inicial_ug_ml, replica,
               absorbancia_595, factor_dilucion,
               concentracion_recuperada_ug_ml, porcentaje_recuperado))

datos <- muestras

# --------------------------------------------------------------------------
# Parada 2. Resumen por temperatura y concentracion
# --------------------------------------------------------------------------
# Estamos en la mesa con la acetona a tres temperaturas. Precipitamos la albumina, la redisolvemos y medimos por Bradford cuanta se recupero: resumimos el porcentaje por temperatura y por concentracion inicial, y despues la media por temperatura.

resumen <- datos %>%
  group_by(temperatura_C, concentracion_inicial_ug_ml) %>%
  summarise(
    recuperacion_media = mean(porcentaje_recuperado),
    de = sd(porcentaje_recuperado),
    .groups = "drop"
  )

print(resumen)

# Recuperacion media por temperatura (todas las concentraciones).
por_temp <- resumen %>%
  group_by(temperatura_C) %>%
  summarise(
    recuperacion_media = mean(recuperacion_media),
    .groups = "drop"
  )
print(por_temp)

# --------------------------------------------------------------------------
# Parada 3. Grafica: porcentaje recuperado contra temperatura
# --------------------------------------------------------------------------
# Graficamos el porcentaje recuperado contra la temperatura de la acetona, en un panel por concentracion inicial: cada punto es la media de tres replicas con su barra de desviacion y su valor anotado, y la linea punteada es el 100% de referencia.
grafica <- ggplot(
  resumen,
  aes(x = temperatura_C, y = recuperacion_media)
) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "grey40") +
  geom_errorbar(aes(ymin = recuperacion_media - de,
                    ymax = recuperacion_media + de),
                width = 1.5, linewidth = 0.6, color = paleta[1]) +
  geom_line(linewidth = 1, color = paleta[1]) +
  geom_point(size = 3, color = paleta[1]) +
  geom_text(aes(label = paste0(round(recuperacion_media, 1), "%")),
            nudge_y = 3.5, size = 4) +
  facet_wrap(~ concentracion_inicial_ug_ml,
             labeller = labeller(
               concentracion_inicial_ug_ml =
                 function(x) paste0("Inicial: ", x, " ug/mL")
             )) +
  labs(
    x = "Temperatura de la acetona (C)",
    y = "Albumina recuperada en solucion (%)",
    title = "Precipitacion con acetona: recuperacion contra temperatura",
    subtitle = "La linea punteada es el 100% de referencia"
  ) +
  tema

print(grafica)

# --------------------------------------------------------------------------
# 4. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la mesa de precipitacion con acetona guardamos la grafica de la practica.
ggsave("05_acetona.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (porcentaje recuperado contra temperatura, un panel por concentracion inicial): el eje x es la temperatura de la acetona en C y el eje y es la albumina recuperada en solucion en %; la linea punteada es el 100% de referencia.
# - La recuperacion es mayor con acetona fria: cerca de 92% a -20 C contra cerca de 69% a 25 C. Esto significa que el frio protege la estructura de la proteina para redisolverla despues, y por eso lo siguiente es precipitar con acetona fria.
# - La concentracion inicial cambia poco la recuperacion: la temperatura es el factor que manda. Esto significa que al planear la precipitacion lo primero que se fija es la temperatura, no la concentracion de partida.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La absorbancia a 595 nm se convierte en concentracion con la curva de Bradford; la dilucion 1:2 deja la lectura dentro de la curva.
# - El solvente organico precipita la proteina y el frio protege su estructura para redisolverla despues.
# - El porcentaje recuperado se calcula con la concentracion medida por Bradford entre la concentracion inicial del tubo.
# Terminamos la practica en la mesa de precipitacion con acetona: ya sabemos que el frio da la mejor recuperacion. Seguimos a la siguiente practica: el equipo FPLC, donde se prepara la columna para la cromatografia.
