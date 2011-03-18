set terminal postscript eps enhanced color solid
set output "micro.ps"
set key right top font "Helvetica,20" spacing 3 width 6 
set boxwidth 1.0 absolute 
set style fill solid 1.0 border -1
set style data histogram
set xlabel "Optimisation level" font "Helvetica,25" offset 0,-2.0
set xtics font "Helvetica,20" rotate by 35 offset -4.5,-3.0
set ylabel "Seconds" font "Helvetica,25"
set style histogram errorbars gap 1.0
set grid
plot 'gnuplot.dat' u 2:3:xtic(1) t 'gcc','' u 4:5:xtic(1) t 'clang', '' u 6:7:xtic(1) t 'clang/instr', '' u 8:9:xtic(1) t 'clang/tesla'
