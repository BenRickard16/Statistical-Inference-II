#
# PRACTICAL 1-2: 1-3: Likelihood Inference
# ---------------------------------
#
#
# We have seen in lectures that the MLEs for the parameters of several common 
# distributions can be found in closed form. However, in general, the problem is 
# not guaranteed to be so easy with a simple closed-form result. Therefore, in 
# these situations, we will have to find and maximise the likelihood numerically.


#  *  You will need the following skills from previous practicals:
#     *   Basic R skills with arithmetic, functions, etc
#     *   Manipulating and creating vectors: `c`, `seq`,
#     *   Calculating data summaries: `mean`, `sum`, `length`
#     *   Drawing a histogram with `hist`, and adding simple lines to plots `abline`
#     *   Customising plots using `col`our
#  *  New R techniques:
#     *   Drawing a plot of a simple function using `curve`
#     *   Optimising a function with `optim`
#     *   Extracting named elements of a list using the `$` operator



#
#
# 1. The Poisson Likelihood
# ==================================================================================
#
# Our likelihood calculations begin with writing down the likelihood function of our
# data. For a single observation $X=x$ from a Poisson distribution, the likelihood is
# the the probability of observing $X=x$ written as a function of the parameter lambda:
# 
# l(lambda) = P[X=x | lambda] = (e^{-lambda} lambda^x)/(x!).
# 
# To begin with, suppose we observe a count of X=5.


#
# Exercise:
# ~~~~~~~~~~~~~
# * Write a simple function called `poisson` that takes arguments `lambda` 
#    which evaluates the Poisson probability P[X=5 | lambda].
#   Hint: You will need the `exp` and `factorial` functions.
# * Evaluate the Poisson probability for X=5 when lambda=7 - you should get a 
#   value of 0.1277167.

poisson <- function(lambda){
  ans <- exp(-lambda)*lambda^5/factorial(5)
return(ans)
  }

print(poisson(7))













# What we have just created is the likelihood function, l(lambda), for the Poisson
# parameter lambda given a single observation of X=5.
# 
# Before we consider a larger data problem, let's briefly explore this simplest case
# of a Poisson likelihood. Let's begin with a plot of the likelihood function itself.


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ TECHNIQUE: 
# ^ 
# ^ **Using `curve` to plot a funtion**
# ^ 
# ^ Given an expression for a function f(x), we can plot the values of f for various 
# ^ values of x in a given range. This can be accomplished using an R function called
# ^ `curve`. The main syntax for `curve` is as follows:
# ^ 
# ^ curve(expr, from = NULL, to = NULL, add = FALSE,...)
# ^ 
# ^ The arguments are:
# ^ * expr: an expression or function in a variable x which evaluates to the function
# ^          to be drawn. Examples include `sin(x)` or `x+3*x^2`
# ^  * from, `to`: specifies the range of `x` for which the function will be plotted
# ^  * add: if `TRUE` the graph will be added to an existing plot; if `FALSE` a new 
# ^         plot will be created
# ^  * ...: any of the standard plot customisation arguments can be given here 
# ^         (e.g. `col` for colour, `lty` for line type, `lwd` for line width)
# ^ 
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        

# For example, the following code when evaluated produces the plot below:
# 
  curve(x^3 - 5*x, from = -4, to = 4)



#
# Exercise:
# ~~~~~~~~~~~~~
# * Try out using `curve` to draw a quick plot of the following functions:
#   * f(x)=3x^2+x over [0,10]
#   * f(x)=sin(x)+cos(x)$ over [0,2pi] as a blue curve. 
#      Note: R defines `pi` as the constant pi
#   * Use the `add=TRUE` option to superimpose g(x)=0.5sin(x)+cos(x) as a red 
#      curve over [0,2pi] on the previous plot.
# * Now, use `curve`  and your `poisson` function to draw a plot of your Poisson
#      likelihood for lambda in [0.1, 20].
# * By eye, what is the value lambdahat of lambda which maximises the 
#      likelihood?


curve(3*x^2, from = 0, to = 10)

curve(sin(x)+cos(x), from = 0, to = 2*pi)
curve(0.5*sin(x)+cos(x), from = 0, to = 2*pi, add=TRUE, col='red')


poisson <- function(lambda){
  ans <- exp(-lambda)*lambda^5/factorial(5)
  return(ans)
}

curve(poisson(x), from = 0.1, to = 20)


logPoisson <- function(lambda){
  return(log(poisson(lambda)))
}

curve(logPoisson(x), from = 0.1, to = 20)
curve(poisson(x), from = 0.1, to = 20)


# Typically, we usually work with the log-likelihood L(lambda)=log l(lambda),
# rather than the likelihood itself. This can often make the mathematical
# maximisation simpler, the numerical computations more stable, and it is also
# intrinsically connected to the idea of *information* and variance (which we will
# consider later).


