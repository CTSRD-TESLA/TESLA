set terminal postscript enhanced color solid
set output "sshperf.ps"
set key left top
set boxwidth 1.0 absolute 
set style fill solid 1.0 border -1
set style data histogram
set xlabel "Bytes transferred over localhost SSH"
set xtics font "Helvetica,10" rotate by 35 offset -2.5,-1
set ylabel "Seconds for successful transfer"
set style histogram errorbars gap 1.0
plot 'ssh_data.dat' u 2:3:xtic(1) t 'Clang/No Tesla','' u 4:5:xtic(1) t 'Clang/ Tesla', '' u 6:7:xtic(1) t 'Gcc/NoTesla'
