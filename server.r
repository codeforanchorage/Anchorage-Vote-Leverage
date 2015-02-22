library(dplyr)
library(tidyr)
library(shiny)
library(ggplot2)
load("app_data.rda")

#input <- list(House_Can = "Young", Gov_Can = "Walker", HouseQuantile = .75, GovQuantile = 0.6, Prop1Quantile = .3, Prop2Quantile = .5, Prop3Quantile = .5, Prop4Quantile = .2)
shinyServer(function(input, output, session) {
  
reactive_plot <- reactive({
if(input$House_Can == "Dunbar")         {house_percentile <- quantile(app_data$Dunbar, input$HouseQuantile) }
if(input$House_Can == "McDermott") {house_percentile <- quantile(app_data$McDermott, input$HouseQuantile)}
if(input$House_Can == "Young")     {house_percentile <- quantile(app_data$Young, input$HouseQuantile)}

  if(input$Gov_Can == "Clift")           {gov_percentile <- quantile(app_data$Clift, input$GovQuantile) }
if(input$Gov_Can == "Myers")      {gov_percentile <- quantile(app_data$Myers, input$GovQuantile)}
if(input$Gov_Can == "Parnell")    {gov_percentile <- quantile(app_data$Parnell, input$GovQuantile)}
if(input$Gov_Can == "Walker")     {gov_percentile <- quantile(app_data$Walker, input$HouseQuantile)}

one_percentile   <- quantile(app_data$Prop1, input$Prop1Quantile)
two_percentile   <- quantile(app_data$Prop2, input$Prop2Quantile)
three_percentile <- quantile(app_data$Prop3, input$Prop3Quantile)
four_percentile  <- quantile(app_data$Prop4, input$Prop3Quantile)

app_data <- app_data[, c("District","Total_Votes", input$House_Can, input$Gov_Can, "Prop1", "Prop2",       "Prop3",       "Prop4")] 


df <- data.frame(x = c(1,2), y = c(0, 3), z = c(3, 0))

gov_diff   <- gov_percentile - app_data[,input$Gov_Can]
house_diff <- house_percentile - app_data[,input$House_Can]
one_diff   <- one_percentile - app_data$Prop1
two_diff   <- two_percentile- app_data$Prop2
three_diff <- three_percentile - app_data$Prop3
four_diff  <- four_percentile - app_data$Prop4

vote_distance <- sqrt(
    gov_diff^2 +
    house_diff^2 +
    one_diff^2 + 
    two_diff^2  +
    three_diff^2 + 
    four_diff^2
  )

df <- data.frame(District = app_data$District, 
           gov_diff, 
           house_diff,         
           one_diff, 
           two_diff, 
           three_diff, 
           four_diff,
           vote_distance,
           Total_Votes = app_data$Total_Votes)

ggplot(data = df, aes( x = (vote_distance/6)/ Total_Votes, label = District)) + geom_bar()

})

output$testplot <- renderPlot({
  print(reactive_plot())  })
})
