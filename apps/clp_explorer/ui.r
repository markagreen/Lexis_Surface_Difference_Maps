

country_codes <- read.csv("data/country_codes__new.csv", stringsAsFactors=F)
europe_labels <- country_codes$short[country_codes$europe==1]
names(europe_labels) <- country_codes$long[country_codes$europe==1]

shinyUI(fluidPage( 
  titlePanel("Comparative Level Plot Explorer"),

  helpText(em("Dr Jon Minton, University of Glasgow"), align="right"),br(),
  helpText(em("10 May 2015"), align="right"),
  br(),
  hr(),
  
  h2("Information and instructions"),
  em("Once the data are loaded, please select a country."),
  em("Once a selection is made, the comparative level plot (CLP) will be generated."),br(),
  em("Reds on the CLP indicate worse-than-average mortality, and blues indicated better-than-average mortality rates."),br(),
  em("The darkness of the shade indicates how far the mortality rates differ from the European average."),
  br(),
  em("If the box is checked, then a shaded contour map showing mortality rates for Europe as a whole will be shown."),
  br(),
  
  hr(),
  fluidRow(
    column(
      4,
      h3("Select country"),
      selectInput(
        "country_selection", "select a country",
        choices=c("", names(europe_labels)),
        selected=""
      ),
      checkboxInput(
        "select_sc_plot",
        "Check to show overall shaded contour plot",
        value=FALSE
      ),
      checkboxInput(
        "select_composite_plot",
        "Check to show composite plot",
        value=FALSE
      )
      
    ),
    column(
      4,
      h3("Select range"),
      sliderInput(
        inputId = "year_range", 
        label = "select range of years",
        min=1900, max=2011,
        value=c(1950, 2010), step=1,
        sep=""
      ),
      sliderInput(
        inputId = "age_range",
        label = "select range of ages",
        min=0, max=100,
        value=c(0, 80), step=1
      )      
    ),
    column(
      3,
      checkboxInput(
        "show_cohort_line",
        "Check to overlay a cohort line and bathtub curves",
        value=FALSE
      ),
      sliderInput(
        inputId ="select_cohort_year",
        label="select the cohort to highlight",
        min=1900, max=2000,
        value=1970, step=1,
        sep=""
        )
    ),
    column(
      3,
      checkboxInput(
        "apply_blurrer",
        "Check to apply a blurrer to the CLP levels",
        value=FALSE
        ),
      sliderInput(
        inputId="blurrer_value",
        label="Select the level of blur to apply",
        min=0.5, max=3.5,
        value=2.0, step=0.1
        )
      
      )
  ),
  hr(),
  
  textOutput("show_blur_value"),
  
  # outputs: SCP ------------------------------------------------------------  
  h2("Shaded Contour Plot"),
  em("The shaded contour plot shows the European average mortality rate, and how it varies"),
  em(" over the years for which the data are available. Contour lines connect positions "),
  em("on the Lexis surface (the range of age and year combinations) that have equal values. "),
  em("A slightly upwards sloping line therefore shows a steady improvement in mortality rates."),
  br(), em("The shade of the cells behind the contour lines also indicates the underlying value, "),
  em("with darker shades indicating higher values."),br(),
  em("All mortality rates are shown on the log scale, to make trends in adulthood easier to identify"),
  plotOutput("plot_scp", height="auto"),
  
  # outputs: CLP ------------------------------------------------------------
  
  h2(textOutput("text_clp_title")),
  em("This image shows the comparative level plot (CLP). Reds indicate that health is worse than"),
  em(" the European average, and blues indicate better health than the European average."),
  em("Lighter shades indicate smaller differences from the average, and darker shades indicate "),
  em("greater differences from the average."),br(),
  em("The left panel shows the CLP for females, and the right panel shows the CLP for males"),
  plotOutput("plot_clp", height="auto"),
  br(),
  
  # Outputs: Bathtub --------------------------------------------------------  
  h2("Bathtub Plot"),
  em("This shows the relationship between age and mortality risk for the cohort of interest, "),
  em("for the country of interest (solid line) compared with the average of all countries (dashed line"),
  plotOutput("plot_bathtub")
  
))
