remove_outs <- function(x, q_min="10%", q_max="90%") {

  qnts <- quantile(x, probs=seq(0,1,by=.05))
  cut_1 <- qnts %>% enframe %>% filter(name==q_min) %>% .$value
  cut_2 <- qnts %>% enframe %>% filter(name==q_max) %>% .$value

  x <- x %>% enframe %>% filter(value > cut_1 & value < cut_2) %>% .$value

}

