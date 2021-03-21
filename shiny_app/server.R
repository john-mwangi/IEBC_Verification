load("iebc_data_fin.RData")

library(shiny)
library(DT)

shinyServer(function(input, output, session) {
    output$tbl_out = DT::renderDataTable(iebc_data_fin, 
                                         filter="top", 
                                         options = list(dom = "ltipr"), 
                                         rownames = FALSE)
})
