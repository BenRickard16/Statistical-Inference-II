#
# PRACTICAL 2-2: Comparing Two Samples
# ---------------------------------
#
#
# In this practical, we illustrate frequentist techniques for comparing two samples 
# under the assumption that the populations are normal. 
# Our objective will be to assess whether or not two samples can be regarded as being
#from the same population.
# 
# You will need the following skills from previous practicals:
#    *   Basic R skills with arithmetic, functions, etc
#    *   Manipulating and creating vectors: `c`, `seq`, `length`
#    *   Calculating data summaries: `mean`, `sd`, `var`, `min`, `max`
#    *   Plotting a scatterplot with `plot`, a histogram with `hist`, and a boxpot with `boxplot`
# 
# New R techniques:
#    *   Normal quantile plots for assessing normality using `qqnorm`
#    *   Quantile and inverse-quantile functions for standard distributions, e.g. `qnorm` and `pnorm`

# ==================================================================================
#
# 1. The data
# 
#
# Eriksen, Björnstad an Götestam (1986) studied a social skills training program for alcoholics.
# Twenty-three alcohol-dependent male inpatients at an alcohol treatment centre were randomly
# assigned to two groups. The 12 control group patients were given a traditional treatment 
# programme. The 11 treatment group patients were given the traditional treatment, plus a class
# in social skills training ("SST"). The patients were monitored for one year at 2-week intervals,
# and their total alcohol intake over the year was recorded (in cl pure alcohol).
#
# A: Control	1042	1617	1180	973	1552	1251	1151	1511	 728	1079	951	1391
# B: SST	    874	   389	 612	798	1152	 893	 541	 741	1064	 862	213	
#


#
# Exercise 1.1:
# ~~~~~~~~~~~~~
#
#  * Use the `c` function to enter these data into R as two vectors called `A` for the control 
#    group, and `B` for the treatment group. 
#
#  * Check your summary statistics match mine below to ensure the data are correct.

## summary(A)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     728    1025    1166    1202    1421    1617
## summary(B)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   213.0   576.5   798.0   739.9   883.5  1152.0


A<-c(1042,1617,1180,973,1552,1251,1151,1511,728,1079,951,1391)
B<-c(874,389,612,798,1152,893,541,741,1064,862,213)



#
# Exercise 1.2:
# ~~~~~~~~~~~~~
#
# * Compare the distributions of  `A` and `B` using a side-by-side `boxplot`. What conclusions 
#   can you draw about the two groups?
# * Draw histograms (`hist`) and Normal quantile plots (`qqnorm`) of both samples. On the basis 
#   of these plots, do the samples look approximately symmetric and Normally distributed?

boxplot(A,B)

par(mfrow=c(1,2))
hist(A)
hist(B)

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ TECHNIQUE: 
# ^ 
# ^ A better graphical way to assess whether the data is distributed normally is to draw a "normal
# ^ quantile plot" (or quantile-quantile, or QQ plot). We can do this in _R_ using the `qqnorm`
# ^ function, where to draw the Normal quantile plot for a vector of data `x` we use the command
# ^ 
# ^ qqnorm(x)
# ^ 
# ^ With this technique, the quantiles of the data (i.e. the ordered data values) are plotted
# ^ against the quantiles which would be expected of a matching normal distribution. If the data
# ^ are normally distributed, then the points of the quantile plot will should lie on an 
# ^ approximately straight line. Deviations from a straight line suggest departures from the
# ^ normal distribution.
# ^
# ^ The straight line can be superimposed on the plot by using the following command
# ^ 
# ^ qqline(x)
# ^
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


#
# Exercise 1.3:
# ~~~~~~~~~~~~~
#
# * Draw Normal quantile plots of both samples using `qqnorm`. Add the lines using `qqline`. Do the samples look approximately
#   Normally distributed? Do your conclusions agree with those made on the basis of the histograms?
#



par(mfrow=c(1,2))
qqnorm(A)
qqline(A)
qqnorm(B)
qqline(B)

# ==================================================================================
#
# 3. Applying the independent sample t-test
#
# 
# To compute the t-test statistic, we're going to need to begin by finding some simple summaries of our two samples.

