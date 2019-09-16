#!/bin/bash



palabrasarchivo="/home/stephanie/Escritorio/PREBESHELL/Prebeshell/listaanimales"
inicio=0


Intentos=
respuesta=
pregunta=
numero_letras=()

checar_letras() {

    local e

    for e in "${@:1:1}"; do
        [[ "$e" == "$2" ]] && return $(true)
    done

    return $(false)
}

perder() {
    echo -e "Nopo, la respuesta es: $respuesta"
    echo -e "Gracias por participar.\n"
}

ganar() {

    if [[ "$pregunta" =~ _ ]]; then
        return $(false)
    fi

    echo -e "Sí! La respuesta es: $respuesta"

    local contador="${#numero_letras[@]}"
    local letr="letras"
    if [[ $contador> 1 ]]; then
        letr+="s"
    fi

    echo -e "Ganaste con $contador $letr."
    echo -e "Felicidades!\n"
}

preguntar() {

    respuesta=$(python -c "import random, sys; print random.choice(open(sys.argv[1]).readlines())" $palabrasarchivo)


    local i
    for (( i=0; i<${#respuesta}; i++ )); do
        if [[ "${respuesta:$i:1}" =~ [[:space:]] ]]; then
            pregunta+="  "
        else
            pregunta+="_ "
        fi
    done


    Intentos=$(( ${#respuesta} / 2 + 5 ))
}

esc_letras() {
    if [[ "${#numero_letras[*]}" > 0 ]]; then
        echo "${lnumero_letras[*]}"
    fi
}

esc_preguntas() {
    echo -e "\n\n\t$pregunta\n\n"
}

instruccion() {
    echo -en "Ingresa una letra "

    echo -e "$Intentos $int restantes."

}

bienvenido() {
    echo -e "Bienvenido!!!"
}

entusu() {
    local c="$entrada"
    local pos=()
    local i
    local ans=$(echo $respuesta | tr '[:upper:]' '[:lower:]')


    for (( i = 0; i < ${#respuesta}; i++ )); do
        if [ "${ans:$i:1}" = "$c" ]; then
            pos+=($i)
        fi
    done


    numero_letras+=($c)

    if [[ "${#pos}" = 0 ]]; then
        let Intentos-=1
        return
    fi


    local empezar
    local fin
    local p
    for (( i = 0; i < ${#pos[@]}; i++ )); do
        p=${pos[$i]}
        c=${respuesta:$p:1}
        empezar=$(( ${pos[$i]} * 2 ))
        fin=$(( empezar + 2 ))


        pregunta="${pregunta:0:$empezar}$c ${pregunta:fin}"
    done
}

checarentrada() {

    entrada=$(echo $entrada| tr '[:upper:]' '[:lower:]')

  
    if [[ "$entrada" =~ [^[:alpha:]] ]]; then
        echo "Por favor ingresa una letra."
        return $(false)
    fi

    if checar_letras "${numero_letras[@]}" "$entrada"; then
        esc_letras
        return $(false)
    fi
}


main() {
    bienvenido

    if [[ ! -f "$palabrasarchivo" ]]; then
        echo -e "\nError: Could not find words file \"$palabrasarchivo\".\n" >&2
        exit 1
    fi

    preguntar

    while true; do
        esc_preguntas

        if [ "$Intentos" = 0 ]; then
            break
        fi

        if ganar; then
            exit
        fi

        instruccion

        read -n 1 -e entrada

        if [ "$entrada" = "$inicio" ]; then
            break
        fi

        if ! checarentrada; then
            continue
        fi

        entusu

        esc_letras
    done

    perder
}

main
