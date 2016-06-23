#---------Connecting to Adobe Analytics and creating Search Key Word's Word Cloud----------------------

#Author: Alice Daish (British Museum adaish@britishmuseum.org)
#January 2016
#https://github.com/BritishMuseum/RSearchWordCloud

#------------PACKAGE IN USE IS RSITECATALYST-----------------------------------------------------------
#https://github.com/randyzwitch/RSiteCatalyst

#------------INSTALL PACKAGES--------------------------------------------------------------------------
#install.packages("devtools")
library(devtools)
#install_github("randyzwitch/RSiteCatalyst", ref="master")
library(RSiteCatalyst)

#------Install dependant packages-----------------------------------------------------------------------
#install.packages("jsonlite")
#install.packages("plyr")
#install.packages("httr")
#install.packages("stringr")
#install.packages("digest")
#install.packages("base64enc")
#install.packages("RCurl")
library("jsonlite")
library("plyr")
library("httr")
library("stringr")
library("digest")
library("base64enc")
library("RCurl")

#-------Authentication----------------------------------------------------------------------------------
#Find web service credentials in User Managerment in the marketing cloud
#log in for adobe analytics
SCAuth("username:Company", "secretkey")

#----------Explore Report Suite and Metrics, Evars and Props--------------------------------------------
#Report Suites
report_suites <- GetReportSuites()
report_suites

#Find eVars
eVars<-GetEvars("ReportSuite")
eVars

eVars[which(eVars$id =="evar1-search term"),] #search Term = word
eVars[which(eVars$id =="evar2-search results"),] #search results = freq

eVars$name

#Find metrics
metrics<-GetMetrics("ReportSuiteName")
metrics$id #list of metric id available

#Find elements
elements <- GetElements("ReportSuiteName")
elements$id #list of elements id available

#GetSuccessEvents
events <- GetSuccessEvents("ReportSuiteName")
events <- GetSuccessEvents(report_suites$rsid)
events

#GetProps
props <- GetProps("ReportSuiteName")
props

#-------------- Finding Top search words----------------------------------------------------------------
#Find top 500 search grouped from start of analytics to today
searchdata<-QueueRanked("ReportSuiteName", 
                     date.from="2015-07-08", #start date for example "2015-07-08" to
                     date.to="2016-06-19",   #end date for example "2016-06-19"
                     metrics=c("event1"), #Search Results -"event" need DTM name provided
                     elements=c("evar2"), #Search Term -"evar" need DTM name provided
                     search=c("::unspecified::","PDF*"),search.type="not", #exclude unwanted words
                     top=500)
View(searchdata) #view data

#---------------Create a Search Wordcloud----------------------------------------------------------------
#-------General WORD CLOUD ----------MAKE A PICTURE FOR ALL SEARCH CONTENT
#install.packages("wordcloud")
library(wordcloud)

#TOP 500 KEYWORD SEARCH TERMS 
png("wordcloudkeywords.png", width=700,height=700) #create a png
#-------------WORDCLOUD RANDOM COLOURS ---------------------------
wordcloud(searchdata$name,searchdata$event1,scale=c(8,.2), 
          min.freq=2,   #minimum count of words results 
          max.words=Inf, #max count of words results 
          random.order=FALSE, #largest word in the middle
          random.color=TRUE, #change to FALSE of non-random colours
          rot.per=.35, #text rotation
          colors=brewer.pal(8, "Dark2"), #Choose colour palette
          )
dev.off() #close and create png

#---------------------------------------------end--------------------------------------------------------

