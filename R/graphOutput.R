#' Render a Rickshaw graph
#' 
#' @param outputId output variable which will be used in addressing update
#' messages.
#' @param width Graph width. Until more testing is done with Rickshaw, your
#'  safest bet is to leave these as numeric values representing the units in 
#'  pixels.
#' @param height Graph height Must be a valid CSS unit (like "100\%", "400px", 
#' "auto") or a number, which will be coerced to a string and have "px" 
#' appended.
#' @param axisType The type of X-axis to use for the graph. \code{time} assumes
#' the data will be provided as a number of seconds since the epoch (see 
#' \code{\link{Sys.time}}) and will render them accordingly. \code{numeric} will 
#' not manipulate the provided numeric values.
#' @param legend If specified, an interactive legend of all series of data
#' displayed in the graph will be visible at the location given. If unspecified,
#' the legend will not be visible.
#' @param toolTip If \code{TRUE}, a tooltip providing additional information
#' about the values in the graph will be available when the user points the
#' mouse at the graph.
#' @param type The renderer to use when displaying the graph.
#' @importFrom shiny validateCssUnit
#' @seealso \code{\link{lineGraphOutput}}
#' @author Jeff Allen <jeff.allen@@trestletechnology.net>
graphOutput <- function(outputId, width, height, 
                            axisType=c("numeric", "time"),
                            legend = c("topleft", "topright", "bottomleft", "bottomright"),
                            toolTip = TRUE, 
                            type=c("line", "scatterplot", "area", "bar")) {
  graphType <- match.arg(type)
  
  legendDiv <- ""
  if (!missing(legend)){
    legend <- match.arg(legend)
    
    side <- "right"
    if (grepl("left", legend)){
      side <- "left"
    }
        
    marginAdjust <- "margin-top: -100px"
    if (grepl("top", legend)){
      marginAdjust <- paste("margin-top: -", validateCssUnit(height), ";", sep="")
    }
    
    legendDiv <- tags$div(id= paste(outputId, "-legend", sep=""), class="rickshaw_legend",
           style=paste("float: ",side,"; margin-",side,": 50px;", marginAdjust, sep=""))
      
  }
  
  axisType <- match.arg(axisType)
  axisType <- switch(axisType, 
                     time = "Time",
                     numeric = "X")
  
  tagList(
    singleton(tags$head(
      initResourcePaths(),
      tags$script(src = 'shinyDash/rickshaw/d3.v3.min.js'),
      tags$script(src = 'shinyDash/rickshaw/rickshaw.min.js'),
      tags$script(src = 'shinyDash/rickshaw/initRickshaw.js'),
      tags$link(rel = 'stylesheet',
                type = 'text/css',
                href = 'shinyDash/rickshaw/rickshaw.min.css')
    )),
    tags$div(id = outputId, class = "rickshaw_output", style = 
               paste("width:", validateCssUnit(width), ";", "height:", 
                     validateCssUnit(height), ";")),
    
    #include the legend element if 'legend' is true.
    legendDiv,
    
    tags$script(paste("new ShinyRickshawDOM('",outputId,"',
                       '",as.integer(width),"',
                       '",as.integer(height),"',
                       '",type,"',
                       '",axisType,"',
                       ",ifelse(missing(legend), 'false', 'true'),",
                       '",toolTip,"')", sep=""))
)
}