set terminal png size 640, 640 font ",10"
set output "result/filename.png"
set title "Top Words for 'file'\nCreated:date\ninfo"
set xlabel 'words'
set ylabel 'number of occurrences'
set boxwidth 0.8
set xtics rotate by -45
set style fill solid border 0
set size square
set grid
set label 1 "Authors: Ivo Bispo, José Areia" at graph -0.15, -0.13, 0 left back textcolor rgb "#000" font ",8"
set label 2 "Created: date" at graph -0.15, -0.17, 0 left back textcolor rgb "#000" font ",8"
plot [][0:] "result/filename" using 1:2:xtic(3) with boxes ti "# of occurrences" linecolor rgb "#026440", '' using 1:2:2 with labels offset 0.4,0.5 ti ""
