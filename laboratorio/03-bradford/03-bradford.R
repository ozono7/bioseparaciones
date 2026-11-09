# ==========================================================================
# P3. Ensayo de Bradford: curva de calibracion de proteina
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Laboratorio, Practica 3. Ensayo de Bradford
#
# Descripcion: Recorrido por el laboratorio de la planta, estacion 3: el espectrofotometro del ensayo de Bradford. Aqui se construye la curva de calibracion del ensayo de Bradford con los estandares del manual (BSA 0, 2.5, 5, 10 y 20 ug/mL, por triplicado, absorbancia a 595 nm). Se ajusta una recta y un polinomio de segundo orden, se comparan, y se cuantifica una muestra problema con la recta. Lo que se aprende aqui es como convertir una absorbancia medida en una concentracion de proteina, que es lo que se necesita en casi todas las estaciones que siguen.
#
# Objetivos de aprendizaje:
#   - Construir la curva de calibracion con estandares por triplicado.
#   - Comparar el ajuste lineal con el polinomial de segundo orden.
#   - Cuantificar una muestra problema a partir de su absorbancia.

# Datos: datos_bradford.csv (estandares de BSA del manual, absorbancia a 595 nm) y datos_bradford_muestra.csv (muestra problema).
# Recorrido: llegamos al espectrofotometro con los estandares de BSA ya preparados. Primera parada: resumir la absorbancia por concentracion. Segunda parada: comparar la recta con el polinomio. Tercera parada: cuantificar la muestra problema. En cada parada medimos, calculamos y comentamos que significa el resultado antes de seguir.
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# Protocolo (Manual de Practicas, Practica 3. Ensayo de Bradford)
# --------------------------------------------------------------------------
# Reactivo Bradford (manual): disolver 20 mg de Coomassie Brilliant Blue G-250 en 10 mL de etanol; una vez disuelto parcialmente el colorante, agregar 20 mL de acido fosforico al 85% (w/v) y agitar hasta disolverlo por completo; diluir a 200 mL con agua y almacenar por 3 meses a 4 C protegido de la luz. Antes de usarlo, centrifugar la solucion. El manual tambien pide usar la solucion de colorante a temperatura ambiente y filtrarla antes del ensayo, y trabajar en una placa de microtitulacion limpia.
# Paso 1. Preparar las muestras y los estandares en un volumen de 160 uL, con los estandares cubriendo el rango de 1.25 a 20 ug/mL segun la Tabla 1 del manual (ver la tabla de abajo). Utilizar una placa de microtitulacion limpia.
# Paso 2. Agregar 40 uL del reactivo Bradford (previamente filtrado) y agitar con mucho cuidado con la micropipeta, un microagitador o golpeando suavemente un lado de la placa.
# Paso 3. Incubar 5 min a temperatura ambiente.
# Paso 4. Medir la absorbancia de las muestras y los estandares a 595 nm.
# Paso 5. Disponer las muestras con reactivo Bradford donde indique el instructor.
# Nota del manual: el texto de la practica dice que los estandares cubren de 1.25 a 20 ug/mL, pero su Tabla 1 lista los estandares 0, 2.5, 5, 10 y 20 ug/mL (sin estandar de 1.25 ug/mL). Este repositorio usa la Tabla 1 del manual, como ya se indica en el README.
# Seguridad (manual): revisar la hoja de datos de seguridad (MSDS) del acido fosforico y conocer sus riesgos de manejo y contacto con la piel. El colorante Coomassie G-250 tiene baja estabilidad en solucion y se precipita continuamente: por eso se filtra y se centrifuga antes de usarlo.

# Tabla 1 del manual: curva de calibracion. Volumen de muestra mas agua: 160 uL; reactivo Bradford: 40 uL en todos los casos.
tabla_calibracion_manual <- tibble(
  estandar_BSA_0_1_mg_ml_uL = c(0, 0, 0, 4, 4, 4, 8, 8, 8, 16, 16, 16, 32, 32, 32),
  agua_uL = c(160, 160, 160, 156, 156, 156, 152, 152, 152, 144, 144, 144, 128, 128, 128),
  reactivo_bradford_uL = 40,
  BSA_ug = c(0, 0, 0, 0.4, 0.4, 0.4, 0.8, 0.8, 0.8, 1.6, 1.6, 1.6, 3.2, 3.2, 3.2),
  BSA_ug_ml = c(0, 0, 0, 2.5, 2.5, 2.5, 5, 5, 5, 10, 10, 10, 20, 20, 20)
)
print(tabla_calibracion_manual)

