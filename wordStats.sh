#!/usr/bin/env bash
mode=$1
file=$2
iso=$3
n=$WORD_STATS_TOP

[[ $# -eq 0 ]] && echo "[ERROR] insufficient parameters" && exit 1

#Check if the file exists and his extension. If it is PDF it converts to TXT
if [[ -f "$file" ]]; then
    if [[ $file == *.pdf ]]; then
        echo -e "'$file': PDF file"; echo -e "[INFO] Processing '${file}'"
        pdftotext $file $file.txt && file=$file.txt && filename="result---$file"
    elif [[ $file == *.txt ]]; then
        echo -e "'$file': TXT file"; echo -e "[INFO] Processing '${file}'"
        filename="result---$file"
    fi
elif [[ -z $file ]]; then
    echo "[ERROR] no file selected"
    exit 1
else
    echo "[ERROR] can't find file '$file'"
    exit 1
fi

#Check if ISO is set and covert string to lowercase
if [[ -n $iso ]]; then
    iso=$(echo $iso | tr '[:upper:]' '[:lower:]')
    case $iso in
        pt)
            stopwords="stopwords/pt.stop_words.txt"
            ;;
        en)
            stopwords="stopwords/en.stop_words.txt"
            ;;
        *)
            echo -e "ISO3166 '$iso' not supported. Using default ISO3166 format 'en'"
            stopwords="stopwords/en.stop_words.txt"
            iso='en'
            ;;
    esac
fi

case $mode in
    c | C)
        case $mode in
            c)
                #Check if theres any stopwords in the file and creates a tmp file with a list of words without the them
                echo -e "STOP WORDS will be filtered out"; echo -e "StopWords file '$iso': '$(echo "$stopwords")' ($(wc -l "$stopwords" | tr " " '\n' | head -n 1) words)"
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| sed -e 's/\(.*\)/\L\1/' > tmp/$file.tmp && grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                ;;
            C)
                echo -e "STOP WORDS will be counted"
                ;;
        esac

        #Check if exists the file new_$file, which is the one with the list of words without the stopwords
        if [[ -f "tmp/new_$file.tmp" ]]; then
            sort tmp/new_$file.tmp | uniq -c | sort -nr | nl > result/$filename && rm tmp/new_$file.tmp && rm tmp/$file.tmp
        else
            sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| sed -e 's/\(.*\)/\L\1/' | sort | uniq -c | sort -nr | nl > result/$filename
        fi

        echo -e "COUNT MODE"; cat result/$filename && echo -e "RESULTS: '$filename'" && ls -la result | grep $filename && echo -e "$(wc -l "result/$filename" | tr " " '\n' | head -n 1) distinct words"
        ;;

    p | P)
        filename="result---$file.dat"
        case $mode in
            p)
                #Check if theres any stopwords in the file and creates a tmp file with a list of words without the them
                echo -e "STOP WORDS will be filtered out"; echo -e "StopWords file '$iso': '$(echo "$stopwords")' ($(wc -l "$stopwords" | tr " " '\n' | head -n 1) words)"
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| sed -e 's/\(.*\)/\L\1/' > tmp/$file.tmp && grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                ;;
            P)
                echo -e "STOP WORDS will be counted"
                ;;
        esac

        #If the global var "WORD_STATS_TOP" isn't set, it's used the default value of 10
        if [[ -z $WORD_STATS_TOP ]]; then
            echo -e "Environment variable 'WORD_STATS_TOP' is empty (using default 10)"; n=10
        else
            echo -e "WORD_STATS_TOP=$n"
        fi

        if [[ -f "tmp/new_$file.tmp" ]]; then
            sort tmp/new_$file.tmp | uniq -c | sort -nr | nl | head -n $n > result/$filename && rm tmp/new_$file.tmp && rm tmp/$file.tmp
        else
            sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| sed -e 's/\(.*\)/\L\1/' | sort | uniq -c | sort -nr | nl | head -n $n > result/$filename
        fi

        ls -la result | grep $filename
        echo -e "-------------------------------------\n# TOP $n elements" && cat result/$filename && echo -e "-------------------------------------"

        #Creates the graph
        cp template.gnuplot bar.gnuplot
        sed -i "s/filename/$filename/g" bar.gnuplot
        filecut=`echo $file | cut -d'.' -f1,2`
        sed -i "s/varfile/$filecut/g" bar.gnuplot
        gnuplot < bar.gnuplot
        display result/$filename.png
        rm bar.gnuplot

        #Creates the html
        cp template.html result/$filename.html && sed -i "s/filename/$filename/g" result/$filename.html
        ;;

    t | T)
        case $mode in
            t)
                #Check if theres any stopwords in the file and creates a tmp file with a list of words without the them
                echo -e "STOP WORDS will be filtered out"; echo -e "StopWords file '$iso': '$(echo "$stopwords")' ($(wc -l "$stopwords" | tr " " '\n' | head -n 1) words)"
                sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| sed -e 's/\(.*\)/\L\1/' > tmp/$file.tmp && grep -vxf $stopwords tmp/$file.tmp > tmp/new_$file.tmp
                ;;
            T)
                echo -e "STOP WORDS will be counted"
                ;;
        esac

        #If the global var "WORD_STATS_TOP" isn't set, it's used the default value of 10
        if [[ -z $WORD_STATS_TOP ]]; then
            echo -e "Environment variable 'WORD_STATS_TOP' is empty (using default 10)"; n=10
        else
            echo -e "WORD_STATS_TOP=$n"
        fi

        if [[ -f "tmp/new_$file.tmp" ]]; then
            sort tmp/new_$file.tmp | uniq -c | sort -nr | nl | head -n $n > result/$filename && rm tmp/new_$file.tmp && rm tmp/$file.tmp
        else
            sed -e 's/[^[:alpha:]]/ /g' $file | tr '\n' " " |  tr -s " " | tr " " '\n'| sed -e 's/\(.*\)/\L\1/' | sort | uniq -c | sort -nr | nl | head -n $n > result/$filename
        fi

        ls -la result | grep $filename
        echo -e "-------------------------------------\n# TOP ${n} elements"; cat result/$filename; echo -e "-------------------------------------"
        ;;
    *)
        echo -e "[ERROR] unknown command '$mode'"
        exit 1
        ;;
esac

exit 0
