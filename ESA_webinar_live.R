install.packages('neonUtilities')
library(neonUtilities)

stackByTable('/Users/clunch/Desktop/NEON_par.zip')

pr <- loadByProduct(dpID='DP1.00024.001', site=c('BART','DEJU'),
              startdate='2021-09', enddate='2021-10',
              package='basic')
names(pr)
View(pr$PARPAR_30min)
