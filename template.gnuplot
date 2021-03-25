set terminal png
set output "filename.png"
set boxwidth 0.5
set style fill solid
plot "filename" using 1:2:xtic(3) with boxes
