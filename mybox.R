mybox <- function(x, x1, x2, col = "black", pch = 8, ...){
  
  med <- quantile(x, .5, ...)
  iqr <- quantile(x, c(0.25, 0.75), ...)
  mu <- mean(x, ...)
  w <- 1.5*(iqr[2]-iqr[1])
  uw <- min(c(iqr[2]+w, max(x)), ...)
  lw <- max(c(iqr[1]-w, min(x)), ...)
  # x1 <- .8
  # x2 <- 1.2
  
  lines(y = c(iqr[1], iqr[1], iqr[2], iqr[2], iqr[1]), x = c(x1, x2, x2, x1, x1), col = col)
  lines(y = c(lw, lw), x = c(x1, x2), col = col)
  lines(y = c(uw, uw), x = c(x1, x2), col = col)
  lines(y = c(med, med), x = c(x1, x2), col = col)
  lines(y = c(iqr[1], lw), x = rep((x1+x2)/2, 2), col = col)
  lines(y = c(iqr[2], uw), x = rep((x1+x2)/2, 2), col = col)
  out <- x[x < lw | x > uw]
  points(y = out, x = rep((x1+x2)/2, length(out)), pch = pch, cex = 0.6, col = col)
}

myboxplot <- function(x1, x2, ylab, xlim = NULL, ylim = NULL, ylog = FALSE, ...){
  
  if(is.null(xlim)) xlim <- c(0.5, 2.9)
  if(is.null(ylim)) ylim <- c(min(c(min(x1), min(x2))), max(c(max(x1), max(x2))))
  plot(y = x1, x = rep(1, length(x1))+rnorm(length(x1), 0, 0.02), pch = 16, xlim = xlim, col = "grey", ylab = ylab, xaxt = "n", xlab = "", ylim = ylim, log = ifelse(ylog, "y", ""))
  points(y = x2, x = rep(2, length(x2))+rnorm(length(x2), 0, 0.02), col = "red", pch = 16)
  axis(1, at = c(mean(c(1, mean(c(1.2, 1.4)))), mean(c(2, mean(c(2.2, 2.4))))), labels = c("Classical", "HSAr"))
  mybox(x1, 1.2, 1.4, col = "grey", ...)
  mybox(x2, 2.2, 2.4, col = "red", ...)
  
}


myboxplot(rnorm(20), runif(20) , "")

x <- c(rnorm(20, sd = 5), runif(20), c(rnorm(10, 1, 1), rnorm(10, 1, 10)))
y <- rep(1:3, each = 20)
cols <- rep(1:3, each = 20)
labs <- c("Classical", "HSAr", "Clust")

myboxplot2 <- function(x, grp, ylab= "", xlim = NULL, ylim = NULL, ylog = FALSE, bwidth = 0.2, col = "grey", labs = "", xaxt = TRUE, xaxt_y = grconvertY(.05, "nfc", "user")){
  
  grp <- as.numeric(as.factor(grp))
  b_x <- grp - 0.2
  s_x <- grp + 0.2
  
  
  if(is.null(xlim)) xlim <- c(min(grp)-1, max(grp)+1)
  # if(is.null(ylim)) ylim <- c(min(x), max(x))
  
  plot(y = x, x = s_x+rnorm(length(x), 0, 0.02), pch = 16, xlim = xlim, ylim = ylim, col = col, ylab = ylab, xaxt = "n", yaxt = "n", xlab = "", log = ifelse(ylog, "y", ""))
  # boxplot
  for(i in unique(grp)){
    mybox(x[grp == i], b_x[grp == i][1]-bwidth/2, b_x[grp == i][1]+bwidth/2, col = col[grp == i])
  }
  at2 <- axTicks(2)
  # if(!ylog) at2 <- at2[at2 >= par("usr")[3] & at2 <= par("usr")[4]]
  # if(ylog) at2 <- at2[at2 >= exp(par("usr")[3]) & at2 <= exp(par("usr")[4])]
  # axis(1, at = unique(grp), labels = labs)
  # x axis
  if(xaxt) text(x = unique(grp), y = xaxt_y, labels = labs, srt = 45, xpd = "n")
  # y axis
  axis(2, at = at2, label = rep("", length(at2)))
  text(x = grconvertX(.01, "npc", "user"), y = at2, labels = at2, xpd = "n", pos = 2)
  
  print(summary(x))
  print(axTicks(2))
  
}

myboxplot2(x, y, col = cols, labs = labs)
