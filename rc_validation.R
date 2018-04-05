# dat = export
# dd = data dictionary
# inst = instruments/forms
# instmap = form-event mapping
# event = events
 
q <- data.frame(querynum = numeric(),
                querydetail = character(),
                record_id = character(),
                event = character(),
                event_label = character(),
                form = character(),
                variable = character(),
                variablelabel = character(),
                value = character())
 
# missing values ----
nth <- 1
for(i in names(dat)[names(dat) %in% dd$field_name]){
 
  tmp_dd <- dd[dd$field_name == i,]
  events <- instmap$unique_event_name[instmap$form_name == tmp_dd$form_name]
 
  if(tmp_dd$branching_logic != "" & !is.na(tmp_dd$branching_logic)){
    bl <- tmp_dd$branching_logic[1]
    bl <- gsub("=", "==", bl)
    bl <- gsub("or", "|", bl)
 
  }
 
  tmp1 <- dat[dat$redcap_event_name %in% events, ]
 
  if(sum(is.na(tmp1[, i]))>0){
    tmp <- tmp1[is.na(tmp1[, i]), ]
    qtmp <- tmp[, c("record_id", "redcap_event_name", i)]
    qtmp$variable <- i
    qtmp$variablelabel <- dd$field_label[dd$field_name == i]
    qtmp$event <- tmp$redcap_event_name
    qtmp$event_label <- event$event_name[match(tmp$redcap_event_name, event$unique_event_name)]
    qtmp$querynum <- nth
    qtmp$querydetail <- "missing value"
    qtmp$value <- qtmp[, i]
    qtmp$form <- inst$instrument_label[inst$instrument_name == dd$form_name[dd$field_name == i]]
    qtmp <- qtmp[, c("querynum", "querydetail", "record_id", "event", "event_label", "form", "variable", "variablelabel", "value")]
    q <- rbind(q, qtmp)
  }
  nth <- nth + 1
}
 
#dd$branching_logic[dd$field_name[dd$branching_logic != "" | !is.na(dd$branching_logic)] %in% unique(q$variable[q$querydetail == "missing value"])]
 
#logic_to_r <- function(x, dd){
#  checkboxes <- dd$field_name[dd$field_type %in% c("checkbox")]
#  checkboxes <- paste(checkboxes, collapse = "|")
#  pattern <- paste0(checkboxes, "(?=\\()") # lookahead to find checkboxes
#  dd$branching_logic[grepl(pattern, dd$branching_logic, perl = TRUE)]
#}
 
# complete forms ----
for(i in instmap$form_name){
  print(i)
  I <- paste0(i, "_complete")
  events <- instmap$unique_event_name[instmap$form_name == i]
  tmp <- dat[dat$redcap_event_name %in% events, ]
  check <- tmp[, I] == 0 | is.na(tmp[, I])
  if(sum(check) > 0){
    tmp <- tmp[check, ]
    qtmp <- tmp[, c("record_id", I)]
    qtmp$variable <- I
    qtmp$variablelabel <- "Form status"
    qtmp$event <- tmp$redcap_event_name
    qtmp$event_label <- event$event_name[match(tmp$redcap_event_name, event$unique_event_name)]
    qtmp$querynum <- nth
    qtmp$querydetail <- "form marked incomplete"
    qtmp$value <- qtmp[, I]
    qtmp$form <- inst$instrument_label[inst$instrument_name == i]
    qtmp <- qtmp[, c("querynum", "querydetail", "record_id", "event", "event_label", "form", "variable", "variablelabel", "value")]
    q <- rbind(q, qtmp)
  }
  nth <- nth + 1
}
 
 
# outliers ----
outlier <- function(x){
  qs <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
  diff <- qs[2] - qs[1]
  lbound <- qs[1] - 1.5*diff
  ubound <- qs[2] + 1.5*diff
  out <- x < lbound | x > ubound
  out
}
 
 
for(i in dd$field_name[dd$text_validation_type_or_show_slider_number %in% c("integer", "number")]){
  if(i == "hospitalnumber") next
 
  forms <- dd$form_name[dd$field_name == i]
  events <- instmap$unique_event_name[instmap$form_name %in% forms]
  tmp <- dat[dat$redcap_event_name %in% events, ]
 
  check <- outlier(tmp[, i]) & !is.na(tmp[, i])
  if(sum(check, na.rm = TRUE) > 0){
    tmp <- tmp[check, ]
    qtmp <- tmp[, c("record_id", i)]
    qtmp$variable <- i
    qtmp$variablelabel <- dd$field_label[dd$field_name == i]
    qtmp$event <- tmp$redcap_event_name
    qtmp$event_label <- event$event_name[match(tmp$redcap_event_name, event$unique_event_name)]
    qtmp$querynum <- nth
    qtmp$querydetail <- "possible outlier"
    qtmp$value <- qtmp[, i]
    qtmp$form <- inst$instrument_label[inst$instrument_name == dd$form_name[dd$field_name == i]]
    qtmp <- qtmp[, c("querynum", "querydetail", "record_id", "event", "event_label", "form", "variable", "variablelabel", "value")]
    q <- rbind(q, qtmp)
  }
  nth <- nth + 1
}
