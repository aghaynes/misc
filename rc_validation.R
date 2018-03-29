# dat = export
# dd = data dictionary
# 

q <- data.frame(querynum = numeric(),
                querydetail = character(),
                record_id = character(),
                form = character(),
                variable = character(),
                variablelabel = character(),
                value = character())

nth <- 1
for(i in names(dat)){
  if(sum(is.na(dat[, i]))>0){
    tmp <- dat[is.na(dat[, i]), ]
    qtmp <- tmp[, c("record_id", i)]
    qtmp$variable <- i
    qtmp$variablelabel <- dd$field_label[dd$field_name == i]
    qtmp$querynum <- nth
    qtmp$querydetail <- "missing value"
    qtmp$value <- qtmp[, i]
    qtmp$form <- inst$instrument_label[inst$instrument_name == dd$form_name[dd$field_name == i]]
    qtmp <- qtmp[, c("querynum", "querydetail", "record_id", "form", "variable", "variablelabel", "value")]
    q <- rbind(q, qtmp)
  }
  nth <- nth + 1
}

for(i in names(dat)[grepl("complete", names(dat))]){
  if(sum(dat[, i] == 0) > 0){
    tmp <- dat[dat[, i] == 0, ]
    qtmp <- tmp[, c("record_id", i)]
    qtmp$variable <- i
    qtmp$variablelabel <- "Form status"
    qtmp$querynum <- nth
    qtmp$querydetail <- "form marked incomplete"
    qtmp$value <- qtmp[, i]
    qtmp$form <- inst$instrument_label[inst$instrument_name == gsub("_complete", "", i)]
    qtmp <- qtmp[, c("querynum", "querydetail", "record_id", "form", "variable", "variablelabel", "value")]
    q <- rbind(q, qtmp)
  }
  nth <- nth + 1
}


outlier <- function(x){
  qs <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
  diff <- qs[2] - qs[1]
  lbound <- qs[1] - 1.5*diff
  ubound <- qs[2] + 1.5*diff
  out <- x < lbound | x > ubound
  out
}
