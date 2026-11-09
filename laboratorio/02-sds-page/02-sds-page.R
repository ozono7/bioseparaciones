# ==========================================================================
# P2. SDS-PAGE: peso molecular a partir de la migracion
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 2. SDS-PAGE
#
# Descripcion: Recorrido por el laboratorio de la planta, estacion 2: el equipo de electroforesis SDS-PAGE. Aqui se calcula el Rf de cada banda (distancia recorrida entre distancia del frente, 65 mm) y se ajusta log10(PM) contra Rf con el marcador de peso molecular. Con esa recta se estima el peso molecular de la albumina (BSA) a partir de su Rf medido. Lo que se aprende aqui dice como convertir una distancia medida en el gel en un peso molecular.
#
# Objetivos de aprendizaje:
#   - Calcular el Rf de cada banda del gel.
#   - Ajustar log10(PM) contra Rf con el marcador.
#   - Estimar el peso molecular de la BSA desde su migracion.

# Datos: datos_sds_page.csv (distancia migrada de cada banda del marcador y de la BSA; frente del gel 65 mm).
# Recorrido: llegamos a la estacion de electroforesis, con el gel ya corrido y tenido. Primera parada: medir las bandas y calcular el Rf de cada una. Segunda parada: la recta de calibracion con el marcador y el peso molecular de la BSA. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 2. SDS-PAGE)
# --------------------------------------------------------------------------
# Paso 1. Limpiar los vidrios con etanol, dejar secar y montar en los soportes como indique el instructor.
# Paso 2. Gel separador: en un tubo Falcon o recipiente de vidrio mezclar los volumenes de la Tabla 1 (gel 10% o 12%, 2 geles de 1 mm). El persulfato de amonio y el TEMED se agregan al final. Vaciar la mezcla en los vidrios, agregar isopropanol para favorecer la polimerizacion y esperar 20-30 min o hasta que polimerice.
# Paso 3. Gel concentrador: mezclar los volumenes de la Tabla 2 (gel 4%, 2 geles de 1 mm), con el persulfato de amonio y el TEMED al final. Vaciar sobre el gel separador, colocar el peine y esperar 20-30 min o hasta que polimerice.
# Paso 4. Muestras: tomar 15 uL de cada stock de BSA (2.5, 5, 10, 15 y 20 ug/mL) y mezclar con 5 uL de buffer de carga (contiene beta-mercaptoetanol). Calentar los tubos a 95 C por 10 min y dejar enfriar antes de cargar el gel.
# Paso 5. Montar el gel polimerizado con los vidrios en la camara de electroforesis y llenar con buffer de corrida hasta la marca, con los pozos cubiertos de buffer.
# Paso 6. Cargar el gel con 15 uL de cada muestra y dejar un carril para el estandar o marcador de peso molecular.
# Paso 7. Colocar la tapa segun los electrodos, conectar a la fuente de poder y correr el gel a 50 mA aproximadamente 1 h.
# Paso 8. Desmontar el gel y colocarlo en un bano con la solucion de tincion (Coomassie) en agitacion suave; dejar toda la noche.
# Paso 9. Destenir el gel con lavados con la solucion destenidora en agitacion suave.
# Nota del manual: la Tabla 2 del manual dice "Buffer Tris-base 8.8" para el gel concentrador, aunque en la lista de reactivos de la misma practica aparece el buffer Tris pH 6.8. Esa diferencia viene asi en el manual y conviene confirmarla con el instructor antes de preparar el gel.
# Nota: se preparan 20 uL de muestra (15 uL de stock + 5 uL de buffer de carga) y se cargan 15 uL en el gel, como indica el manual.
# Seguridad y residuos (manual): la acrilamida es neurotoxica; los residuos liquidos de acrilamida se almacenan debidamente etiquetados para entregarlos a companias de recoleccion y disposicion especializada, segun la programacion de la Subcomision de Seguridad e Higiene de la FCQ. Usar guantes y bata.

