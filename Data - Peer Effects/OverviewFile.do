//Make Table 1
clear
use ${DATA}pga_data



set more off

* summ scorerd score_i handicap hand_i drivdist putts fairrd greenrd tigeringrp purse log_purse, det
** mscore
* scoreresid

preserve


//Creating an empty matrix that has 20 rows, 12 columns, with each cell initialized to 0.
matrix table1 = J(20, 12, 0)
local i = 1 //just used for the for loop below. Not sure why they put it here...
//Capture terminates errors
capture drop *Xcat*


**
* use "catnum" instead of "cat" for summary statistics
**
//This is all one line, generating catnum variable
gen catnum = .
replace catnum = 1   if cat == "1"  & missing(catnum)
replace catnum = 1.5 if cat == "1a" & missing(catnum)
replace catnum = 2   if cat == "2"  & missing(catnum)
replace catnum = 3   if cat == "3"  & missing(catnum)

/*handXcat = handicap interacting with category
handicap is the players handicap
hand_i is the avg of playing partners handicap */
gen handXcat1 = handicap if (catnum == 1)
gen handXcat1a = handicap if (catnum == 1.5)
gen handXcat2 = handicap if (catnum == 2)
gen handXcat3 = handicap if (catnum == 3)
gen hand_iXcat1 = hand_i if (catnum == 1)
gen hand_iXcat1a = hand_i if (catnum == 1.5)
gen hand_iXcat2 = hand_i if (catnum == 2)
gen hand_iXcat3 = hand_i if (catnum == 3)

