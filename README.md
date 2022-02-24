# Sistema de Segmentación y Reconocimiento de Matrículas

:computer: Proyecto práctico para la asignatura Visión por Computador   
:school: Universidad de Huelva  
:books: Curso 2020-2021

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.55.15.png"/>

---
# Objetivo del trabajo
- Implementar un algoritmo que segmente y reconozca cada uno de los números
y letras que componen las imágenes de placas de matrículas.
- Como entradas deberá recibir una cadena de texto con el nombre del archivo de la imagen a tratar y el número total de letras y número presentes en la matrícula
- Como salida, una ventana tipo figure, con el resultado del reconocimiento como título y sobre la imagen original, representar el centroide de cada carácter y su BoundingBox.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.55.38.png"/>

---

# Fase 1: Segmentación de placa de la matrícula

## Objetivo
- Implementar un algoritmo que segmente la placa de una matrícula.
- Se partirá de una imagen a color.
- El resultado será una imagen recortada que contendrá la información e la placa de la matrícula.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.55.53.png"/>

## Metodología
- **Obtención de la imagen de trabajo**: Donde reduciremos la imagen y haremos una serie de transformaciones para poder utilizar durante el proceso, imágenes homogéneas entre las diferentes imágenes de matriculas.
- **Detección de contornos horizontales de la matrícula**: Mediante el uso de diferentes máscaras, filtros y suavizado; hallaremos el valor correspondiente a la fila superior y la fila inferior, del contorno de la matricula, en la imagen reducida.
- **Detección de contornos verticales de la matrícula**: Mediante el uso de máscaras, la apertura morfológica, y suavizado; encontraremos el valor correspondiente a las columnas del contorno de la imagen reducida.
- **Segmentación de la placa de la matrícula**: Al haber trabajado con una imagen reducida, debemos encontrar la correspondencia con la imagen original. Una vez hallados las nuevos valores, segmentar la zona comprendida entre las filas y columnas seleccionadas. Ya hemos obtenido la imagen solución para el proceso.

## Obtención de imagen de trabajo
- Primero reducimos la imagen a 120 columnas, para que siempre trabajemos con el mismo número entre una imagen y otra.
- A partir de la imagen de intensidad, aplicamos una transformación logarítmica, con el objetivo de reducir el rango dinámico y homogeneizar la imagen.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.56.20.png"/>

## Detección de contornos horizontales
- Aplicamos una máscara horizontal de bordes de Prewitt, y trabajaremos con la magnitud de bordes verticales.
- Aplicamos un filtro de orden, donde seleccionaremos el percentil 80 de la ventana, en este caso una vecindad de 3 filas y 24 columnas.
- Calculamos las proyecciones verticales, mediante la media de las columnas por cada fila, más tarde suavizamos mediante el uso de una media móvil.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.57.19.png"/>

- Tenemos que encontrar las posiciones de los dos máximos los suficientemente separados para que correspondan a distantas zonas de la imagen, así como el mínimo entre ellos.
- Para el primer máximo, bastará con calcular el valor máximo del vector suavizado.
- Para el segundo valor lo calcularemos a partir de la siguiente fórmula propocionada: [(f - $f_{max1})^2$ * Vector_PSuav(f)]
 
 <img src="Capturas/Captura de pantalla 2022-02-24 a las 13.16.50.png"/>

- Seleccionamos de los dos máximos, el perteneciente a la placa de la matrícula, mediante un criterio especificado en el enunciado.
- Una vez conocido el máximo descartado, asignamos el valor mínimo hasta el principio o hasta el final, dependiendo de si la fila del máximo descartado es inferior o superior a la fila del máximo descartado.
 
 <img src="Capturas/Captura de pantalla 2022-02-24 a las 11.57.33.png"/>

 - Encontramos las filas que limitan la matricuta. Para ello aplicamos un umbral el cual es calculado como el 60% del valor del máximo del vector suavizado. Las posiciones de interés serán la primera y la última fila que satisfacen este umbral.

 <img src="Capturas/Captura de pantalla 2022-02-24 a las 13.20.05.png"/>

 ## Detección de contornos verticales
 - El primer paso a realizar es igual que en el proceso anterior, haremos uso de la máscara de Prewitt.
 - Aplicaremos una apertura morfologica con vecindad vertical para realzar las contribuciones de bordes verticales.
 - Calcularemos las proyecciones horizontales, como la media de las filas por cada columna y suavizaremos una vez más con el método de la media móvil, con una ventana de amplitud 3.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.57.44.png"/>

- Buscamos las columnas significativas, como aquellas que presentan un valor más alto que el valor medio, este valor medio es calculado descartando el 10% de las contribuciones más bajas.
- Mediante el criterio facilitado en el enunciado, creamos un conjunto de columnas candidatas, que formaban parte del anterior conjunto de significativas.
- Escogeremos las columnas que limitan la matricula, como la primera y la ultima que satisfacen el apartado anterior.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.57.57.png"/>

## Segmentación de la placa de la matrícula
- En el proceso anterior hemos calculado tanto las filas como las columnas, con respecto a la imagen reducida, pero guardando el factor de reducción, fácilmente podremos calcular el valor de las filas y columnas de la imagen a tamaño original.
- Para facilitar el proceso posterior de segmentación de caracteres, hemos reducido las columnas en una cincuenteava parte.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 13.29.34.png"/>

---