#
# Exercise 3.1:
# ~~~~~~~~~~~~~
# 
# * Use the `mean`, `var`, and `length` functions to find the sample mean, sample variance, and
#   sample size for the Treatmeant A group. Save these as `abar`, `sa2`, and `n`. 
#
# * Repeat the process for the Treatmeant B group, creating variables `bbar`, `sb2`, and `m`.
#


abar<-mean(A)
sa2<-var(A)
n<-length(A)

bbar<-mean(B)
sb2<-var(B)
m<-length(B)


#
# Exercise 3.2:
# ~~~~~~~~~~~~~
# 
# * Use the formula given above and the variables you have just created to calculate the 
#   pooled sample variance; save this to `sp2`.
#

sp2 <- ((n-1)*sa2 + (m-1)*sb2)/(n+m-2)

sp2




#
# Exercise 3.3:
# ~~~~~~~~~~~~~
# 
# * Under the null hypothesis of no difference in population means, calculate the value of the 
#   test statistic, t, as defined in the theory section above and save it as `t`. Check you
#   get the same value as shown below.
#
## [1] 4.00757
#
# * How many degrees of freedom do we associate with the distribution of t? Save this value to
#   a variable `df`.
#

t<-(abar-bbar)/(sqrt(sp2)*sqrt(1/n+ 1/m))

df<-n+m-2


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# ^ 
# ^ TECHNIQUE: 
# ^ 
# ^ R provides a range of functions to support calculations with standard probability 
# ^ distributions. In the previous practical, we encountered the normal density function `dnorm`,
# ^ as well as the random number generation functions for the uniform (`runif`) and normal 
# ^ (`rnorm`) distributions.
# ^ 
# ^ For every distribution there are four functions. The functions for each distribution begin 
# ^ with a particular letter to indicate the functionality (see table below) followed by the 
# ^ name of the distribution:
# ^ 
# ^ | Letter | e.g. | Function                                                             |
# ^ |-----|---------|----------------------------------------------------------------------|
# ^ | "d" | `dnorm` | evaluates the probability density (or mass) function, $f(x)$         |
# ^ | "p" | `pnorm` | evaluates the cumulative density function, $F(x)=P[X \leq x]$, hence |
# ^ |     |         | finds the probability the specified random variable is less than the |
# ^ |     |         | given argument.                                                      |
# ^ | "q" | `qnorm` | evaluates the inverse cumulative density function (quantiles),       |
# ^ |     |         | $F^{-1}(q)$ i.e. the value $x$ such that $P[X \leq x] = q$. Used to  |
# ^ |     |         | obtain critical values associated with particular probabilities $q$. |
# ^ | "r" | `rnorm` | generates random numbers                                             |
# ^ 
# ^ The appropriate functions for Normal, $t$ and $\chi^2$ distributions are given below, 
# ^ along with the optional parameter arguments.
# ^ 
# ^   + Normal distribution: `dnorm`, `pnorm`, `qnorm`, `rnorm`. 
# ^        Parameters: `mean` (μ) and `sd` (σ).
# ^   + $t$ distribution: `dt`, `pt`, `qt`, `rt`. 
# ^        Parameter: `df`.
# ^   + $\chi^2$ distribution: `dchisq`, `pchisq`, `qchisq`, `rchisq`. 
# ^        Parameter: `df`.
# ^ 
# ^ For a list of all the supported distributions, run the command `help(Distributions)`
# ^ 
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




#
# Exercise 3.4:
# ~~~~~~~~~~~~~
# 
# * How would you use the `qt`` function function to find the appropriate critical value for
#   a test of H_0: μ_X=μ_Y against H_1: μ_X≠μ_Y at the 5% level of significance. 
#   Check you get the same value as below.
#
## [1] 2.079614
#


tstar <- qt(0.975,df)

#
# Exercise 3.5:
# ~~~~~~~~~~~~~
# 
# *  Compare this to your value of `t`, and hence perform the significance test. 
# *  Use this information to construct a 95% confidence interval for the difference in means
#    between the two populations.
# *  What is the probability of observing a value of the test statistic whose absolute value is
#    at least as large as the one observed under the null hypothesis? i.e. what is 
#    P[T_{df} >= t]?
# *  On the basis of your calculations above, what would you conclude about the population 
#    means for the two groups A and B?
# *  Do you think the assumption of equal variances holds here? If not, would this affect your
#    conclusions?

