# ==========================================================================
# P8. Cromatografia de intercambio ionico
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 8. Intercambio ionico
#
# Descripcion: Practica 8 y ultima del laboratorio: la columna de intercambio ionico. Aqui se mide cada fraccion por Bradford: la absorbancia a 595 nm es la medicion y la concentracion sale de la curva de calibracion, con una dilucion 1:100 que deja la lectura dentro de la curva. A pH 8.0 la albumina esta por encima de su pI (4.7), asi que tiene carga negativa y se retiene en un intercambiador de aniones; la desorcion se hace subiendo la fuerza ionica con NaCl 500 mM. La masa por fraccion es concentracion por 0.5 mL y la suma da la recuperacion respecto a los 6 mg cargados. Lo que se aprende aqui cierra el laboratorio: el pH respecto al pI decide que intercambiador retiene a la proteina.
#
# Objetivos de aprendizaje:
#   - Convertir la absorbancia a 595 nm en concentracion con la curva de Bradford.
#   - Predecir el signo de la carga de la albumina a pH 8.0 desde su pI.
#   - Identificar el pico de desorcion con NaCl 500 mM.
#   - Calcular la masa recuperada y su porcentaje respecto a lo cargado.

# Datos: datos_intercambio.csv (estandares de Bradford y fracciones con su absorbancia a 595 nm, su absorbancia a 280 nm y su factor de dilucion; carga 3 mL a 2 mg/mL = 6 mg).
# Desarrollo: llegamos a la ultima practica del laboratorio, la columna de intercambio ionico, con la albumina caracterizada desde la primera parada de la teoria. Primera parada: la curva de Bradford y la conversion de la absorbancia a concentracion. Segunda parada: la masa de proteina en cada fraccion. Tercera parada: la masa recuperada en la desorcion y su porcentaje. Cuarta parada: la A280 contra el Bradford. Quinta parada: el gel de la sesion 2. Sexta parada: el cromatograma. En cada parada calculamos y comentamos que significa el resultado, y aqui cerramos el laboratorio.
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
# Protocolo (Manual de Practicas, Practica 8. Intercambio ionico)
# --------------------------------------------------------------------------
# Buffers y soluciones (manual): buffer de adsorcion (Tris 50 mM, pH 8.0, filtrado); buffer de desorcion (Tris 50 mM, NaCl 500 mM, pH 8.0, filtrado); agua filtrada; solucion acida (HCl 0.1 M, filtrado).
# Paso 1. Preparar una solucion de albumina (3 mL) en buffer de adsorcion a 2 mg/mL. Agitar suavemente para que se disuelvan los cristales.
# Paso 2. Con la columna conectada, alimentar agua por 5 min a un flujo de 0.5 mL/min.
# Paso 3. Detener la bomba y sustituir la alimentacion por la solucion acida. Arrancar la bomba y alimentar la solucion acida al mismo flujo por 10 min.
# Paso 4. Detener la bomba y sustituir la alimentacion por agua. Arrancar la bomba y lavar por 10 min o hasta que el pH de la solucion de salida de la columna sea neutro.
# Paso 5. Detener la bomba y sustituir la alimentacion por el buffer de adsorcion. Arrancar la bomba y alimentar el buffer de adsorcion por 10 min o hasta que el pH de la solucion que sale de la columna sea 8.0 (verificarlo con papel pH).
# Paso 6. Cuando el pH sea el deseado el sistema esta listo para alimentar la muestra. No apagar la bomba. Cargar la solucion de proteina en una jeringa de 3 mL y llenar el loop del sistema cromatografico evitando la introduccion de burbujas.
# Paso 7. Conectar la salida de la bomba al fraccionador, al que previamente se le han colocado tubos de ensayo. Seleccionar 1 min como intervalo de fraccionacion. Una vez que la solucion comience a caer en el primer tubo de ensayo del automuestreador, inyectar la muestra y arrancar el automuestreador (sin olvidar cambiar de tubo).
# Paso 8. Permitir que se fraccionen 10 tubos de muestra. Despues detener la bomba junto con el fraccionador y sustituir la alimentacion por buffer de desorcion. Arrancar la bomba y el fraccionador y alimentar el buffer de desorcion hasta que se colecten 20 tubos de muestra.
# Paso 9. Detener la bomba junto con el fraccionador y sustituir la alimentacion por la solucion acida. Arrancar la bomba y alimentar la solucion acida por 10 min sin fraccionar tubos.
# Paso 10. Detener la bomba y alimentar agua hasta que el pH de la solucion de salida de la columna sea neutro. No es necesario fraccionar mas tubos.
# Paso 11. Analizar los tubos fraccionados midiendo la absorbancia a 280 nm y mediante el ensayo de Bradford, y mediante SDS-PAGE (sesion 2).
# Intercambiador (post-laboratorio 1 y 2 del manual): a pH 8.0 la albumina esta por encima de su pI (4.7) y tiene carga negativa, asi que se retiene en un intercambiador de aniones. La especie retenida es el anion albumina, que desplaza al contra-anion del intercambiador y ocupa su sitio.
# Sesion 2 (SDS-PAGE de las fracciones): el manual solo indica analizar las fracciones mediante SDS-PAGE en la sesion 2, sin detallar la preparacion de esas muestras. La indicacion para esa sesion es: calentar las muestras de las fracciones en microtubos 2 min antes de cargarlas, con buffer de carga 50/50 (50% muestra y 50% buffer de carga).
# Seguridad y reglas (manual): no introducir burbujas al llenar el loop; verificar el pH de salida con papel pH; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Curva de Bradford y conversion de la absorbancia a concentracion
# --------------------------------------------------------------------------
# Cada fraccion se mide por Bradford: la absorbancia a 595 nm es la medicion
# y la concentracion sale de la curva de calibracion. El CSV trae los
# estandares de Bradford (0, 2.5, 5, 10 y 20 ug/mL, por triplicado, los
# mismos valores de la practica 3) y las fracciones con su absorbancia a
# 595 nm, su absorbancia a 280 nm y su factor de dilucion. Ajustamos la
# recta y el polinomio a los estandares y convertimos cada absorbancia en
# concentracion con la recta.
# Dilucion: las fracciones llegan hasta casi 1 mg/mL (unos 880 ug/mL) y la
# curva de Bradford llega hasta 20 ug/mL, asi que cada fraccion se diluye
# 1:100 para leerla dentro de la curva (la fraccion mas concentrada queda
# en unos 8.8 ug/mL, a la mitad de la curva). La concentracion en la
# fraccion es la concentracion diluida por el factor de dilucion.
datos <- read_csv("datos_intercambio.csv", show_col_types = FALSE)

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
    concentracion_proteina_mg_ml =
      concentracion_diluida_ug_ml * factor_dilucion / 1000
  )
