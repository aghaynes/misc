clean_slivers <- function(sp, status=TRUE, nodes = 3) {
  # this function comes from tlocoh
  if (!inherits(sp, "SpatialPolygons")) stop("sp should be a SpatialPolygons* object")
  
  results <- NULL
  for (i in 1:length(sp)) {
    bad_Poly_idx <- which(unlist(lapply(sp@polygons[[i]]@Polygons, function(x) dim(unique(x@coords))[1] < nodes)))
    
    if (length(bad_Poly_idx) > 0) {
      results <- rbind(results, data.frame(polygon_idx=i, Polygon_idx=bad_Poly_idx))
      ## Remove them backwards, because when you take out an element from a list the subsequent indices get messed up
      for (Poly_idx in sort(bad_Poly_idx, decreasing=TRUE)) {
        sp@polygons[[i]]@Polygons[[Poly_idx]] <- NULL ##
        if (status) cat("Getting rid of Polygon ", Poly_idx, " from polygon ", i, "\n", sep="")
      }
    }
  }
  
  return(list(sp=sp, results=results))
  
}
