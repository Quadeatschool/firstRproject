3
print(3)


# lists

first_list <- list(1, 2, 3)

print(first_list)

#for loop
for (toes in 1:5)
{
print(toes)
}
#function
makeFunction <- function()
{
    print(3)
    print(first_list)
    "stuff"
}

print(makeFunction())

# --------------------------------------------------------
# Simple R Program Example: Analyzing a Small Dataset
# --------------------------------------------------------

# 1. Using at least 5 different R datatypes

# 1.1 Character (String)
project_title <- "Financial Tracker v1.0" # Type: Character
print(paste("Project:", project_title))

# 1.2 Integer (Note: 'L' ensures it's stored as an integer, not numeric)
months_tracked <- 3L # Type: Integer
print(paste("Months Tracked:", months_tracked))

# 1.3 Numeric (Double/Decimal)
average_income <- 4550.75 # Type: Numeric (Double)

# 1.4 Logical (Boolean)
is_profitable <- TRUE # Type: Logical
print(paste("Is Profitable:", is_profitable))

# 1.5 Complex (for mathematical operations, though rarely used in data science)
complex_value <- 2 + 3i # Type: Complex
# print(complex_value) # Not displayed for simplicity

# ---

## Data Structures and Loop

# 2. Incorporate an Array (specifically a 3D Array)
# This array stores weekly expenses (3 categories x 4 weeks x 3 months)
expense_array <- array(
  data = c(
    150, 200, 180, 190, # Week 1 Groceries
    400, 400, 400, 400, # Week 1 Rent
    50, 75, 20, 100, # Week 1 Entertainment
    
    160, 210, 170, 195, # Week 2
    400, 400, 400, 400, 
    60, 80, 25, 95,
    
    170, 220, 160, 200 # Week 3
  ),
  dim = c(3, 4, 3), # 3 Categories, 4 Weeks, 3 Months
  dimnames = list(
    c("Groceries", "Rent", "Fun"),
    paste("Wk", 1:4),
    paste("Month", 1:3)
  )
)

# 3. Incorporate at least one loop that works with lists or arrays (using the Array)
# Calculate the total spending for each expense category across all months
category_totals <- c()

# Loop through the 3 expense categories (dimension 1 of the array)
for (i in 1:dim(expense_array)[1]) {
  category_name <- dimnames(expense_array)[[1]][i]
  
  # The 'sum' function automatically sums all elements for the current category 'i'
  # across all weeks and all months.
  total_spent <- sum(expense_array[i, , ])
  
  # Display output to the screen
  print(paste("Total for", category_name, "over", months_tracked, "months:", total_spent))
  
  # Store the result for later use in the data frame
  category_totals <- c(category_totals, total_spent)
}

# ---

## Data Frame Creation

# 4. Use Dataframes
# Create a data frame summarizing the expense totals
expense_summary_df <- data.frame(
  Expense_Category = dimnames(expense_array)[[1]], # Character vector
  Total_Spent = category_totals, # Numeric vector
  Is_High_Expense = category_totals > 1000 # Logical vector (automatically created)
)

# Sort the data frame by Total_Spent in descending order
expense_summary_df <- expense_summary_df[order(-expense_summary_df$Total_Spent), ]

# 5. Display output to the screen (Final Display)
cat("\n--- Expense Summary Report ---\n")
print(expense_summary_df)

# Final derived output
total_expenses <- sum(expense_summary_df$Total_Spent)
net_surplus <- (average_income * months_tracked) - total_expenses
cat(paste("\nTotal Expenses:", total_expenses))
cat(paste("\nTotal Income:", (average_income * months_tracked)))
cat(paste("\nNet Surplus/Deficit:", round(net_surplus, 2)))