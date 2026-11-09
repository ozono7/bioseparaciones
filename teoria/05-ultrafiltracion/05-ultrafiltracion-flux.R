# ==========================================================================
# 05. Ultrafiltracion: flux contra presion y diafiltracion
# ==========================================================================
# Autor: Dr. Jose Juan Torres Martinez
# Docente de Ciencias Quimicas
# Universidad Autonoma de San Luis Potosi (UASLP)
# Mexico
#
# Material academico para estudiantes
# Serie "Bioseparaciones" - Teoria, Unidad 5. Ultrafiltracion
#
# Descripcion: Se analiza el flux medido contra la presion transmembrana (TMP): en la zona controlada por presion el flux es lineal y su pendiente es la permeabilidad hidraulica; a TMP alta el flux se estabiliza en el flux limite por polarizacion. Tambien se calcula la caida de sal en diafiltracion a volumen constante, C = C0 * exp(-Vd/V).
#
# Objetivos de aprendizaje:
#   - Calcular la permeabilidad hidraulica en la zona lineal.
#   - Identificar el flux limite por polarizacion de concentracion.
#   - Calcular cuantos volumenes de diafiltracion hacen falta para bajar la sal a un valor dado.

# Datos: datos_flux.csv (flux medido contra TMP) y datos_diafiltracion.csv (sal relativa medida contra volumenes de diafiltracion).
# ==========================================================================

library(tidyverse)

# --------------------------------------------------------------------------
# 1. Flux contra TMP: zona lineal y flux limite
# --------------------------------------------------------------------------
datos <- read_csv("datos_flux.csv", show_col_types = FALSE)

# Zona controlada por presion: los tres primeros puntos (TMP hasta 1.5 bar).
# J = Lp * TMP; la pendiente de la recta es Lp.
ajuste_lp <- lm(flux_L_m2_h ~ tmp_bar - 1,
                data = filter(datos, tmp_bar <= 1.5))
lp <- coef(ajuste_lp)[["tmp_bar"]]
print(tibble(permeabilidad_L_m2_h_bar = lp))

# Flux limite: media de los dos ultimos puntos, donde el flux ya no sube.
flux_limite <- datos %>%
  filter(tmp_bar >= 2.5) %>%
  summarise(flux_limite = mean(flux_L_m2_h)) %>%
  pull(flux_limite)
print(tibble(flux_limite_L_m2_h = flux_limite))

# --------------------------------------------------------------------------
# 2. Diafiltracion a volumen constante
# --------------------------------------------------------------------------
# Modelo: C/C0 = exp(-Vd/V), donde Vd/V es el numero de volumenes de
# diafiltracion. Se compara el modelo con la sal medida.
datos_dia <- read_csv("datos_diafiltracion.csv", show_col_types = FALSE)

datos_dia <- datos_dia %>%
  mutate(concentracion_sal_relativa_modelo =
           exp(-volumenes_diafiltracion))

print(datos_dia)

# Volumenes para bajar la sal al 1% del valor inicial: -ln(0.01).
print(tibble(volumenes_para_1_porciento = -log(0.01)))

# --------------------------------------------------------------------------
# 3. Grafica 1: flux contra TMP
# --------------------------------------------------------------------------
grafica_flux <- ggplot(datos, aes(x = tmp_bar, y = flux_L_m2_h)) +
  geom_hline(yintercept = flux_limite, linetype = "dashed") +
  geom_line(linewidth = 1) +
  geom_point(size = 2.5) +
  labs(
    x = "Presion transmembrana, TMP (bar)",
    y = "Flux (L/m2/h)",
    title = "Ultrafiltracion: flux contra TMP (flux limite marcado)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_flux)

# --------------------------------------------------------------------------
# 4. Grafica 2: sal relativa en diafiltracion
# --------------------------------------------------------------------------
grafica_dia <- ggplot(
  datos_dia,
  aes(x = volumenes_diafiltracion,
      y = concentracion_sal_relativa_medida)
) +
  geom_line(aes(y = concentracion_sal_relativa_modelo),
            linetype = "dashed", linewidth = 1) +
  geom_point(size = 2.5) +
  scale_y_log10() +
  labs(
    x = "Volumenes de diafiltracion (Vd/V)",
    y = "Sal relativa C/C0 (escala log)",
    title = "Diafiltracion: sal relativa (puntos medidos, linea modelo)"
  ) +
  theme_classic(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

print(grafica_dia)

# --------------------------------------------------------------------------
# 5. Exportar las graficas
# --------------------------------------------------------------------------
ggsave("05_flux.png", grafica_flux,
       width = 18, height = 12, units = "cm", dpi = 300)
ggsave("05_diafiltracion.png", grafica_dia,
       width = 18, height = 12, units = "cm", dpi = 300)

# --------------------------------------------------------------------------
# Interpretacion
# --------------------------------------------------------------------------
# - El flux sube lineal con la TMP hasta 1.5 bar y luego se estabiliza cerca del flux limite: subir mas la presion ya no aumenta el flux.
# - La sal cae de forma exponencial con los volumenes de diafiltracion; los puntos medidos siguen el modelo C = C0 * exp(-Vd/V).

# --------------------------------------------------------------------------
# Que aprendimos
# --------------------------------------------------------------------------
# - La permeabilidad hidraulica sale de la pendiente en la zona lineal y el flux limite de la zona plana.
# - La diafiltracion lava la sal sin concentrar la proteina, y el modelo dice cuantos volumenes hacen falta para un objetivo dado.
