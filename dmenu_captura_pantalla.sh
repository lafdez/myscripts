#!/bin/bash

declare -A opciones

opciones=( ["0"]="Y editar área"
             ["1"]="Área"
             ["2"]="Ventana"
             ["3"]="Monitor 26\""
             ["4"]="Monitor 27\"")

imprime_opciones() {
    for i in "${!opciones[@]}"; do
        echo "${opciones[$i]}"
    done
}

opcion=$(imprime_opciones | tac | rofi -dmenu -i -p "Capturar" -l 5 -theme-str 'window {width: 250;}')

for i in "${!opciones[@]}"; do
    if [[ "${opciones[$i]}" == "$opcion" ]]; then
        seleccion=$i
        break
    fi
done

directorio_guardado="$HOME/tmp"
fichero_salida="$directorio_guardado/captura_$(date +%Y%m%d_%H%M%S).png"

case $seleccion in
    0)
        sleep 0.2
        salida=$(scrot -s $fichero_salida 2>&1 && pinta $fichero_salida &)
        ;;
    1|2)
        sleep 0.2
        salida=$(scrot -s $fichero_salida 2>&1)
        ;;
    3)
        sleep 0.2
        salida=$(scrot -M 1 $fichero_salida 2>&1)
        ;;
    4)
        sleep 0.2
        salida=$(scrot -M 0 $fichero_salida 2>&1)
        ;;
    *)
        notify-send "Captura de pantalla" "Opción no válida"
        ;;
esac

if [ $? -eq 0 ]; then
    xclip -selection clip -t image/png $fichero_salida
    notify-send "Captura de pantalla" "Captura guardada en $fichero_salida"
else
    notify-send "Captura de pantalla" "Error al capturar: $salida"
fi

exit 0