#
# Exercise:
# ~~~~~~~~~~~~~
#
# * Modify your `poisson` function to compute the logarithm of the Poisson 
#   probability, and call this new function `logPoisson`. You will need to use the
#   `log` function.
# * Re-draw the plot to show the log-likelihood against lambda. Do you find the same
#   maximum value lambdahat?

  
poisson <- function(lambda){
  ans <- exp(-lambda)*lambda^5/factorial(5)
  return(ans)
}

logPoisson <- function(lambda){
  return(log(poisson(lambda)))
}



curve(poisson(x), from = 0.1, to = 20, ylim = c(0,1.5))
curve(logPoisson(x)+3, from = 0.1, to = 20, add=TRUE, col="red", abline(v=5.2))








#
#
# 2.  Likelihood methods for real data
# ==================================================================================
#
# 
# The Poisson distribution has been used by traffic engineers as a model for light 
# traffic. This assumption is based on the rationale that if the rate is approximately
# constant and the traffic is light (so the individual cars move independently of 
# each other), then the distribution of counts of cars in a given time interval or 
# space area should be nearly Poisson (Gerlough and Schuhl 1955).
# 
# The following table shows the number of right turns during three hundred 3-minute
# intervals at a specific junction.


traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))

# Note that we interpret these data as 14 observations of the value 0, 
# 30 observations of the value 1, and so forth.


#
# Exercise:
# ~~~~~~~~~~~~~
#
# * Evaluate the piece of code above to create the vector `traffic` corresponding to the above data set.
# * Plot a `hist`ogram of the data. Does an assumption of a Poisson distribution appear reasonable?




traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))
hist(traffic)










# If we suppose a Poisson distribution might be a good choice of distribution for
# this dataset, we still need to find out _which_ particular Poisson distribution 
# is best by estimating the parameter lambda.
# 
# Let's begin by constructing the likelihood and log-likelihood functions for this
# data set of 300 observations. Assuming that the observations x_1, ..., x_300 
# can be treated as 300 i.i.d. values from Po(lambda), the log-likelihood 
# function for the entire sample is:
# 
# L(lambda) = -nlambda +(sum_{i=1}^n x_i ) log lambda ,
# 
# up to an additive constant from the factorial terms (which we know we can ignore 
# for the purposes of these calculations).

#
# Exercise:
# ~~~~~~~~~~~~~
#
#  * Write a new functions `logLike` with a single parameter `lambda`, which 
# evaluates the log-likelihood expression above for the `traffic` data and 
# the supplied values of `lambda`.
# _Hint_: Use `length` and `sum` to compute the summary statistics.
#  * Evaluate the data log-likelihood for all lambda in `lambdavals` and plot the 
#  log-likelihood against lambda. Without further calculations, use the plot to 
#  have a guess at the maximum likelihood estimate lambdahat -- 
#  we'll check this later!

traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))

logLike <- function(lambda){
 ans <- -length(traffic)*lambda + sum(traffic)*log(lambda)
 return(ans)
}


curve(logLike(x), from = 0, to = 20)
abline(v=4)

















#
# 2.1 Maximising the likelihood
# ----------------------------------------------------------------------------------
# 
# 
# The maximum likelihood estimate (MLE) lambdahat for the lambda parameter of the
# Poisson distribution is the value of lambda which maximises the likelihood
# 
# lambdahat = argmax_lambda l(lambda)= argmax_lambda L(lambda).
# 
# Therefore to find the MLE, we must maximise l or L. We know we can do this 
# analytically for certain common distributions, but in general we'll have to 
# optimise the function numerically instead. For such problems, `R` provides 
# various functions to perform a numerical optimisation of a give function 
# (even one we have defined ourself). The function we will focus on is `optim`:
#   


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ TECHNIQUE: 
# ^ 
# ^ 
# ^ `R` offers several optimisation functions, however the one we shall be using 
# ^ today is `optim` which is one of the most general optimisation functions. 
# ^ This generality comes at the price of having a lot of optional parameters that
# ^ need to be specified.
# ^ 
# ^ For our purposes, we're doing a 1-dimensional optimisation of a given function 
# ^ named `logLike`. So the syntax we will use to _maximise_ we call optim  as follows
# ^ 

optim(start, logLike, lower=lwr, upper=upr, method='Brent', control=list(fnscale=-1))

