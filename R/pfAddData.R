#' Add user defined charcoal data series to paleofire
#' 
#' This function is used to create a "pfAddData" object, from user defined csv
#' files containing charcoal data, to be passed to pfTransform. Usually csv
#' files should contain three columns with Depth, Age, Charcoal quantity in
#' this same order. A metadata csv file should also be specified with sites
#' location information (three columns with: SITE_NAME, LATITUDE, LONGITUDE).
#' CharAnalysis data files could also be used, in this case the file must
#' include the following informations: DepthTop, DepthBottom, AgeTop,
#' AgeBottom, Volume and Charcoal value in this exact order. Then the files are
#' passed to the pretreatment function in order to calculate Charcoal
#' Accumulation Rates (see pretreatment for details).
#' 
#' 
#' @param files Character, names and path to csv files.
#' @param metadata Character, name and path to the (unique) metadata csv file.
#' @param type Character, "NONE": user defined csv (default), "CharAnalysis":
#' CharAnalysis data file.
#' @param Int Logical specifying whether the pretreatment function interpolates
#' particle zero counts, default TRUE.
#' @param first,last Numeric, date of the first, last sample for accumulation
#' rate calculation, if NULL first, last are automatically specified as the the
#' minimum and maximum ages of the record respectively.
#' @param yrInterp Numeric, temporal resolution of the interpolated
#' accumulation rates, if NULL, yrInterp is automatically specified as the
#' median resolution of the record.
#' @return
#' 
#' \item{out}{A list with merged data files that can be passed to
#' \code{\link{pfTransform}}}
#' @author O. Blarquez
#' @seealso \code{\link{pretreatment}}
#' @examples
#' 
#' 
#' \dontrun{
#' # Ad user own data from CharAnalysis file (csv)
#' # In this example we will use data from:
#' # Senici, D., A. Lucas, H. Y. H. Chen, Y. Bergeron, A. Larouche, B. Brossier, O.
#' # Blarquez, and A. A. Ali. 2013. Multi-millennial fire frequency and tree abundance
#' # differ between xeric and mesic boreal forests in central Canada. Journal of Ecology:
#' # 101, 356-367.
#' 
#' files=c("http://blarquez.com/public/data//Ben.csv",
#'        "http://blarquez.com/public/data/Small.csv")
#' metadata=c("http://blarquez.com/public/data/metadata.csv")
#' 
#' mydata=pfAddData(files=files,metadata=metadata,type="CharAnalysis")
#' 
#' # Transform and compositing:
#' TR1=pfTransform(add=mydata, method=c("MinMax","Box-Cox","Z-Score"),
#'                 BasePeriod=c(200,2000))
#' COMP2=pfCompositeLF(TR1, tarAge=seq(-50,8000,20), hw=500, nboot=100)
#' plot(COMP2)
#' }
#' 
pfAddData=function(files,metadata=NULL,type="NULL",Int=TRUE,first=NULL,last=NULL,yrInterp=NULL){
  
  
  ## Data part
  
  ## Read data
  for (i in 1:length(files))
    assign(paste("data",i,sep=""),read.csv(paste(files[i])))
  
  ## Calculates Charcoal Accumulation rates
  if(type=="CharAnalysis"){
    for (i in 1:length(files)){
      temp=pretreatment(get(paste("data",i,sep=""))[,1:5],
                        get(paste("data",i,sep=""))[,6],
                        Int=Int,first=first,last=last,yrInterp=yrInterp)
      assign(paste("dataI",i,sep=""),na.omit(as.data.frame(cbind(10000+i,temp$cmI, temp$ybpI, temp$accI))))
    }
    all_data=do.call(rbind,lapply(1:length(files),function(i) rbind(get(paste("dataI",i,sep="")))))
  }
  
  ## If data already specified as Influx (i.e. 3 columns csv's with Depth, Age, Influx)
  if(type=="NULL")
    all_data=do.call(rbind,lapply(1:length(files),function(i) rbind(cbind(10000+i,get(paste("data",i,sep=""))))))
  
  ## Set colnames
  colnames(all_data)=c("ID_SITE","DEPTH","EST_AGE","QUANTITY")
  
  ## Metadata part
  
  ## NULL option
  if(is.null(metadata))
    meta=data.frame(SITE_NAME=rep(NA,length(files)),
                    LATITUDE=rep(NA,length(files)),
                    LONGITUDE=rep(NA,length(files)))
  
  ## Metadata exist
  if(is.null(metadata)==FALSE){
    options(warn=-1)
    assign("meta",read.csv(paste(metadata),header=T))
    meta[,1]=as.character(meta[,1])
    class(meta[,1])="character"
    meta=cbind(unique(all_data[,1]),meta)
    colnames(meta)[1]="ID_SITE"
  }

  ## Output
  output=structure(list(data=all_data,
                        metadata=meta))
  return(output)
}




