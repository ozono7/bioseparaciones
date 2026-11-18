# ==========================================================================
# P4. Precipitacion de albumina con sulfato de amonio
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 4. Sulfato de amonio
#
# Descripcion: Practica 4 del laboratorio: la precipitacion de albumina con sulfato de amonio en viales. Aqui se mide el sobrenadante por Bradford: la absorbancia a 595 nm es la medicion y la concentracion sale de la curva de calibracion, con una dilucion 1:1000 que deja la lectura dentro de la curva. Despues se convierte a molaridad la masa de sulfato de amonio indicada en el manual para cada saturacion (49, 60, 73 y 85%, gramos por vial de 5 mL), y se ajusta la ecuacion de Cohn a la solubilidad de albumina medida en el sobrenadante. Lo que se aprende aqui es la tabla de solubilidad contra molaridad que pide el manual, construida con los gramos del manual y la albumina medida.
#
# Objetivos de aprendizaje:
#   - Convertir la absorbancia a 595 nm en concentracion con la curva de Bradford.
#   - Convertir los gramos del manual a molaridad de sulfato de amonio.
#   - Construir la tabla de solubilidad contra concentracion molar.
#   - Ajustar la ecuacion de Cohn a los datos de la practica.

# Datos: datos_sulfato.csv (estandares de Bradford y muestras del sobrenadante con su absorbancia a 595 nm y su factor de dilucion; saturacion y gramos del manual; 3 replicas).
# Desarrollo: llegamos a la mesa con los viales de albumina y el sulfato de amonio del manual. Primera parada: la curva de Bradford y la conversion de la absorbancia a concentracion. Segunda parada: convertir los gramos del manual a molaridad. Tercera parada: ajustar la ecuacion de Cohn a la solubilidad medida en el sobrenadante. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
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
# Protocolo (Manual de Practicas, Practica 4. Sulfato de amonio)
# --------------------------------------------------------------------------
# Paso 1. Preparar 20 mL de una solucion de albumina a 15 mg/mL en buffer de fosfato (50 mM, pH 7).
# Paso 2. Colocar 5 mL de esa solucion en 4 viales. Tomar uno de los viales, agregar un agitador magnetico y colocarlo en una placa de agitacion, agitando a una velocidad en la que no se genere espuma.
# Paso 3. Pesar sulfato de amonio y agregarlo al vial poco a poco hasta alcanzar 49% de saturacion (1.53 g por vial de 5 mL, segun la tabla del manual; la cantidad se determina con la tabla citada en el manual: http://www.encorbio.com/protocols/AM-SO4.htm). Hay que esperar a que se disuelvan los cristales antes de adicionar mas. Una vez disueltos todos los cristales, retirar el vial de la placa.
# Paso 4. Repetir con el resto de los viales hasta alcanzar saturaciones de 60% (1.95 g), 73% (2.49 g) y 85% (3.03 g). Al terminar con el ultimo vial, dejar reposar los viales 5 min para que se complete la precipitacion.
# Paso 5. Mezclar suavemente los viales y tomar 1.5 mL de suspension de cada uno en tubos de centrifuga. Centrifugar a 15000g por 5 min.
# Paso 6. Separar el sobrenadante de cada tubo y cuantificar la concentracion de proteina con el metodo de Bradford. Diluir las muestras a analizar con agua, de manera que la concentracion maxima de sulfato de amonio sea 1 M; diluir aun mas si hace falta.
# Paso 7. Con los datos obtenidos generar una tabla de solubilidad de albumina contra la concentracion molar de sulfato de amonio.
# Paso 8. Agregar a los precipitados obtenidos 1 mL de agua y determinar visualmente si es posible disolver completamente a la albumina.
# Principio (manual): al agregar sal la solubilidad de la proteina primero sube (salting-in) hasta un maximo y despues baja rapido (salting-out) hasta precipitar. El sulfato de amonio es la sal mas usada por su bajo costo; el anion mas efectivo para precipitar es el citrato y el cation mas efectivo es el amonio. La precipitacion con sales es barata, escalable, continua y usa equipo sencillo.
# Seguridad y reglas (manual): agitar con suavidad, sin generar espuma; agregar los cristales poco a poco esperando a que se disuelvan; bata blanca obligatoria y guantes cuando se indique; limpiar la mesa antes y despues.