# --------------------------------------------------------------------------
# Parada 1. Leer los estandares y resumir por concentracion
# --------------------------------------------------------------------------
# Estamos frente al espectrofotometro a 595 nm. Leemos los estandares por triplicado y resumimos la absorbancia media con su desviacion estandar a cada concentracion.
datos <- read_csv("datos_bradford.csv", show_col_types = FALSE)

resumen <- datos %>%
  group_by(concentracion_ug_ml) %>%
  summarise(
    absorbancia_media = mean(absorbancia_595),
    de = sd(absorbancia_595),
    .groups = "drop"
  )

print(resumen)

# --------------------------------------------------------------------------
# Parada 2. Ajuste lineal y ajuste polinomial de segundo orden
# --------------------------------------------------------------------------
# Seguimos en el espectrofotometro: ajustamos la recta y el polinomio de segundo orden a los mismos datos y comparamos sus R2, para ver hasta donde la respuesta del colorante se mantiene lineal.
ajuste_lineal <- lm(absorbancia_595 ~ concentracion_ug_ml, data = datos)
ajuste_poli <- lm(absorbancia_595 ~ concentracion_ug_ml +
                    I(concentracion_ug_ml^2), data = datos)

print(summary(ajuste_lineal))
print(summary(ajuste_poli))

tabla_r2 <- tibble(
  modelo = c("Lineal", "Polinomial grado 2"),
  r_cuadrado = c(summary(ajuste_lineal)$r.squared,
                 summary(ajuste_poli)$r.squared)
)
print(tabla_r2)

# --------------------------------------------------------------------------
# Parada 3. Cuantificacion de la muestra problema con la recta
# --------------------------------------------------------------------------
# Ahora usamos la recta para cuantificar la muestra problema: su absorbancia medida se convierte en concentracion con la pendiente y la ordenada del ajuste.
muestra <- read_csv("datos_bradford_muestra.csv", show_col_types = FALSE)

muestra <- muestra %>%
  mutate(concentracion_ug_ml =
           (absorbancia_595 - coef(ajuste_lineal)[["(Intercept)"]]) /
           coef(ajuste_lineal)[["concentracion_ug_ml"]])

print(muestra)
print(muestra %>%
        summarise(concentracion_media = mean(concentracion_ug_ml),
                  de = sd(concentracion_ug_ml)))

# --------------------------------------------------------------------------
# Parada 4. Grafica: curva de calibracion
# --------------------------------------------------------------------------
# Graficamos la curva de calibracion: cada punto es la absorbancia media de un estandar con su barra de desviacion, y la linea es la recta ajustada.
grafica <- ggplot(
  resumen,
  aes(x = concentracion_ug_ml, y = absorbancia_media)
) +
  geom_errorbar(aes(ymin = absorbancia_media - de,
                    ymax = absorbancia_media + de),
                width = 0.5, linewidth = 0.6) +
  geom_point(size = 2.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  labs(
    x = "Concentracion de BSA (ug/mL)",
    y = "Absorbancia a 595 nm",
    title = "Bradford: curva de calibracion de BSA"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica)

# --------------------------------------------------------------------------
# 5. Exportar la grafica
# --------------------------------------------------------------------------
# Antes de salir del espectrofotometro guardamos la grafica del recorrido.
ggsave("03_bradford.png", grafica,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica (curva de calibracion de BSA): el eje x es la concentracion de BSA en ug/mL y el eje y es la absorbancia a 595 nm (adimensional).
# - La absorbancia sube con la concentracion de proteina en todo el intervalo de 0 a 20 ug/mL. Esto significa que el ensayo responde en todo el intervalo del manual, y por eso lo siguiente es usar la curva para cuantificar las muestras de las estaciones que siguen.
# - El polinomio de segundo orden ajusta un poco mejor que la recta, porque la respuesta del colorante no es perfectamente lineal. Esto significa que en los extremos del intervalo la recta se desvia un poco, y por eso conviene cuantificar dentro del intervalo donde la recta ajusta bien.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La curva de calibracion se construye cada vez que se cuantifica, con la misma proteina que se va a medir.
# - La recta convierte la absorbancia de una muestra en concentracion; el polinomio muestra hasta donde la linealidad alcanza.
# Terminamos el recorrido en el espectrofotometro: ya sabemos convertir una absorbancia en concentracion de proteina. Seguimos a la siguiente estacion del laboratorio: el tanque de precipitacion con sulfato de amonio, donde se aplica la ecuacion de Cohn a la albumina.
