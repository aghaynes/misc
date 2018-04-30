# 
# Code to export data from REDCap
# 

library(httr)

token <- readLines("XXX")
url <- "XXX"


# data itself
x <- POST(url, 
          config = httr::config(SSL_VERIFYPEER = FALSE),
          body = list(token = token,
                      content = "record", type = "flat",
                      format = "csv"))


x <- as.character(x)
con <- textConnection(x)
dat <- read.csv(con, head = TRUE, na.strings = "", stringsAsFactors = FALSE)




# data dictionary
x <- POST(url, 
          config = httr::config(SSL_VERIFYPEER = FALSE),
          body = list(token = token,
                      content = "metadata", type = "flat",
                      format = "csv"))

x <- as.character(x)
con <- textConnection(x)
dd <- read.csv(con, head = TRUE, na.strings = "", stringsAsFactors = FALSE)


# instruments
x <- POST(url, 
          config = httr::config(SSL_VERIFYPEER = FALSE),
          body = list(token = token,
                      content = "instrument", type = "flat",
                      format = "csv"))

x <- as.character(x)
con <- textConnection(x)
inst <- read.csv(con, head = TRUE, na.strings = "", stringsAsFactors = FALSE)


# instrument-event mapping
x <- POST(url, 
          config = httr::config(SSL_VERIFYPEER = FALSE),
          body = list(token = token,
                      content = "formEventMapping", type = "flat",
                      format = "csv"))

x <- as.character(x)
con <- textConnection(x)
instmap <- read.csv(con, head = TRUE, na.strings = "", stringsAsFactors = FALSE)


# events
x <- POST(url, 
          config = httr::config(SSL_VERIFYPEER = FALSE),
          body = list(token = token,
                      content = "event", type = "flat",
                      format = "csv"))

x <- as.character(x)
con <- textConnection(x)
event <- read.csv(con, head = TRUE, na.strings = "", stringsAsFactors = FALSE)



