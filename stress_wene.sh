#!/bin/bash

# Función para generar un hash aleatorio de longitud 6 (puedes cambiar la longitud si lo necesitas)
generate_random_hash() {
    echo "$(head /dev/urandom | tr -dc 'a-f0-9' | head -c 6)"
}

# URL base
url_base="https://wene.fi.uncoma.edu.ar/certificado/view?hash="

# Carpeta para almacenar los PDFs descargados
output_folder="./certificados"

# Crear el directorio de salida si no existe
mkdir -p "$output_folder"

# Número de hashes aleatorios que deseas generar
num_hashes=50  # Cambia este valor según tus necesidades
num_hashes=$1  # Cambia este valor según tus necesidades

# Iterar sobre el número de hashes aleatorios
for ((i=1; i<=num_hashes; i++)); do
    # Generar un hash aleatorio
    random_hash=$(generate_random_hash)
    
    # Generar la URL completa
    url="${url_base}${random_hash}&pdf=1"
    
    # Nombre del archivo PDF temporal
    temp_file="/tmp/${random_hash}.pdf"

    # Nombre del archivo PDF final en el directorio de salida
    output_file="${output_folder}/${random_hash}.pdf"
    
    # Mostrar el progreso
    echo "Descargando certificado para hash: $random_hash"

    # Descargar el archivo PDF temporalmente
    curl -s -o "$temp_file" "$url"

    # Verificar si el archivo descargado es un PDF válido (el encabezado de un archivo PDF comienza con '%PDF-')
    if head -c 4 "$temp_file" | grep -q "%PDF"; then
        # Si es válido, mover el archivo a la carpeta final
        mv "$temp_file" "$output_file"
        echo "Certificado guardado en: $output_file"
    else
        # Si no es válido, eliminar el archivo temporal
        echo "El archivo descargado no es un PDF válido para hash: $random_hash"
        rm "$temp_file"
    fi
done

echo "Pruebas de rendimiento completadas."

