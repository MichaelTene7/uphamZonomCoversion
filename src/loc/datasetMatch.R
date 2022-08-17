library(RERconverge)
library(dplyr)
library(tibble)
library(readr)

#Read the upham Tree
uphamData = read.nexus("data/Upham_Tree_pruned.nex")
#Make a vector of the species names 
uphamSpecies = c(uphamData$tip.label)
uphamSpecies

#Read the zonom dataset
zonomData = read.csv("data/zonomData.csv")
#Make a vector of the zonom names
zonomNames = c(zonomData$V3)
zonomNames

#convert the zonomNames to the format in the upham tree
zonomNamesUs = gsub(" ", "_", zonomNames)
zonomNamesUs
#Add the upham names to the zonom Data
zonomData = zonomData %>%
  mutate(uphamName = gsub(" ", "_",zonomData$V3)
  )

#Compare the two name vectors 
i = 1
valuesin = NULL
valuesnot = NULL
while (i < length(zonomNamesUs)) {
  if(zonomNamesUs[i] %in% uphamData$tip.label){
    valuesin  = c(valuesin, i)
    i = i+1
  }else{
    valuesnot = c(valuesnot,i)
    i=i+1
    }
  
}
#Return the values in and values not 
valuesin
valuesnot

#Create a vector of the names that overlap
overlapNames = zonomNamesUs[valuesin]
length(overlapNames)

#Create a vector of the tips which overlap 
overlapTipsBool = uphamData$tip.label %in% overlapNames
overlapTips = which(overlapTipsBool)

#Create a vector of all of the tips which are not in that vector 
tipsToRemove = c(1:3649)
tipsToRemove = setdiff(tipsToRemove,overlapTips)

#Create a table of the overlap by removing all non-overlaping tips. 
overlapSpecies = drop.tip(uphamData, c(tipsToRemove))

#Create a table of the non-overlaping upham data
uphamNonOverlaping = drop.tip(uphamData, c(overlapTips))

#Create a table of the non-overlaping zonom Data
zonomNonOverlaping = zonomData[c(valuesnot),]
zonomOverlaping = zonomData[c(valuesin),]

#Save all of the above 

write.csv(zonomData, "output/zonomDataUphamConversionData.csv")
write.csv(zonomNonOverlaping, "output/nonOverlapingZoonomiaData.csv")
write.csv(zonomOverlaping, "output/OverlapingZoonomiaData.csv")
write.tree(overlapSpecies, "output/overlapingData.nwk")
write.tree(uphamNonOverlaping, "output/uphamNonOverlapingData.nwk")