# Tablas de recetas del manual (Tabla 1 y Tabla 2), para 2 geles de 1 mm.
receta_gel_separador <- tibble(
  reactivo = c("Poliacrilamida", "Buffer Tris-base 8.8", "SDS 20%",
               "Agua desionizada", "TEMED", "Persulfato de amonio"),
  gel_10 = c("3.33 mL", "2.5 mL", "50 uL", "4 mL", "10 uL", "100 uL"),
  gel_12 = c("4.16 mL", "2.5 mL", "50 uL", "3.2 mL", "10 uL", "100 uL")
)
print(receta_gel_separador)

receta_gel_concentrador <- tibble(
  reactivo = c("Poliacrilamida", "Buffer Tris-base 8.8", "SDS 20%",
               "Agua desionizada", "TEMED", "Persulfato de amonio"),
  gel_4 = c("0.67 mL", "1.25 mL", "25 uL", "3 mL", "8 uL", "80 uL")
)
print(receta_gel_concentrador)

# --------------------------------------------------------------------------
# Parada 1. Rf de cada banda
# --------------------------------------------------------------------------
# Estamos frente al gel con la regla en la mano. Medimos la distancia recorrida por cada banda y la dividimos entre la distancia del frente, 65 mm: ese cociente es el Rf de cada banda.
# Rf = distancia recorrida por la banda / distancia recorrida por el
# frente del gel (65 mm, medido en el gel).
frente_mm <- 65

datos <- read_csv("datos_sds_page.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(rf = distancia_mm / frente_mm)

print(datos)

# --------------------------------------------------------------------------
# Parada 2. Recta de calibracion log10(PM) contra Rf
# --------------------------------------------------------------------------
# Seguimos en el gel: con las bandas del marcador ajustamos la recta de log10(PM) contra Rf. Esa recta es la regla que convierte migracion en peso molecular.
marcador <- filter(datos, carril == "Marcador")

ajuste <- lm(log10(peso_molecular_kda) ~ rf, data = marcador)
print(summary(ajuste))

# --------------------------------------------------------------------------
# Parada 3. Peso molecular estimado de la BSA
# --------------------------------------------------------------------------
# Ahora aplicamos la recta a la banda de la BSA: con su Rf medido estimamos su peso molecular y lo comparamos con su valor de referencia.
rf_bsa <- datos %>%
  filter(proteina == "BSA") %>%
  pull(rf)

pm_bsa <- 10^predict(ajuste, newdata = tibble(rf = rf_bsa))
print(tibble(rf_bsa = rf_bsa, peso_molecular_BSA_kda = pm_bsa))

# --------------------------------------------------------------------------
# Parada 4. Grafica: calibracion y BSA
# --------------------------------------------------------------------------
# Graficamos la calibracion: los puntos son las bandas del marcador, la linea es la recta ajustada y el punto rojo es la BSA.
grafica <- ggplot(marcador, aes(x = rf, y = log10(peso_molecular_kda))) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  geom_point(
    data = tibble(rf = rf_bsa, y = log10(pm_bsa)),
    aes(x = rf, y = y), color = "red", size = 3
  ) +
  labs(
    x = "Rf (distancia / frente)",
    y = "log10(peso molecular, kDa)",
    title = "SDS-PAGE: calibracion con marcador y BSA (punto rojo)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 5. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la estacion de electroforesis guardamos la grafica del recorrido.
ggsave("02_sds_page.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (calibracion con marcador y BSA): el eje x es el Rf (adimensional, distancia entre frente) y el eje y es log10 del peso molecular en kDa.
# - El Rf baja al subir el peso molecular: las proteinas grandes migran menos en el gel. Esto significa que en SDS-PAGE la separacion es por tamano, y por eso lo siguiente es leer el peso molecular de cualquier banda con la recta.
# - La BSA cae sobre la recta del marcador, cerca de 66 kDa, que es su peso molecular de referencia. Esto significa que la calibracion funciona y que la banda que medimos es la albumina que esperabamos.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - En SDS-PAGE la separacion es por peso molecular, porque el SDS da la misma carga por unidad de longitud.
# - La recta log10(PM) contra Rf convierte una distancia medida en un peso molecular estimado.
# Terminamos el recorrido en la estacion de electroforesis: ya sabemos leer el peso molecular de una banda en el gel. Seguimos a la siguiente estacion del laboratorio: el espectrofotometro del ensayo de Bradford, donde se cuantifica la proteina.
