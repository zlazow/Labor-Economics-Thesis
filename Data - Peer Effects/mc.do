
drop _all

set mem 2000m
set more off
set linesize 200
set matsize 10000
set maxvar  10000
set seed 12345


*****************
* MONTE CARLO TEST 
*****************

local B = 10000
matrix Bvals = J(`B',1, 0)
matrix pvals = J(`B',1,  0)
matrix Zvals = J(`B', 3,  0)

local N                   = 3
local J                   = `3' / 3

/**
local N                   = $N
local J                   = `3' / `N'
local num_players         = `2'
local players_per_tourney = `3'
local num_tourneys        = 1
**/

local num_players         = `2'
local players_per_tourney = `N' * `J' 
local num_tourneys        = 100
assert(`3' == (`N' * `J'))


forvalues b = 1/`B' {
di "boostrap replication `b' ..."

global qui = "noi"
$qui {


*di "N: `N' ... J: `J' ..."
di "num_players: `num_players' ... players_per_tourney: `players_per_tourney' ..."

drop _all

local newobs = `num_tourneys' * `num_players'
set obs `newobs'

gen player = .
gen handicap = .

di "creating players ..."
forvalues p = 1/`num_players' {
  qui replace player = `p' if (_n >= (1 + (`p' - 1) * `num_tourneys') & _n <= (`p') * `num_tourneys')
}
*qui replace player = _n
di "done creating players."

**
* generate handicap from N(0,1)
**
replace handicap = invnorm(uniform())
bys player: replace handicap = handicap[1]




**
* generate tournaments and pairings
**
bys player: gen tourney = _n
gen t_rand = uniform()
sort tourney t_rand
bys tourney: gen myt = _n

gen size_rand = uniform()
bys tourney: replace size_rand = size_rand[1]

**
* NEED tournaments of different sizes to avoid collinearity in regression!
**
drop if myt > `players_per_tourney' & size_rand <= (1/5)
drop if myt > (`players_per_tourney'-6) & size_rand > (1/5) & size_rand <= (2/5)
drop if myt > (`players_per_tourney'-3) & size_rand > (2/5) & size_rand <= (3/5)
drop if myt > (`players_per_tourney'+3) & size_rand > (3/5) & size_rand <= (4/5)
drop if myt > (`players_per_tourney'+6) & size_rand > (4/5) & size_rand <= (5/5)

*drop if myt > (`players_per_tourney'-9) & size_rand > (5/6) & size_rand <= (6/6)
*drop if myt > `players_per_tourney'
*drop if myt > `players_per_tourney' & size_rand <= (1/2)
*drop if myt > `players_per_tourney'-3 & size_rand > (1/2)



/**
gen     offset1 = -2
replace offset1 = -1 if ( (myt - 2) / 3 - floor( (myt - 2) / 3) == 0)
replace offset1 =  1 if ( (myt - 1) / 3 - floor( (myt - 1) / 3) == 0)
gen     offset2 = -1
replace offset2 =  1 if ( (myt - 2) / 3 - floor( (myt - 2) / 3) == 0)
replace offset2 =  2 if ( (myt - 1) / 3 - floor( (myt - 1) / 3) == 0)
gen hand_i = (handicap[_n + offset1] + handicap[_n + offset2]) / 2
**/



gen rand_offset1 = 1 + floor(uniform() * _N)
gen rand_offset2 = 1 + floor(uniform() * _N)
gen rand_hand_i = (handicap[_n + rand_offset1] + handicap[_n + rand_offset2]) / 2

**
* gen teegp id for "clustering"
**
gen teegp = floor( (_n-1) / `N')

bys teegp: egen mean_h = mean(handicap)
gen hand_i = (`N'*mean_h - handicap) / (`N' - 1) 


**
* gen MEAN of handicap in my cell NOT including me
**
bys tourney: egen mean_handicap = mean(handicap)
bys tourney: gen num_temp = _N
replace mean_handicap = (num_temp * mean_handicap - handicap) / (num_temp - 1)

**
* gen MEAN of handicap in my cell NOT including me and another random guy
**
/**
bys tourney: egen mean_handicap = mean(handicap)
bys tourney: gen num_temp = _N
gen test_rand = 1+floor(num_temp * uniform())
assert test_rand >= 1 & test_rand <= num_temp
bys tourney: gen rc = handicap[test_rand]
*replace mean_handicap = (num_temp * mean_handicap - handicap - rc) / (num_temp - 2)
replace mean_handicap = (num_temp * mean_handicap - handicap) / (num_temp - 1)
**/
qui summ

**list

**
* RUN REGRESSIONS!
**
di "doing regression ..."
**xi i.tourney

 **
 * MODE 0: Sacerdote-style OLS (tourney FE)
 * MODE 1: Include mean of others as control
 * MODE 2: Allow pairings with self (just to verify that everything "works" perfectly
 **
 if (`1' == 0) {
  qui areg handicap hand_i, absorb(tourney) cluster(teegp)
 }
 else {
   if (`1' == 1) {
    qui areg handicap hand_i mean_handicap, absorb(tourney) cluster(teegp)
   }
   else {
    drop hand_i
    rename rand_hand_i hand_i
    areg handicap hand_i, absorb(tourney)
   }
 }

 ** ereturn list
 qui testparm hand_i
 ** return list

matrix B = e(b)
matrix Bvals[`b',1] = B[1,1]
local val = B[1,1]
matrix pvals[`b',1] = r(p)

qui summ handicap, meanonly
egen x_bar = mean(handicap)
gen hsq = handicap * handicap
egen S = sum(hsq)
bys teegp: egen x_bar_j = mean(handicap)
gen x_bar_j_sq = x_bar_j * x_bar_j
bys teegp: gen inc = _n == 1
egen sum_x_bar_j = sum(x_bar_j_sq) if inc == 1

gen z1 = `N'*`N'* sum_x_bar_j - S 
gen z2 = `J'*`N'*((`N'-1)^2) * x_bar * x_bar 
gen z3 =  ( (`N' - 2)*`N'*`N'* sum_x_bar_j - `J'*`N'*((`N'-1)^2) * x_bar * x_bar + S ) 
gen beta_hat = ( (`N'-1)*z1  - z2 ) / z3

qui summ beta_hat 
di "val: `val'

qui summ z1, meanonly
matrix Zvals[`b',1] = r(mean)
qui summ z2, meanonly
matrix Zvals[`b',2] = r(mean)
qui summ z3, meanonly
matrix Zvals[`b',3] = r(mean)


}

preserve
drop _all
svmat Bvals
svmat pvals
svmat Zvals
keep if _n <= `b'
assert _N == `b'
summ Bvals , det
summ pvals  , det
qui summ Zvals*  , det
**save bootstrap`B'_`1', replace
restore


**
* end bootstrap loop
}


preserve
drop _all
svmat Bvals
svmat pvals
svmat Zvals
summ Bvals , det
summ pvals , det
summ Zvals*  , det
save bootstrap`B'_`1'_`2', replace
restore

