
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

