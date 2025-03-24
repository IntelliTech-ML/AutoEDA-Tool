library(shiny)
library(ggplot2)

#################################################################################
summary_fn<-function(data,selected_features){
  data<-data[selected_features]
  summary_data<-data.frame(
    Feature=colnames(data),
    Min=sapply(data,function(x) if(is.numeric(x)) summary(x)[1] else NA),
    Median=sapply(data,function(x) if(is.numeric(x)) summary(x)[3] else NA),
    Mean=sapply(data,function(x) if(is.numeric(x)) mean(x,na.rm=TRUE) else NA),
    Max=sapply(data,function(x) if(is.numeric(x)) summary(x)[6] else NA),
    StdDev=sapply(data,function(x) if(is.numeric(x)) sd(x,na.rm=TRUE) else NA),
    Variance=sapply(data,function(x) if(is.numeric(x)) var(x,na.rm=TRUE) else NA),
    MissingValues=sapply(data,function(x) sum(is.na(x)))
  )
  return(summary_data)
}

outlier_fn<-function(data,feature){
  ggplot(data,aes(x="",y=.data[[feature]]))+
    geom_boxplot(
      outlier.colour="red",
      outlier.shape=16,
      outlier.size=2,
      fill="skyblue",
      color="black")+
    labs(
      title=paste("Outlier Detection for",feature),
      x="Feature",y="Values"
    )+
    theme_minimal(base_size=14)
}

total_outlier<-function(data,feature){
  values<-data[[feature]]
  
  Q1<-quantile(values,0.25,na.rm=TRUE)
  Q3<-quantile(values,0.75,na.rm=TRUE)
  IQR<-Q3-Q1
  
  lower_bound<-Q1-1.5*IQR
  upper_bound<-Q3+1.5*IQR
  
  outliers<-sum(values<lower_bound|values>upper_bound,na.rm=TRUE)
  
  return(outliers)
}

dist_fn<-function(data,feature){
  ggplot(data,aes(x=.data[[feature]]))+
    geom_density(alpha=0.5,fill="blue",color="black")+
    labs(
      title=paste("Density Plot of",feature),
      x=feature,
      y="Density"
    )
}

data_fn<-function(data){
  result<-data.frame(
    Feature=colnames(data),
    Data_Type=sapply(data,class),
    row.names=NULL
  )
  return(result)
}

correlation_fn<-function(data,feature1,feature2){
  cor_value<-cor(data[[feature1]],data[[feature2]],use="complete.obs")
  return(data.frame(Feature1=feature1,Feature2=feature2,Correlation=cor_value))
}




#################################################################################

ui<-fluidPage(
  tags$style(
    HTML(
      "
      h2 {color: #4682B4; font-weight: bold;}
      body {background-color: #f4f7f9; font-family: Arial, sans-serif; color: #333;}
      .title {text-align: center; text-decoration: underline; font-style: bold;}
      
      .checkbox input[type='checkbox'] {
        width: 18px; height: 18px;
      }
      
      .checkbox label {font-size: 18px; line-height: 1.5;}
      
      .start {
        padding-left: 8vw; padding-right: 6.8vw;
        background-color: #4682B4;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        transition: background-color 0.3s, transform 0.2s;
      }
      
      .start:hover {
        background-color: #5a9fd6;
        cursor: pointer;
      }
      
      .start:active {
        transform: scale(0.98); 
        background-color: #3b6a91; 
      }
      
      .download {
        padding-left: 6.5vw; padding-right: 8vw;
        background-color: #5cb85c;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        transition: background-color 0.3s, transform 0.2s;
      }
      
      .download:hover {
        background-color: #6cd16c;
        cursor: pointer;
      }
      
      .download:active {
        transform: scale(0.98); 
        background-color: #4ca14c;
      }
      .main {background-color: #ffffff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
      }
      
      .image{border: 4px solid blue; border-radius: 10px;width:60vw;}  
      
      .pr_name{text-align:center;text-style:bold;color:blue;border:solid;border-color:red;padding:4px;}
      "
    )
  ),
  
  div(class="title",titlePanel("Auto EDA Tool")),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("CSV",tags$h2("Choose CSV File:")),
      br(),
      checkboxGroupInput(
        inputId="eda_options",
        div(class="lbl",tags$h2("Select EDA Tasks:")),
        choices=c(
          "Plotting (Necessary)",
          "Summarizing Data",
          "Identifying Outliers",
          "Data Types",
          "Correlation Analysis",
          "Data Distributions"
        )
      ),
      br(),br(),br(),
      actionButton("start","START ANALYSIS",class="start"),
      br(),br(),
      actionButton("reload", "RELOAD ANALYSIS", class = "download")
    ),
    
    mainPanel(
      class="main",
      uiOutput("plot_heading"),
      uiOutput("feature_selectors"),
      uiOutput("plot_btn"),
      uiOutput("plot_ui"),
      br(),br(),
      uiOutput("summ_heading"),
      uiOutput("feature_selector"),
      uiOutput("summary_btn"),
      tableOutput("summary_show"),
      br(),br(),
      uiOutput("outlier_heading"),
      uiOutput("feature_selector2"),
      uiOutput("outlier_btn"),
      br(),
      uiOutput("outlier_count"),
      br(),
      br(),
      uiOutput("type_heading"),
      tableOutput("table"),
      br(),br(),
      uiOutput("correlation_heading"),
      uiOutput("correlation_selectors"),
      uiOutput("correlation_btn"),
      br(),
      tableOutput("correlation_result"),
      br(),
      br(),
      uiOutput("distribution_heading"),
      uiOutput("feature_selector3"),
      uiOutput("distribution_btn"),
      br(),
      imageOutput("myImage"),
      plotOutput("dist_plot"),
      br(),
      br(),
      tags$h4(class="pr_name","R Programming Project Made by Ajay"),
    )
  )
)



