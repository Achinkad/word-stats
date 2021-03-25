set terminal png
set output "result---text.txt.dat.png"
set boxwidth 0.5
set style fill solid
plot "result---text.txt.dat" using 1:2:xtic(3) with boxes