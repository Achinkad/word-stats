set terminal png
set output "result/filename.png"
set boxwidth 0.5
set style fill solid border 0
set xtics rotate by -45
set grid
set title 'Top Words for varfile'
set xlabel 'words'
set ylabel 'number of occurrences'
plot [][0:] "result/filename" using 1:2:xtic(3) with boxes ti "# of occurrences" linecolor rgb "#026440", '' using 1:2:2 with labels offset 0.7,0.5 ti ""