print(muestras %>%
        select(fraccion, fase, absorbancia_595, absorbancia_280,
               factor_dilucion, concentracion_proteina_mg_ml))

datos <- muestras

# --------------------------------------------------------------------------
# Parada 2. Masa de proteina por fraccion
# --------------------------------------------------------------------------
# Estamos frente a la columna de intercambio ionico. Antes de calcular recordamos la prediccion: el pI de la albumina es 4.7 y trabajamos a pH 8.0, por encima del pI, asi que su carga neta es negativa y se retiene en un intercambiador de aniones. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es la concentracion por 0.5 mL.
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
# pI de la albumina: 4.7. A pH 8.0 (por encima del pI) su carga neta es
# negativa, asi que se retiene en un intercambiador de aniones.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- datos %>%
  mutate(masa_mg = concentracion_proteina_mg_ml * volumen_fraccion_ml)

print(datos)

# --------------------------------------------------------------------------
# Parada 3. Masa recuperada en la desorcion y porcentaje de recuperacion
# --------------------------------------------------------------------------
# Seguimos en la columna: sumamos la masa por fase y calculamos la masa recuperada en la desorcion con NaCl 500 mM y su porcentaje respecto a los 6 mg cargados.
resumen <- datos %>%
  group_by(fase) %>%
  summarise(masa_mg = sum(masa_mg), .groups = "drop")

print(resumen)

masa_desorcion <- resumen %>%
  filter(fase == "Desorcion (NaCl 500 mM)") %>%
  pull(masa_mg)
print(tibble(
  masa_recuperada_mg = masa_desorcion,
  recuperacion_porciento = masa_desorcion / masa_cargada_mg * 100
))

# --------------------------------------------------------------------------
# Parada 4. Absorbancia a 280 nm y Bradford (paso 11 del manual)
# --------------------------------------------------------------------------
# El manual pide analizar las fracciones por absorbancia a 280 nm, por
# el ensayo de Bradford y por SDS-PAGE. La A280 de la albumina con paso
# optico de 1 cm es 0.667 por mg/mL, asi que la concentracion por A280
# es A280 / 0.667.
# A280 de BSA (1 mg/mL, 1 cm): 0.667.
datos <- datos %>%
  mutate(concentracion_a280_mg_ml = absorbancia_280 / 0.667)

