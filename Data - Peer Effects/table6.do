

est clear


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
