

library(grid)
library(Gmisc)

grid.newpage()


leftx <- .25
midx <- .5
rightx <- .75
width <- .4
gp <- gpar(fill = "lightgrey")

(total <- boxGrob("Total\n N = NNN", 
                  x=midx, y=.9, box_gp = gp, width = width))

(rando <- boxGrob("Randomized\n N = NNN", 
                  x=midx, y=.75, box_gp = gp, width = width))

connectGrob(total, rando, "v")

(inel <- boxGrob("Ineligible\n N = NNN", 
                  x=rightx, y=.825, box_gp = gp, width = .25, height = .05))

connectGrob(total, inel, "-")

(g1 <- boxGrob("Allocated to Group 1\n N = NNN", 
                 x=leftx, y=.5, box_gp = gp, width = width))
(g2 <- boxGrob("Allocated to Group 2\n N = NNN", 
                 x=rightx, y=.5, box_gp = gp, width = width))

connectGrob(rando, g1, "N")
connectGrob(rando, g2, "N")

(g11 <- boxGrob("Followed up\n N = NNN", 
               x=leftx, y=.3, box_gp = gp, width = width))
(g21 <- boxGrob("Followed up\n N = NNN", 
               x=rightx, y=.3, box_gp = gp, width = width))

connectGrob(g1, g11, "N")
connectGrob(g2, g21, "N")

(g12 <- boxGrob("Completed\n N = NNN", 
               x=leftx, y=.1, box_gp = gp, width = width))
(g22 <- boxGrob("Completed\n N = NNN", 
               x=rightx, y=.1, box_gp = gp, width = width))

connectGrob(g11, g12, "N")
connectGrob(g21, g22, "N")

# see https://cran.r-project.org/web/packages/Gmisc/vignettes/Grid-based_flowcharts.html for details
