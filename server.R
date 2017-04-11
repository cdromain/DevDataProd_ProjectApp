# Developing Data Products course project
# "Prediction Playground" Shiny application
# Server logic
# Romain Faure - April 2017
###########################################

library(shiny)
library(plotly)
library(caret)
library(plyr)
library(mboost)
library(ipred)
library(e1071)
library(randomForest)
library(klaR)
library(evtree)
library(mgcv)
library(ElemStatLearn)
library(ISLR)
library(AppliedPredictiveModeling)
library(MASS)

shinyServer(function(input, output) {
        
        #output$variables <- reactive({
        #         names(input$dataset)
        # })
        
        # Return the requested dataset
        #datasetInput <- reactive({
        #input$dataset
        #})
        
        getUrl <- reactive({
                if (input$dataset == "iris") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/iris.html"
                if (input$dataset == "trees") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/trees.html"
                if (input$dataset == "mtcars") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html"
                if (input$dataset == "ToothGrowth") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/ToothGrowth.html"
                if (input$dataset == "ChickWeight") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/ChickWeight.html"
                if (input$dataset == "esoph") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/esoph.html"
                if (input$dataset == "faithful") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/faithful.html"
                if (input$dataset == "infert") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/infert.html"
                if (input$dataset == "Loblolly") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/Loblolly.html"
                if (input$dataset == "morley") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/morley.html"
                if (input$dataset == "Orange") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/Orange.html"
                if (input$dataset == "OrchardSprays") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/OrchardSprays.html"
                if (input$dataset == "InsectSprays") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/InsectSprays.html"
                if (input$dataset == "PlantGrowth") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/PlantGrowth.html"
                if (input$dataset == "pressure") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/pressure.html"
                if (input$dataset == "sleep") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/sleep.html"
                if (input$dataset == "swiss") 
                        url <- "https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/swiss.html"
                if (input$dataset == "spam") 
                        url <- "https://artax.karlin.mff.cuni.cz/r-help/library/kernlab/html/spam.html"
                if (input$dataset == "ozone") 
                        url <- "https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/ozone.info.txt"
                if (input$dataset == "prostate") 
                        url <- "https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/prostate.info.txt"
                if (input$dataset == "galaxy") 
                        url <- "https://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/galaxy.info.txt"
                if (input$dataset == "Auto") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=2"
                if (input$dataset == "Caravan") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=3"
                if (input$dataset == "Carseats") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=4"
                if (input$dataset == "College") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=5"
                if (input$dataset == "Default") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=6"
                if (input$dataset == "Hitters") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=7"
                if (input$dataset == "OJ") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=9"
                if (input$dataset == "Wage") 
                        url <- "https://cran.r-project.org/web/packages/ISLR/ISLR.pdf#page=11"
                if (input$dataset == "abalone") 
                        url <- "https://cran.r-project.org/web/packages/AppliedPredictiveModeling/AppliedPredictiveModeling.pdf#page=2"
                if (input$dataset == "ChemicalManufacturingProcess") 
                        url <- "https://cran.r-project.org/web/packages/AppliedPredictiveModeling/AppliedPredictiveModeling.pdf#page=5"
                if (input$dataset == "concrete") 
                        url <- "https://cran.r-project.org/web/packages/AppliedPredictiveModeling/AppliedPredictiveModeling.pdf#page=5"
                if (input$dataset == "schedulingData") 
                        url <- "https://cran.r-project.org/web/packages/AppliedPredictiveModeling/AppliedPredictiveModeling.pdf#page=14"
                url
                })
        
        #observeEvent(input$button1, {
        #        dataset <- input$dataset
        #        url <- getUrl()
        #        browseURL(url, browser = getOption("browser"), encodeIfNeeded = TRUE)
        #})
        
        output$helpButton <- renderUI({
                tags$a(class="btn btn-default", target="_blank", href=getUrl(), "?")
                })
        
        output$selecOutcome <- renderUI({
                dataset <- input$dataset
                selectInput("outcome", "Choose the outcome :", choices = names(dataset()))
        })
        
        output$selecPredictors <- renderUI({
                dataset <- input$dataset
                outcome <- input$outcome
                choices1 <- names(dataset())
                index <- which(choices1 == outcome)
                choices2 <- choices1[- index]
                selectInput("predictors", "Choose the predictors :", choices = choices2, multiple = TRUE, selected = names(dataset()))
        })
        
        output$selecX1 <- renderUI({
                dataset <- input$dataset
                outcome <- input$outcome
                choices1 <- names(dataset())
                index <- which(choices1 == outcome)
                choices2 <- choices1[- index]
                selectInput("x1", "x-axis variable :", choices = choices2)
        })
        
        dataset <- reactive({
                if(is.null(input$dataset))
                        return()
                dataset <- input$dataset
                if (dataset == "spam") 
                        data(spam, package = "kernlab")
                if (dataset == "abalone") 
                        data(abalone, package="AppliedPredictiveModeling")
                if (dataset == "ChemicalManufacturingProcess") 
                        data(ChemicalManufacturingProcess, package = "AppliedPredictiveModeling")
                if (dataset == "concrete") 
                        data(concrete, package = "AppliedPredictiveModeling")
                if (dataset == "schedulingData") 
                        data(schedulingData, package = "AppliedPredictiveModeling")
                get(dataset)
        })
        
        
        dataPartitioned <- reactive({

                if(input$setSeed){
                        set.seed(1234)
                }
                
                dataset <- dataset()
                if(is.null(dataset))
                        return()                
                
                ## Filtering out rows with missing values
                complete <- complete.cases(dataset)
                dataset <- dataset[complete,]
                
                y <- input$outcome
                if(is.null(input$outcome))
                        return()
                
                split <- input$split / 100
                inTrain <- createDataPartition(y = dataset[[y]], p = split, list = FALSE)
                output <- list()
                output$train <- dataset[inTrain, ]
                output$test <- dataset[-inTrain, ]
                output
        })
        
        model1 <- reactive({

                if(input$setSeed){
                        set.seed(1234)
                }
                
                if (input$method == 1) method <- "lm"
                if (input$method == 2) method <- "glmboost"
                if (input$method == 3) method <- "gam"                
                if (input$method == 4) method <- "treebag"
                if (input$method == 5) method <- "rf"
                if (input$method == 6) method <- "knn"
                if (input$method == 7) method <- "nb"
                if (input$method == 8) method <- "svmLinear"
                if (input$method == 9) method <- "evtree"
                x <- input$predictors
                if(is.null(input$predictors))
                        return()
                y <- input$outcome
                dataPartitioned <- dataPartitioned()
                training <- dataPartitioned$train
                
                k <- input$k
                if (k == 1) {
                        model1 <- train(reformulate(x, response = y), method = method, 
                                        data = training, na.action = na.fail)
                } else {
                        fitControl <- trainControl(method = "cv", number = k)
                        model1 <- train(reformulate(x, response = y), method = method, 
                                        data = training, trControl = fitControl, na.action = na.fail)
                }
                
                model1
        })
        
        predic <- reactive({
                dataPartitioned <- dataPartitioned()
                testing <- dataPartitioned$test
                if(is.null(testing))
                        return()
                model <- model1()
                if(is.null(model))
                        return()
                predict(model, testing)
        })
        
        
        output$results <- renderPrint({
                model1()
        })
        
        output$accuracy <- renderPrint({
                dataPartitioned <- dataPartitioned()
                testing <- dataPartitioned$test
                if(is.null(testing))
                        return()
                y <- input$outcome
                if(is.null(input$outcome))
                        return()
                pred <- predic()
                if(is.null(pred))
                        return()
                postResample(pred, testing[[y]])[1]
        })
        
        output$plot1 <- renderPlotly({
                model <- model1()
                dataPartitioned <- dataPartitioned()
                test <- dataPartitioned$test
                x1 <- input$x1
                y <- input$outcome
                
                if(is.null(model))
                        return()
                
                        pred <- data.frame(x = test[[x1]], y = predic(), label = "predicted values")
                        names(pred) <- c(x1, y, "label")
                        
                        test <- data.frame(test, label = "test set values")
                        
                        g <- ggplot(data = test, aes(x = test[[x1]], y = test[[y]])) +  
                                geom_point(aes(colour = test$label), size = 2, alpha = 0.6)
                        
                        g <- g + geom_point(aes(x = pred[1], y = pred[2], colour = pred$label), 
                                                    size = 2, alpha = 0.4, inherit.aes = FALSE)
                        
                        g <- g + theme(axis.title = element_text(size = 10)) + 
                                labs(x = x1, y = y) + scale_color_manual(values=c("#468cc8", "red"), 
                                                                         name = "Legend (show/hide)")
                        
                        ggplotly(g, tooltip = c("x","y"))
        })     
        
})
