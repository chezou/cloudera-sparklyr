library(ggplot2)
library(maps)
library(geosphere)
library(sparklyr)
library(dplyr)

config <- spark_config()
config$spark.driver.cores   <- 4
config$spark.executor.cores <- 4
config$spark.executor.memory <- "4G"
#spark_home <- "/opt/cloudera/parcels/CDH/lib/spark"
#spark_version <- "1.6.2"
spark_home <- "/opt/cloudera/parcels/SPARK2/lib/spark2"
spark_version <- "2.0.0"
sc <- spark_connect(master="yarn-client", version=spark_version, config=config, spark_home=spark_home)

airlines <- tbl(sc, "airlines_bi_pq")
airline_counts_by_year <- airlines %>% group_by(year) %>% summarise(count=n()) %>% collect
airline_counts_by_year %>% tbl_df %>% print(n=nrow(.))

flights_2007 <- airlines %>% filter(year==2007) %>% group_by(carrier, origin, dest) %>% summarise(count=n()) %>% collect
airports <- tbl(sc, "airports_new_pq") %>% collect
flights_aa <- flights_2007 %>% filter(carrier=="AA")

# draw map with line of AA
xlim <- c(-171.738281, -56.601563)
ylim <- c(12.039321, 71.856229)

# Color settings
pal <- colorRampPalette(c("#333333", "white", "#1292db"))
colors <- pal(100)

map("world", col="#6B6363", fill=TRUE, bg="#000000", lwd=0.05, xlim=xlim, ylim=ylim)

flights_aa <- flights_aa[order(flights_aa$count),]
maxcnt <- max(flights_aa$count)
for (j in 1:length(flights_aa$carrier)) {
  air1 <- airports[airports$iata == flights_aa[j,]$origin,]
  air2 <- airports[airports$iata == flights_aa[j,]$dest,]
  
  inter <- gcIntermediate(c(air1[1,]$longitude, air1[1,]$latitude), c(air2[1,]$longitude, air2[1,]$latitude), n=100, addStartEnd=TRUE)
  colindex <- round( (flights_aa[j,]$count / maxcnt) * length(colors) )
  
  lines(inter, col=colors[colindex], lwd=0.8)
}

# build predictive model with linear regression
partitions <- airlines %>%
  filter(arrdelay >= 5) %>%
  sdf_mutate(
    carrier_cat = ft_string_indexer(carrier),
    origin_cat = ft_string_indexer(origin),
    dest_cat = ft_string_indexer(dest)
  ) %>%
  mutate(hour = floor(dep_time/100)) %>%
  sdf_partition(training = 0.5, test = 0.5, seed = 1099)

fit <- partitions$training %>%
  ml_linear_regression(
    response = "arrdelay",
    features = c(
      "month", "hour", "dayofweek", "carrier_cat", "depdelay", "origin_cat", "dest_cat", "distance"
    )
  )
fit

summary(fit)