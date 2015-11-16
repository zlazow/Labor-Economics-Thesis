


est clear



**
* Regression options
**
global options = " robust cluster(grouping_id) absorb(tourncat) "
xi i.round





**
*  [KEY]
* handicap_c2 is the is the \hat{s}^2 term (variance of past scores)
* ntourn      is the N_i term (number of past scores used to estimat ability)
**
bys year: summ handicap_c2
bys year: summ ntourn, det








**
* create dummy variables and constant term 
**
gen cons = 1



**
* "eiv_vars" are variables measured with error and should have associated `var'_c2
* "varlist"  are all other variables (assumed to be measured without error)
**
global eiv_vars = " handicap hand_i "
global varlist = "$eiv_vars cons _I*"







**
** if any partners (or yourself) has <= X tourns; then don't include
**
bys teegprd1: egen min_ntourn = min(ntourn)
summ min_ntourn, det
**drop if min_ntourn <= 5



capture drop cons
gen cons = 1




**
* create variance of playing partners
**
gen handicap_c2_var = handicap_c2
replace handicap_c2 = handicap_c2 / (ntourn)

summ handicap_c2, det
**replace handicap_c2 = r(p99) if handicap_c2 >= r(p99)
replace handicap_c2_var = handicap_c2 * ntourn
capture drop myN
bys teegprd1 round: gen myN = _N
bys teegprd1 round: egen sum_c2 = sum(handicap_c2_var / ( (myN - 1)^2 * ntourn))
gen hand_i_c2 = sum_c2 - handicap_c2_var / ( (myN - 1)^2 * ntourn)
replace hand_i_c2 = 0 if hand_i_c2 == .
replace handicap_c2 = 0 if handicap_c2 == .

replace handicap_c2_var = handicap_c2_var / ntourn
summ handicap_c2 handicap_c2_var hand_i_c2, det

summ handicap_c2, det
summ handicap_c2 [aw=wgt], det
summ hand_i_c2, det
summ hand_i_c2 [aw=wgt], det




********************
* measurement-error corrected estimator ...
********************
*summ wgt
*replace wgt = wgt / r(mean)

capture drop _I*
xi i.round i.tourncat


**
** create X'X and X'Y and inv(X'X)*X'Y
**
matrix accum xx = $varlist [aw=wgt], noconstant
matrix vecaccum xy = scorerd $varlist [aw=wgt], noconstant
matrix xy = xy'



** OLS estimates
**matrix pi = invsym(xx) * xy



**
* create "sigma_hat" (see Note for formula)
*  NOTE: sigma_hat is assumed to be diagonal matrix
*        dimensions of "sigma_hat" are K X K where K is width of data matrix, 
**
di " Creating sigma_hat ..."
local K = colsof(xx)
matrix sigma_hat = J(`K', `K', 0)
if ("$eiv_vars" != "") {
 local i = 1
 foreach var of varlist $eiv_vars {
  summ `var'_c2 [aw=wgt], det
  matrix sigma_hat[`i',`i'] = r(mean)
  local i = `i' + 1
 }
}


**
* get "beta_hat" (ME-CORRECTED)
**
count
local N = r(N)
matrix pi = invsym(xx / `N' - sigma_hat) * (xy / `N')


**matrix list sigma_hat
**matrix list pi


**
* generate "e_hat" ( = Y - X*Beta)
**
di " generating nu_hat ..."
local v = 1
capture drop nu_hat
gen nu_hat = scorerd
foreach var of varlist $varlist {
 qui replace nu_hat = nu_hat - pi[`v',1] * `var'
 local v = `v' + 1
}

capture drop e_hat
local K = rowsof(pi)
egen e_hat = sum(nu_hat * nu_hat / (_N - `K'))
summ e_hat, det
local e_hat = r(mean)

**
* Generate "W_hat"
*  W_hat = [(x*e - V_hat * Beta) * (x*e - V_hat * Beta)']
** 
capture drop W_*

local v = 1
di "generating W ..."
foreach var of varlist $varlist {
 qui gen W_`v' = `var' * nu_hat
 local v = `v' + 1
}
if ("$eiv_vars" != "") {
local i = 1
di "updating W ..."
foreach var of varlist $eiv_vars {
 replace W_`i' = W_`i' - `var'_c2 * pi[`i',1]
 local i = `i' + 1
}
}



**
* Generate variance-covariance matrix V
**
matrix accum W = W_* [aw=wgt], noconstant
matrix W = W / `N'
matrix V = (1/`N')*inv(xx / `N' - sigma_hat)*W*inv(xx / `N' - sigma_hat)



**
* Prepare results
**
matrix sd = vecdiag(V)
local cols = colsof(sd)
forvalues c = 1(1)`cols' {
 matrix sd[1,`c'] = sqrt(sd[1,`c'])
}
matrix results = (pi, sd')

matrix rownames results = $varlist
matrix colnames results = beta_hat std_err
matrix results = results[1..3,1..2]

**
* MEASUREMENT-ERROR CORRECTED RESULTS
**
matrix list results


**
* Compare to baseline
**
areg scorerd $eiv_vars _Ir* [aw=wgt], $options

local b = _b[handicap]
lincom _b[hand_i] / `b'
nlcom _b[hand_i] / _b[handicap]






