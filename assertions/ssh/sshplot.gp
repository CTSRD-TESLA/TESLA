set terminal png
set output "sshperf.png"
set key left top
set noxtics
set boxwidth 0.75 absolute
set style fill solid 1.0 border -1
set style data histogram
set xlabel "Bytes transferred over localhost SSH"
set ylabel "Seconds for successful transfer"
set style histogram errorbars 
plot 'ssh_data.dat' u 2:3:xtic(1) t 'Clang/NoTesla','' u 4:5:xtic(1) t 'Clang/Tesla', '' u 6:7:xtic(1) t 'Gcc/NoTesla'
