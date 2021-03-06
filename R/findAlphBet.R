
# multiplicative random effects model:  the rating Y, 0 or 1, is
# generated by
# 
# EY_ij = q alpha_i beta_j 

# for unobservable alpha, beta, and an unknown constant q

# this is a very simple model, whose virtue is simplicity and quick
# computation

# arguments:

#   ratingsIn: input data, with first cols (userID,itemID,rating,
#              covariates); data frame

# value:

#   S3 class of type "MMmultiplic", with components:

#      alphavec: the alpha_i
#      betavec: the beta_j

findMultiplicYdots <- function(ratingsIn) {
   users = ratingsIn[,1] 
   items = ratingsIn[,2] 
   ratings = ratingsIn[,3] 
   yd <- findYdotsMM(ratingsIn)
   ydi <- yd$usrMeans
   ydj <- yd$itmMeans
   nu <- yd$grandMean
   alph <- ydi / nu
   bet <- ydj / nu
   res <- list(alph=alph,bet=bet)
   class(res) <- 'MMmultiplic'
   res
} 

# predict() method for the 'MMmultiplic' class
#
# testSet in same form as ratingsIn above, except that there 
# is no ratings column 

# MMmultiplic is the output of findAlphBet()
#
# returns vector of predicted values for testSet, i.e. estimated
# probabilities of rating = 1
predict.MMmultiplic = function(multiplicObj,testSet) {
   tmp <- 
      multiplicObj$alphavec[as.character(testSet[,1])] * 
      multiplicObj$betavec[as.character(testSet[,2])] 
   lmc <- multiplicObj$lmcoef
   tmp <- lmc[1] + lmc[2]*tmp
   tmp <- pmin(tmp,1)
   pmax(tmp,0)
}

