#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(plyr)
library(mboost)
library(ipred)
library(e1071)
library(randomForest)
library(evtree)
library(mgcv)
library(ElemStatLearn)
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
                selectInput("predictors", "Choose the predictors (default = all) :", choices = choices2, multiple = TRUE, selected = names(dataset()))
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
                        data(spam, package="kernlab")
                get(dataset)
        })
        
        
        trainingData <- reactive({
                set.seed(1234)
                dataset <- dataset()
                y <- input$outcome
                split <- input$split / 100
                inTrain <- createDataPartition(y = dataset[[y]], p = split, list = FALSE)
                dataset[inTrain, ]
        })
        
        testingData <- reactive({
                set.seed(1234)
                dataset <- dataset()
                if(is.null(dataset))
                        return()
                y <- input$outcome
                if(is.null(input$outcome))
                        return()
                split <- input$split / 100
                inTrain <- createDataPartition(y = dataset[[y]], p = split, list = FALSE)
                dataset[-inTrain, ]
        })
        
        model1 <- reactive({
                set.seed(1234)
                if (input$method == 1) method <- "lm"
                if (input$method == 2) method <- "glmboost"
                if (input$method == 3) method <- "gam"                
                if (input$method == 4) method <- "treebag"
                if (input$method == 5) method <- "rf"
                if (input$method == 6) method <- "knn"
                if (input$method == 7) method <- "svmLinear"
                if (input$method == 8) method <- "evtree"
                x <- input$predictors
                if(is.null(input$predictors))
                        return()
                y <- input$outcome
                k <- input$k
                fitControl <- trainControl(method = "cv", number = k)
                model1 <- train(reformulate(x, response = y), method = method, 
                                data = trainingData(), trControl = fitControl, na.action = na.fail)
                model1
        })
        
        predic <- reactive({
                testing <- testingData()
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
                testing <- testingData()
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
        
        output$plot1 <- renderPlot({
                model <- model1()
                testing <- testingData()
                x1 <- input$x1
                y <- input$outcome
                
                if(is.null(model))
                        return()
                
                        datapred <- data.frame(x = testing[[x1]], y = predic(), label = "predictions")
                        names(datapred) <- c(x1, y, "label")
                        
                        testing <- data.frame(testing, label = "original data")
                        
                        g <- ggplot(data = testing, aes(x = testing[[x1]], y = testing[[y]])) +  
                                geom_point(aes(x = testing[[x1]], y = testing[[y]], colour = testing$label, shape = testing$label), 
                                           size = 5, alpha = 0.7)
                        
                        if(input$showPred){
                                g <- g + geom_point(aes(x = datapred[1], y = datapred[2], colour = datapred$label, shape = datapred$label), 
                                                    size = 4, alpha = 0.4)
                        }
                        
                        g <- g + ggtitle(paste("Dataset =", input$dataset))
                        g <- g + theme(plot.title = element_text(hjust=0.5, size = 16), 
                                       axis.title = element_text(size = 12)) + 
                                labs(x = x1, y = y) + scale_color_manual(values=c("#468cc8", "red"), name = "Legend") + 
                                scale_shape_manual(values=c(19, 16), name = "Legend")
                        g
        })     
        
})
