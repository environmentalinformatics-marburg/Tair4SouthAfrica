rm(list=ls())
library(raster)
library(rgdal)
library(RColorBrewer)
mainpath <- "/home/hanna/Documents/Projects/IDESSA/airT/forPaper/"
modelpath <- paste0(mainpath,"/modeldat")
vispath <- paste0(mainpath,"visualizations/")

load("/home/hanna/Documents/Projects/IDESSA/airT/forPaper/modeldat/modeldata.RData")
shp <- readOGR("/home/hanna/Documents/Projects/IDESSA/airT/forPaper/shp/WeatherStations.shp")

dataset <- dataset[complete.cases(dataset$ndvi),]

stationCor <- c()
for (i in 1:length(unique(dataset$Station))){
  subs <- dataset[dataset$Station==unique(dataset$Station)[i],]
  stationCor[i] <- cor(subs$ndvi,subs$Tair)
}
stationCor <- data.frame("Station"=unique(dataset$Station),"cor"=stationCor)

shp <- shp[shp$plot%in%stationCor$Station,]
shp$ndvicor <- merge(shp@data,stationCor,by.y="Station",by.x="plot")$cor

####plot
base <- readOGR("/home/hanna/Documents/Projects/IDESSA/GIS/TM_WORLD_BORDERS-0.3/TM_WORLD_BORDERS-0.3.shp",
                "TM_WORLD_BORDERS-0.3")
#shp$ndvicor<-round(shp$ndvicor,2)

pdf(paste0(vispath,"/ndvicorr.pdf"),width=5.5,height=5.5)
spplot(shp,"ndvicor",pretty=TRUE,
       key.space=list(x = 0.68, y = 0.18, cex=0.7,corner = c(0, 1)),
       col.regions=rev(brewer.pal(5, "RdBu")), 
       cuts=5,scales=list(draw = TRUE),
       sp.layout=list(
  "sp.polygons", base, col = "black", fill="grey90",first = TRUE)
)
dev.off()