# Fase 2: Segmentación de caracteres
## Objetivo
- Segmentar en la imagen original los píxeles que integran cada carácter de la matrícula y obtener la región compuesta por el mínimo rectángulo más pequeño que delimita dichos píxeles (BoundingBox).
- Las segmentaciones siempre se expresarán a través de matrices binarias cuyos valores serán 0’s para los pixeles de fondo y 1’s para los pixeles que forman parte del carácter.
 
 <img src="Capturas/Captura de pantalla 2022-02-24 a las 11.58.36.png"/>

 ## Diseño
- El algoritmo de segmentación ha sido desarrollado teniendo en cuenta
exclusivamente las imágenes facilitadas en: */Material_Imagenes_Plantillas/01_Training* 

- Se nos ha informado de que estas imágenes reúnen toda la casuística exigida:
    -  Diferentes condiciones de iluminación y defectos.
    - Ruido y suciedad.
    - Caracteres de interés situados en posiciones cercanas.
    - Pequeñas agrupaciones de pixeles de carácter con valores anómalos.

- La estrategia y metodología ha sido escogido en función de estas imágenes:
 
  <img src="Capturas/Captura de pantalla 2022-02-24 a las 11.58.51.png"/>

  ## Metodología
- **Binarización**: Separar entre pixeles de fondo y pixeles candidatos a formar parte.
- **Limpieza de la imagen binaria**: Eliminar las agrupaciones de pixeles que se puedan considerar como ruido.
- **Etiquetado de agrupaciones**: Proceso de identificación de agrupaciones, entre las que se encontraran los caracteres, a cada agrupación le asignamos un identificador.
- **Aplicar criterio de segmentación**: Donde descartaremos las agrupaciones de pixeles que no sean caracteres, obtendremos una imagen binaria que contendrá todos los pixeles que forman parte de los caracteres.
- **Generar los BoundingBox individuales de cada carácter detectado**: Generar las regiones compuestas por el rectángulo más pequeño que contiene todos los pixeles que forman el carácter.

## Binarización
- Realizamos una binarización mediante detección de umbral basada en
histograma, concretamente con el Método de OTSU.
- Método de OTSU: Elige un umbral que minimiza la varianza intraclase de los píxeles en blanco y negro.
- Como entrada a esta función, necesitamos una imagen de intensidad.
- La salida será el umbral que permitirá dividir la imagen en dos clases, el conjunto de pixeles que tengan un valor de intensidad menor al umbral y el conjunto de pixeles que tengan un nivel de intensidad mayor a igual.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.59.05.png"/>

## Limpieza de ruido
- Para limpiar el ruido de la imagen optaremos por, eliminar todos los componentes conectados, es decir las agrupaciones de píxeles que consideremos como ruido.
- Para considerar una agrupación como ruido, debe cumplir que:
    - El área es menor que el 0.1% del total de píxeles.
    - El área es menor que el valor de un quinto de la mayor agrupación.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.59.17.png"/>

## Etiquetado de agrupaciones
- Para etiquetar, partimos de una Imagen binaria, donde los 0’s representan el fondo y los 1’s representan los pixeles de interés.
- Recorremos de izquierda a derecha y de arriba hacia abajo, ya que nos interesa que los las etiquetas de los caracteres estén ordenados en ese sentido (en la matricula aparecen de izquierda a derecha).
- Cuando encontramos un pixel a 1, asignamos un identificador, comprobamos sus vecindad tipo 4, es decir, los pixeles conexos: superior, inferior, derecho e izquierdo; y a esos pixeles conectados le asignamos el mismo identificador. Así obtendremos que por cada agrupación, todos los pixeles que al forman tienen el mismo valor.
 
 <img src="Capturas/Captura de pantalla 2022-02-24 a las 11.59.31.png"/>

- Como entrada a la función hemos usado la imagen binaria limpiada.
- Como salida tendremos una matriz de las mismas dimensiones donde todos los pixeles de cada agrupación tendrán el mismo valor (etiqueta), y están ordenados de izquierda a derecha.
- Opcionalmente se puede usar la función_colorea_etiquetas para ver en diferentes colores las etiquetas reconocidas en la imagen.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 11.59.47.png"/>

 ## Criterio de segmentación
 Analizando la componente roja de cada una de las imágenes, se cumple:
- Las líneas horizontales de los tercios de la imagen contiene al menos un pixel de los caracteres (NumObjetos) que pretende segmentar.
- Los caracteres están presentes en los NumObjetos+1 detectados, con mayor área y detectados en la línea central.
- De esos objetos detectados se debe descartar el de la izquierda, ya que es el logo de la Unión Europea, presente en todas las matriculas.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.00.09.png"/>

## Generar BoundigBox
- Para cada etiqueta encontrada, buscamos el rectángulo de menor tamaño que contenga todos los pixeles que forman a la agrupación. Haremos uso de la función regionprops de Matlab en su modo BoudingBox.
- Como entrada a dicha función usaremos una matriz binaria de las mismas dimensiones que la imagen, donde solo se encontrarán a 1 los pixeles del carácter en cuestión.
- Como salida tendremos las coordenadas del punto superior izquierdo del rectángulo, junto con su largo y ancho. Por lo que nos será muy fácil hallar los 3 puntos restantes.
- Por ultimo solo tendremos que generar una matriz de las mimas dimensiones que el BoundingBox y centrarla en el carácter.

<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.00.41.png"/>

## Resultados
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.01.04.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.01.20.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.01.45.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.02.05.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.02.16.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.02.28.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.02.40.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.02.56.png"/>
<img src="Capturas/Captura de pantalla 2022-02-24 a las 12.03.25.png"/>

---

# Fase 3: Reconocimiento de caracteres