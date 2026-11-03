# Define the Server (Backend)
source("app_functions.R")
server <- function(input, output, session) {

  protein_sequence <- reactiveVal(NULL)


# virtual gene generator
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


# transcription from dna to rna
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


# translation from rna to protein
  observeEvent(input$translate, {

    rna <- input$rna_input

    aminoacids <- translate_rna(rna)

    protein_sequence(aminoacids)

    output$protein <- renderText({
      aminoacids
    })

  })

# amino acid frequency plot
  output$protein_plot <- renderPlot({

    aminoacids <- protein_sequence()

    req(aminoacids)

    dawgma::plot_aa(aminoacids)

  })
  output$protein_plot <- renderPlot({

    aminoacids <- protein_sequence()

    if (is.null(aminoacids) || aminoacids == "") {
      return(NULL)
    }

    plot_aa(aminoacids)

  })

}
