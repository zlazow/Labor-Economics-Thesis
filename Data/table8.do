

est clear



**
* Regression options
**
global options = " robust cluster(grouping_id) absorb(tourncat) "
xi i.round



local var = "first_year"

di "====="
di "VAR: `var' ..."
di "====="

areg scorerd handicap hand_i _I* [aw=wgt], $options
est store baseline


summ handicap
replace handicap = handicap - r(mean)
summ hand_i
replace hand_i = hand_i - r(mean)

gen `var'_old = `var'
summ `var'
replace `var' = `var' - r(mean)
capture drop handicapX*
gen handicapXhand_i = handicap * hand_i
gen `var'Xhand_i = `var' * hand_i
gen handicapX`var' = handicap * `var'
gen hX`var'Xhand_i = handicap * `var' * hand_i

areg scorerd handicap hand_i handicapXhand_i _I* [aw=wgt], $options
est store inter_hand

/**
 **
preserve
keep if cat != "1"
foreach v of varlist hand_i handicap {
 summ `v'
 replace `v' = `v' - r(mean)
}
replace handicapXhand_i = handicap * hand_i
areg scorerd handicap hand_i handicapXhand_i _I* [aw=wgt] , $options
est store byabil2
restore
 **
 **/

areg scorerd handicap hand_i `var' `var'Xhand_i _I* [aw=wgt], $options
est store inter_exper

areg scorerd handicap hand_i handicapXhand_i `var' `var'Xhand_i _I* [aw=wgt] , $options
est store inter_both


estout * using ${OUTPUT}table8.txt, drop(_*) ///
 stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
 cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

/**
estout * using ${OUTPUT}table8_`var'_stars.txt, drop(_*) ///
 stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
 starlevels(* 0.10 ** 0.05 *** 0.01) ///
 cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 
 **/

