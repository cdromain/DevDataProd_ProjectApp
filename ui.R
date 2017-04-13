# Developing Data Products course project   #
# "Prediction Playground" Shiny application #
# User-interface definition                 #
# Romain Faure - April 2017                 #
#############################################

library(shiny)
library(shinythemes)
library(plotly)

shinyUI(fluidPage(theme = shinytheme("simplex"),
                  titlePanel("Prediction Playground"),
                  fluidRow(
                          column(3,
                                 wellPanel(
                                         fluidRow(
                                                 column(9, div(style="height: 70px;", selectInput("dataset", label = "Data set :", 
                                                                       list("iris", "trees", "mtcars", "ToothGrowth",
                                                                            "ChickWeight", "esoph", "faithful",
                                                                            "infert", "Loblolly", "morley", "Orange",
                                                                            "OrchardSprays", "InsectSprays",
                                                                            "PlantGrowth", "pressure", "sleep",
                                                                            "swiss", "spam", "ozone", "prostate",
                                                                            "galaxy", "Auto", "Caravan", "Carseats",
                                                                            "College", "Default", "Hitters", "OJ",
                                                                            "Wage", "abalone", "ChemicalManufacturingProcess",
                                                                            "concrete", "schedulingData"), selected = "faithful"))
                                                 ),
                                                 column(1, uiOutput("helpButton"))),
                                         div(style="height: 60px;", uiOutput("selecOutcome")),
                                         uiOutput("selecPredictors"),
                                         div(style="height: 85px;", sliderInput("split", "Data in training set (%) :", 1, 90, value = 80)),
                                         div(style="height: 90px;", sliderInput("k", "k-fold cross validation (k) :", 1, 20, value = 5)),
                                         div(style="height: 70px;", selectInput("method", label = "Model type :", 
                                                     list("Linear model (R)" = 1, 
                                                          "Boosted Generalized Linear Model" = 2, "Generalized Additive Model using splines" = 3,
                                                          "Boosted logistic regression (C)" = 4, "Bagged CART" = 5, "Random forest" = 6, 
                                                          "k-Nearest Neighbors" = 7, "Linear Discriminant Analysis (C)" = 8, "Naive Bayes (C)" = 9, 
                                                          "S.V.M. with linear kernel" = 10, "Neural network" = 11, "Tree models from genetic algorithms" = 12), selected = 1)),
                                         div(style="height: 12px;", checkboxInput("setSeed", "Set seed to 1234", value = FALSE)),
                                         div(style="height: 5px;", checkboxInput("showDoc", "Show documentation", value = TRUE))
                                 ),
                                 
                                 wellPanel(
                                         div(style="height: 20px;", tags$h4(icon("bar-chart-o"), paste0("Plot"))),
                                         div(style="height: 50px;", uiOutput("selecX1")),
                                         div(style="height: 12px;", checkboxInput("showLine", "Show prediction line", value = FALSE)),
                                         div(style="height: 5px;", checkboxInput("showSmooth", "Show smoothed line", value = FALSE))
                                 )),
                          
                          column(9, uiOutput('rightPanel')
                          )
                          
                  ))
        )
