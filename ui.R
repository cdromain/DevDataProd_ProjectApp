# Developing Data Products course project
# "Prediction Playground" Shiny application
# User-interface definition
# Romain Faure - April 2017
###########################################

library(shiny)
library(shinythemes)
library(plotly)

shinyUI(fluidPage(theme = shinytheme("simplex"),
        # theme = shinytheme("united"),
        # shinythemes::themeSelector(),
        titlePanel("Prediction Playground"),
        fluidRow(
                column(4,
                       wellPanel(
                               fluidRow(
                                       column(9, selectInput("dataset", label = "Data set :", 
                                                             list("iris", "trees", "mtcars", "ToothGrowth",
                                                                  "ChickWeight", "esoph", "faithful",
                                                                  "infert", "Loblolly", "morley", "Orange",
                                                                  "OrchardSprays", "InsectSprays",
                                                                  "PlantGrowth", "pressure", "sleep",
                                                                  "swiss", "spam", "ozone", "prostate",
                                                                  "galaxy"), selected = "faithful")
                                              ),
                                       column(1, uiOutput("helpButton"))),
                                       #column(1, actionButton("button1", "?"))),
                               uiOutput("selecOutcome"),
                               uiOutput("selecPredictors"),
                               sliderInput("split", "Percentage of data in training set :", 1, 90, value = 80),
                               sliderInput("k", "k-fold cross validation k value :", 2, 20, value = 5),
                               selectInput("method", label = "Model choice :", 
                                           list("Linear model" = 1, 
                                                "Boosted Generalized Linear Model" = 2, "Generalized Additive Model using Splines" = 3, 
                                                "Bagged CART" = 4, "Random forest" = 5, 
                                                "k-Nearest Neighbors" = 6, 
                                                "S.V.M. with linear kernel" = 7, "Tree Models from Genetic Algorithms" = 8), selected = 1)
                       ),
                       wellPanel(
                               tags$h4(icon("bar-chart-o"), paste0("Plot")),
                               uiOutput("selecX1"),
                               checkboxInput("showPred", "Show/Hide predictions", value = TRUE)
                       )),
                column(8,
                       verbatimTextOutput("results"),
                       h6("Prediction results on the test set :"),
                       verbatimTextOutput("accuracy"),
                       plotlyOutput("plot1", height = "350px", width = "75%")
                       # plotOutput("plot1", height = "350px", width = "75%")
                       # Masking error messages using CSS
                       ## source : https://groups.google.com/forum/#!topic/shiny-discuss/FyMGa2R_Mgs
                       #tags$style(type="text/css",
                       #".shiny-output-error { visibility: hidden; }",
                       #".shiny-output-error:before { visibility: hidden; }")
                )
        )
))
