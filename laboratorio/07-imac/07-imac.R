# ==========================================================================
# P7. Cromatografia de afinidad por metal inmovilizado (IMAC)
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 7. IMAC
#
# Descripcion: Practica 7 del laboratorio: la columna de afinidad IMAC con niquel. Aqui se analiza el cromatograma de IMAC con niquel: albumina cargada en buffer de adsorcion (fosfato 20 mM, NaCl 500 mM, pH 7.0) y desorbida con buffer pH 4.0. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es concentracion por 0.5 mL; la suma da la masa recuperada y su porcentaje respecto a los 6 mg cargados. Lo que se aprende aqui dice cuanta proteina se recupera en la desorcion y en que fracciones sale.
#
# Objetivos de aprendizaje:
#   - Identificar el pico de desorcion en el cromatograma.
#   - Calcular la masa de proteina por fraccion y la masa total.
#   - Calcular el porcentaje de recuperacion respecto a lo cargado.

# Datos: datos_imac.csv (concentracion de proteina por fraccion, medida por Bradford; carga 3 mL a 2 mg/mL = 6 mg).
# Desarrollo: llegamos a la columna de IMAC ya preparada en la practica del FPLC. Primera parada: la masa de proteina en cada fraccion. Segunda parada: la masa recuperada en la desorcion y su porcentaje. Tercera parada: el cromatograma. En cada parada calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 7. IMAC; pasos 9 a 19 del manual)
# --------------------------------------------------------------------------
# Buffers y soluciones (manual): buffer de adsorcion (fosfato 20 mM, NaCl 500 mM, pH 7.0, filtrado); buffer de desorcion (fosfato 20 mM, NaCl 500 mM, pH 4.0, filtrado); agua filtrada; sulfato de niquel (20 mM, filtrado); solucion acida (HCl 0.1 M, filtrado).
# Paso 9. Preparar una solucion de albumina (3 mL) en buffer de adsorcion a 2 mg/mL. Agitar suavemente para que se disuelvan los cristales.
# Paso 10. Con la columna conectada, alimentar agua por 5 min a un flujo de 0.5 mL/min.
# Paso 11. Detener la bomba y sustituir la alimentacion por la solucion de sulfato de niquel. Arrancar la bomba y alimentar el sulfato de niquel al mismo flujo hasta que el frente verde alcance la parte superior de la columna.
# Paso 12. Detener la bomba y sustituir la alimentacion por agua. Arrancar la bomba y lavar por 10 min.
# Paso 13. Detener la bomba y sustituir la alimentacion por el buffer de adsorcion. Arrancar la bomba y alimentar el buffer de adsorcion por 10 min o hasta que el pH de la solucion que sale de la columna sea 7.0 (verificarlo con papel pH).
# Paso 14. Cuando el pH sea el deseado el sistema esta listo para alimentar la muestra. No apagar la bomba. Cargar la solucion de proteina en una jeringa de 3 mL y llenar el loop del sistema cromatografico evitando la introduccion de burbujas.
# Paso 15. Conectar la salida de la bomba al fraccionador, al que previamente se le han colocado tubos de ensayo. Seleccionar 1 min como intervalo de fraccionacion. Una vez que la solucion comience a caer en el primer tubo de ensayo del automuestreador, inyectar la muestra y arrancar el automuestreador (sin olvidar cambiar de tubo).
# Paso 16. Permitir que se fraccionen 10 tubos de muestra. Despues detener la bomba junto con el fraccionador y sustituir la alimentacion por buffer de desorcion. Arrancar la bomba y el fraccionador y alimentar el buffer de desorcion hasta que se colecten 20 tubos de muestra.
# Paso 17. Detener la bomba junto con el fraccionador y sustituir la alimentacion por la solucion acida. Arrancar la bomba y el fraccionador y alimentar la solucion acida hasta que la coloracion azul de la columna desaparezca. Colectar cuantos tubos sean necesarios.
# Paso 18. Detener la bomba y el fraccionador y alimentar agua hasta que el pH de la solucion de salida de la columna sea neutro. No es necesario fraccionar mas tubos.
# Paso 19. Analizar los tubos fraccionados midiendo la absorbancia a 280 nm (a excepcion de los tubos que contienen niquel) y mediante SDS-PAGE (sesion 2).
# Principio (manual): la cromatografia de afinidad por metal inmovilizado la desarrollo J. Porath en 1975. El ion metalico queda inmovilizado por un quelatante (acido iminodiacetico, IDA, y acido nitrilotriacetico, NTA, son los mas comunes) y las proteinas se adsorben por los residuos de histidina de su superficie. La union es reversible: a pH 7.0 la histidina esta desprotonada y se une al niquel; a pH 4.0 se protona y la union se rompe. Por eso a las proteinas recombinantes se les agrega una cola de histidinas para purificarlas por IMAC.
# Sesion 2 (SDS-PAGE de las fracciones): el manual solo indica analizar las fracciones mediante SDS-PAGE en la sesion 2, sin detallar la preparacion de esas muestras. La indicacion para esa sesion es: calentar las muestras de las fracciones en microtubos 2 min antes de cargarlas, con buffer de carga 50/50 (50% muestra y 50% buffer de carga).
# Las concentraciones por fraccion del CSV se midieron por Bradford; el manual indica analizar las fracciones por absorbancia a 280 nm (excepto los tubos con niquel) y por SDS-PAGE en la sesion 2.
# Seguridad y reglas (manual): no introducir burbujas al llenar el loop; verificar el pH de salida con papel pH; bata blanca obligatoria y guantes cuando se indique.

