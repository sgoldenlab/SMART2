#works for a single brain region in a single slice

get.region.area <- function (acronym, registration) 
{
  coordinate <- registration$coordinate
  k <- which(abs(coordinate - atlasIndex$mm.from.bregma) == 
               min(abs(coordinate - atlasIndex$mm.from.bregma)))
  plate.info <- EPSatlas$plate.info[[k]]
    get.outline <- function(acronym) {
    id <- id.from.acronym(acronym)
    index <- match(id, plate.info$structure_id, nomatch=0)
    if (index == 0) {
      region <- data.frame(xT = 0, yT = 0, x = 0, y =0, 
                   right.hemisphere = 0)
      }
    else {
      region <- registration$atlas$outlines[index]
      region <- data.frame(xT = c(region[[1]]$xlT, region[[1]]$xrT), 
                           yT = c(region[[1]]$ylT, region[[1]]$yrT), x = c(region[[1]]$xl, 
                                                                           region[[1]]$xr), y = c(region[[1]]$yl, region[[1]]$yr), 
                           right.hemisphere = c(rep(FALSE, length(region[[1]]$xl)), 
                                                rep(TRUE, length(region[[1]]$xr))))
      region <- data.frame(region, name = rep(acronym, 
                                              nrow(region)))
    }
    return(region)
  }
    if (length(acronym) == 1) {
      region <- get.outline(acronym)
  }
    else {
      region <- lapply(acronym, get.outline)
      region <- do.call("rbind", region)
  }
    if (length(region) > 1) 
      scale.factor <- mean(dim(registration$transformationgrid$mx)/c(registration$transformationgrid$height, 
                                                                   registration$transformationgrid$width))
    region[, 1:4] <- region[, 1:4] * (1/scale.factor)
    
  coordinates(region) <-c ("xT","yT")
  poly <-Polygon(coordinates(region))
  area1 <- poly@area
  area <- (area1 * (.75488 * .75488 * 10^-6))
  return(area)
}  

#areas of all brain regions in a slice

region.area.loop <- function(registration)
{ regionareas <- data.frame(col1 = character(), col2 = numeric(), stringsAsFactors = FALSE)
regions <- c(unique(dataset$acronym))
for(i in 1:length(regions)){
  vec <- c(regions[i], get.region.area(regions[i], registration))
  regionareas <- rbind(regionareas, vec, stringsAsFactors = FALSE)}
return(regionareas)
} 