# ^ 
# ^ The arguments are:
# ^    * `start` : an initial value for lambda at which to start the optimisation.
# ^                *Replace this with a sensible value.*
# ^    * `logLike` : this is the function we're optimising. In general, we can 
# ^               replace this with any other function.
# ^ * `lower=lwr, upper=upr` : lower and upper bounds to our search for lambdahat.
# ^               *Replace `lwr` and `upr`  with appropriate numerical values*;
# ^               an obvious choice for this problem is the min and max of our data.
# ^ * `method='Brent'` : this selects an appropriate optimisation algorithm for a 1-D 
# ^               optimisation between specified bounds. Other options are available
# ^               for other classes of optimisation problem.
# ^ * `control=list(fnscale=-1)` : this looks rather strange, but is simply telling
# ^               `optim` to *max*imise the given function, rather than *min*imise
# ^               which is the default (it's instructing R to scale the function
# ^               by a factor of $-1$ and minimise the result).
# ^ 
# ^ `optim` returns a number of values in the form of a list. The relevant components are:
# ^ 
# ^    * `par` : the optimal value of the parameter
# ^    * `value` : the optimum of the function being optimised.
# ^    * `convergence`: if `0` this indicates that the optimisation has completed successfully.
# ^ 
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


#
# Exercise:
# ~~~~~~~~~~~~~
#
#   * Use `optim` to maximise the `logLike` function. You should choose an 
#     appropriate initial value for lambda, as well as sensible `upper` and 
#     `lower` bounds.
#   * What value of lambdahat do you obtain? How does this compare to 
#     your guess at the MLE?
#   * We know from lectures that the lambdahat = Xbar -- evaluate the 
#     sample mean of the `traffic` data. Does this agree with your results from
#     directly maximising the log-likelihood?


traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))

logLike <- function(lambda){
  ans <- -length(traffic)*lambda + sum(traffic)*log(lambda)
  return(ans)
}

optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1))











# You should see output something like this:

## $par
## [1] 3.893333
## 
## $value
## [1] 419.6223
## 
## $counts
## function gradient 
##       NA       NA 
## 
## $convergence
## [1] 0
## 
## $message
## NULL



# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ TECHNIQUE: 
# ^ 
# ^ 
# ^ The output of `optim` is in the form of a `list`. Unlike vectors, `list`s can 
# ^ combine many different variables together (numbers, strings, matrices, etc) and
# ^ each element of a list can be given a name to make it easier to access.
# ^ 
# ^ For example, we can create our own lists using the `list` function:
# ^ 
# ^  test <- list(Name='Donald', IQ=-10, Vegetable='Potato')`
# ^ 
# ^ Once created, we can access the named elements of the list using the `$` operator.
# ^ For example,
# ^ 
# ^  test$IQ
# ^ 
# ^ will return the value saved to `IQ` in the list, i.e. `-10`. RStudio will show 
# ^ auto-complete suggestions for the elements of the list after you press `$`, which
# ^ can help make life easier.
# ^
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# 
# We can use this `$` operator to extract the MLE value from `optim` by first 
# saving the results to a variable, called `results` say, and then extracting the
# list element named `par`, which corresponds to the maximising value of lambda.


#
# Exercise:
# ~~~~~~~~~~~~~
#
# * Extract the optimal value of lambda from the output of `optim` and save it 
# to a new variable called `mle`.
# * Re-draw your plot of the log-likelihood function, and use `abline` to:
#     * Add a red solid vertical line at lambda=lambdahat.
#     _Hint:_ pass the `col='red'` argument to your plotting function.
#     * Add a blue dashed vertical line at lambda=xbar.
# * Do the results agree with each other, and with your guess at lambdahat?
#


traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))

logLike <- function(lambda){
  ans <- -length(traffic)*lambda + sum(traffic)*log(lambda)
  return(ans)
}

result <- optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1))

mle <- result$par

curve(logLike, from = 0, to = 20)
abline(v=mle, col="red", lwd = 3)
abline(v=mean(traffic), col = "blue", lty = "dashed")







# Let's return to the original distribution of the data. The results of our 
# log-likelihood analysis suggest that a Poisson distribution with parameter 
# lambdahat is the best choice of Poisson distributions for this data set.

 

#
# Exercise:
# ~~~~~~~~~~~~~
#
# * Re-draw the `hist`ogram of the `traffic` data.
# * Modify your `poisson` function to evaluate the Poisson probability
#    P[X=x] when X ~ Po(lambdahat). Save the function as `poissonProb`.
# * The expected number of Poisson counts under this Po(lambdahat)
#   distribution will be 300P[X=x], for x=0,...,16. Use the 
#   `curve` function to `add` draw this function over your histogram in red.
#   (We will ignore the fact that $X$ should be discrete for the time-being.)
# * Does this look like a good fit to the data?


traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))
hist(traffic)

logLike <- function(lambda){
  ans <- -length(traffic)*lambda + sum(traffic)*log(lambda)
  return(ans)
}

result <- optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1))

mle <- result$par

poissonProb <- function(x){
  ans <- exp(-mle)*mle^x/factorial(x)
  return(ans)
}

