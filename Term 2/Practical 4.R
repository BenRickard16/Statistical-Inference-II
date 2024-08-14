#
# PRACTICAL 2-4: Chi-square tests
# ---------------------------------
#
# In this practical, we will use R to investigate 
# the sampling distribution of Pearson's chi-squared statistic for goodness of
# fit. We will do a sampling experiment for rolling a die, first in the case
# where the die is fair and then in the case that it is biased.

# 1. Rolling a fair die -------------------------------------------------

# We can simulate the rolling of a fair die using the sample function that we
# have seen before
#
sample(1:6, 1)
#
# This samples a number between 1 and 6 with the probability of each number
# being equal. Actually, the function sample has 2 default values so that the
# above is really
#
sample(x=1:6,size=1, replace=FALSE, prob=c(1/6,1/6,1/6,1/6,1/6,1/6))
#
# though you don't have to type all of this. You can see this for yourself in 
# the help file for sample. Here, the default is for each number in x 
# (1,2,3,4,5,6) to have an equal probability. 
# 
# Question: By changing the default value of replace how do you simulate 10
# rolls of a fair die using sample?
sample(1:6, 10, replace=TRUE)

# Question: Create a vector called rolls that contains 1200 simulated rolls of a
# fair die.

rolls <- sample(1:6, 1200, replace=TRUE)
# 2. A chi-squared test by hand -------------------------------------------

# We refer to the hypothesis that the die we have rolled is fair as the null
# hypothesis, H0. In this case we know H0 is true, however, the purpose of this
# experiment is to compare how a chi-squared test for examining H0 performs when
# we know that H0 is true.
# 
# To compute Pearson's chi-squared statistic we need
# to identify the discrete set of possible outcomes (in our case the integers
# 1 to 6) and the expected number of each outcome in our experiment under
# H0. The statistic is


#     _____          2
#  2  \     /O  - E \
# X =  \    \ i    i/
#      /    -------             
#     /____     E
#       i         i

# where O  is the observed number of instances of outcome i in the sample and
#        i
# E  is the expected number of instances of outcome i in the sample under H0.
#  i


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ 
# ^ TECHNIQUE: 
# ^ 
# The **repeat** command: If we want to repeat a value multiple times in a vector we use
# ```rep(a ,n )```
# where `a` is the value and `n` is the number of repeats.
# **Maxima and minima**: To find the maximum and minimum of a vector `x` , use the commands `max(x)` and `min(x)`.
# **Counting integers**:
# The function `tabulate` takes a large vector of integers and computes the number of instances of each integer. Suppose we have a large vector of
# integers between 1 and `a` called `intVec` , then we can compute the number of `1`’s, `2`’s, ..., `a`’s using
# 
#```tabulate(intVec, a)```
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



# Under H0, the probability of each outcome is 1/6, so we can get the vector
# E easily using rep via
#
E = rep(1200/6, 6)
# 
# We can count the number of 1's, 2's etc in our sample using the tabulate 
# function. See the techniques sheet or the online help for more details.
#
O = tabulate(rolls, nbins=6)
#
# (Note O here is an `Oh', not a zero!).  Finally, to get the test statistic
#                                             2
# value, we can simply create the vector (O-E) /E and sum its values via
#
# 
# Question: What is your value of X2?
X2 <- sum((O-E)^2/E)

# In order to see if your value of X2 is unusually large under H0 we need to
# know the distribution of X2 under H0. We investigate this with a sampling
# experiment.

# 3. A repeated sampling experiment --------------------------------------

