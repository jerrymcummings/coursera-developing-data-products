
# This is the server logic for a Shiny web application that
# uses the mtcars data set ("mt" as in "Motor Trend") from
# a standard R distribution.
#
# The weight of the car and the number of cyclinders in the
# cars engine are used to predict gas mileage.
#

library(shiny)
library(ggplot2)


shinyServer(function(input, output) {
  
  # for the sake of effeciency, put the 'expensive' model run
  # in one place where shiny's reactive machinery can keep it
  # to one run per change (i.e. not doing the calc twice, once
  # for the text output in the sidebar and once for the plot)
  predicted.mpg <- reactive({
    # create the model. in the future additional inputs could
    # go here
    model <- lm(mpg ~ cyl + wt, data=mtcars)
    
    # given user's selections, get a prediction
    x <- predict(model, newdata=data.frame(cyl=input$cyl, wt=input$wt))
    
    # return prediction to the caller
    return(x[1])    
  })
  
  # format and return the text of our prediction
  output$predictedMpg <- renderText(sprintf('Prediction: %.1f MPG',predicted.mpg()))
  
  # Show an awesome plot of all the motortrend data plus the user's
  # car and prediction.
  output$mpgPlot <- renderPlot({
    
    # we're going to start with a copy of mtcars data set and
    # then add a fake car for the user
    zcars <- mtcars
    
    # new column, initialized to show where the car data came from
    zcars$from = 'Motor Trend'
    
    # create the user's car
    new.car <- data.frame(
      mpg = predicted.mpg(),
      cyl = input$cyl,
      disp = 1,
      hp = 1,
      drat = 1,
      wt = input$wt,
      qsec = 1,
      vs = 1,
      am = 1,
      gear = 1,
      carb = 1,
      from = 'Prediction'
    )
    
    # append the new car
    zcars <- rbind(zcars, new.car)
    rownames(zcars)[nrow(zcars)] <- "user"
    
    # we'll try to highlight the user's car and prediction
    # by drawing a shaded rectangle around that point on
    # the plot. Figure out how much we need to go in each
    # direction around the point to draw the box.
    xfactor <- (max(zcars$wt) - min(zcars$wt)) * 0.025
    yfactor <- (max(zcars$cyl) - min(zcars$cyl)) * 0.25
    
    # Instead of showing cylinders as a continuous variable, flip
    # it into a factor so that we get discrete values and colors.
    # --- we do this after the above calculation so that max/min
    # --- can work as expected.
    zcars$cyl <- as.factor(zcars$cyl)
    
    # do the plot
    p <- ggplot(zcars, aes(x=wt, y=mpg, color=cyl, shape=from)) +
      annotate('rect',
               xmin=new.car$wt-xfactor, ymin=new.car$mpg-yfactor,
               xmax=new.car$wt+xfactor, ymax=new.car$mpg+yfactor,
               alpha=0.3,
               fill='darkorange') +
      geom_point(size=5, alpha=0.75) +
      xlab('Weight (tons)') +
      ylab('Miles Per Gallon') +
      ggtitle('Predicting Miles Per Gallon\nfrom Engine Cylinder Count and Weight\n') +
      theme_bw()
    
    # 'return' the plot to shiny
    print(p)
  })
  
})