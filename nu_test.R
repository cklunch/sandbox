# clone https://github.com/NEONScience/utilities-test-suite to local

library(devtools)
install_github('NEONScience/NEON-utilities/neonUtilities')

# re-start R

library(devtools)
library(neonUtilities)

setwd("file path to clone of GitHub/utilities-test-suite/testUtilities")
test()

# tests will take a half hour or so to run. you should end with one warning, zero failures
