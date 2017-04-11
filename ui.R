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
                column(3,
                       wellPanel(
                               fluidRow(
                                       column(9, selectInput("dataset", label = "Data set :", 
                                                             list("iris", "trees", "mtcars", "ToothGrowth",
                                                                  "ChickWeight", "esoph", "faithful",
                                                                  "infert", "Loblolly", "morley", "Orange",
                                                                  "OrchardSprays", "InsectSprays",
                                                                  "PlantGrowth", "pressure", "sleep",
                                                                  "swiss", "spam", "ozone", "prostate",
                                                                  "galaxy", "Auto", "Caravan", "Carseats",
                                                                  "College", "Default", "Hitters", "OJ",
                                                                  "Wage", "abalone", "ChemicalManufacturingProcess",
                                                                  "concrete", "schedulingData"), selected = "faithful")
                                              ),
                                       column(1, uiOutput("helpButton"))),
                                       #column(1, actionButton("button1", "?"))),
                               uiOutput("selecOutcome"),
                               uiOutput("selecPredictors"),
                               sliderInput("split", "Data in training set (%) :", 1, 90, value = 80),
                               sliderInput("k", "k-fold cross validation (k) :", 1, 20, value = 5),
                               selectInput("method", label = "Model choice :", 
                                           list("Linear model (R)" = 1, 
                                                "Boosted Generalized Linear Model" = 2, "Generalized Additive Model using Splines" = 3, 
                                                "Bagged CART" = 4, "Random forest" = 5, 
                                                "k-Nearest Neighbors" = 6, "Naive Bayes (C)" = 7, 
                                                "S.V.M. with linear kernel" = 8, "Tree Models from Genetic Algorithms" = 9), selected = 1),
                               checkboxInput("setSeed", "Set seed to 1234", value = FALSE)
                       ),
                       wellPanel(
                               tags$h4(icon("bar-chart-o"), paste0("Plot")),
                               uiOutput("selecX1")
                       )),
                column(6,
                       verbatimTextOutput("results"),
                       h6("Prediction results on the test set :"),
                       verbatimTextOutput("accuracy"),
                       plotlyOutput("plot1", height = "300px")
                       # plotOutput("plot1", height = "350px", width = "75%")
                       # Masking error messages using CSS
                       ## source : https://groups.google.com/forum/#!topic/shiny-discuss/FyMGa2R_Mgs
                       #tags$style(type="text/css",
                       #".shiny-output-error { visibility: hidden; }",
                       #".shiny-output-error:before { visibility: hidden; }")
                ),
                column(3,
                       h4("Documentation"),
                       hr(),
                       h6("1. Select a data set"),
                       helpText("Click on the ? button to get more info",
                                "about the selected data set."),
                       hr(),
                       h6("2. Choose the outcome variable"),
                       hr(),
                       h6("3. Choose the predictors variable"),
                       helpText("Default = all; the chosen outcome variable", 
                                "is automatically removed from the list."),
                       hr(),
                       h6("4. Partition the data using the slider 1"),
                       helpText("This % gets assigned to the training set,", 
                                "while the remaining data goes to the test set."),
                       hr(),
                       h6("5. Choose k for k-fold cross-validation using slider 2"),
                       helpText("Choose 1 to disable C.V."),
                       hr(),
                       h6("6. Choose the prediction model"),
                       helpText("The model will be trained and then used", 
                                "for prediction. (C) means classification only",
                                "and (R) regression only."),
                       hr(),
                       h6("7. Optionally set the seed to 1234"),
                       helpText("The seed concerns both data partitioning", 
                                "and model building for reproducibility purposes.")
                       
                )
        )
))