# --------------------------------------------------------------------------
# Parada 1. Curva de Bradford y conversion de la absorbancia a concentracion
# --------------------------------------------------------------------------
# El sobrenadante de cada vial se mide por Bradford: la absorbancia a 595 nm
# es la medicion y la concentracion sale de la curva de calibracion. El CSV
# trae los estandares de Bradford (0, 2.5, 5, 10 y 20 ug/mL, por triplicado,
# los mismos valores de la practica 3) y las muestras con su absorbancia y su
# factor de dilucion. Ajustamos la recta y el polinomio a los estandares y
# convertimos cada absorbancia en concentracion con la recta, como en la
# practica 3.
# Dilucion (paso 6 del manual): el sobrenadante anda en unos 12 mg/mL y la
# curva de Bradford llega hasta 20 ug/mL, asi que se diluye 1:1000 (en dos
# pasos, 1:100 y luego 1:10). Con ese factor, la concentracion diluida en
# ug/mL es numericamente igual a la concentracion original en mg/mL. La
# dilucion tambien deja el sulfato de amonio muy por debajo de 1 M, como
# pide el manual.
datos <- read_csv("datos_sulfato.csv", show_col_types = FALSE)

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
    solubilidad_sobrenadante_mg_ml =
      concentracion_diluida_ug_ml * factor_dilucion / 1000
  )
print(muestras %>%
        select(saturacion_pct, replica, absorbancia_595, factor_dilucion,
               concentracion_diluida_ug_ml, solubilidad_sobrenadante_mg_ml))

datos <- muestras

# --------------------------------------------------------------------------
# Parada 2. Gramos del manual a molaridad
# --------------------------------------------------------------------------
# Estamos en la mesa con los viales de 5 mL de albumina. Pesamos el sulfato de amonio que indica el manual para cada saturacion y lo convertimos a molaridad con su peso molecular de 132.14 g/mol y el volumen del vial.
# Peso molecular del sulfato de amonio: 132.14 g/mol.
# Cada vial tiene 5 mL de solucion de albumina (15 mg/mL en fosfato
# 50 mM, pH 7, segun el manual).
datos <- datos %>%
  mutate(molaridad_M = gramos_5ml / 132.14 / 0.005)

resumen <- datos %>%
  group_by(saturacion_pct, gramos_5ml, molaridad_M) %>%
  summarise(
    solubilidad_media = mean(solubilidad_sobrenadante_mg_ml),
    de = sd(solubilidad_sobrenadante_mg_ml),
    .groups = "drop"
  )

print(resumen)

# --------------------------------------------------------------------------
# Parada 3. Comprobacion de los gramos del manual (post-laboratorio 3)
# --------------------------------------------------------------------------
# El manual pide comprobar que el procedimiento de la pagina de referencia
# para calcular el sulfato de amonio es correcto. La formula estandar de
# saturacion (Scopes; la tabla citada en el manual) da los gramos por
# litro para pasar de 0% a S% de saturacion a 25 C:
#   g/L = 533 * S / (100 - 0.3 * S).
# Para un vial de 5 mL se multiplica por 0.005 L y se compara con los
# gramos del manual. La saturacion del 100% a 25 C es 761.4 g/L = 5.76 M.
verificacion_gramos <- tibble(
  saturacion_pct = c(49, 60, 73, 85),
  gramos_manual = c(1.53, 1.95, 2.49, 3.03)
) %>%
  mutate(
    gramos_por_litro = 533 * saturacion_pct / (100 - 0.3 * saturacion_pct),
    gramos_calculados = gramos_por_litro * 0.005,
    diferencia_g = gramos_calculados - gramos_manual
  )

print(verificacion_gramos)

# --------------------------------------------------------------------------
# Parada 4. Ajuste de Cohn a la solubilidad en el sobrenadante
# --------------------------------------------------------------------------
# Seguimos con los viales: ahora ajustamos la ecuacion de Cohn a la solubilidad que quedo en el sobrenadante, medida por Bradford. La fraccion soluble se calcula contra los 15 mg/mL iniciales.
ajuste <- lm(log10(solubilidad_media) ~ molaridad_M, data = resumen)
print(summary(ajuste))

