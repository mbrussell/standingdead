# Species-specific decay rates of downed woody beris 
# for 36 tree species in the eastern US

# From: Russell, M.B., C.W. Woodall, S. Fraver, A.W. D'Amato, 
# G.M. Domke, and K.E. Skog. Residence Times and Decay Rates of 
# Downed Woody Debris Biomass/Carbon in Eastern US Forests. 
# Ecosystems (in press)

library(ggplot2)
        
#Species-specific parameters       
species=c("SW.AB","SW.JV","SW.PG","SW.PM","SW.PR","SW.PB",
"SW.PE","SW.PEll","SW.PRes","SW.PS","SW.PT","SW.PV","SW.TO",
"HW.AR","HW.AS","HW.ASilver","HW.BA","HW.BP","HW.FG","HW.FN",
"HW.LS","HW.LT","HW.PB","HW.PG","HW.PT","HW.PS","HW.QA","HW.QF",
"HW.QN","HW.QP","HW.QR","HW.QS","HW.QV","HW.SA","HW.TA","HW.UA")

years=seq(0,200,b=1)
biomass_remain.pred=as.data.frame(merge(years,species))
names(biomass_remain.pred)[1]='years';names(biomass_remain.pred)[2]='species'


#A function to estimate the biomass remaining by species
biomass_remain=function(years,species){
           if(species=='SW.AB'){
    k=-0.023}                           #Abies balsamea
      else if(species=='SW.JV'){
    k=-0.027}                           #Juniperus virginiana
      else if(species=='SW.PG'){
    k=-0.025}                           #Picea glauca
      else if(species=='SW.PM'){
    k=-0.025}                           #Picea mariana
      else if(species=='SW.PR'){
    k=-0.027}                           #Picea rubens
      else if(species=='SW.PB'){
    k=-0.025}                           #Pinus banksiana
      else if(species=='SW.PE'){
    k=-0.039}                           #Pinus echinata
      else if(species=='SW.PEll'){
    k=-0.048}                           #Pinus elliottii
      else if(species=='SW.PRes'){
    k=-0.023}                           #Pinus resinosa
      else if(species=='SW.PS'){
    k=-0.024}                           #Pinus strobus
      else if(species=='SW.PT'){
    k=-0.041}                           #Pinus taeda
      else if(species=='SW.PV'){
    k=-0.037}                           #Pinus virginiana
      else if(species=='SW.TO'){
    k=-0.026}                           #Thuja occidentalis
      else if(species=='HW.AR'){
    k=-0.048}                           #Acer rubrum
          else if(species=='HW.AS'){
    k=-0.058}                           #Acer saccharinum
          else if(species=='HW.ASilver'){
    k=-0.045}                           #Acer saccharum
          else if(species=='HW.BA'){
    k=-0.045}                           #Betula alleghaniensis
          else if(species=='HW.BP'){
    k=-0.045}                           #Betula papyrifera
          else if(species=='HW.FG'){
    k=-0.047}                           #Fagus grandifolia
          else if(species=='HW.FN'){
    k=-0.045}                           #Fraxinus nigra
          else if(species=='HW.LS'){
    k=-0.063}                           #Liquidambar styraciflua
          else if(species=='HW.LT'){
    k=-0.057}                           #Liriodendron tulipifera
          else if(species=='HW.PB'){
    k=-0.046}                           #Populus balsamifera
          else if(species=='HW.PG'){
    k=-0.046}                           #Populus grandidentata
          else if(species=='HW.PT'){
    k=-0.043}                           #Populus tremuloides
          else if(species=='HW.PS'){
    k=-0.053}                           #Prunus serotina
          else if(species=='HW.QA'){
    k=-0.048}                           #Quercus alba
          else if(species=='HW.QF'){
    k=-0.057}                           #Quercus falcata
          else if(species=='HW.QN'){
    k=-0.076}                           #Quercus nigra
          else if(species=='HW.QP'){
    k=-0.049}                           #Quercus prinus
          else if(species=='HW.QR'){
    k=-0.053}                           #Quercus rubra
          else if(species=='HW.QS'){
    k=-0.060}                           #Quercus stellata
          else if(species=='HW.QV'){
    k=-0.054}                           #Quercus velutina
          else if(species=='HW.SA'){
    k=-0.055}                           #Sassafras albidum
          else if(species=='HW.TA'){
    k=-0.047}                           #Tilia americana
          else if(species=='HW.UA'){
    k=-0.050}                           #Ulmus americana
  biomass_remain=100*exp(k*years)
  return(biomass_remain)}
  
#Estimate the amount of biomass remaining (kg)
biomass_remain.pred$biomass_remain=mapply(biomass_remain,
  biomass_remain.pred$years,biomass_remain.pred$species)

#Estimate the proportion of biomass remaining
biomass_remain.pred$biomass_remain_prop=biomass_remain.pred$biomass_remain/100

#Trim the dataset to graph 99% biomass remaining  
biomass_remain.pred<-biomass_remain.pred[biomass_remain.pred$biomass_remain_prop>0.01,]

dcy<-ggplot(biomass_remain.pred,aes(years,biomass_remain_prop))+geom_line()+facet_wrap(~species,ncol=6)
dcy

