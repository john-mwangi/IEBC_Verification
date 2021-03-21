library(shiny)

fluidPage(
    tags$h1("Interim Verified List of BBI Supporters"),
    HTML("<p> A simple tool to help you check whether your name 
         is in the list of BBI supporters following the 
         <a href='https://twitter.com/IEBCKenya/status/1352199249069535233', target='_blank'> IEBC announcement</a> 
         recently made. Start by entering the last 3 digits 
         of your ID and one of your names.</p>"),
    tags$p(),
    DT::dataTableOutput('tbl_out')
)