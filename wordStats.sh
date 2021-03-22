#!/usr/bin/env bash
mode=$1
file=$2
iso=$3
n=$WORD_STATS_TOP

[[ $# -eq 0 ]] && echo "[ERROR] insufficient parameters" && exit 1

case $mode in
    c | C)
        if [[ -f "$file" ]]; then
            [[ -z $WORD_STATS_TOP ]] && n=10
            sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -n $n > result---$file.txt
        else
            echo "[ERROR] can't find file '$file'"
            exit 1
        fi
        ;;

    p | P)
        #APRENSETAR GRÁFICO
        ;;

    t | T)
        if [[ -f "$file" ]]; then
            echo -e "[INFO] Processing '$file'"
            case $mode in
                t)
                    echo -e "STOP WORDS will be filtered out"
                    #FILTRAR A CONTAGEM DE STOP WORDS
                    case $iso in
                        pt)
                            echo -e "StopWords file 'pt': 'StopWords/pt.stop_words.txt' (205 words)"
                            ;;
                        en)
                            echo -e "StopWords file 'en': 'StopWords/en.stop_words.txt' (205 words)"
                            ;;
                        *)
                            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en': 'StopWords/en.stop_words.txt' (205 words)"
                            ;;
                    esac
                    ;;

                T)
                    echo -e "STOP WORDS will be counted"
                    ;;
            esac

            if [[ -z $WORD_STATS_TOP ]]; then
                echo -e "Environment variable 'WORD_STATS_TOP' is empty (using default 10)"
                n=10
            else
                echo -e "WORD_STATS_TOP=${n}"
            fi

            echo -e "-------------------------------------\n# TOP ${n} elements"
            sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -n $n
            echo -e "-------------------------------------"
        else
            echo "[ERROR] can't find file '$file'"
            exit 1
        fi
        ;;
    *)
        echo -e "[ERROR] unknown command '$mode'"
        exit 1
        ;;
esac

exit 0
