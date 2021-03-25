set terminal png
set output "result/filename.png"
set boxwidth 0.5
set style fill solid
plot "result/filename" using 1:2:xtic(3) with boxes
