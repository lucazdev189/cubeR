# cubeR - the R package for speedcubing  
[![](https://img.shields.io/github/last-commit/lucazdev189/cubeR.svg)](https://github.com/lucazdev189/cubeR/commits/main)
[![R build status](https://github.com/lucazdev189/cubeR/workflows/R-CMD-check/badge.svg)](https://github.com/lucazdev189/cubeR/actions)  
**This package scrapes data from the WCA website.**

## Installation  
```
library(devtools)
install_github("lucazdev189/cubeR")
```

## Examples
```
library(cubeR)

# Puts Feliks Zemdegs' data in a variable
x <- get_person_data("2009ZEMD01")

# Gets the "person_data" tibble specifically
x <- x$person_data

# Print
print(x)
```
The code above will return:
```
# A tibble: 1 × 7
  Name           ID         Avatar   From  Gender Competitions Completed_Solves
1 Feliks Zemdegs 2009ZEMD01 https:/… " Au… Male   152          10109
```
