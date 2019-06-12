library(visNetwork)
options(stringsAsFactors = F)

tree <- read.delim("/Users/clunch/GitHub/sandbox/data_viz/edges_for_viz_testing.csv", sep=",")
edges <- tree[,c("from","to")]
id <- unique(tree$from)
label <- id
nodes <- data.frame(cbind(id, label))

# arr <- character(nrow(edges))
# arr[which(tree$directSampleLink=="Y")] <- "to"
# 
# dash <- arr
# dash[which(dash=="to")] <- F
# dash[which(is.na(dash))] <- T

network <- visNetwork(nodes, edges) %>% visEdges(arrows="to") %>% 
  visLegend %>% visNodes(size=15, font=list(size=24))
visExport(network)

