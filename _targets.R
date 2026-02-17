library(targets)
library(tarchetypes)
library(here)

tar_option_set(
  packages = c("tidyverse", "here", "magrittr") # Packages that your targets need for their tasks.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  tar_target(
    raw_results_file,
    here("data-raw", "results.csv"),
    format = "file"
  ),
  tar_target(
    raw_results,
    read_csv(raw_results_file)
  ),
  tar_target(
    youth_games,
    get_youth_games(raw_results)
  ),
  tar_target(
    results,
    get_results(raw_results, youth_games)
  ),
  tar_target(
    medals,
    get_medals(results)
  ),
  tar_target(
    medals_file,
    here("data", "medals.csv") %T>% write_csv(medals, .),
    format = "file"
  ),
  tar_quarto(
    olympic_success,
    here("document", "olympic_success.qmd")
  ),
  tar_download(
    bios_file,
    urls = "https://raw.githubusercontent.com/KeithGalli/Olympics-Dataset/refs/heads/master/clean-data/bios.csv",
    paths = here("data-raw", "bios.csv")
  ),
  tar_target(
    bios,
    read_csv(bios_file)
  )
)
