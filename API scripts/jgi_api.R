library(jsonlite)
library(httr)

# search for the project ID
r <- GET('https://files.jgi.doe.gov/search/?q=1414438')

# get the file table from the response
pr <- fromJSON(content(r, "text"), flatten=T)
fls <- pr$organisms$files[[1]]

# get the first ID from the file table and download. would need to iterate over IDs to get them all.
# token is the full session token from the JGI portal, 'Bearer /api/sessions/###'
id1 <- fls$`_id`[1]
rf <- GET(paste('https://files.jgi.doe.gov/download_files/', id1, sep=''),
          add_headers(.headers=c('Authorization' = Sys.getenv('JGI_TOKEN'))))

# for each ID, check if you can download or if the data are on tape
if(rf$status_code==409){print('Data on tape, must request restoration.')}

# if not on tape, extract files. TBD.



