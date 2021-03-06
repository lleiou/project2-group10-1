#this part requires R-pacakge choroplethrzip, to install the package,type in 
#following lines:
#install.packages("devtools")
#library(devtools)
#install_github('arilamstein/choroplethrZip@v1.4.0')



# New York City is comprised of 5 counties: Bronx, Kings (Brooklyn), New York (Manhattan), 
# Queens, Richmond (Staten Island). Their numeric FIPS codes are:
library(choroplethr)
library(choroplethrZip)
library(data.table)
library(devtools)
library(dplyr)
library(ggplot2)

#the input data frame must only have two columns:region(zip code) and value
nyc_fc=data.frame(fread("fac_num1.csv"))
nyc_pop=data.frame(fread("NYC_pop.csv"))
nyc_hos=data.frame(fread("house.csv"))


nyc_pop=nyc_pop[2:3]
colnames(nyc_pop)=c("region","value")
nyc_pop$region=as.character(nyc_pop$region)

#every region must only appear once
grouped=nyc_fc %>%
  group_by(region) %>%
  summarise(value=sum(value))
data.frame(grouped)

head(nyc_hos)
nyc_hos=nyc_hos[4:5]
colnames(nyc_hos)=c("region","value")
nyc_hos$region=as.character(nyc_hos$region)

grouped1=nyc_hos %>%
  group_by(region) %>%
  summarise(value=mean(value))
data.frame(grouped1)


#grouped_rm<-grouped[!(grouped$region==10129|grouped$region==10281|grouped$region==10430|grouped$region==11249|grouped$region==11352
#                      |grouped$region==11695
#                      |grouped$region==13564)]


#remove the zip code area that not defined in the function
grouped_rm=subset(grouped,region!=10129
                  &region!=10281
                  &region!=10430
                  &region!=11249
                  &region!=11352
                  &region!=11695
                  &region!=13564)

group1_rm=subset(grouped1,region!=10129
                 &region!=10281
                 &region!=10430
                 &region!=11249
                 &region!=11352
                 &region!=11695
                 &region!=13564)

#data.frame(grouped_rm)
#toString(grouped_rm$region)

#the column region must be character
grouped_rm$region=as.character(grouped_rm$region)

#select the nyc county
nyc_fips = c(36005, 36047, 36061, 36081, 36085)


# #this is the map fucntion 
# map1=zip_choropleth(grouped_rm,
#                county_zoom=nyc_fips,
#                title="New York City Facilities with Restroom",
#                legend="Num of Facility",
#                num_colors=3,
#                reference_map=FALSE
#                )
#belowed is another method to mapp
map2=ZipChoropleth$new(grouped_rm)
map2$title="New York City Facilities with Restroom"
map2$ggplot_scale = scale_fill_brewer(name="Num of facility", palette=8, drop=FALSE)
map2$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)
map1<-map2$render()
map1

map_pop=ZipChoropleth$new(nyc_pop)
map_pop$title="New York Population"
map_pop$ggplot_scale = scale_fill_brewer(name="population", palette=8, drop=FALSE)
map_pop$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)

map_pop=map_pop$render()
map_pop

map_hos=ZipChoropleth$new(group1_rm)
map_hos$title="Manhattan House Price"
map_hos$ggplot_scale = scale_fill_brewer(name="house price", palette=8, drop=FALSE)
map_hos$set_zoom_zip(state_zoom=NULL, county_zoom=nyc_fips, msa_zoom=NULL, zip_zoom=NULL)

map_hos=map_hos$render()
