ui <- fluidPage(
  leafletOutput("m"),
  p(),
  selectInput("site", label="Site", choices=c("MLBS","TOOL"))
)