# Define the User Interface (Frontend)

ui <- bslib::page_fluid(

#title
  bslib::layout_columns(
    col_widths = 12,

    bslib::card(
      titlePanel("Virtual Central Dogma"),
      style = "background-color: #f0f0f0; padding: 15px;"
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
