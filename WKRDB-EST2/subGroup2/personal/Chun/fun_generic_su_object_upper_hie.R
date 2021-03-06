#' generic_su_object_upper_hie
#'
#' @param input_list All the data tables in a named list. Name should be equal 
#' to the short table names e.g. DE, SD, TE, FO. An example can be found at the share point: 
#' https://community.ices.dk/ExpertGroups/WKRDB/2019%20Meetings/WKRDB-EST%202019/06.%20Data/Kirsten/H1/H1_upper.RData
#' @param hierachy The number of the hierachy you are inputting - 1 to 13
#' 
#'
#' @return
#' @export
#'
#' @examples
#' 


generic_su_object_upper_hie <-
  function(input_list = H1_upper,
           hierachy = NULL) {
    library(dplyr)
    
    # CC: assign hierachy index from data, or check consistency between input and data
    if (is.null(hierachy)) {
      hierachy <- unique(input_list[["DE"]]$DEhierarchy)
    } else {
      if (hierachy != unique(input_list[["DE"]]$DEhierarchy)) 
        stop("Input hierachy is not consistent to data hierachy.")
    }
    
    
    # Varibale names for the output
    var_names <- c(
      "hierachy",
      "su",
      "recType",
      "idAbove",
      "id",
      "stratification",
      "stratum",
      "clustering",
      "clusterName",
      "total",
      "sampled",
      "prob",
      "selectMeth",
      "selectMethCluster",
      "totalClusters",
      "sampledClusters",
      "probCluster"
    )
    
    # createing a list with expected tables for each hierachy
    expected_tables <- list(
      H1 = data.frame(
        table_names = c("DE", "SD", "VS", "FT", "FO", "SL", "SA"),
        su_level = c("NA", "NA", "su1", "su2", "su3", "su4", "su5")
      ),
      H2 = data.frame(
        table_names = c("DE", "SD", "FT", "FO"),
        su_level = c("NA", "NA", "su1", "su2")
      ),
      H3 = data.frame(
        table_names = c("DE", "SD", "TE", "VS", "FT", "FO"),
        su_level = c("NA", "NA", "su1", "su2", "su3", "su4")
      ),
      H4 = data.frame(
        table_names = c("DE", "SD", "OS", "FT", "LE"),
        su_level = c("NA", "NA", "su1", "su2", "su3")
      ),
      H5 = data.frame(
        table_names = c("DE", "SD", "OS", "LE"),
        su_level = c("NA", "NA", "su1", "su2")
      ),
      H6 = data.frame(
        table_names = c("DE", "SD", "OS", "FT"),
        su_level = c("NA", "NA", "su1", "su2")
      ),
      H7 = data.frame(
        table_names = c("DE", "SD", "OS"),
        su_level = c("NA", "NA", "su1")
      ),
      H8 = data.frame(
        table_names = c("DE", "SD", "TE", "VS", "LE"),
        su_level = c("NA", "NA", "su1", "su2", "su3")
      ),
      H9 = data.frame(
        table_names = c("DE", "SD", "LO", "TE"),
        su_level = c("NA", "NA", "su1", "su2")
      ),
      H10 = data.frame(
        table_names = c("DE", "SD", "VS", "TE", "FT", "FO"),
        su_level = c("NA", "NA", "su1", "su2", "su3", "su4")
      ),
      H11 = data.frame(
        table_names = c("DE", "SD", "LO", "TE", "FT"),
        su_level = c("NA", "NA", "su1", "su2", "su3")
      ),
      H12 = data.frame(
        table_names = c("DE", "SD", "LO", "TE", "LE"),
        su_level = c("NA", "NA", "su1", "su2", "su3")
      ),
      H13 = data.frame(
        table_names = c("DE", "SD", "FO"),
        su_level = c("NA", "NA", "su1")
      )
    )
    
    
    out <- list()
    
    
    expected_tables_here <-
      eval(parse(text = paste0("expected_tables$H", hierachy)))
    
    ## CC: changed script here to be more universal, so that it also works when data does not contain DE or SD tables
    #for (i in c(3:length(expected_tables_here$table_names))) {
    for (i in grep("su", expected_tables_here$su_level)) {
      su <-
        eval(parse(text = paste0(
          "input_list$", expected_tables_here$table_names[[i]]
        )))
      
      names(su) <-
        sub(unique(expected_tables_here$table_names[[i]]), "", names(su))
      
      su$su <- expected_tables_here$su_level[[i]]
      su$hierachy <- hierachy
      h <- i - 1
      su$idAbove <-
        eval(parse(text = paste0(
          "su$", expected_tables_here$table_names[[h]], "id"
        )))
      
      eval(parse(
        text = paste0(
          expected_tables_here$su_level[[i]],
          "_done",
          "<- select(su, one_of(var_names))"
        )
      ))
      
      # Create list with the table name
      eval(parse(
        text = paste0(
          "out$",
          expected_tables_here$su_level[[i]],
          "$name",
          " = ",
          "'",
          unique(su$recType),
          "'"
        )
      ))
      
      # Create list with the dasign variables
      eval(parse(
        text = paste0(
          "out$",
          expected_tables_here$su_level[[i]],
          "$designTable",
          " = ",
          expected_tables_here$su_level[[i]],
          "_done"
        )
      ))
      
      #eval(parse(
      #  text = paste0(
      #    "out$",
      #    expected_tables_here$su_level[[i]],
      #    " = ",
      #    expected_tables_here$su_level[[i]],
      #    "_done"
      #  )
      #))
      
      # Create list with the inclusion probabilities
      
      # Create list with the selection probabilities
      
      # Create list with combined inclusion probabilities
    }
    
    return(out)
  }
