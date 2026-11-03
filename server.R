# Define the Server (Backend)
source("app_functions.R")
server <- function(input, output, session) {

  protein_sequence <- reactiveVal(NULL)


  # Virtual gene generator

  # Store the generated DNA sequence
  dna_sequence <- reactiveVal(NULL)

  # Generate DNA automatically when the app starts
  observe({

    tryCatch({

      dna_sequence(
        gene_dna(
          length = input$n_bases,
          base_probs = c(
            input$prob_A,
            input$prob_T,
            input$prob_C,
            input$prob_G
          )
        )
      )

    }, error = function(e) {
      showNotification(
        conditionMessage(e),
        type = "error"
      )
    })

  })

  # Display the DNA sequence
  output$dna <- renderText({

    dna_sequence()

  })


  # Transcription from DNA to RNA

  rna_sequence <- reactive({

    dna <- input$dna_input

    if (is.null(dna) || dna == "") {
      return("")
    }

    transcribe_dna(dna)

  })

  output$rna <- renderText({

    rna_sequence()

  })


  # Translation from RNA to protein

  amino_acid_sequence <- reactive({

    rna <- input$rna_input

    if (is.null(rna) || rna == "") {
      return("")
    }

    translate_rna(rna)

  })

  output$protein <- renderText({

    amino_acid_sequence()

  })

  protein_sequence <- reactive({

    amino_acid_sequence()

  })

  # Amino acid frequency plot
  output$protein_plot <- renderPlot({

    aminoacids <- protein_sequence()

    # Show an empty plot if there is no protein sequence
    if (is.null(aminoacids) || aminoacids == "") {

      ggplot2::ggplot() +
        ggplot2::labs(
          title = "Amino acid frequency",
          x = "Amino acid",
          y = "Frequency"
        ) +
        ggplot2::theme_classic() +
        ggplot2::theme(
          plot.title = ggplot2::element_text(
            hjust = 0.5,
            face = "bold"
          )
        )

    } else {

      plot_aa(aminoacids)

    }

  })

  # Nucleotide frequency table and plot

  # Calculate nucleotide frequencies from the DNA input
  base_frequency_data <- reactive({

    dna <- input$dna_input

    # Handle empty input
    if (is.null(dna) || dna == "") {
      return(
        data.frame(
          nucleotide = factor(
            c("A", "C", "G", "T"),
            levels = c("A", "C", "G", "T")
          ),
          Freq = c(0, 0, 0, 0)
        )
      )
    }

    # Clean DNA sequence
    dna <- toupper(gsub("\\s+", "", dna))

    # Count nucleotides
    dna_vector <- strsplit(dna, "")[[1]]

    base_counts <- table(
      factor(
        dna_vector,
        levels = c("A", "C", "G", "T")
      )
    )

    data.frame(
      nucleotide = factor(
        names(base_counts),
        levels = c("A", "C", "G", "T")
      ),
      Freq = as.numeric(base_counts)
    )
  })


  # Render nucleotide frequency table
  output$base_freq_table <- renderTable({

    base_frequency_data() |>
      dplyr::rename(
        nucleotide = nucleotide,
        Freq = Freq
      )

  },
  rownames = FALSE,
  colnames = TRUE,
  digits = 0
  )


  # Render nucleotide frequency plot
  output$base_freq_plot <- renderPlot({

    df <- base_frequency_data()

    ggplot2::ggplot(
      df,
      ggplot2::aes(
        x = nucleotide,
        y = Freq
      )
    ) +

      ggplot2::geom_col(
        fill = "#E88BAA",
        width = 0.8
      ) +

      ggplot2::labs(
        title = "Nucleotide frequency",
        x = "Nucleotide",
        y = "Frequency"
      ) +

      ggplot2::theme_classic() +

      ggplot2::theme(
        plot.title = ggplot2::element_text(
          hjust = 0.5,
          face = "bold"
        )
      )

  })

}
