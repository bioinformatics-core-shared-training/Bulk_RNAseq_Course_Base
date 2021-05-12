library(tidyverse)

Dispersion <- 0.8
tibble(Mean = 1:1000) %>%
    mutate(Variance = Mean + (Mean ^ 2/ Dispersion)) %>% 
    ggplot(aes(x = Mean, y = Variance)) +
    geom_line() +
    labs(x = "Mean Expression",
         title = str_c("Dispersion = ", Dispersion))
tibble(Mean = sample(1:1000, 50)) %>%
    mutate(Variance = Mean + (Mean ^ 2/ Dispersion)) %>% 
    ggplot(aes(x = Mean, y = Variance)) +
    geom_point() +
    labs(x = "Mean Expression",
         title = str_c("Dispersion = ", Dispersion))
tibble(Mean = sample(1:1000, 10)) %>%
    mutate(Variance = Mean + (Mean ^ 2/ Dispersion)) %>% 
    ggplot(aes(x = Mean, y = Variance)) +
    geom_point() +
    labs(x = "Mean Expression",
         title = str_c("Dispersion = ", Dispersion))
tibble(Mean = sample(1:1000, 2)) %>%
    mutate(Variance = Mean + (Mean ^ 2/ Dispersion)) %>% 
    ggplot(aes(x = Mean, y = Variance)) +
    geom_point() +
    labs(x = "Mean Expression",
         title = str_c("Dispersion = ", Dispersion))

        
