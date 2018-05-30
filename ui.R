#---------------------------------------------------------------------#
#               Udpipe Text An App                               #
#---------------------------------------------------------------------#

if (!require(udpipe)){install.packages("udpipe")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(igraph)) {install.packages("igraph")}
if (!require(ggraph)) {install.packages("ggraph")}
if (!require(tm)) {install.packages("tm")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(wordcloud)){install.packages("wordcloud")}



library(udpipe)
library(textrank)
library(lattice)
library(stringr)
library(tm) 
library(tidyverse)
library(tidytext)
library(wordcloud)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)


shinyUI(
  fluidPage(
  
    titlePanel("Annotation using UDPipe"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("file1", "Upload text file"),
              checkboxGroupInput("upos", 
                                 label = h3("Select POS tag"), 
                                 choices = list("Adjective" = 'ADJ', 
                                                "Noun" = 'NOUN',
                                                "Proper Noun" = 'PROPN', 
                                                "Adverb" = 'ADV', 
                                                "Verb" = 'VERB'),
                                 selected = c("ADJ", "NOUN", "PROPN")),

              
              radioButtons("lang", 
                                 label = h3("Select Language"), 
                                 choices = list("English" = 'Eng', 
                                                "Spanish" = 'Span',
                                                "Hindi" = 'Hin'),
                                 selected = "Eng"),
               radioButtons("rd",
                            label=h3("Select WordCloud POS tag"),
                            choices = list("Adjective" = 'ADJ', 
                                           "Noun" = 'NOUN',
                                           "Proper Noun" = 'PROPN', 
                                           "Adverb" = 'ADV', 
                                           "Verb" = 'VERB'),
                            selected = "NOUN")  ),   

              

    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input")),
                               p("This app supports only text files",align="justify"),
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on Browse and ', 
                                 span(strong("Upload text file.")),
                                 'You can also select POS tags')),
                      tabPanel("Annotated Document", 
                               dataTableOutput('top_100_annotated'),
                               downloadButton("downloaddata", "Download Annotated Data")),
                      
                      tabPanel("Wordcloud",
                               plotOutput('wordcloud')),
                          #     br(),  
                          #     h4(p("Verb Word Cloud")),
                          #     plotOutput('Verb_wordcloud')),
                      
                      tabPanel("Co-occurence Plots",
                               plotOutput('COG'))
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
                ) # end of UI
  