print(datos %>%
        select(fraccion, fase, concentracion_proteina_mg_ml,
               absorbancia_280, concentracion_a280_mg_ml))

# Comparacion entre los dos metodos de cuantificacion.
print(datos %>%
        summarise(
          diferencia_media_mg_ml =
            mean(concentracion_a280_mg_ml - concentracion_proteina_mg_ml),
          diferencia_maxima_mg_ml =
            max(abs(concentracion_a280_mg_ml - concentracion_proteina_mg_ml))
        ))

# La recta de la A280 contra el Bradford y su R2: si los dos metodos miden
# lo mismo, la pendiente es cercana a 1 y el R2 cercano a 1.
ajuste_a280 <- lm(concentracion_a280_mg_ml ~ concentracion_proteina_mg_ml,
                  data = datos)
r2_a280 <- round(summary(ajuste_a280)$r.squared, 4)

grafica_a280 <- ggplot(
  datos,
  aes(x = concentracion_proteina_mg_ml,
      y = concentracion_a280_mg_ml, color = fase)
) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed",
              color = "grey40") +
  geom_smooth(method = "lm", se = FALSE, color = paleta[6], linewidth = 1) +
  geom_point(size = 3) +
  annotate("text", x = 0.05, y = 0.9,
           label = paste0("R2 = ", r2_a280), hjust = 0, size = 4.5) +
  scale_color_manual(values = paleta) +
  labs(
    x = "Concentracion por Bradford (mg/mL)",
    y = "Concentracion por A280 (mg/mL)",
    color = "Fase",
    title = "Intercambio ionico: A280 contra Bradford por fraccion",
    subtitle = "La linea punteada es la identidad; la linea continua es el ajuste"
  ) +
  tema

print(grafica_a280)

ggsave("08_intercambio_a280.png", grafica_a280,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Parada 5. Sesion 2: SDS-PAGE de las fracciones
# --------------------------------------------------------------------------
# En la sesion 2 las fracciones se analizan por SDS-PAGE. El gel lleva
# su propio carril de marcador, asi que la recta log10(PM) contra Rf se
# calcula desde ese marcador y se aplica a las bandas de las fracciones.
# Las fracciones de carga y lavado no muestran banda (la proteina que
# pasa queda por debajo del limite de deteccion de la tincion); las de
# desorcion muestran la banda de la albumina.
gel <- read_csv("datos_sds_page_sesion2.csv", show_col_types = FALSE)

gel <- gel %>%
  mutate(rf = distancia_mm / frente_mm)

marcador_gel <- filter(gel, carril == "Marcador")
ajuste_gel <- lm(log10(peso_molecular_kda) ~ rf, data = marcador_gel)

bandas <- gel %>%
  filter(carril != "Marcador", !is.na(distancia_mm)) %>%
  mutate(peso_molecular_kda_estimado =
           10^predict(ajuste_gel, newdata = tibble(rf = rf)))

print(bandas %>%
        select(fraccion, distancia_mm, rf, peso_molecular_kda_estimado))

# La ecuacion de la recta de calibracion y su R2, y la linea de referencia
# de la albumina (66.5 kDa): las bandas de las fracciones de desorcion
# deben caer sobre la recta cerca de esa linea.
ecuacion_gel <- paste0(
  "log10(PM) = ", round(coef(ajuste_gel)[["(Intercept)"]], 2),
  " - ", round(-coef(ajuste_gel)[["rf"]], 2), " * Rf,  R2 = ",
  round(summary(ajuste_gel)$r.squared, 3)
)
grafica_gel <- ggplot(marcador_gel,
                      aes(x = rf, y = log10(peso_molecular_kda))) +
  geom_hline(yintercept = log10(66.5), linetype = "dotted",
             color = paleta[6], linewidth = 1) +
  annotate("text", x = max(marcador_gel$rf) * 0.95, y = log10(66.5),
           label = "Albumina 66.5 kDa", hjust = 1, vjust = -0.6,
           color = paleta[6], size = 4.5) +
  geom_point(size = 3, color = paleta[1]) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1, color = paleta[1]) +
  geom_point(
    data = bandas,
    aes(x = rf, y = log10(peso_molecular_kda_estimado)),
    color = paleta[6], size = 3.5
  ) +
  labs(
    x = "Rf (distancia / frente)",
    y = "log10(peso molecular, kDa)",
    title = "Intercambio ionico sesion 2: calibracion y bandas",
    subtitle = ecuacion_gel,
    caption = "Puntos oscuros: marcador; puntos naranja: bandas de las fracciones"
  ) +
  tema

