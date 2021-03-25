#!/usr/bin/env bash
mode=$1
file=$2
iso=$3
n=$WORD_STATS_TOP

[[ $# -eq 0 ]] && echo "[ERROR] insufficient parameters" && exit 1

# Converts PDF to TXT
if [ `echo "$file" | cut -d'.' -f2` == pdf ]; then
#if [[ $file == *.pdf ]]; then
  pdftotext $file $file.txt
  file=$file.txt
fi

case $mode in
    c | C)
        if [[ -f "$file" ]]; then
                filename="result---$file"
            echo -e "[INFO] Processing '${file}'"
            case $mode in
                c)
                    echo -e "STOP WORDS will be filtered out"
                        #Associa à variável stopwords o caminho do ficheiro que contêm as stopwords consoante o iso escolhido
                        if [[ -z $iso || $iso = "en" ]]; then
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        elif [[ $iso = "pt" ]]; then
                            stopwords="stopwords/pt.stop_words.txt"
                        else
                            #Se o iso for diferente de pt ou en, por defeito é utilizado o iso en
                            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en'"
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        fi
                        #Verifica se existem stopwords no ficheiro, excluindo as mesmas, e guarda o novo ficheiro na diretoría tmp
                        sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' > tmp/$file.tmp
                        grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                    ;;
                C)
                    echo -e "STOP WORDS will be counted"
                    ;;
            esac

            #Verifica se existe o ficheiro new_$file.tmp, ou seja, o ficheiro que contêm a lista sem as stopwords
            if [[ -f "tmp/new_$file.tmp" ]]; then
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
        if [[ -f "$file" ]]; then
                filename="result---$file.dat"
            echo -e "[INFO] Processing '$file'"
            case $mode in
                p)
                    echo -e "STOP WORDS will be filtered out"
                        #Associa à variável stopwords o caminho do ficheiro que contêm as stopwords consoante o iso escolhido
                        if [[ -z $iso || $iso = "en" ]]; then
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        elif [[ $iso = "pt" ]]; then
                            stopwords="stopwords/pt.stop_words.txt"
                        else
                            #Se o iso for diferente de pt ou en, por defeito é utilizado o iso en
                            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en'"
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        fi
                        #Verifica se existem stopwords no ficheiro, excluindo as mesmas, e guarda o novo ficheiro na diretoría tmp
                        sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' > tmp/$file.tmp
                        grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                        echo -e "StopWords file '$iso': '$(echo "$stopwords")' ($(wc -l "$stopwords" | tr " " '\n' | head -n 1) words)"
                    ;;
                P)
                    echo -e "STOP WORDS will be counted"
                    ;;
            esac

            #Caso a variável de ambiente WORD_STATS_TOP não for definida usa-se o número default de 10
            if [[ -z $WORD_STATS_TOP ]]; then
                echo -e "Environment variable 'WORD_STATS_TOP' is empty (using default 10)"
                n=10
            else
                echo -e "WORD_STATS_TOP=${n}"
            fi

            if [[ -f "tmp/new_$file.tmp" ]]; then
                sort tmp/new_$file.tmp | uniq -c | sort -nr | nl | head -n $n > $filename
                #Após a listagem da orrência de palavras os ficheiros são tmp são eliminados
                rm tmp/new_$file.tmp && rm tmp/$file.tmp
            else
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -n $n > $filename
            fi

            ls -la | grep $filename
            echo -e "-------------------------------------\n# TOP ${n} elements"
            cat $filename
            echo -e "-------------------------------------"
                        
            # Creates the graphic png
            printf "set terminal png\nset output \"$filename.png\"\nset boxwidth 0.5\nset style fill solid\nplot \"$filename\" using 1:2:xtic(3) with boxes" > bar.gnuplot
            gnuplot < bar.gnuplot
            display $filename.png
            printf "<img src=\"$filename.png\">" > $filename.html

    else
        echo "[ERROR] can't find file '$file'"
        exit 1
    fi
        ;;

    t | T)
        if [[ -f "$file" ]]; then
                filename="result---$file.dat"
            echo -e "[INFO] Processing '$file'"
            case $mode in
                t)
                    echo -e "STOP WORDS will be filtered out"
                        #Associa à variável stopwords o caminho do ficheiro que contêm as stopwords consoante o iso escolhido
                        if [[ -z $iso || $iso = "en" ]]; then
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        elif [[ $iso = "pt" ]]; then
                            stopwords="stopwords/pt.stop_words.txt"
                        else
                            #Se o iso for diferente de pt ou en, por defeito é utilizado o iso en
                            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en'"
                            stopwords="stopwords/en.stop_words.txt"
                            iso='en'
                        fi
                        #Verifica se existem stopwords no ficheiro, excluindo as mesmas, e guarda o novo ficheiro na diretoría tmp
                        sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' > tmp/$file.tmp
                        grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                        echo -e "StopWords file '$iso': '$(echo "$stopwords")' ($(wc -l "$stopwords" | tr " " '\n' | head -n 1) words)"
                    ;;
                T)
                    echo -e "STOP WORDS will be counted"
                    ;;
            esac

            #Caso a variável de ambiente WORD_STATS_TOP não for definida usa-se o número default de 10
            if [[ -z $WORD_STATS_TOP ]]; then
                echo -e "Environment variable 'WORD_STATS_TOP' is empty (using default 10)"
                n=10
            else
                echo -e "WORD_STATS_TOP=${n}"
            fi

            if [[ -f "tmp/new_$file.tmp" ]]; then
                sort tmp/new_$file.tmp | uniq -c | sort -nr | nl | head -n $n > $filename
                #Após a listagem da orrência de palavras os ficheiros são tmp são eliminados
                rm tmp/new_$file.tmp && rm tmp/$file.tmp
            else
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -n $n > $filename
            fi

            ls -la | grep $filename
            echo -e "-------------------------------------\n# TOP ${n} elements"
            cat $filename
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