# --------------------------------------------------------------------------
# Parada 1. Leer las fracciones y calcular la masa por fraccion
# --------------------------------------------------------------------------
# Estamos frente a la columna de IMAC con el colector de fracciones. Cada fraccion es de 1 min a 0.5 mL/min, asi que la masa por fraccion es la concentracion medida por Bradford por 0.5 mL.
# Fraccion de 1 min a 0.5 mL/min = 0.5 mL por fraccion.
# Masa por fraccion (mg) = concentracion (mg/mL) * 0.5 mL.
# Carga: 3 mL a 2 mg/mL = 6 mg de albumina.
volumen_fraccion_ml <- 0.5
masa_cargada_mg <- 6.0

datos <- read_csv("datos_imac.csv", show_col_types = FALSE)

datos <- datos %>%
  mutate(masa_mg = concentracion_proteina_mg_ml * volumen_fraccion_ml)

print(datos)

# --------------------------------------------------------------------------
# Parada 2. Masa recuperada en la desorcion y porcentaje de recuperacion
# --------------------------------------------------------------------------
# Seguimos en la columna: sumamos la masa por fase y calculamos la masa recuperada en la desorcion y su porcentaje respecto a los 6 mg cargados.
resumen <- datos %>%
  group_by(fase) %>%
  summarise(masa_mg = sum(masa_mg), .groups = "drop")

print(resumen)

masa_desorcion <- resumen %>%
  filter(fase == "Desorcion (pH 4.0)") %>%
  pull(masa_mg)
print(tibble(
  masa_recuperada_mg = masa_desorcion,
  recuperacion_porciento = masa_desorcion / masa_cargada_mg * 100
))

# --------------------------------------------------------------------------
# Parada 3. Absorbancia a 280 nm contra Bradford (paso 19 del manual)
# --------------------------------------------------------------------------
# El manual pide analizar las fracciones por absorbancia a 280 nm (a
# excepcion de los tubos que contienen niquel) y por SDS-PAGE. La A280
# de la albumina con paso optico de 1 cm es 0.667 por mg/mL, asi que la
# concentracion por A280 es A280 / 0.667. Los tubos de la tira acida, que
# contienen el niquel desprendido de la columna, no se miden por A280 y
# no estan en esta tabla.
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

