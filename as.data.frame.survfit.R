

as.data.frame.survfit <- function(x){  
  data.frame(time = x$time,             
  n.risk   = x$n.risk  ,              
  n.event  = x$n.event ,              
  n.censor = x$n.censor,              
  surv     = x$surv    ,              
  std.err  = x$std.err ,              
  upper    = x$upper   ,              
  lower    = x$lower    )  
}

