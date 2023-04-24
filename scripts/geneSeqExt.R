##### Setup parameters #####
#### Create list object to store / organize parameters
### Inititalize object
opt<-list() 

### Store URL's for downloading input data
opt$assemblyURL    <- "https://utexas.box.com/shared/static/cmzenewipqpeibxayofp3jib1gb9fim3.gz"
opt$assemblyFile   <- "Phallii_495_v3.1.cds.fa"
opt$annotationURL  <- "https://utexas.box.com/shared/static/s7p4pq2oytcb0i11o0bnva6twny0dxyo.gz"
opt$annotationFile <- "Phallii_495_v3.1.gene_exons.gff3"

### Packages needed
opt$biocPackages <- c("GEOquery","Biostrings","ape")

### Setup directories for storing data
## Working directory
opt$wd <- "~/GitHub/geneSeqExt"
## Local storage of downloaded files
opt$localDataDir <- "./localData"
## Local storage of packages
opt$localPckDir  <- "./localData/R"

##### Setup environment ######
#### Set the working directory
setwd(opt$wd)

#### Setup directory to download data
dir.create(opt$localDataDir,showWarnings = F)
write(file = file.path(opt$localDataDir,".gitignore"),x = "*")

##### Install software if needed
#### Tell R where to install packages
dir.create(opt$localPckDir,recursive = T,showWarnings = F)
.libPaths(opt$localPckDir)

#### Install from BiocManager if needed
# Say no to pop-ups MOST of the time.
if(any(!opt$biocPackages%in%installed.packages())){
    if (!"BiocManager"%in%installed.packages()){install.packages("BiocManager")}
    BiocManager::install(update = T,ask = F)
    BiocManager::install(opt$biocPackages,update = T,ask = F)
}


#### Detect files and download if needed
dldIfNeeded <- function(x,y,dir=opt$localDataDir,overwrite=F){
    library(GEOquery)
    dirY    <- file.path(dir,basename(y))
    zipFile <- paste0(dirY,".gz")
    if(file.exists(zipFile)&overwrite==F){
        stop(zipFile," already exists. Remove zipped file manually and retry")
    }
    if(!file.exists(dirY)|overwrite==T){
        download.file(x,destfile = zipFile)
        gunzip(filename = zipFile,overwrite = overwrite)
    }else{
        message(dirY," already exists. Skipping download.")
    }
}
dldIfNeeded(x = opt$assemblyURL  ,y = opt$assemblyFile  ,overwrite = F)
dldIfNeeded(x = opt$annotationURL,y = opt$annotationFile,overwrite = F)


#### 
dna <- Biostrings::readDNAStringSet(
    filepath = file.path(opt$localDataDir,opt$assemblyFile)
)

read
