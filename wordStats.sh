#!/usr/bin/env bash
mode=$1
file=$2
iso=$3
n=$WORD_STATS_TOP

[[ $# -eq 0 ]] && echo "[ERROR] insufficient parameters" && exit 1

case $mode in
    c | C)
        if [[ -f "$file" ]]; then
            #Remover a extensão do ficheiro caso o mesmo seja .txt
            if [[ $file == *.txt ]]; then
                filename="result---$file"
            else
                filename="result---$file.txt"
            fi
            echo -e "[INFO] Processing '${file}'"
            case $mode in
                c)
                    echo -e "STOP WORDS will be filtered out"
                        #Associa à variável stopwords o caminho do ficheiro que contêm as stopwords consoante o iso escolhido
                        if [[ -z $iso || $iso = "en" ]]; then
                            stopwords="stopwords/en.stop_words.txt"
                        elif [[ $iso = "pt" ]]; then
                            stopwords="stopwords/pt.stop_words.txt"
                        else
                            #Se o iso for diferente de pt ou en, por defeito é utilizado o iso en
                            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en'"
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        fi
                    ;;
                C)
                    echo -e "STOP WORDS will be counted"
                    ;;
            esac

            #Verifica se existe o ficheiro new_$file.tmp, ou seja, o ficheiro que contêm a lista sem as stopwords
            if [[ -f "tmp/new_$file.tmp" ]]; then
                #Verifica se existem stopwords no ficheiro, excluindo as mesmas, e guarda o novo ficheiro na diretoría tmp
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' > tmp/$file.tmp
                grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                echo -e "StopWords file '$iso': '$(echo "$stopwords")' ($(wc -l "$stopwords" | tr " " '\n' | head -n 1) words)\nCOUNT MODE"
                sort tmp/new_$file.tmp | uniq -c | sort -nr | nl > $filename
                #Após a listagem da orrência de palavras os ficheiros são tmp são eliminados
                rm tmp/new_$file.tmp && rm tmp/$file.tmp
            else
                echo -e "COUNT MODE"
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl > $filename
            fi

            cat $filename | more
            echo -e "RESULTS: '$filename'"
            ls -la | grep $filename
            echo -e "$(wc -l "$filename" | tr " " '\n' | head -n 1) distinct words"
        else
            echo "[ERROR] can't find file '$file'"
            exit 1
        fi
        ;;

    p | P)
        #APRESENTAR GRÁFICO
        ;;

    t | T)
        if [[ -f "$file" ]]; then
            echo -e "[INFO] Processing '$file'"
            case $mode in
                t)
                    echo -e "STOP WORDS will be filtered out"
                        #Associa à variável stopwords o caminho do ficheiro que contêm as stopwords consoante o iso escolhido
                        if [[ -z $iso || $iso = "en" ]]; then
                            stopwords="stopwords/en.stop_words.txt"
                        elif [[ $iso = "pt" ]]; then
                            stopwords="stopwords/pt.stop_words.txt"
                        else
                            #Se o iso for diferente de pt ou en, por defeito é utilizado o iso en
                            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en'"
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        fi
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
