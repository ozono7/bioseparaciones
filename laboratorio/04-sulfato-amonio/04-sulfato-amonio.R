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
# Descripcion: Practica 4 del laboratorio: la precipitacion de albumina con sulfato de amonio en viales. Aqui se convierte a molaridad la masa de sulfato de amonio indicada en el manual para cada saturacion (49, 60, 73 y 85%, gramos por vial de 5 mL), y se ajusta la ecuacion de Cohn a la solubilidad de albumina medida en el sobrenadante por Bradford. Lo que se aprende aqui es la tabla de solubilidad contra molaridad que pide el manual, construida con los gramos del manual y la albumina medida.
#
# Objetivos de aprendizaje:
#   - Convertir los gramos del manual a molaridad de sulfato de amonio.
#   - Construir la tabla de solubilidad contra concentracion molar.
#   - Ajustar la ecuacion de Cohn a los datos de la practica.

# Datos: datos_sulfato.csv (saturacion y gramos del manual, solubilidad en el sobrenadante medida por Bradford, 3 replicas).
# Desarrollo: llegamos a la mesa con los viales de albumina y el sulfato de amonio del manual. Primera parada: convertir los gramos del manual a molaridad. Segunda parada: ajustar la ecuacion de Cohn a la solubilidad medida en el sobrenadante. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

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
# Parada 1. Gramos del manual a molaridad
# --------------------------------------------------------------------------
# Estamos en la mesa con los viales de 5 mL de albumina. Pesamos el sulfato de amonio que indica el manual para cada saturacion y lo convertimos a molaridad con su peso molecular de 132.14 g/mol y el volumen del vial.
# Peso molecular del sulfato de amonio: 132.14 g/mol.
# Cada vial tiene 5 mL de solucion de albumina (15 mg/mL en fosfato
# 50 mM, pH 7, segun el manual).
datos <- read_csv("datos_sulfato.csv", show_col_types = FALSE)

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
# Parada 2. Comprobacion de los gramos del manual (post-laboratorio 3)
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
# Parada 3. Ajuste de Cohn a la solubilidad en el sobrenadante
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
# Parada 4. Grafica: solubilidad en el sobrenadante contra molaridad
# --------------------------------------------------------------------------
# Graficamos la albumina que queda soluble en el sobrenadante contra la molaridad de sal: cada punto es la media de tres replicas con su barra de desviacion.
grafica <- ggplot(
  resumen,
  aes(x = molaridad_M, y = solubilidad_media)
) +
  geom_errorbar(aes(ymin = solubilidad_media - de,
                    ymax = solubilidad_media + de),
                width = 0.1, linewidth = 0.6) +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Sulfato de amonio (M)",
    y = "Albumina soluble en el sobrenadante (mg/mL)",
    title = "Salting-out: albumina soluble contra molaridad de sal"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 5. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de terminar la practica guardamos la grafica de la practica.
ggsave("04_sulfato.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (albumina soluble contra molaridad de sal): el eje x es la molaridad de sulfato de amonio en M y el eje y es la albumina soluble en el sobrenadante en mg/mL.
# - La albumina soluble en el sobrenadante cae de unos 12.7 mg/mL a 49% de saturacion a menos de 1 mg/mL a 85%: la proteina pasa al precipitado. Esto significa que al subir la sal la albumina deja la solucion y se recupera en el precipitado, y por eso lo siguiente es separar ese precipitado y redisolverlo.
# - El logaritmo de la solubilidad es lineal con la molaridad, como pide la ecuacion de Cohn. Esto significa que los datos de la practica siguen el modelo de la teoria, y con beta y Ks se predice la solubilidad a cualquier saturacion.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - Los gramos del manual se convierten a molaridad con el peso molecular y el volumen del vial.
# - La tabla de solubilidad contra molaridad es el resultado que pide el manual para esta practica.
# Terminamos la practica de precipitacion con sulfato de amonio: ya tenemos la tabla de solubilidad contra molaridad que pide el manual. Seguimos a la siguiente practica: la precipitacion con acetona, donde la temperatura decide cuanta proteina se recupera.
