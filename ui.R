# Define the User Interface (Frontend)
# Pink theme
pink_theme <- bslib::bs_theme(
  version = 5,

  bg = "#FFF5F8",
  fg = "#6B3A4A",

  primary = "#E88BAA",
  secondary = "#F4B8CC",
  success = "#D98CA8",
  info = "#F7C8D9"
)

ui <- bslib::page_fluid(
  theme = pink_theme,

  tags$head(
    tags$style(HTML("
    .card {
      background-color: #FFF9FB !important;
    }

    .card-header {
      background-color: #FCE4EC !important;
    }

    /* Compact nucleotide frequency table */
    #base_freq_table {
      width: 100%;
    }

    #base_freq_table table {
      width: 100%;
      margin-bottom: 0;
      color: #6B3A4A;
      border-collapse: collapse;
    }

    #base_freq_table thead th {
      background-color: #FFFFFF;
      color: #6B3A4A;
      border-bottom: 1px solid #D98CA8;
    }

    #base_freq_table tbody tr:nth-child(even) td {
      background-color: #FCE4EC !important;
    }

    #base_freq_table tbody tr:nth-child(odd) td {
      background-color: #FFFFFF !important;
    }

    #base_freq_table td,
    #base_freq_table th {
      padding: 6px 10px;
    }
  "))
  ),


  #title
  bslib::layout_columns(
    col_widths = 12,

    bslib::card(
      titlePanel("Virtual Central Dogma"),
      style = "background-color: #FCE4EC; padding: 15px;"
    )
  ),


  #about section
  bslib::layout_columns(
    col_widths = 12,

    bslib::card(
      titlePanel("About"),
      helpText("This shiny app generates random DNA strings based on varying probabilities and sequence lengths, translates the DNA sequence to RNA, and then translates the RNA sequence to an amino acid sequence. This is done via the virtual tools: Vitrual Gene Generator, Virtual RNA Polymerase and Virtual Ribosome.")
    )
  ),


  #virtual gene generator
  bslib::layout_columns(
    col_widths = 12,

    bslib::card(
      bslib::card_header("Virtual Gene Generator"),

      # Number of bases
      sliderInput(
        inputId = "n_bases",
        label = "Number of bases:",
        min = 3,
        max = 60,
        value = 30,
        step = 3,
        width = "100%"
      ),

      # DNA output
      verbatimTextOutput(
        outputId = "dna"
      ),

      # Probability inputs
      bslib::layout_columns(
        col_widths = c(3, 3, 3, 3),

        numericInput(
          inputId = "prob_A",
          label = "Probability of A",
          value = 0.25,
          min = 0,
          max = 1,
          step = 0.01
        ),

        numericInput(
          inputId = "prob_T",
          label = "Probability of T",
          value = 0.25,
          min = 0,
          max = 1,
          step = 0.01
        ),

        numericInput(
          inputId = "prob_C",
          label = "Probability of C",
          value = 0.25,
          min = 0,
          max = 1,
          step = 0.01
        ),

        numericInput(
          inputId = "prob_G",
          label = "Probability of G",
          value = 0.25,
          min = 0,
          max = 1,
          step = 0.01
        )
      )
    )
  ),


  #virtual rna polymerase
  bslib::layout_columns(
    col_widths = 12,

    bslib::card(
      bslib::card_header("Virtual RNA Polymerase"),

      textAreaInput(
        inputId = "dna_input",
        label = "DNA sequence:",
        placeholder = "Paste your DNA sequence here...",
        width = "100%",
        rows = 3
      ),

      actionButton(
        inputId = "transcribe",
        label = "Transcribe DNA to RNA"
      ),

      verbatimTextOutput(
        outputId = "rna"
      ),

      # Table of frequencies
      bslib::card(
        bslib::card_header("Table of frequencies"),

        div(
          style = "width: 280px; max-width: 100%;",
          tableOutput("base_freq_table")
        )
      ),

      # Nucleotide frequency plot
      bslib::card(
        bslib::card_header("Nucleotide frequency"),
        plotOutput("base_freq_plot", height = "300px")
      )
    )
  ),


  #virtual ribosome
  bslib::layout_columns(
    col_widths = 12,

    bslib::card(
      bslib::card_header("Virtual Ribosome"),

      textAreaInput(
        inputId = "rna_input",
        label = "RNA sequence:",
        placeholder = "Paste your RNA sequence here...",
        width = "100%",
        rows = 3
      ),

      actionButton(
        inputId = "translate",
        label = "Translate RNA to Protein"
      ),

      verbatimTextOutput("protein"),

      plotOutput("protein_plot")
    )
  )

)
