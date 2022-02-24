# Sistema de Segmentación y Reconocimiento de Matrículas

:computer: Proyecto práctico para la asignatura Visión por Computador   
:school: Universidad de Huelva  
:books: Curso 2020-2021

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.55.15.png" width="800px"/>

---
# Objetivo del trabajo
- Implementar un algoritmo que segmente y reconozca cada uno de los números
y letras que componen las imágenes de placas de matrículas.
- Como entradas deberá recibir una cadena de texto con el nombre del archivo de la imagen a tratar y el número total de letras y número presentes en la matrícula
- Como salida, una ventana tipo figure, con el resultado del reconocimiento como título y sobre la imagen original, representar el centroide de cada carácter y su BoundingBox.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.55.38.png" width="400px"/>

---

# Fase 1: Segmentación de placa de la matrícula

## Objetivo
- Implementar un algoritmo que segmente la placa de una matrícula.
- Se partirá de una imagen a color.
- El resultado será una imagen recortada que contendrá la información e la placa de la matrícula.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.55.53.png" width="500px"/>

## Metodología
- Obtención de la imagen de trabajo: Donde reduciremos la imagen y haremos una serie de transformaciones para poder utilizar durante el proceso, imágenes homogéneas entre las diferentes imágenes de matriculas.
- Detección de contornos horizontales de la matrícula: Mediante el uso de diferentes máscaras, filtros y suavizado; hallaremos el valor correspondiente a la fila superior y la fila inferior, del contorno de la matricula, en la imagen reducida.
- Detección de contornos verticales de la matrícula: Mediante el uso de máscaras, la apertura morfológica, y suavizado; encontraremos el valor correspondiente a las columnas del contorno de la imagen reducida.
- Segmentación de la placa de la matrícula: Al haber trabajado con una imagen reducida, debemos encontrar la correspondencia con la imagen original. Una vez hallados las nuevos valores, segmentar la zona comprendida entre las filas y columnas seleccionadas. Ya hemos obtenido la imagen solución para el proceso.

## Obtención de imagen de trabajo
- Primero reducimos la imagen a 120 columnas, para que siempre trabajemos con el mismo número entre una imagen y otra.
- A partir de la imagen de intensidad, aplicamos una transformación logarítmica, con el objetivo de reducir el rango dinámico y homogeneizar la imagen.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.56.20.png" width="500px"/>

## Detección de contornos horizontales
- Aplicamos una máscara horizontal de bordes de Prewitt, y trabajaremos con la magnitud de bordes verticales.
- Aplicamos un filtro de orden, donde seleccionaremos el percentil 80 de la ventana, en este caso una vecindad de 3 filas y 24 columnas.
- Calculamos las proyecciones verticales, mediante la media de las columnas por cada fila, más tarde suavizamos mediante el uso de una media móvil.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.57.19.png" width="500px"/>

- Tenemos que encontrar las posiciones de los dos máximos los suficientemente separados para que correspondan a distantas zonas de la imagen, así como el mínimo entre ellos.
- Para el primer máximo, bastará con calcular el valor máximo del vector suavizado.
- Para el segundo valor lo calcularemos a partir de la siguiente fórmula propocionada: [(f - $f_{max1})^2$ * Vector_PSuav(f)]
 
 <img src="Capturas/Captura de pantalla 2022-02-24 a las 13.16.50.png" width="500px"/>

- Seleccionamos de los dos máximos, el perteneciente a la placa de la matrícula, mediante un criterio especificado en el enunciado.
- Una vez conocido el máximo descartado, asignamos el valor mínimo hasta el principio o hasta el final, dependiendo de si la fila del máximo descartado es inferior o superior a la fila del máximo descartado.
 
 <img src="Capturas/Captura de pantalla 2022-02-24 a las 11.57.33.png" width="500px"/>

 - Encontramos las filas que limitan la matricuta. Para ello aplicamos un umbral el cual es calculado como el 60% del valor del máximo del vector suavizado. Las posiciones de interés serán la primera y la última fila que satisfacen este umbral.

 <img src="Capturas/Captura de pantalla 2022-02-24 a las 13.20.05.png" width="500px"/>

 ## Detección de contornos verticales
 - El primer paso a realizar es igual que en el proceso anterior, haremos uso de la máscara de Prewitt.
 - Aplicaremos una apertura morfologica con vecindad vertical para realzar las contribuciones de bordes verticales.
 - Calcularemos las proyecciones horizontales, como la media de las filas por cada columna y suavizaremos una vez más con el método de la media móvil, con una ventana de amplitud 3.