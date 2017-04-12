# Developing Data Products course project
# "Prediction Playground" Shiny application
# User-interface definition
# Romain Faure - April 2017
###########################################

library(shiny)
library(shinythemes)
library(plotly)

shinyUI(fluidPage(theme = shinytheme("simplex"),
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
                                         checkboxInput("setSeed", "Set seed to 1234", value = FALSE),
                                         checkboxInput("showDoc", "Show documentation", value = TRUE)
                                 ),
                                 
                                 wellPanel(
                                         tags$h4(icon("bar-chart-o"), paste0("Plot")),
                                         uiOutput("selecX1")
                                 )),
                          
                          column(9, uiOutput('rightPanel')
                          )
                          
                  )))
