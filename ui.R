
# This is the user-interface definition of a Shiny web application that
# uses the mtcars data set ("mt" as in "Motor Trend") from
# a standard R distribution.
#
# The weight of the car and the number of cyclinders in the
# cars engine are used to predict gas mileage.
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Motor Trend Cars - Gas Mileage"),
  
  # Sidebar with a helpful prompt, a slider to set cylinder
  # count, a slider to set weight, and an output for the
  # predicted value (which will also be in the plot to the
  # right)
  sidebarLayout(
    sidebarPanel(
      p(
        "We've created a model that predicts gas mileage",
        "when given the number of cylinders in the car's",
        "engine and the car's weight.",
        "The model is derived from a Motor Trends data set."
      ),
      br(),
      p(
        "Use the controls below to adjust settings and the",
        "prediction will be displayed in the plot to the",
        "right."
      ),
      br(),
      
      sliderInput("cyl",
                  "Number of cyclinders:",
                  min = 1,
                  max = 10,
                  value = 8),
      
      sliderInput("wt",
                  "Weight (tons):",
                  min = 1,
                  max = 15,
                  value = 4),
      
      br(), br(),
      textOutput("predictedMpg")
    ),
    
    # Show a plot of the cars and the prediction
    mainPanel(
      plotOutput("mpgPlot")
    )
  )
))