# now, we need to get a column of number of alleles, etc for prt.all from the Codes in the file
# for num alleles
CodeToAlleNum <- function(Code) {
	alle.letters <- paste("a",letters, sep="")
	alle.letter.nums <- 0:(length(alle.letters)-1)
	names(alle.letter.nums) <- alle.letters
	
	alle.letter.nums[substr(Code,1,2)]
}



CodeToScenarioName <- function(Code) {
	the.scen.names <- c("allhalf", "allpathalf", "lotta_large", "nosibs", "onelarge_noh", "onelarge_wh",
											"sfs_noh", "sfs_wh", "slfsg_noh", "slfsg_wh")
	names(the.scen.names) <- c("AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK")
	the.scen.names[substr(Code,3,4)]
}


CodeToGenoError <- function(Code) {
	substr(Code,8,8)
}


CodeToRepNumber <- function(Code) {
  rep.letters <- paste("a", rep(c("a","b"), each=26), letters, sep="")
  rep.nums <- 0:(length(rep.letters)-1)
  names(rep.nums) <- rep.letters
  rep.nums[substr(Code, 5, 7)]
}



