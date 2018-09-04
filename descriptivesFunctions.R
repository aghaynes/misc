# continuous variables
conti_ag <- function(dat, by){
  require(Hmisc)
  for(i in names(dat)) if(label(dat[, i]) == "") label(dat[, i]) <- i
  fn <- function(x) c(n = length(na.omit(x)),
                      n_unique = length(unique(x)),
                      mean = mean(x, na.rm = TRUE),
                      sd = sd(x, na.rm = TRUE),
                      med = as.numeric(quantile(x, .5, na.rm = TRUE)),
                      lq = as.numeric(quantile(x, .25, na.rm = TRUE)),
                      uq = as.numeric(quantile(x, .75, na.rm = TRUE)),
                      min = min(x, na.rm = TRUE), 
                      max = max(x, na.rm = TRUE))
  median.test <- function(x, y){
    z <- c(x, y)
    g <- rep(1:2, c(length(x), length(y)))
    m <- median(z)
    fisher.test(z < m, g)$p.value
  }
  for(i in 1:ncol(dat)){
    ag <- aggregate(dat[,i], by = list(group = by), fn)
    tmp <- data.frame(x = dat[,i], y = by)
    # ag$p.ttest <- t.test(x ~ y, data = tmp)$p.value
    # ag$p.kruskal <- kruskal.test(x ~ y, data = tmp)$p.value
    # ag$p.median <- median.test(dat[, i], y = by)$p.value # this is wrong...y needs to be the values not the group indicator
    # ag$x
    # hist(exp1s[,i], main = i)  
    # ag$cluster
    if(exists("res", inherits = FALSE)){
      res <- rbind(res, cbind(data.frame(var = names(dat)[i], label = label(dat[,i]), group = ag$group), ag$x))
    } else {
      res <- cbind(data.frame(var = names(dat)[i], label = label(dat[,i]), group = ag$group), ag$x)
    }
    if(length(unique(by))>1){
      ag <- aggregate(dat[,i], by = list(group = rep("t", length(by))), fn)
      res <- rbind(res, cbind(data.frame(var = names(dat)[i], label = label(dat[,i]), group = "t"), ag$x))
    }
  }
  res$mean[is.nan(res$mean)] <- NA
  res$min[is.infinite(res$min)] <- NA
  res$max[is.infinite(res$max)] <- NA
  res <- reshape(res, 
                 v.names = names(res)[!names(res) %in% c("group", "var", "label")],
                 idvar = c("var", "label"), 
                 timevar = "group", 
                 direction = "wide")
  res$vtype <- "conti"
  res
}




# categorical variables

cat_ag <- function(dat, by = NULL){
  require(Hmisc)
  
  if(is.null(by)) by <- rep(1, nrow(dat))
  
  for(i in names(dat)){
    if(label(dat[, i]) == "") label(dat[, i]) <- i
    t <- as.data.frame(table(level = dat[, i], group = by))
    names(t)[3] <- "n"
    t$N_total <- sum(t$n)
    groupn <- tapply(t$n, t$group, sum)
    t$n_group <- groupn[match(t$group, names(groupn))]
    groupn <- tapply(t$n, t$level, sum)
    t$n_total <- groupn[match(t$level, names(groupn))]
    
    # print(names(t))
    t <- reshape(t, 
                 v.names = c("n", "n_group"), 
                 idvar = "level", 
                 timevar = "group", 
                 direction = "wide")
    t$var <- i
    t$label <- label(dat[, i])
    if(exists("t2")){
      t2 <- rbind(t2, t)
    } else {
      t2 <- t
    }
    # print(t2)
  }
  t2$vtype <- "cat"
  return(t2)
}