server<-function(input,output,session){
  observeEvent(input$start,{
    data<-read.csv(input$CSV$datapath)
    
    #################################################################################
    if("Plotting (Necessary)"%in%input$eda_options){
      output$plot_heading<-renderUI({
        tags$h2("Plotting:")
      })
      
      output$feature_selectors<-renderUI({
        tagList(
          selectInput(
            inputId="feature1",
            label="Select a feature for the first plot:",
            choices=colnames(data),
            selected=colnames(data)[1]
          ),
          selectInput(
            inputId="feature2_x",
            label="Select the first feature for the second plot (X-axis):",
            choices=colnames(data),
            selected=colnames(data)[1]
          ),
          selectInput(
            inputId="feature2_y",
            label="Select the second feature for the second plot (Y-axis):",
            choices=colnames(data),
            selected=colnames(data)[2]
          )
        )
      })
      
      output$plot_btn<-renderUI({
        actionButton("plot","Generate Plots")
      })
      
      observeEvent(input$plot,{
        output$plot_ui<-renderUI({
          tagList(
            plotOutput("hist_plot"),
            plotOutput("scatter_plot")
          )
        })
        
        output$hist_plot<-renderPlot({
          hist(data[[input$feature1]],
               main=paste("Histogram of",input$feature1),
               xlab=input$feature1,
               col="skyblue",border="white")
        })
        
        output$scatter_plot<-renderPlot({
          plot(data[[input$feature2_x]],data[[input$feature2_y]],
               main=paste("Scatter Plot of",input$feature2_x,"vs",input$feature2_y),
               xlab=input$feature2_x,
               ylab=input$feature2_y,
               pch=19,col="darkgreen")
        })
      })
    }
    
    #################################################################################
    
    if("Summarizing Data"%in%input$eda_options){
      output$summ_heading<-renderUI({
        tags$h2("Summarizing Data:")
      })
      
      output$feature_selector<-renderUI({
        selectInput("selected_features","Select Features:",
                    choices=colnames(data),
                    multiple=TRUE)
      })
      
      output$summary_btn<-renderUI({
        actionButton("summarize","Summarize")
      })
      
      observeEvent(input$summarize,{
        output$summary_show<-renderTable({
          summary_fn(data,input$selected_features)
        })
      })
    }
    
    #################################################################################
    
    if("Identifying Outliers"%in%input$eda_options){
      output$outlier_heading<-renderUI({
        tags$h2("Identifying Outliers:")
      })
      
      output$feature_selector2<-renderUI({
        selectInput("outlier_feature","Select a Feature:",
                    choices=colnames(data))
      })
      
      output$outlier_btn<-renderUI({
        actionButton("detect_outliers","Detect Outliers")
      })
      
      observeEvent(input$detect_outliers,{
        output$outlier_count<-renderUI({
          outliers<-total_outlier(data,input$outlier_feature)
          ui_list<-list()
          ui_list<-append(ui_list,list(renderText({
            br()
            "Total Outliers are: "
          })))
          ui_list<-append(ui_list,list(renderText({
            outliers
          })))
          ui_list<-append(ui_list,list(renderPlot({
            outlier_fn(data,input$outlier_feature)
          })))
        })
      })
    }
    #############################################################################
    
    if("Data Distributions"%in%input$eda_options){
      output$myImage<-renderImage({
        list(
          class="image",
          src="distribution.jpg",
          contentType="image/jpg",
          alt="This is an image"
        )
      },deleteFile=FALSE)
      
      output$distribution_heading<-renderUI({
        tags$h2("Data Distributions:")
      })
      
      output$feature_selector3<-renderUI({
        selectInput("distribution_feature","Select a Feature:",
                    choices=colnames(data))
      })
      
      output$distribution_btn<-renderUI({
        actionButton("distribution_btn","See Data Distribution:")
      })
      
      observeEvent(input$distribution_btn,{
        output$dist_plot<-renderPlot({
          dist_fn(data,input$distribution_feature)
        })
      })
    }
    
    #############################################################################
    
    if("Data Types"%in%input$eda_options){
      output$type_heading<-renderUI({
        tags$h2("Data Types:")
      })
      
      output$table<-renderTable({
        class="table"
        data_fn(data)
      })
    }
    
    ###############################################################################
    
    if("Correlation Analysis"%in%input$eda_options){
      output$correlation_heading<-renderUI({
        tags$h2("Correlation Analysis:")
      })
      
      output$correlation_selectors<-renderUI({
        tagList(
          selectInput(
            inputId="feature_corr1",
            label="Select First Feature:",
            choices=colnames(data),
            selected=colnames(data)[1]
          ),
          selectInput(
            inputId="feature_corr2",
            label="Select Second Feature:",
            choices=colnames(data),
            selected=colnames(data)[2]
          )
        )
      })
      
      output$correlation_btn<-renderUI({
        actionButton("calc_correlation","Calculate Correlation")
      })
      
      observeEvent(input$calc_correlation,{
        output$correlation_result<-renderTable({
          correlation_fn(data,input$feature_corr1,input$feature_corr2)
        })
      })
    }
  })
  observeEvent(input$reload, {
    session$reload()
  })
  
}

shinyApp(ui,server)
