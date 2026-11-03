# Define the Server (Backend)
source("app_functions.R")
server <- function(input, output, session) {

  # ----------------------------------------
  # 1. VIRTUAL GENE
  # ----------------------------------------

  output$dna <- renderText({

    gene_dna(
      length = input$n_bases,

      base_probs = c(
        input$prob_A,
        input$prob_T,
        input$prob_C,
        input$prob_G
      )
    )

  })


  # ----------------------------------------
  # 2. TRANSCRIPTION: DNA -> RNA
  # ----------------------------------------

  observeEvent(input$transcribe, {

    # Take the DNA sequence entered by the user
    dna <- input$dna_input

    # Transcribe DNA into RNA
    rna <- transcribe_dna(dna)

    # Display the RNA sequence
    output$rna <- renderText({
      rna
    })

  })


  # ----------------------------------------
  # 3. TRANSLATION: RNA -> PROTEIN
  # ----------------------------------------

  observeEvent(input$translate, {

    # Take the RNA sequence entered by the user
    rna <- input$rna_input

    # Translate RNA into a protein sequence
    protein <- translate_rna(rna)

    # Display the protein sequence
    output$protein <- renderText({
      protein
    })

  })

}