print(grafica_gel)

ggsave("08_intercambio_sds_sesion2.png", grafica_gel,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Parada 6. Grafica: cromatograma de intercambio ionico
# --------------------------------------------------------------------------
# Graficamos el cromatograma: cada barra es una fraccion y su color marca la fase, carga y lavado o desorcion. La fraccion del pico de desorcion lleva su etiqueta y el subtitulo trae la masa recuperada en la desorcion y su porcentaje respecto a lo cargado.
pico <- datos %>%
  filter(fase == "Desorcion (NaCl 500 mM)") %>%
  filter(concentracion_proteina_mg_ml ==
           max(concentracion_proteina_mg_ml))
subtitulo_cromatograma <- paste0(
  "Pico de desorcion en la fraccion ", pico$fraccion,
  "; masa recuperada en la desorcion: ", round(masa_desorcion, 2),
  " mg (", round(masa_desorcion / masa_cargada_mg * 100, 1),
  "% de los 6 mg cargados)"
)
grafica <- ggplot(
  datos,
  aes(x = fraccion, y = concentracion_proteina_mg_ml, fill = fase)
) +
  geom_col(width = 0.8) +
  geom_text(data = pico,
            aes(x = fraccion, y = concentracion_proteina_mg_ml,
                label = paste0("Pico: fraccion ", fraccion)),
            nudge_y = 0.06, size = 4.5, color = "black",
            inherit.aes = FALSE) +
  scale_fill_manual(values = paleta) +
  labs(
    x = "Fraccion (1 min, 0.5 mL cada una)",
    y = "Concentracion de proteina (mg/mL)",
    fill = "Fase",
    title = "Intercambio ionico: cromatograma de albumina (pH 8.0)",
    subtitle = subtitulo_cromatograma
  ) +
  tema

print(grafica)

# --------------------------------------------------------------------------
# 7. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la columna de intercambio ionico guardamos la grafica de la practica.
ggsave("08_intercambio.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (cromatograma de intercambio ionico): el eje x es la fraccion (1 min, 0.5 mL cada una) y el eje y es la concentracion de proteina en mg/mL; el color marca la fase y el subtitulo trae la masa recuperada en la desorcion.
# - En carga y lavado casi no sale proteina: a pH 8.0 la albumina, con carga negativa, queda retenida en el intercambiador de aniones. Esto significa que la prediccion desde el pI se cumple en la columna, y por eso lo siguiente es subir la fuerza ionica para desorberla.
# - Al subir la fuerza ionica con NaCl 500 mM aparece el pico de desorcion entre las fracciones 12 y 16. Esto significa que la sal compite por los sitios del intercambiador y libera la proteina en pocas fracciones concentradas, que son las que se juntan.
# Grafica (A280 contra Bradford): el eje x es la concentracion por Bradford en mg/mL y el eje y es la concentracion por A280 en mg/mL; la linea punteada es la identidad y la linea continua es el ajuste, con su R2 anotado.
# - Los puntos caen sobre la identidad: la A280 y el Bradford miden la misma concentracion en cada fraccion. Esto significa que los dos metodos concuerdan y que la A280 sirve para seguir la proteina fraccion por fraccion sin gastar reactivo.
# Grafica (sesion 2, calibracion y bandas): el eje x es el Rf y el eje y es log10 del peso molecular en kDa; los puntos naranja son las bandas de las fracciones de desorcion y la linea punteada es la albumina (66.5 kDa).
# - Las bandas de las fracciones de desorcion caen sobre la recta cerca de 66 kDa, el peso molecular de la albumina, y las fracciones de carga y lavado no muestran banda. Esto significa que lo que salio en la desorcion es la albumina retenida y que en carga y lavado casi no paso proteina.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La absorbancia a 595 nm se convierte en concentracion con la curva de Bradford; la dilucion 1:100 deja la lectura dentro de la curva.
# - El pH respecto al pI decide el signo de la carga y por tanto que intercambiador retiene a la proteina.
# - La sal compite por los sitios del intercambiador y desorbe la proteina; la masa recuperada sale de sumar las fracciones.
# - La A280 confirma la cuantificacion por Bradford fraccion por fraccion, y el gel de la sesion 2 confirma que la banda de la desorcion es la albumina.
# Terminamos la practica en la columna de intercambio ionico, ultima practica del laboratorio: la albumina quedo retenida por su carga y salio con la sal. Aqui se cierra el laboratorio, desde la preparacion de soluciones hasta la cromatografia.
