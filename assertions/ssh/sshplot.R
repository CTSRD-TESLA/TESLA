## Read data
tab <- read.table("ssh_data.dat", header=FALSE)

## Split into error values, mean values
errors <- as.vector(t(tab[,c(3,5,7)]))
values <- as.vector(t(tab[,c(2,4,6)]))

## Calculate limits of y axis
ylim = c(0, max(values + errors))

## Open and format plotting area
pdf("sshperf.pdf", width=10/2.54, height=10/2.54/1.5)
par(mar=c(5.1, 4.5, 0.6, 0.6))
par(cex=0.4)

## Plot the graph
cols <- c("#8DD3C7", "#FFFFB3", "#BEBADA") # From http://colorbrewer2.org/
mp <- barplot(t(as.matrix(tab[,c(2,4,6)])), names.arg=tab[,1], beside=TRUE, col=cols, ylim=ylim)

## Plot the error bars
midpoints <- as.vector(mp)
arrows(midpoints, values + errors, midpoints, values - errors, code=3, angle=90, length=0.015, lwd=0.5)

## Plot the legends
legends <- c("Clang/No Tesla", "Clang/Tesla", "Gcc/NoTesla")
legend(mp[1,1], values[30], legends, fill=cols, bty="n", cex=1.5)

## Plot the axis labels
par(cex=0.6)
title(xlab="Bytes transferred over localhost SSH", ylab="Seconds for successful transfer")

## Close the plotting area
dev.off()