curve(300*poissonProb(x), from = 0, to = 16, add=TRUE, col = "red")












 
# We will return to the question of fitting distributions to data and the 
# "goodness of fit" later next term.

 
#
# 2.2 Information and inference
# ----------------------------------------------------------------------------------
# 
# For an iid sample X_1,...,X_n from a sufficiently nicely-behaved ("regular") density 
# function f(x_i | theta) with unknown parameter theta, the sampling distribution 
# of the MLE thetahat is such that
# 
# thetahat ~~> N(theta, 1/(I_n(theta)) ),
# 
# as n -> infinity. For large samples, we can also replace the expected Fisher 
# information in the variance with the observed information, I(thetahat) = -L''(thetahat)
# instead, Whilst we may be used to finding Normal distributions in unusual places,
# this result is noteworthy as we never assumed any particular distribution of our
# data here. This result therefore provides us with a general method for making 
# inferences about parameters of distributions and their MLEs for problems involving
# large samples!
#  
# In particular, we can apply this to our Poisson data problem above to construct a
# large-sample approximate 100(1-alpha)% confidence interval for lambda in the form:
# 
#    lambdahat +/- z*{alpha/2} 1/(sqrt[-L''(lambdahat)]),
# 
# where z*{alpha/2} is the alpha/2 critical value of a standard Normal distribution
# and we have estimated the expected Fisher information I_n(theta) by the observed
# information I(lambdahat}) = -L''(lambdahat).

#
# Exercise:
# ~~~~~~~~~~~~~
#
#  * We can request that `R` computes the second derivative at the maximum, 
#    L''(lambdahat), as part of the maximisation process. To do this, re-run your
#    optimisation, but add the additional argument `hessian=TRUE`.

 
result <- optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1), hessian=TRUE)









 
 
 
 
#
# You should now obtain R output that looks like this:
#
## $par
## [1] 3.893333
## 
## $value
## [1] 419.6223
## 
## $counts
## function gradient 
##       NA       NA 
## 
## $convergence
## [1] 0
## 
## $message
## NULL
## 
## $hessian
##           [,1]
## [1,] -77.05481
 
 
#
# Exercise:
# ~~~~~~~~~~~~~
#
# * The output from `optim` will now contain an additional element named `hessian`.
#   Extract this element, multiply by -1, and save it as `obsInfo`.
# * To get the variance of lambdahat we need to invert the information matrix. We
#   can achieve this using R's `solve` function. Try this now on `obsInfo`. Save 
#   this to `varMLE`.
# * As `obsInfo` is just a scalar (or a $1\times1$ matrix), the invers of the matrix
#   is the same as the reciprocal $\frac{1}{I(\widehat{\lambda})}$ - check this now!
# * Finally, `varMLE` will be in the form of a $1\times 1$ matrix rather than a 
#   scalar (as the Hessian matrix is a matrix of the second order partial derivatives).
#   To extract the value from within the matrix, run the following code
#
# varMLE <- varMLE[1,1]
traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))


logLike <- function(lambda){
  ans <- -length(traffic)*lambda + sum(traffic)*log(lambda)
  return(ans)
}
 
result <- optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1), hessian=TRUE)

obsInfo <- -result$hessian

varMLE <- solve(obsInfo)

varMLE <- varMLE [1,1]




#
# Exercise:
# ~~~~~~~~~~~~~
#
# * Use your standard Normal tables (or R's built-in function `qnorm`) to find the
#   critical z*{alpha/2} value for a 95% confidence interval. Save this as `zcrit`.
# * Combine `mle`, `zcrit`, and `varMLE` to evaluate an approximate 95% Wald 
#   confidence interval for lambda.
# * Return (and possibly re-draw) the plot of your log-likelihood function, with 
#   the MLE indicated as a vertical line. Add the limits of the confidence interval
#   to your plot as vertical green lines.
# * What does the confidence interval suggest about the reliability of your estimate.
# * Does the log-likelihood look reasonably quadratic near the MLE? Does this affect
#   your conclusions, and how would you investigate this further?
traffic <- rep(0:12, c(14,30,36,68,43,43,30,14,10,6,4,1,1))


logLike <- function(lambda){
  ans <- -length(traffic)*lambda + sum(traffic)*log(lambda)
  return(ans)
}
result <- optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1))

mle <- result$par

result1 <- optim(4, logLike, lower=1, upper=10, method='Brent', control=list(fnscale=-1), hessian=TRUE)

obsInfo <- -result1$hessian

varMLE <- solve(obsInfo)

varMLE <- varMLE [1,1]
zcrit <- qnorm(0.975)

wald <- c(mle - zcrit*varMLE, mle + zcrit*varMLE)


curve(logLike(x), from=3.7, to=4.3)
abline(v=mle, col="red")
abline(v=wald[1], col="green")
abline(v=wald[2], col="green")

































