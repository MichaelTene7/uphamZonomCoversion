require(data.table)
library(dplyr)
#Get names from txt
zoNames = c(scan("data/SpeciesInAlignmentsFromFiltering.txt", what = "character"))
#remove the header from the txt names
zoNames2 = gsub("vs_","", zoNames)

#Get the data from the tsv file; this version requires manually removing the "latest"s added to some entries
zonomData = read.table("data/assembly.source.species.tsv", sep = '\t', fill = T)
write.csv(zonomData, "data/zonomData.csv")

#Get the names as a string vector
zonomDataNames = (zonomData[,1])

#Sort names alphabetically to match the format of the scan 
zonomDataNames =sort(zonomDataNames)

#Test to see if they are the same
all.equal(zoNames2,zonomDataNames)

#Loop to tell you where they aren't equal 
i = 1
while (i < length(zoNames2)) {
  if (zoNames2[i] == zonomDataNames[i]){
    i = i+1
  }else{
    print(paste(i, " ", zoNames2[i], " ", zonomDataNames[i]))
    i = i+1
  }
}
#Find the line where the difference is 
grep("hg38", zonomData)
