
Paso 1: Configurar el entorno
Entorno sugerido: Debian 12 con GHC y Cabal.
Instala GHC y Cabal usando los repositorios oficiales o ghcup:

bash

sudo apt update
sudo apt install ghc cabal-install

Verifica las versiones instaladas:
bash

ghc --version
cabal --version

cabal update
cabal build


Ejecución del programa:

Una vez compilado, ejecuta el binario generado con el comando:
bash

cabal run midi-to-tabs jardín.mid salida.txt

Esto leerá jardín.mid y generará la tablatura en un archivo llamado salida.txt.