# We will write a program that simulates the rolling of 1200 dice and computes
# the chi-squared statistic. We will then use this program to do a repeated
# sampling experiment and look at the properties of the chi-squared
# distribution.
# 

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ 
# ^ TECHNIQUE: 
# ^ 
# ***Functions with no arguments***
# So far, we have written our own _R_ programs as functions of a number of inputs that we specify. We can write programs that do a certain task every
# time, without any input variable by simply not including an input variable at the beginning. Here is an example of a function that takes a random 
#integer from 1 to 10
#`
#RanInt <- function(){ sample(1:10,1)
#}
#`
# The important thing to note is that when *calling* a function with no arguments, we still **must include the brackets at the end!** To use the function
# above, for example, we type `RanInt()`.
# **Functions with default arguments**
# Default arguments are very useful in _R_, and most of the functions we have used up to now contained hidden defaults. For example, the function
# `sample` has the default argument `replace=FALSE`, amongst others.
# A default allows us to change an argument if we wish to, but to not specify it when we call the function if we don’t. For example, `sample(1:10,4)`
# will sample 4 values from 1 to 10 without replacement by default. If we want to sample with replacement we write `sample(1:10,4,replace=TRUE)` in
# order to change the default.
# To add defaults to our own functions we simply add the default value after an `=` sign in the inputs to the function. E.g.
#`RanInt <- function(N=10){ sample(1:N,1)
#}`
#Now `RanInt` draws a sample from the natural numbers up to `N`. If we don’t specify an `N` by typing `RanInt()`, we get a sample from the numbers 1 to #10, else we could specify `RanInt(30)` to get a number from 1 to 30.
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



# Question: Write a function, called rollFun, with no arguments that simulates
# 1200 rolls of a fair die and computes the chi-squared statistic in the way we
# computed it above. Write your script below.

rollFun <- function(){
  rolls <- sample(1:6, 1200, replace=TRUE)
  Obs <- tabulate(rolls, nbins=6)
  Exp <- rep(1200/6, 6)
  X2 <- sum((Obs-Exp)^2/Exp)
  return(X2)
}










# Question: When we call rollFun, we should get a single number back from the
# function. Call rollFun to check this is the case. Don't forget the brackets!

rollFun()





# Question: Use replicate to perform 1000 sampling experiments with rollFun and
# call the resulting vector of chi-squared statistics, roll1200.

roll1200 <- replicate(1000, rollFun())





# Plot your statistics as a histogram using a density scale on the vertical axis
# using the command
# 
hist(roll1200, freq=FALSE)

# The result is an approximation to the distribution of the chi-squared
# statistic under H0.  

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ 
# ^ TECHNIQUE: 
# ^ 
#***Overlaying distributions on histograms***:
#We often want to apply theory that says a random sample behaves as a draw from a certain distribution. One useful sanity check for this is to draw
# a histogram of the sample and overlay the shape of the distribution to see if the sample is consistent with our assumptions. The function
# `lines(x,y)` allows us to draw lines on plots, including histograms.

#To overlay a particular distribution onto a histogram, we require a large sequence `x` that that runs from the minimum to the maximum of 
#the values in the histogram, and a `y` of the distribution function in question applied to each value in `x`.

#We know by now how to generate sequences and we can get maxima and minima using commands given above. We can get the density function using
# `d` prefixed to one of the many distributions provided by _R_. The density function for the chi-squared distribution is `dchisq`, for example,
# and for the normal it is `dnorm`. Other distributions in _R_ are `unif`, `exp` and `pois`. Don’t forget to prefix the `d` if you want the 
#density function. You can read more about these functions using their help pages.

# Putting this together: Suppose we have a vector `x` that we suppose is a random sample from a chi-squared distribution with degrees of freedom 5. The
# following commands will draw the histogram of the vector and then overlay the chi-squared density to check our supposition:
  
#```hist(x)```

#```forLine <- seq(from=min(x), to = max(x), len=100) ```

#```lines(forLine, dchisq(forLine,df=5))```
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



#As introduced in the lectures, when all the E  are
#                                                         2         i  
# greater than 5, we can approximate the distribution of X  under H0 using a 
# chi-squared distribution with k-1 degrees of freedom, where k is the number of
# possible outcomes (6 in our case). To see if our sample is consistent with a
# chi-squared(5) distribution, we can overlay the chi-squared(5) density on our
# histogram.
#
# Question: Use the   commands `seq` and `lines`  (see the technique tips) to overlay the 
# $\chi^2_{5}$ density onto your histogram. Is your sample consistent with the
# theory?

hist(roll1200, freq=FALSE)
#forLine <- seq(from=min(roll1200), to=max(roll1200), len=100)
lines(forLine, dchisq(forLine, df=5), lwd=2)
abline(v=X2, col='red', lwd=2)





# Question: Add a vertical line showing the value of our test statistic for
# `rolls` using the command  `abline`.







# 3.1 Computing p-values ---------------------------------------------------

