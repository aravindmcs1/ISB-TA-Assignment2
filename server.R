

shinyServer(function(input, output) {
  
  Dataset <- reactive({
    
    if (is.null(input$file1)) {return(NULL)} 
    else{
        text <- readLines(input$file1$datapath )
        text = str_replace_all(text, "<.*?>", "")
        text = text[text !=""]
        return(text)
    }
  })

  
  
  lang_model = reactive({
    if (input$lang == "Eng") {
      lang_model = udpipe_load_model("./english-ud-2.0-170801.udpipe")
    }
    if (input$lang == "Span") {
      lang_model = udpipe_load_model("./spanish-ud-2.0-170801.udpipe")
    }
    if (input$lang == "Hin") {
      lang_model = udpipe_load_model("./hindi-ud-2.0-170801.udpipe")
    }
    return(lang_model)
  })
    
  annot = reactive({
    x <- udpipe_annotate(lang_model(), x = Dataset()) 
    x <- as.data.frame(x)
    return(x)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      "annotated_data.csv"
    },
    content = function(file){
      write.csv(annot()[-4], file, row.names = FALSE)
    }
  )
  
  output$top_100_annotated = renderDataTable({
    if (is.null(input$file1)) {return(NULL)}
    out = annot()[-4]
    return(out)
  })
  

  output$wordcloud = renderPlot({
      if (is.null(input$file1)) {return(NULL)}
      else{
        x <- annot()
        x = x %>% subset(., upos %in% input$rd) 
        x = txt_freq(x$lemma)  # txt_freq() calcs noun freqs in desc order
        
        wordcloud(x$key, x$freq, scale = c(3.5, 0.5), min.freq = 5, max.words = 100, colors = brewer.pal(8, "Dark2"))

        }
    })
  
  
  output$COG = renderPlot({
    if (is.null(input$file1)) {return(NULL)}
    else{
      nokia_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(annot(), upos %in% input$upos), 
        term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      wordnetwork <- head(nokia_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
 
        
#        labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
        labs(title = "Cooccurrences within 3 words distance", subtitle = "Cooccurrences plot")
    }
  })
  
})
