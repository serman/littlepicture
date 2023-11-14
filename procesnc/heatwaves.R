library(ncdf4)
library(tidyverse)
library(RColorBrewer)

#You need to download the datasets from here:
#https://cds.climate.copernicus.eu/cdsapp#!/dataset/sis-heat-and-cold-spells?tab=overview

#Help:
#https://towardsdatascience.com/how-to-crack-open-netcdf-files-in-r-and-extract-data-as-time-series-24107b70dcd
#https://rpubs.com/boyerag/297592

POIS <- list(
  'Athens'= c(23.728056, 37.983889), #long lat
  'Barcelona'= c(2.152641, 41.384404),
  'Budapest'= c(19.130742, 47.495514),
  'London'= c(-0.128112, 51.508213),
  'Milan'= c(9.186554, 45.46017),
  'Munich'= c(11.549651, 48.163273),
  'Paris'= c(2.354478, 48.860506),
  'Rome'= c(12.478823, 41.861608),
  'Valencia'= c(-0.39413, 39.480000),
  'Madrid' = c(-3.700340,40.416691),
  'Berlin' = c(13.411440,52.523430)
)


nc_file <- nc_open("HWD_EU_health_rcp45_mean_v1.0.nc") # change 85 for 45 to extract
#ct.catalogue.retrieve(
#  'sis-heat-and-cold-spells',
#  {
#    'variable': 'heat_wave_days',
#    'experiment': scenario.lower().replace('.', '_'),
#    'ensemble_statistic': 'ensemble_members_average',
#    'definition': 'health_related'
#  }
#)
print(nc_file)
days <- "HWD_EU_health"

lat <- ncvar_get(nc_file,"lat")
nlat <- dim(lat)
lon <- ncvar_get(nc_file,"lon")
nlon <- dim(lon)
print(c(nlon, nlat))

time <- ncvar_get(nc_file,"time") # days after first datum
head(time)
tunits <- ncatt_get(nc_file,"time","units")
nt <- dim(time)


# now lets extract data
heatWaves_array <- ncvar_get(nc_file,"HWD_EU_health")
fillvalue <- ncatt_get(nc_file,"HWD_EU_health", "_FillValue")

heatWaves_array[heatWaves_array == fillvalue$value] <- NA 
secondsInADay<-24*60*60
timeInSeconds<-time*secondsInADay
time_obs <- as.POSIXct(timeInSeconds, origin = "1986-01-01", tz="GMT")
range(time_obs)
#3 dimensions: lat(425) lon(599) and time (100,  units: days since 1986-01-01)
#3 variables height, quantile, HWD_EU_health

#names(nc_file$var)
# [1] "height"         "quantile"       "HWD_EU_health"

# let's get some "slices"
# This first slice is a the data for a year
heatWave_slice <- heatWaves_array[,,99]
image(lon,lat, heatWave_slice, col=brewer.pal(8,"YlOrRd"))
sample_lon <- -3.703790
sample_lat <- 40.416775
# find the closest lat/lon index in the grid
lon_index <- which.min(abs(lon-sample_lon))
lat_index <- which.min(abs(lat-sample_lat))
#lon_index <- which(lon == sample_lon)
#lat_index <- which(lat == sample_lat)

# evolution in period of time 2.132641, 41.384404
heatWave_slice <- heatWaves_array[lon_index,lat_index,]
heatWave_df <- data.frame(time_obs, heatWave_slice)



# create an empty dictionary to store the heatWave_slice values
heatWave_dict <- list()

# iterate over each city in the POIS list
heatWave_df <- data.frame(city=character(), year=integer(), value=numeric())

for (city in names(POIS)) {
  # get the lat and lon for the current city
  sample_lat <- POIS[[city]][2]
  sample_lon <- POIS[[city]][1]
  
  # find the closest lat/lon index in the grid
  lon_index <- which.min(abs(lon - sample_lon))
  lat_index <- which.min(abs(lat - sample_lat))
  
  # get the heatWave_slice for the current city
  heatWave_slice <- heatWaves_array[lon_index, lat_index, ]
#  heatWave_df <- data.frame(format(time_obs, "%Y"), heatWave_slice)
  heatWave_df_city <- data.frame(city=rep(city, length(time_obs)), year=format(time_obs, "%Y"), value=heatWave_slice)
  heatWave_df <- rbind(heatWave_df, heatWave_df_city)

  # plot the heatWave_slice for the current city
  #heatWave_dict[[city]] <- heatWave_df
}

plot(time_obs, heatWave_slice, type="l", xlab="Year", ylab="Heatwave days")
write.csv(heatWave_df, "heatWave_dict.csv", row.names=FALSE)