tabla_cohn <- tibble(
  beta = coef(ajuste)[["(Intercept)"]],
  ks_por_M = -coef(ajuste)[["molaridad_M"]]
)
print(tabla_cohn)

# Fraccion de albumina que queda soluble a cada saturacion, respecto a
# los 15 mg/mL iniciales.
resumen <- resumen %>%
  mutate(fraccion_soluble = solubilidad_media / 15.0)
print(resumen)

# --------------------------------------------------------------------------
# Parada 5. Grafica: solubilidad en el sobrenadante contra molaridad
# --------------------------------------------------------------------------
# Graficamos la albumina que queda soluble en el sobrenadante contra la molaridad de sal: cada punto es la media de tres replicas con su barra de desviacion y su saturacion anotada; la curva es el ajuste de Cohn (en escala lineal es una exponencial decreciente) y el texto trae su ecuacion y su R2.
curva_cohn <- tibble(
  molaridad_M = seq(min(resumen$molaridad_M),
                    max(resumen$molaridad_M), length.out = 100)
) %>%
  mutate(solubilidad_ajustada = 10^predict(ajuste, newdata = .))
ecuacion_cohn <- paste0(
  "log10(S) = ", round(coef(ajuste)[["(Intercept)"]], 2),
  " - ", round(-coef(ajuste)[["molaridad_M"]], 2), " * M,  R2 = ",
  round(summary(ajuste)$r.squared, 3)
)
grafica <- ggplot(
  resumen,
  aes(x = molaridad_M, y = solubilidad_media)
) +
  geom_errorbar(aes(ymin = solubilidad_media - de,
                    ymax = solubilidad_media + de),
                width = 0.1, linewidth = 0.6, color = paleta[1]) +
  geom_line(data = curva_cohn,
            aes(x = molaridad_M, y = solubilidad_ajustada),
            color = paleta[6], linewidth = 1) +
  geom_point(size = 3, color = paleta[1]) +
  geom_text(aes(label = paste0(saturacion_pct, "%")),
            nudge_x = 0.22, nudge_y = 0.5, size = 4.5) +
  annotate("text", x = 4.5, y = 11, label = ecuacion_cohn,
           hjust = 1, size = 4.5) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "Albumina soluble en el sobrenadante (mg/mL)",
    title = "Salting-out: albumina soluble contra molaridad de sal",
    subtitle = "Cada punto trae su saturacion; la curva es la ecuacion de Cohn"
  ) +
  tema

print(grafica)

# --------------------------------------------------------------------------
# 6. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de terminar la practica guardamos la grafica de la practica.
ggsave("04_sulfato.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (albumina soluble contra molaridad de sal): el eje x es la molaridad de sulfato de amonio en M y el eje y es la albumina soluble en el sobrenadante en mg/mL; cada punto trae su saturacion anotada y la curva es el ajuste de Cohn, con su ecuacion y su R2 en el texto.
# - La albumina soluble en el sobrenadante cae de unos 12.7 mg/mL a 49% de saturacion a menos de 1 mg/mL a 85%: la proteina pasa al precipitado. Esto significa que al subir la sal la albumina deja la solucion y se recupera en el precipitado, y por eso lo siguiente es separar ese precipitado y redisolverlo.
# - El logaritmo de la solubilidad es lineal con la molaridad, como pide la ecuacion de Cohn. Esto significa que los datos de la practica siguen el modelo de la teoria, y con beta y Ks se predice la solubilidad a cualquier saturacion.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La absorbancia a 595 nm se convierte en concentracion con la curva de Bradford; la dilucion 1:1000 deja la lectura dentro de la curva y el sulfato por debajo de 1 M.
# - Los gramos del manual se convierten a molaridad con el peso molecular y el volumen del vial.
# - La tabla de solubilidad contra molaridad es el resultado que pide el manual para esta practica.
# Terminamos la practica de precipitacion con sulfato de amonio: ya tenemos la tabla de solubilidad contra molaridad que pide el manual. Seguimos a la siguiente practica: la precipitacion con acetona, donde la temperatura decide cuanta proteina se recupera.
