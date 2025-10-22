# My budget for one semester at BYU-I

# -----------------------------
# Example budget script
# Demonstrates: multiple R datatypes, loops over lists, data.frames, CSV read/write
# -----------------------------

## 1) Different data types
project_title <- "My budget for one semester at BYU-I"    # character
starting_balance <- 1000.50                                # numeric (double)
months <- as.integer(4)                                    # integer
card <- TRUE                                               # logical
cash <- FALSE                                              # logical

# a small list of misc values (list)
misc_info <- list(owner = "student", semester = "Fall 2025", overdraft_limit = -200)

# a factor for categories (factor)
categories <- factor(c("Tuition","Rent","Groceries","Gas","Entertainment","Books"))

# a complex number just to show another type
example_complex <- 1 + 2i

## 2) Helper: locate the script directory robustly so CSV lookups work whether run in RStudio or Rscript
get_script_dir <- function() {
    cmdArgs <- commandArgs(trailingOnly = FALSE)
    file_arg <- "--file="
    match <- grep(file_arg, cmdArgs)
    if (length(match) > 0) {
        return(dirname(normalizePath(sub(file_arg, "", cmdArgs[match]))))
    }
    # fallback (interactive): use current working directory
    return(getwd())
}

script_dir <- get_script_dir()
csv_path <- file.path(script_dir, "data.csv")

## 3) Read CSV into a data.frame and show structure
if (file.exists(csv_path)) {
    expenses_df <- read.csv(csv_path, stringsAsFactors = FALSE)
} else {
    # create an empty placeholder data.frame with the expected columns
    expenses_df <- data.frame(Date=character(0), Category=character(0), Amount=numeric(0), PaymentMethod=character(0), Notes=character(0), stringsAsFactors = FALSE)
}

## 4) Work with arrays / matrices as another datatype
amounts_vec <- as.numeric(expenses_df$Amount)
amounts_mat <- matrix(amounts_vec, nrow = max(1,length(amounts_vec)), ncol = 1)

## 5) Build a list of expense records (list of rows) and loop over it
expenses_list <- apply(expenses_df, 1, function(r) as.list(r))

print_header <- function(title) {
    cat("\n-----", title, "-----\n")
}

main <- function() {
    print_header(project_title)
    cat("Starting balance:", starting_balance, "(numeric)\n")
    cat("Months tracked:", months, "(integer)\n")
    cat("Card available?", card, "; Cash available?", cash, "(logical)\n")
    cat("Example complex number:", example_complex, "(complex)\n")

    print_header("Raw expenses (data.frame)")
    print(head(expenses_df, 20))

    # simple checks
    total_expenses <- if (nrow(expenses_df) > 0) sum(as.numeric(expenses_df$Amount), na.rm = TRUE) else 0
    cat("\nTotal expenses:", total_expenses, "(computed from data.frame)\n")

    # Loop over the list of expense rows and print each in a readable form
    print_header("Expenses (loop over list)")
    if (length(expenses_list) == 0) {
        cat("No expenses found in CSV.\n")
    } else {
        for (i in seq_along(expenses_list)) {
            e <- expenses_list[[i]]
            # e is a list with Date, Category, Amount, PaymentMethod, Notes
            cat(sprintf("%02d) %s | %s | $%0.2f | %s | %s\n", i, as.character(e$Date), as.character(e$Category), as.numeric(e$Amount), as.character(e$PaymentMethod), as.character(e$Notes)))
        }
    }

    # Aggregate by category using base R (data.frame operation)
    if (nrow(expenses_df) > 0) {
        agg <- aggregate(Amount ~ Category, data = expenses_df, FUN = sum)
        print_header("Totals by category")
        print(agg)

        # write a summary CSV next to the data file
        summary_csv <- file.path(script_dir, "summary_by_category.csv")
        write.csv(agg, summary_csv, row.names = FALSE)
        cat("\nWrote summary to:", summary_csv, "\n")
    }

    # Demonstrate matrix operations (sum using matrix)
    if (nrow(amounts_mat) > 0) {
        cat("\nSum via matrix operations:", sum(amounts_mat, na.rm = TRUE), "\n")
    }

    # Small example showing updating balance
    new_balance <- starting_balance - total_expenses
    cat("\nEnding balance after expenses:", new_balance, "\n")

    # Final thoughts printed to screen
    print_header("Project thoughts")
    cat("- Keep your raw transactions in CSV and use scripts to generate cleaned summaries.\n")
    cat("- Add unit tests (small R scripts) that validate aggregation logic with known inputs.\n")
    cat("- Consider using 'readr' and 'dplyr' for bigger datasets and easier pipelines.\n")
    cat("- Add functions to forecast future months and visualize spending with ggplot2.\n")
    cat("- Store sensitive data (if any) outside the repo and avoid committing real payment data.\n")
}

main()
