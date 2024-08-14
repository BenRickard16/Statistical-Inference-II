#' As usual, we begin in R by entering the data and examining summaries of the data, and plots of the data, initially.  

x = c(0.8, 0.8, 1.3, 1.5, 1.8, 1.9, 1.9, 2.1, 2.6, 2.7, 2.9, 3.1, 3.2, 3.3, 3.5, 3.6, 4.0, 4.1, 4.2, 4.2, 4.3, 4.3, 4.4, 4.4, 4.6, 4.7, 4.7, 4.8, 4.9, 4.9)
summary(x)
sd(x)
hist(x, col = 2, main = 'Waiting times (minutes) in banks')


#' # Applying simple vs. simple tests to the data.
#' Assume that for the given data we have a suspicion that parameter $\lambda$ is concentrated 
#' somewhere within the region $[0,1]$. 
## * Assume that, initially, test the hypothesis $H_0: \lambda = 0.5$ vs. $H_0: \lambda = 0.6$.
# Define appropriately named objects for the quantities that you will use: `l0`, `l1` for the
# prior hypotheses, `n` for sample size, and `S` for the sum of the data.

## * What are the results in terms of $B_{01}$, $2log B_{10}$?

## *Calculate the posterior probabilities $p_0$, $p_1$, assuming that the two hypotheses 
# are equally likely *a-priori*.

## *What are your conclusions?














#' 
#' Of course, in this simple case we can "cheat" a bit, and use the build-in R function `dexp`
#'  for calculating the ratio. Type `?dexp' to see how this function works.
#' 
## * Repeat the previous calculations for $B_{01}$, $2log B_{10}$ using `dexp` and taking the product 
# of the result via function `prod`.

## * Check whether the results are in agreement.















#' Ideally, we would like to construct an automated procedure which will produce results over a grid 
#' of values of $\lambda_1$. This is easy to do once we have our function and the arguments `data` and
#' `l0` and use the command `seq` for defining a grid of values for the argument `l1`.   

## * Type `?seq` to remember how to use this command. Then define an object `grid1` based on `seq` 
# which will be an equally spaced grid of 100 values from 0 to 1.

## * Storing results to an object `logB10`, use `gridl1` as input to your function `f` using the
# same `data` and `l0` as before.

## * Assuming that we would be strict and reject $H_0$ if $2\log B_{10} >1$ find the minimum and
# the maximum $\lambda_1$s for which we would reject. Store them to objects `minl1` and `maxl1`,
# respectively. *Hint:* You can use the `which`, command which we used in the previous practicals.


















#' 
## * Plot the results having on the x-axis the sequence of $\lambda_1$ values and on the y-axis the 
# calculated $2\log B_{10}$.

## * Use the command `abline` to highlight horizontally where $2\log B_{10} >1$ and vertically the 
# minimum and maximum $\lambda_1$s as the boundaries where this happens.

## * What are your conclusions from the plot?




















#' # Applying simple vs. composite tests to the data.
#' 
#' Assume that we make the prior assumption that $\alpha =2$ and $\beta=4$. 
## * This time create a function `f2` that takes as input `data`, `l0`, `alpha` and `beta` and gives as output the posterior probability of $H_0$ (use the formula shown in Section 2).

## * Apply the function to the dataset assuming this time that `l0=0.3`.

## * If you have coded this correctly you will an output approximately equal to 0.578. What can we say based on the output?





















## * Create a function `f3` that takes as further input the additional argument `pi0`
# for the prior posterior probability of $H_0$ and produces again as output the 
# posterior probability of $H_0$.

## * Assume that for some reason we believe that $H_0$ is more likely and assign
# the prior odds to be equal to 2.333333. Use your function `f3` to find the posterior
#probability of the null.

## * Has the posterior probability increaed or decreased, and is the result expected?













## * Think of values of $\alpha$ and $\beta$ that give again a prior expectation equal to 0.5,
# but that result in a higher prior variance.

## * Apply then your function `f1` using these hyperparameters.

## * What is the resulting posterior probability now, and how do you explain the change 
# in comparison to the result in Exercise 5.1?




