grafica_a280 <- ggplot(
  datos,
  aes(x = concentracion_proteina_mg_ml,
      y = concentracion_a280_mg_ml, color = fase)
) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  geom_point(size = 2.5) +
  labs(
    x = "Concentracion por Bradford (mg/mL)",
    y = "Concentracion por A280 (mg/mL)",
    color = "Fase",
    title = "IMAC: A280 contra Bradford por fraccion"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_a280)

ggsave("07_imac_a280.png", grafica_a280,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Parada 4. Sesion 2: SDS-PAGE de las fracciones
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

grafica_gel <- ggplot(marcador_gel,
                      aes(x = rf, y = log10(peso_molecular_kda))) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  geom_point(
    data = bandas,
    aes(x = rf, y = log10(peso_molecular_kda_estimado)),
    color = "red", size = 3
  ) +
  labs(
    x = "Rf (distancia / frente)",
    y = "log10(peso molecular, kDa)",
    title = "IMAC sesion 2: calibracion y bandas de las fracciones (rojo)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_gel)

ggsave("07_imac_sds_sesion2.png", grafica_gel,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Parada 5. Grafica: cromatograma IMAC
# --------------------------------------------------------------------------
# Graficamos el cromatograma: cada barra es una fraccion y su color marca la fase, carga y lavado o desorcion. Aqui se ve donde sale la proteina.
grafica <- ggplot(
  datos,
  aes(x = fraccion, y = concentracion_proteina_mg_ml, fill = fase)
) +
  geom_col(width = 0.8) +
  labs(
    x = "Fraccion (1 min, 0.5 mL cada una)",
    y = "Concentracion de proteina (mg/mL)",
    fill = "Fase",
    title = "IMAC con Ni(II): cromatograma de albumina"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 6. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir de la columna de IMAC guardamos la grafica de la practica.
ggsave("07_imac.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (cromatograma IMAC): el eje x es la fraccion (1 min, 0.5 mL cada una) y el eje y es la concentracion de proteina en mg/mL; el color marca la fase.
# - En carga y lavado casi no sale proteina: la albumina queda retenida en la columna con niquel a pH 7.0. Esto significa que la histidina de la superficie se une al niquel a pH 7, y por eso lo siguiente es cambiar el buffer para desorberla.
# - Al cambiar a pH 4.0 aparece el pico de desorcion entre las fracciones 13 y 17, donde sale la mayor parte de la proteina. Esto significa que al protonarse la histidina a pH 4 la union se rompe y la proteina sale en pocas fracciones concentradas, que son las que se juntan.
# Grafica (A280 contra Bradford): el eje x es la concentracion por Bradford en mg/mL y el eje y es la concentracion por A280 en mg/mL; la linea punteada es la identidad.
# - Los puntos caen sobre la identidad: la A280 y el Bradford miden la misma concentracion en cada fraccion. Esto significa que los dos metodos concuerdan y que la A280 sirve para seguir la proteina fraccion por fraccion sin gastar reactivo.
# Grafica (sesion 2, calibracion y bandas): el eje x es el Rf y el eje y es log10 del peso molecular en kDa; los puntos rojos son las bandas de las fracciones de desorcion.
# - Las bandas de las fracciones de desorcion caen sobre la recta cerca de 66 kDa, el peso molecular de la albumina, y las fracciones de carga y lavado no muestran banda. Esto significa que lo que salio en la desorcion es la albumina retenida y que en carga y lavado casi no paso proteina.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La histidina de la superficie se une al niquel a pH 7 y se protona a pH 4, lo que rompe la union y desorbe la proteina.
# - La masa recuperada es la suma de concentracion por volumen en cada fraccion de la desorcion.
# - La A280 confirma la cuantificacion por Bradford fraccion por fraccion, y el gel de la sesion 2 confirma que la banda de la desorcion es la albumina.
# Terminamos la practica en la columna de IMAC: ya sabemos en que fracciones sale la albumina y cuanta se recupera. Seguimos a la ultima practica: la columna de intercambio ionico, donde la carga de la albumina decide si se retiene.
