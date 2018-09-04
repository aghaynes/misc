
# get radio button options into a dataframe
singlechoice_opts <- function(datadict){
  radio <- datadict[datadict$field_type %in% c("radio", "dropdown"), ]
  fn <- function(var, choices, label){
    opts <- choices
    opts <- unlist(strsplit(opts, "|", fixed = TRUE))
    n <- length(opts)
    opts2 <- trimws(unlist(strsplit(opts, ",")))
    vals <- opts2[seq(1,n*2,2)]
    labs <- opts2[seq(2,n*2,2)]
    labvals <- data.frame(var = rep(var, n), label = rep(label, n), val = vals, lab = labs)
    labvals
  }
  radio_labs <- do.call("rbind", apply(radio, 1, function(x) fn(x["field_name"], x["select_choices_or_calculations"], x["field_label"])))
  row.names(radio_labs) <- NULL
  return(radio_labs)
}




# get checkbox button options into a dataframe
multichoice_opts <- function(datadict){
  tmp <- datadict[datadict$field_type == "checkbox", ]
  fn <- function(var, choices, label){
    opts <- choices
    opts <- unlist(strsplit(opts, "|", fixed = TRUE))
    n <- length(opts)
    opts2 <- trimws(unlist(strsplit(opts, ",")))
    vals <- opts2[seq(1,n*2,2)]
    labs <- opts2[seq(2,n*2,2)]
    labvals <- data.frame(ovar = rep(var, n), var = rep(var, n), vlabel = rep(label, n), val = vals, label = labs)
    labvals
  }
  tmp_labs <- do.call("rbind", apply(tmp, 1, function(x) fn(x["field_name"], x["select_choices_or_calculations"], x["field_label"])))
  row.names(tmp_labs) <- NULL
  tmp_labs$var <- paste0(tmp_labs$var, "___", tmp_labs$val)
  return(tmp_labs)
}



# create factors for radio buttons
singlechoice_factor <- function(data, metadata){
  require(Hmisc)
  radios <- singlechoice_opts(metadata)
  for(i in unique(radios$var)){
    tmp <- radios[radios$var == i, ]
    v <- paste0(i, "_factor")
    data[, v] <- factor(data[, i], levels = tmp$val, labels = tmp$lab)
    label(data[, i]) <- unique(tmp$label)
    label(data[, v]) <- unique(tmp$label)
  }
  return(data)
}

# create factors for checkbox buttons
multichoice_factor <- function(data, metadata){
  require(Hmisc)
  checks <- multichoice_opts(metadata)
  for(i in unique(checks$var)){
    tmp <- checks[checks$var == i, ]
    v <- paste0(i, "_factor")
    data[, v] <- factor(data[, i], levels = c(0, 1), labels = c("No", "Yes"))
    label(data[, i]) <- unique(tmp$label)
    label(data[, v]) <- unique(tmp$label)
  }
  return(data)
}


# label non-radio/checkbox fields
label_others <- function(data, metadata){
  tmp <- metadata[!metadata$field_type %in% c("checkbox", "radio", "dropdown"), ]
  tmp <- tmp[tmp$field_name %in% names(data), ]
  for(i in 1:nrow(tmp)){
    label(data[, tmp$field_name[i]]) <- tmp$field_label[i]
  }
  return(data)
}
