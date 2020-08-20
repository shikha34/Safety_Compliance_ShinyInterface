#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(sqldf)
library(ggplot2)
library(shinydashboard)
library(shinythemes)
library(dplyr)
library(shiny)
library(reshape2)

ui<-navbarPage(h2("Health & Safety Analysis"),
               
               
               theme = shinytheme("readable"),
               tabPanel(h4("Upload Data"),
                        sidebarLayout(
                          sidebarPanel(
                            fileInput(inputId = "filedata",
                                      label = "Select the Master Checklist Excel Data for Analysis",
                                      accept = c(".xlsx"))
                            , selectInput("dataset", "Choose a dataset:",
                                          choices = c("Pan-Indigo-Report", "Pan-Indigo-RawData", "Checklist Daily Report","Bottom 10 Compliance Report")),
                            
                            # Button
                            downloadButton("downloadData", "Download")
                            
                          ),
                          mainPanel(
                            tabsetPanel(
                              
                              tabPanel("Table View details of Checklist Data",tableOutput("tableCW")))
                          )
                        )) 
               
)



server <- function(input, output) {
  options(shiny.maxRequestSize=100*1024^2)
  
  output$tableCW<-renderTable({
    library("data.table")
    library("readxl")
    library("sqldf")
    library("plumber")
    
    data <- reactive({
      req(input$filedata)
      read_excel(input$filedata$datapath,na=c(""),col_names = F)})
    data<-data()
    
    cleaning1<-function(x)
    {
      x=sapply(x,toupper)
      x=gsub("$","",x,fixed=TRUE)
      x=gsub(",","",x,fixed=TRUE)
      x=gsub("=","",x,fixed=TRUE)
      x=gsub("+","",x,fixed=TRUE)
      x=gsub("-","",x,fixed=TRUE)
      x=gsub("&","",x,fixed=TRUE)
      x=gsub("\\","",x,fixed=TRUE)
      x=gsub("?","",x,fixed=TRUE)
      x=gsub("~","",x,fixed=TRUE)
      x=gsub("^","",x,fixed=TRUE)
      x=gsub("\\s+"," ",x)
      x=gsub("  ","",x,fixed=TRUE)
      x=gsub(".","",x,fixed=TRUE)
      x=gsub("_","",x,fixed=TRUE)
      x=gsub("`","",x,fixed=TRUE)
    }
    
    #data=read_excel("C:/D Drive Data/health&safety/Master Data_v3.xlsx",na=c(""),col_names = F)
    colnames(data)=data[1,]
    data=data[-1,]
    data=data.table(data)
    names(data)<-sapply(names(data),cleaning1)
    names(data)<-gsub(" ","_",names(data))
    colss1<-names(data[,8:(NCOL(data))])
    data<-data[,c(colss1):=lapply(.SD,function(x){x<-cleaning1(x)}),.SDcols=colss1]
    
    data$STATION_CODE<-gsub(" ","",data$STATION_CODE)
    
    data$STATION_CODE[data$STATION_CODE=="AMDT1"]<-"AMD"
    data$STATION_CODE[data$STATION_CODE=="BBIT1"]<-"BBI"
    data$STATION_CODE[data$STATION_CODE=="BLRT1"]<-"BLR"
    data$STATION_CODE[data$STATION_CODE=="BOMT1ANDT2"]<-"BOM"
    data$STATION_CODE[data$STATION_CODE=="BOMT2ANDT1"]<-"BOM"
    data$STATION_CODE[data$STATION_CODE=="BOMT2"]<-"BOM"
    data$STATION_CODE[data$STATION_CODE=="COKT1"]<-"COK"
    data$STATION_CODE[data$STATION_CODE=="COKT2"]<-"COK"
    data$STATION_CODE[data$STATION_CODE=="DELT3"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="DELT2"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="DELT1"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="DELHI"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="HYDT1"]<-"HYD"
    data$STATION_CODE[data$STATION_CODE=="LKOT2"|data$STATION_CODE=="LKOT1"|data$STATION_CODE=="LUCKNOW"|data$STATION_CODE=="LKOAPT2"]<-"LKO"
    data$STATION_CODE[data$STATION_CODE=="PATT1"|data$STATION_CODE=="PATNA"]<-"PAT"
    data$STATION_CODE[data$STATION_CODE=="JAIT2"]<-"JAI"
    data$STATION_CODE[data$STATION_CODE=="RJAT1"]<-"RJA"
    data$STATION_CODE[data$STATION_CODE=="KOLKATA"]<-"CCU"
    data$STATION_CODE[data$STATION_CODE=="TRVT1"]<-"TRV"
    data$STATION_CODE[data$STATION_CODE=="RAIPUR"]<-"RPR"
    data$STATION_CODE[data$STATION_CODE=="UDAIPUR"]<-"UDR"
    data$STATION_CODE[data$STATION_CODE=="VVGS"|data$STATION_CODE=="VGS"]<-"VGA"
    data$STATION_CODE[data$STATION_CODE=="PUNE"]<-"PNQ"
    data$STATION_CODE[data$STATION_CODE=="NAGT1"]<-"NAG"
    data$STATION_CODE[data$STATION_CODE=="MAAT1T2"|data$STATION_CODE=="MAAT2"]<-"MAA"
    data$STATION_CODE[data$STATION_CODE=="GOA"]<-"GOI"
    
    return(data[1:100])
    
  }) 
  
  datasetInput <- reactive({
    data <- reactive({
      req(input$filedata)
      read_excel(input$filedata$datapath,na=c(""),col_names = F)})
    data<-data()
    
    cleaning1<-function(x)
    {
      x=sapply(x,toupper)
      x=gsub("$","",x,fixed=TRUE)
      x=gsub(",","",x,fixed=TRUE)
      x=gsub("=","",x,fixed=TRUE)
      x=gsub("+","",x,fixed=TRUE)
      x=gsub("-","",x,fixed=TRUE)
      x=gsub("&","",x,fixed=TRUE)
      x=gsub("\\","",x,fixed=TRUE)
      x=gsub("?","",x,fixed=TRUE)
      x=gsub("~","",x,fixed=TRUE)
      x=gsub("^","",x,fixed=TRUE)
      x=gsub("\\s+"," ",x)
      x=gsub("  ","",x,fixed=TRUE)
      x=gsub(".","",x,fixed=TRUE)
      x=gsub("_","",x,fixed=TRUE)
      x=gsub("`","",x,fixed=TRUE)
    }
    
    #data=read_excel("C:/D Drive Data/health&safety/Master Data_v3.xlsx",na=c(""),col_names = F)
    colnames(data)=data[1,]
    data=data[-1,]
    data=data.table(data)
    names(data)<-sapply(names(data),cleaning1)
    names(data)<-gsub(" ","_",names(data))
    colss1<-names(data[,8:(NCOL(data))])
    data<-data[,c(colss1):=lapply(.SD,function(x){x<-cleaning1(x)}),.SDcols=colss1]
    
    data$STATION_CODE<-gsub(" ","",data$STATION_CODE)
    
    data$STATION_CODE[data$STATION_CODE=="AMDT1"]<-"AMD"
    data$STATION_CODE[data$STATION_CODE=="BBIT1"]<-"BBI"
    data$STATION_CODE[data$STATION_CODE=="BLRT1"]<-"BLR"
    data$STATION_CODE[data$STATION_CODE=="BOMT1ANDT2"]<-"BOM"
    data$STATION_CODE[data$STATION_CODE=="BOMT2ANDT1"]<-"BOM"
    data$STATION_CODE[data$STATION_CODE=="BOMT2"]<-"BOM"
    data$STATION_CODE[data$STATION_CODE=="COKT1"]<-"COK"
    data$STATION_CODE[data$STATION_CODE=="COKT2"]<-"COK"
    data$STATION_CODE[data$STATION_CODE=="DELT3"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="DELT2"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="DELT1"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="DELHI"]<-"DEL"
    data$STATION_CODE[data$STATION_CODE=="HYDT1"]<-"HYD"
    data$STATION_CODE[data$STATION_CODE=="LKOT2"|data$STATION_CODE=="LKOT1"|data$STATION_CODE=="LUCKNOW"|data$STATION_CODE=="LKOAPT2"]<-"LKO"
    data$STATION_CODE[data$STATION_CODE=="PATT1"|data$STATION_CODE=="PATNA"]<-"PAT"
    data$STATION_CODE[data$STATION_CODE=="JAIT2"]<-"JAI"
    data$STATION_CODE[data$STATION_CODE=="RJAT1"]<-"RJA"
    data$STATION_CODE[data$STATION_CODE=="KOLKATA"]<-"CCU"
    data$STATION_CODE[data$STATION_CODE=="TRVT1"]<-"TRV"
    data$STATION_CODE[data$STATION_CODE=="RAIPUR"]<-"RPR"
    data$STATION_CODE[data$STATION_CODE=="UDAIPUR"]<-"UDR"
    data$STATION_CODE[data$STATION_CODE=="VVGS"|data$STATION_CODE=="VGS"]<-"VGA"
    data$STATION_CODE[data$STATION_CODE=="PUNE"]<-"PNQ"
    data$STATION_CODE[data$STATION_CODE=="NAGT1"]<-"NAG"
    data$STATION_CODE[data$STATION_CODE=="MAAT1T2"|data$STATION_CODE=="MAAT2"]<-"MAA"
    data$STATION_CODE[data$STATION_CODE=="GOA"]<-"GOI"
    
    # write.csv(indigo,"C:/D Drive Data/health&safety/health_safety_indigo.csv")
    # write.csv(data_final,"C:/D Drive Data/health&safety/health_safety_rawdata.csv")
    # write.csv(shift,"C:/D Drive Data/health&safety/Checklist_Shift.csv")
    # write.csv(indigo_station,"C:/D Drive Data/health&safety/Bottom_10_rawdata.csv")
    
    data1<-data[,c(2,8,11:(NCOL(data)-2)),with=FALSE]
    data12<-data[,c(2,8,11:(NCOL(data)-2)),with=FALSE]
    
    #cleaning
    cols1<-names(data1[,2:(NCOL(data1))])
    
    
    #clenaing
    colss1<-names(data12[,2:(NCOL(data12))])
    
    data1<-data1[,c(cols1):=lapply(.SD,function(x){x<-cleaning1(x)}),.SDcols=cols1]
    data12<-data12[,c(colss1):=lapply(.SD,function(x){x<-cleaning1(x)}),.SDcols=colss1]
    
    cols<-names(data1[,3:(NCOL(data1))])
    colss<-names(data12[,3:(NCOL(data12))])
    
    data1<-data1[,c(cols):=lapply(.SD,function(x){x=sum(x=="COMPLIANCE",na.rm = TRUE)}),.SDcols=cols,by=.(STATION_CODE,START_TIME)]
    
    data12<-data12[,c(colss):=lapply(.SD,function(x){x<-sum(x=="NON COMPLIANCE",na.rm = TRUE)}),.SDcols=colss,by=.(STATION_CODE,START_TIME)]
    
    data1<-unique(data1)
    data12<-unique(data12)
    
    data1_melt<-melt(data1,id.vars = c("STATION_CODE","START_TIME"),variable.name = "Health_Safety_Parameters",value.name = "Compliant_Days")
    data2_melt<-melt(data12,id.vars = c("STATION_CODE","START_TIME"),variable.name = "Health_Safety_Parameters",value.name = "Non_Compliant_Days")
    
    
    
    ##joining compliance and non compliance
    data_final<-merge(data1_melt,data2_melt,by=c("STATION_CODE","Health_Safety_Parameters","START_TIME"))
    data_final$Compliant_Days<-as.numeric(data_final$Compliant_Days)
    data_final$Non_Compliant_Days<-as.numeric(data_final$Non_Compliant_Days)
    data_final$Health_Safety_Parameters<-as.character(data_final$Health_Safety_Parameters)
    ##pan indigo analysis
    
    indigo=sqldf("select Health_Safety_Parameters as Health_Safety_Parameters, sum(Compliant_Days) as Compliant_Days,
                 sum(Non_Compliant_Days) as Non_Compliant_Days from data_final group by Health_Safety_Parameters order by Compliant_Days DESC ")
    
    indigo$Total_Instances=indigo$Compliant_Days+indigo$Non_Compliant_Days
    indigo$Compliant_Percent=100*(indigo$Compliant_Days/max(indigo$Total_Instances))
    indigo$Non_Compliant_Percent=100*(indigo$Non_Compliant_Days/max(indigo$Total_Instances))
    
    data_final$START_TIME=as.Date(as.numeric(data_final$START_TIME),origin = "1900-01-01")
    
    ##checklist filled by station daily per shift
    
    data=unique(data)
    names(data)[NCOL(data)]="HOW_USE_THE_ONLINE_CHECKLIST_IS_COMPARE_TO_PAPER_CHECKLIST"
    
    data$START_TIME=as.Date(as.numeric(data$START_TIME),origin = "1900-01-01")
    
    shift=sqldf("select STATION_CODE,SHIFT,START_TIME,count(HOW_USE_THE_ONLINE_CHECKLIST_IS_COMPARE_TO_PAPER_CHECKLIST) as Checklist_Filled from data group by STATION_CODE,SHIFT,START_TIME")
    
    indigo_station=sqldf("select Health_Safety_Parameters as Health_Safety_Parameters, STATION_CODE, sum(Compliant_Days) as Compliant_Days,
                         sum(Non_Compliant_Days) as Non_Compliant_Days from data_final group by Health_Safety_Parameters,STATION_CODE order by Compliant_Days DESC ")
    
    indigo_station$Total_Instances=indigo$Compliant_Days+indigo$Non_Compliant_Days
    switch(input$dataset,
           "Pan-Indigo-Report" = indigo,
           "Pan-Indigo-RawData" = data_final,
           "Checklist Daily Report" = shift,
           "Bottom 10 Compliance Report"=indigo_station)
  })
  
  
  # Table of selected dataset ----
  output$table <- renderTable({
    
    datasetInput()
    
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0(input$dataset, ".csv")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

