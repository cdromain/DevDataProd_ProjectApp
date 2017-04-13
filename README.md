# DevDataProd_ProjectApp

The *Prediction Playground* application is accessible at https://cdromain.shinyapps.io/prediction_playground/

## Introducing *Prediction Playground*

Started from the wish to be able to actually *play* with **machine learning** concepts and models in an interactive manner in order to develop understanding and intuition - hence the idea of a *"playground"*.     

The idea is to be able to quickly apply different prediction models to different data sets, splitting the data into training and test sets, choosing the outcome and the predictors, building the model and finally evaluate the accuracy of the model predictions. The application interface makes possible to **learn** by seeing how changing parameters affect the resulting predictions. And like in every playground, errors can happen and are part of the experience-based learning process.

For more information, see [this online presentation](https://cdromain.github.io/DevDataProd_ProjectPres/).

## Credits

- The *Prediction Playground* [Shiny](https://shiny.rstudio.com/) web application is powered and made possible by the [`caret`](https://topepo.github.io/caret/) package and its interface unifying different predictive algorithms. The interactive plot displayed in the app is powered by the [`plotly`](https://cran.r-project.org/web/packages/plotly/index.html) package and [graphing library](https://plot.ly/r/). Several other packages were used for data sets and predictive models (see the complete list in the [`server.R`](https://github.com/cdromain/DevDataProd_ProjectApp/blob/master/server.R) file.

- The *Prediction Playground* app was created for the *Developing Data Products* course project, part of the Johns Hopkins Data Science Specialization on [Coursera](http://coursera.org/), using RStudio version 1.0.136 (R version 3.3.3, OSX 10.11.6) in April 2017.

