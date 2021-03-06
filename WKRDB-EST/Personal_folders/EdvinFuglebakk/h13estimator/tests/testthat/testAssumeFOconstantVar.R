data <- parseRDBESexchange(system.file("testresources","herringlottery_trimmed_H13.csv", package="h13estimator"))

context("assumeFOconstantVar: run simple example")
est <- calculateBVmeans(data$BV, type = "Weight", stratified = F)
prop <- calculateBVProportions(data$BV, "Age", stratified = F)
caaSA <- estimateSAcaa(assumeSelectionMethod(data$SA,"SYSS", "SRSWR"), data$SS, data$SL, "126417", prop, est, stratified=F)
caaFO <- estimateFOCatchAtAge(data$FO, data$SS, data$SA, caaSA, stratified = F)
v <- assumeFOconstantVar(caaFO, constant = 0, ages=unique(caaFO$age))
expect_equal(length(v), length(unique(caaFO$FOid)))
expect_equal(dim(v[[1]]), c(length(unique(caaFO$age)),length(unique(caaFO$age))))
