Instrucciones
La página se abre en un navegador web compatible con tecnologías ASP.NET.

Los botones "Cursor" y "Tableta" permiten al usuario elegir el método de firma. Al hacer clic en uno de los botones, se inicia la funcionalidad correspondiente.

El usuario puede dibujar la firma en el canvas utilizando el método seleccionado.

Después de dibujar la firma, el usuario puede hacer clic en el botón "OK" para guardar la firma digital en un campo oculto. (Firmando con el cursor no es necesario presionar el boton "OK")

Luego, se puede hacer clic en el botón "Guardar" para guardar la firma en un archivo en el servidor.

Requisitos
Es necesario contar con el software de firma digital "SigWeb" instalado en el sistema para usar la funcionalidad de la tableta. Si no se detecta el software, se mostrará un mensaje de error.
Notas
El código incluye comentarios que explican las funciones y la lógica detrás de cada sección.

El código del lado del servidor (C#) se encarga de manejar los eventos y realizar operaciones como guardar la firma en un archivo.

El código JavaScript se utiliza para interactuar con el canvas de firma, controlar la funcionalidad de la tableta y verificar la instalación del software "SigWeb".

Instala SigWeb: https://topazsystems.com/sdks/sigweb.html