**foreach var of varlist scorerd score_i handicap hand_i drivdist putts greenrd purse log_purse tigeringrp num_years first_year namelen handXcat1 hand_iXcat1 handXcat2 hand_iXcat2 handXcat3 hand_iXcat3 {
**foreach var of varlist scorerd score_i handicap hand_i drivdist putts greenrd first_year purse log_purse tigeringrp first_year handXcat1 hand_iXcat1 handXcat1a hand_iXcat1a handXcat2 hand_iXcat2 handXcat3 hand_iXcat3 {

foreach var of varlist scorerd score_i handicap hand_i drivdist putts greenrd first_year tigeringrp handXcat1 hand_iXcat1 handXcat1a hand_iXcat1a handXcat2 hand_iXcat2 handXcat3 hand_iXcat3 {

  if ("`var'" == "drivdist" | "`var'" == "putts" | "`var'" == "greenrd") {
    summ `var' if use_in_skill == 1, det
  }
  else {
    summ `var', det
  }


  matrix table1[`i', 1] = r(N)
  matrix table1[`i', 2] = r(mean)
  matrix table1[`i', 3] = r(sd)
  matrix table1[`i', 4] = r(min)
  matrix table1[`i', 5] = r(p10)
  matrix table1[`i', 6] = r(p25)
  matrix table1[`i', 7] = r(p50)
  matrix table1[`i', 8] = r(p75)
  matrix table1[`i', 9] = r(p90)
  matrix table1[`i', 10] = r(max)
  local i = `i' + 1
}


drop _all
svmat table1
outsheet using ${DATA}table1.txt, replace
restore

preserve
bys player year: keep if _n == 1
corr handicap scoreresid
corr handicap mscore
corr scoreresid mscore
restore



// Make Derived Variables
sort cat
by cat: summ handicap, det
by cat: summ hand_i, det

summ handicap, meanonly
replace handicap = handicap - r(mean)
summ hand_i, meanonly
replace hand_i = hand_i - r(mean)
summ purse, meanonly
replace purse = purse - r(mean)
summ log_purse, meanonly
replace log_purse = log_purse - r(mean)
summ putts, meanonly
replace putts = putts - r(mean)
summ drivdist, meanonly
replace drivdist = drivdist - r(mean)
summ fairrd, meanonly
replace fairrd = fairrd - r(mean)
summ greenrd, meanonly
replace greenrd = greenrd - r(mean)

gen purseXscore_i = purse * score_i

summ e9010, meanonly
replace e9010 = e9010 - r(mean)
summ e7525, meanonly
replace e7525 = e7525 - r(mean)
summ sd_over_mean, meanonly
replace sd_over_mean = sd_over_mean - r(mean)

gen purseXhand_i = purse * hand_i
gen e9010Xhand_i = e9010 * hand_i
gen e7525Xhand_i = e7525 * hand_i
gen sd_over_meanXhand_i = sd_over_mean * hand_i

gen log_purseXhand = purse * handicap
gen purseXhand = purse * handicap
gen e9010Xhand = e9010 * handicap
gen e7525Xhand = e7525 * handicap
gen sd_over_meanXhand = sd_over_mean * handicap

gen log_purseXscore_i = log_purse * score_i
gen log_purseXhand_i = log_purse * hand_i 

gen handicapXhand_i = handicap * hand_i
gen puttsXputts_i = putts * putts_i
gen drivdistXdrivdist_i = drivdist * drivdist_i
gen fairrdXfairrd_i = fairrd * fairrd_i
gen greenrdXgreenrd_i = greenrd * greenrd_i


foreach v in drivdist greenrd fairrd putts {
 gen `v'_iXcat2 = 0
 replace `v'_iXcat2 = `v'_i if cat == "2"
 gen `v'_iXcat3 = 0
 replace `v'_iXcat3 = `v'_i if cat == "3"
}

gen tourncat = tourn + "_" + cat

gen hand_iXcat3 = 0
replace hand_iXcat3 = hand_i if cat == "3"
gen hand_iXcat2 = 0
replace hand_iXcat2 = hand_i if cat == "2"

bys year: tab cat, missing



preserve
bys player year: keep if _n == 1
bys player year: assert(handicap[1] == handicap[_N])
summ handicap, det
local hand10 = r(p10)
local hand25 = r(p25)
local hand25 = round(`hand25', 1e-10)
local hand75 = r(p75)
local hand90 = r(p90)
restore

capture drop myn
bys grouping_id: gen myn = _n
gen hand_max = .
gen hand_min = .
gen hand_top10 = .
gen hand_top25 = .
gen hand_bot25 = .
gen hand_bot10 = .

sort grouping_id handicap

by grouping_id: replace hand_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace hand_max = cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3
by grouping_id: replace hand_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3
by grouping_id: replace hand_max = handicap[2] if _n == 1 & _N == 2
by grouping_id: replace hand_max = handicap[1] if _n == 2 & _N == 2

by grouping_id: replace hand_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace hand_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3
by grouping_id: replace hand_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3
by grouping_id: replace hand_min = handicap[2] if _n == 1 & _N == 2
by grouping_id: replace hand_min = handicap[1] if _n == 2 & _N == 2

by grouping_id: replace hand_top10 = handicap[2] < `hand10' | handicap[3] < `hand10' if _n == 1 & _N == 3
by grouping_id: replace hand_top10 = handicap[1] < `hand10' | handicap[3] < `hand10' if _n == 2 & _N == 3
by grouping_id: replace hand_top10 = handicap[1] < `hand10' | handicap[2] < `hand10' if _n == 3 & _N == 3
by grouping_id: replace hand_top10 = handicap[1] < `hand10' if _n == 2 & _N == 2
by grouping_id: replace hand_top10 = handicap[2] < `hand10' if _n == 1 & _N == 2

by grouping_id: replace hand_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3
by grouping_id: replace hand_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3
by grouping_id: replace hand_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3
by grouping_id: replace hand_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2
by grouping_id: replace hand_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2

by grouping_id: replace hand_top25 = handicap[2] < `hand25' | handicap[3] < `hand25' if _n == 1 & _N == 3
by grouping_id: replace hand_top25 = handicap[1] < `hand25' | handicap[3] < `hand25' if _n == 2 & _N == 3
by grouping_id: replace hand_top25 = handicap[1] < `hand25' | handicap[2] < `hand25' if _n == 3 & _N == 3
by grouping_id: replace hand_top25 = handicap[2] < `hand25' if _n == 1 & _N == 2
by grouping_id: replace hand_top25 = handicap[1] < `hand25' if _n == 2 & _N == 2

by grouping_id: replace hand_bot25 = (handicap[2] > `hand75') | (handicap[3] > `hand75') if _n == 1 & _N == 3
by grouping_id: replace hand_bot25 = (handicap[1] > `hand75') | (handicap[3] > `hand75') if _n == 2 & _N == 3
by grouping_id: replace hand_bot25 = (handicap[2] > `hand75') | (handicap[1] > `hand75') if _n == 3 & _N == 3
by grouping_id: replace hand_bot25 = (handicap[2] > `hand75') if _n == 1 & _N ==2
by grouping_id: replace hand_bot25 = (handicap[1] > `hand75') if _n == 2 & _N ==2

summ hand_top25, det
summ hand_bot25, det

by grouping_id: gen tempsize = _N
assert hand_min == hand_max if tempsize == 2  


**
* Baseline weight is inverse of sampling error of handicap measure
**
assert handicap_c2 < .
gen wgt = 1 / (handicap_c2 / ntourn)
label variable wgt "Weight used in regressions; inverse of sampling error in player ability"

desc, full



//Make Table 6
**
* Regression options
**
global options = " robust cluster(grouping_id) absorb(tourncat) "
xi i.round


areg scorerd handicap hand_i  _I* [aw=wgt], $options
est store baseline

foreach var of varlist hand_max hand_min hand_top10 hand_top25 hand_bot25 hand_bot10 tigeringrp {
 **preserve
 **drop hand_i
 **rename `var' hand_i
 **areg scorerd handicap hand_i _I* [aw=wgt], $options
 areg scorerd handicap `var' _I* [aw=wgt], $options 
 est store `var'
 **restore
}

summ handicap
replace handicap = handicap - r(mean)
summ hand_i
replace hand_i = hand_i - r(mean)
gen hand_iXdiff  = hand_i * (hand_i - handicap)
areg scorerd handicap hand_i hand_iXdiff _I* [aw=wgt], $options
est store diff

estout * using ${OUTPUT}table6.txt, drop(_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

exit

/**
estout * using ${OUTPUT}table6_stars.txt, drop(_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
starlevels(* 0.10 ** 0.05 *** 0.01) ///
cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 
 **/

 end( " `=char(13)' " ) ///




 