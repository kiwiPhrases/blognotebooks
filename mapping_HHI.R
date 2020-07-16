library(rgeos)
library(rgdal)
library(shiny)
library(leaflet)
library(reshape2)
library(rgdal)
library(viridis)
library(ggplot2)
library(rgeos)
#library(wesanderson)
library(mapview)

data_path = "C:/Users/SpiffyApple/Documents/USC/OwnResearch/marketShare"

## ----------- Generate the Census Tract map ------------------- ##
# load shapes
df <-readOGR(paste(data_path, 'wake_cnty_tract_hhi.shp', sep="/"))

paldb <- colorFactor(
  palette = 'plasma',#wes_palette('Darjeeling1',n=4, type="discrete")[c(4,3,2,1)], #'YlOrRd',
  domain = df$qcuts)
 #palette = 'prism'

# get bounding coordinates:
boundingbox = bbox(df)

mymap<- leaflet(options = leafletOptions(minZoom = 0, maxZoom = 12)) %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite",
                   options = providerTileOptions(
                     updateWhenZooming = FALSE,      # map won't update tiles until zoom is done
                     updateWhenIdle = TRUE           # map won't load new tiles when panning
                   )) %>%
  addPolygons(data = df,color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 0.0, fillOpacity = 0.7, fillColor = ~paldb(qcuts),
              popup =
                ~paste("<center><strong>Tract:",TRACTCE10," </strong></center>", "<br>",
                       '<strong>','HHI: </strong>', round(HHI,3),'<br>',
                       '<strong>','Num of owners: </strong>', num_owners,'<br>',
                       '<strong>','Num of units: </strong>', nbr_units,'<br>')) %>%
  addLegend('topright', pal = paldb, values = ~qcuts,opacity = 1,data=df) %>%
  setMaxBounds(lng1=boundingbox['x','min'], lat1=boundingbox['y','min'],
             lng2=boundingbox['x','max'], lat2=boundingbox['y','max'])%>%
  fitBounds(boundingbox['x','min'], boundingbox['y','min'],boundingbox['x','max'],boundingbox['y','max'])

# save the map
mapshot(mymap, url =  'wakecounty_tracthhi.html')

## ----------- Generate the Block Group maps ------------------- ##

df <-readOGR(paste(data_path, 'wake_cnty_bg_hhi.shp', sep="/"))

paldb <- colorFactor(
  palette = 'plasma',#wes_palette('Darjeeling1',n=4, type="discrete")[c(4,3,2,1)], #'YlOrRd',
  domain = df$qcuts)
#palette = 'prism'
# get bounding coordinates:

boundingbox = bbox(df)

mymap<-leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18)) %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite",
                   options = providerTileOptions(
                     updateWhenZooming = FALSE,      # map won't update tiles until zoom is done
                     updateWhenIdle = TRUE           # map won't load new tiles when panning
                   )) %>%
  addPolygons(data = df,color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 0.0, fillOpacity = 0.5, fillColor = ~paldb(qcuts),
              popup =
                ~paste("<center><strong>Block group:",GEOID10," </strong></center>", "<br>",
                       '<strong>','HHI: </strong>', round(HHI,3),'<br>',
                       '<strong>','Num of owners: </strong>', num_owners,'<br>',
                       '<strong>','Num of units: </strong>', nbr_units,'<br>')) %>%
  addLegend('topright', pal = paldb, values = ~qcuts,opacity = 1,data=df, , title="HHI range") %>%
  setMaxBounds(lng1=boundingbox['x','min'], lat1=boundingbox['y','min'],
                 lng2=boundingbox['x','max'], lat2=boundingbox['y','max'])%>%
  fitBounds(boundingbox['x','min'], boundingbox['y','min'],boundingbox['x','max'],boundingbox['y','max'])
mymap
mapshot(mymap, url =  'wakecounty_bghhi.html')