ci <- (abar - bbar) + c(-1,1)*tstar*sqrt(sp2*(1/n + 1/m))
ci

pvalue <- 2*(1-pt(t,df))
# 4. Independent $t$-test: Relaxing the equal variance assumption

# If we abandon the assumption of equal variances, then our first sample is i.i.d. 
# $N{mu_X, sigma_X^2} and the second sample i.i.d $d{mu_Y, sigma_Y^2}, 
# with sigma_X not necessarily equal to sigma_Y. Clearly, there is no single variance 
# parameter to estimate and the test which uses the pooled sample variance would not be
# appropriate. *We won't cover the detail of the theory for this in lectures 
# (nor is it examinable)*, but the idea is straightforward and easy to apply. 
# Without the equal variance assumption, our test statistic becomes
#
#     (xbar-ybar) - (mu_X - mu_Y)
# t = ----------------------------,
#       sqrt(s_X^2/n) + s_Y^2/m)
#
# which still has a t-distribution. The problem arises in determining the appropriate
# degrees of freedom for the distribution of $t$. The degrees of freedom of the 
# t-distribution is no longer n+m-2, but instead is approximated by this expression
#
#                               (s^2_X/n + s^2_Y/m)^2
# nu is approximately = -------------------------------------
#                        s^4_X/(n^2(n-1)) + s^4_Y/(m^2(m-1))
#
# though often in practice we take the lazier route of using nu=\min(n,m)-1 as the degrees of 
# freedom (this simpler case corresponds to a conservative version of the test).

#
# Exercise 4.1:
# ~~~~~~~~~~~~~
# 
#  Apply the independent sample $t$-test with unequal variances to compare the two groups. 
#  What do you conclude? Do the results agree with or contradict the equal-variance test?

t<-(abar-bbar)/sqrt(sa2/n+sb2/m)

pval<-2*(1-pt(t,min(n,m)-1))


# 5. Doing it the easy way: Using the `stats` package

# Thankfully, tests such as t-tests are supported by the `stats` package in R which 
# allows us to pass the problem of computing the test line by line, and we can then
# simply interpret the results.

#
# Exercise 5.1:
# ~~~~~~~~~~~~~
# 
# Use the library  function to load the R package `stats`.
# Read the [techniques page on the `t.test` function] (r_10_statsmethods.html#t.test)
# and apply it to your two samples `A` and `B`. Use the optional argument `var.equal`
# to perform an equal-variance test (`TRUE`), and `FALSE` to test without this assumption. 
# Compare with your results from Section 2.
     
library(stats)
t.test(A,B,var.equal=TRUE)                                                                       
t.test(A,B)

# 6. Creating your own functions

#
# Exercise 6.1:
# ~~~~~~~~~~~~~
# 
# Use your code to construct your own version of the `t.test` function. 
# Add an optional `equalvariance` argument than can be `TRUE` or `FALSE` adjusting 
# the test that is performed. You will need to use an `if` statement to handle the different
# cases 
# Use this to show the test statistic, degrees of freedom, and p-value.

my.t.test<-function(x,y,equalvariance){
  xbar<-mean(x)
  sx2<-var(x)
  n<-length(x)
  ybar<-mean(y)
  sy2<-var(y)
  m<-length(y)
  
  if (equalvariance==TRUE) {
    variance<-((n-1)*sx2 + (m-1)*sy2)/(n+m-2)
    df<-n+m-2
  }
  
  if (equalvariance==FALSE) {
    variance<-sx2/n+sy2/m
    df<-(sx2/n+sy2/m)^2 / (sx2^2/(n^2*(n-1))+sy2^2/(m^2*(m-1)))
  }
  tval<-(xbar-ybar)/variance
  pval<-2*(1-pt(0.975,df))
  result <- data.frame('test-statistic'=round(tval,5),'p-value'=round(pval,5),'df'=df)
  row.names <- ''
  result
}


my.t.test(A,B,TRUE)




#
# Exercise 6.2:
# ~~~~~~~~~~~~~
# 
# Write a function to perform a paired sample t-test. 
# Try it out on the `immer` data set from the `MASS` package, which contains pairs of 
# measurements of the barley yield from the same fields in years 1931 (`Y1`) and 1932 (`Y2`). 
# Check your results with the `t.test` function using the argument `paired=TRUE`.






