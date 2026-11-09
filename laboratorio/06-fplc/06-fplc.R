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
# Descripcion: Recorrido por el laboratorio de la planta, estacion 6: el equipo FPLC (BioLogic LP). Aqui se reconstruye el registro del equipo durante la carga de niquel y el equilibrio de la columna: absorbancia a 280 nm y conductividad contra tiempo, con flujo de 0.5 mL/min. El volumen acumulado se calcula de cero como flujo por tiempo, y cada fase del protocolo se identifica en el registro. Lo que se aprende aqui es a leer el registro del equipo: que detector sigue a la proteina y cual sigue a las sales, y donde empieza cada fase.
#
# Objetivos de aprendizaje:
#   - Identificar cada fase del protocolo en el registro del FPLC.
#   - Calcular el volumen acumulado a partir del flujo y el tiempo.
#   - Leer la conductividad como senal del cambio de buffer.

# Datos: datos_fplc.csv (absorbancia a 280 nm y conductividad registradas contra tiempo; flujo 0.5 mL/min).
# Recorrido: llegamos al equipo FPLC, con su modulo de mezclado, sus detectores y su colector de fracciones. Primera parada: el registro completo con el volumen acumulado calculado de cero. Segunda y tercera parada: las graficas de absorbancia y de conductividad contra volumen. En cada parada leemos el registro y comentamos que significa antes de seguir.
# ==========================================================================

library(tidyverse)

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
# Nota: en esta practica todavia no se carga proteina: el registro que analiza este script es el de la preparacion de la columna (lavado, carga de niquel, equilibrio y lavado acido), con flujo de 0.5 mL/min durante 40 min y 20.0 mL acumulados.
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

# Aqui resumimos la conductividad y la absorbancia medias por fase: ese resumen dice que solucion estaba pasando en cada tramo del registro.
# Conductividad media por fase.
print(datos %>%
        group_by(fase) %>%
        summarise(conductividad_media = mean(conductividad_mS_cm),
                  absorbancia_280_media = mean(absorbancia_280),
                  .groups = "drop"))

# --------------------------------------------------------------------------
# Parada 2. Grafica 1: absorbancia a 280 nm contra volumen
# --------------------------------------------------------------------------
# Graficamos la absorbancia a 280 nm contra el volumen acumulado, con cada fase en un color: asi se ve si pasa proteina por el detector en la preparacion.
grafica_uv <- ggplot(
  datos,
  aes(x = volumen_ml, y = absorbancia_280, color = fase)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Absorbancia a 280 nm",
    color = "Fase",
    title = "FPLC: absorbancia a 280 nm durante la preparacion"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_uv)

# --------------------------------------------------------------------------
# Parada 3. Grafica 2: conductividad contra volumen
# --------------------------------------------------------------------------
# Seguimos a la segunda grafica: la conductividad contra el volumen acumulado, con cada fase en un color. Aqui se ve cada cambio de solucion del protocolo.
grafica_cond <- ggplot(
  datos,
  aes(x = volumen_ml, y = conductividad_mS_cm, color = fase)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    x = "Volumen acumulado (mL)",
    y = "Conductividad (mS/cm)",
    color = "Fase",
    title = "FPLC: conductividad durante la preparacion"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_cond)

# --------------------------------------------------------------------------
# 4. Exportar las graficas
# --------------------------------------------------------------------------
# Antes de salir del equipo FPLC guardamos las dos graficas del recorrido.
ggsave("06_fplc_uv.png", grafica_uv,
       width = 20, height = 12, units = "cm", dpi = 300)
ggsave("06_fplc_conductividad.png", grafica_cond,
       width = 20, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# Grafica 1 (absorbancia a 280 nm contra volumen): el eje x es el volumen acumulado en mL y el eje y es la absorbancia a 280 nm (adimensional).
# - La absorbancia a 280 nm se mantiene en la linea base: en esta practica todavia no se carga proteina. Esto significa que el detector UV no ve proteina durante la preparacion, y por eso lo siguiente, en la practica de IMAC, es cargar la albumina y ver su pico.
# Grafica 2 (conductividad contra volumen): el eje x es el volumen acumulado en mL y el eje y es la conductividad en mS/cm.
# - La conductividad marca cada cambio de solucion: sube con la llegada del niquel y del buffer de adsorcion con 500 mM NaCl, y cambia de nuevo con el acido. Esto significa que el detector de conductividad sigue a las sales del buffer, y con el se sabe en que fase del protocolo esta la columna en cada momento.

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - El detector UV sigue a la proteina y el de conductividad sigue a las sales del buffer.
# - El volumen acumulado sale del flujo por el tiempo y permite ubicar cada fase en el cromatograma.
# Terminamos el recorrido en el equipo FPLC: ya sabemos leer su registro y preparar la columna. Seguimos a la siguiente estacion del laboratorio: la columna de IMAC con niquel, donde la albumina se retiene y se desorbe.
