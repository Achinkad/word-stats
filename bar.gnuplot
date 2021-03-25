set terminal png
set output "result---anapdf.pdf.txt.dat.png"
set boxwidth 0.5
set style fill solid
plot "result---anapdf.pdf.txt.dat" using 1:2:xtic(3) with boxes