# To quantify the `goodness of fit' of our value X2 under H0 we can use the
#                                                                       2
# p-value, which is the probability, under H0, of observing a value of X
# that is greater than our value, X2. We can either do this using our sampling
# distribution directly via
# 
# Question: Compare your sampling p-value with the p-value obtained from the
# $\chi^2_{5}$ approximation. Are the two results close?








# 4. Using a biased die -------------------------------------------------- 

# We are now going to generate a sample from a biased die, and see what happens
# to the chi-squared statistic. To do this we will modify rollFun to accept an
# argument containing probabilities for the different values of the die, but
# with a default that the die is fair.

# Question: Edit rollFun so that it has an input called probs with default value
# rep(1/6,6), and so that the sample of 1200 die rolls uses the vector probs for
# the probability of rolling 1,..., 6. 


rollFun=function(probs=rep(1/6,6)){
  rolls = sample(1:6,1200,replace=TRUE,prob=probs)
  Exp = rep(1200/6, 6)
  Obs = tabulate(rolls, nbins=6)
  X2 = sum((Obs-Exp)^2/Exp)
  return(X2)
}


# To see what happens to the chi-squared statistic using slightly biased dice,
#                                                                       2
# we are going to redraw the histogram of our sampling distribution of X
# under H0 using a larger x-axis to allow us to view large values.
# Type the following   before moving on.
# hist(roll1200, breaks=seq(from=0,to=50,by=2.5), freq=FALSE)


hist(roll1200,breaks=seq(0,50,2.5),freq=FALSE)




#4.1 A die with a small bias -----------------------------------------------------


# We will create a die that is slightly biased away from 6 towards one using the
# following vector of probabilities:
# 
# bp = c(1/6 + 0.02, 1/6, 1/6, 1/6, 1/6, 1/6 - 0.02)
#
# Create a function `rollFun1` with an argument `probs`, which calculates the $X^2$ statistic for the biased die.
# You can do this by calling `rollFun(probs)` inside the function. 
# Create the function in such a way that it returns the value of $X^2$ and that it also 
# adds this value as a blue vertical line on the existing histogram. You many define the colour 
# of the line by letting the function have a default argument `col = 'blue'`
bp = c(1/6 + 0.02, 1/6, 1/6, 1/6, 1/6, 1/6 - 0.02)

rollFun1 <- function(probs, colour='blue'){
  biasX2 <- rollFun(probs)
  abline(v=biasX2, col = colour, lwd=2)
}

rollFun1(bp)





# Question: What do you notice about the blue vertical lines on the histogram?
# Would the results of this experiment lead you to suspect that the 
# die was biased if you didn't know?

replicate(10,rollFun1(probs=bp))







#4.2 A die with a larger bias -------------------------------------------------


# Question: Repeat the above experiment 10 times with
#
# bp = c(1/6 + 0.04, 1/6, 1/6, 1/6, 1/6, 1/6 - 0.04)
#
# this time changing the colour of the vertical line to red. What do you notice?

bp1 = c(1/6 + 0.04, 1/6, 1/6, 1/6, 1/6, 1/6 - 0.04)
replicate(10,rollFun1(probs=bp1,colour = 'red'))







# Question: Each experiment, corresponding to each line on our histogram, 
# represents 1200 recorded rolls of a die. Receiving 1 of these experiments in 
# real life would normally be considered a large data set. Would any of the 20 
# or so biased die experiments you have done, if seen alone, lead you not to 
# suspect that the die was biased, based on a chi-squared test, if seen in 
# isolation?




#Question: For what values of $X^2$ would we reject the $H_0$ at a 5% level of significance? 

qchisq(0.95, df=5)
#So reject for X2 > 11.0705

abline(v=11.0705, col='green')

# 5. Further exercises
## Example 1
# We can use the  pre-defined function supported by the stats package in _R_, in order to apply chi-square test to the example in the lecture notes.

# Suppose we wish to know whether a die is fair or not. If it is fair then each face is equally likely to occur, i.e. 1/6. To test this claim,
# a die is rolled 120 times and the number of times each face appeared was recorded.
 
 
 
# Question: Enter the data into _R_, then use the `chisq.test` to perform chi-square test 
# for goodness of fit. Type `?chisq.test` for help.









## Example 2
# A random sample of 1000 residents of a major city to gather information on the alcohol consumption
# yielded the data displayed below.

# Question: Enter the data into _R_ in the form of a 4 by 3 matrix, then use the `chisq.test` to perform chi-square test for independence.








