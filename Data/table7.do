

est clear


**
* Regression options
**
global options = " robust cluster(grouping_id) absorb(tourncat) "
xi i.round


areg scorerd handicap score_i _I*  [aw=wgt], $options
est store baseline



capture drop grp*
sort round tourn teegprd1 player
by round tourn: gen grp = floor( (_n-1) / (_N / 3))
xi i.round i.tourn*i.grp
tab grp, missing
areg scorerd handicap score_i _I* [aw=wgt], $options
est store time_of_day


capture drop grp*
sort round tourn teegprd1 player

sort round tourn teegprd1
by round tourn: gen grp = teegprd1 - teegprd1[1]
summ grp, det

gen grpSq = grp*grp
gen grpCubed = grp*grp*grp
gen grpQuart = grp*grp*grp*grp
gen grpQuint = grp*grp*grp*grp*grp

xi i.round i.tourn*grp i.tourn*grpSq i.tourn*grpCubed
drop _Itourn_*
areg scorerd handicap score_i _I* [aw=wgt], $options
est store cubic_poly

xi i.round i.tourn*grp i.tourn*grpSq i.tourn*grpCubed i.tourn*grpQuart
drop _Itourn_*
areg scorerd handicap score_i _I* [aw=wgt], $options
est store quartic_poly

xi i.round i.tourn*grp i.tourn*grpSq i.tourn*grpCubed i.tourn*grpQuart i.tourn*grpQuint
drop _Itourn_*
areg scorerd handicap score_i _I* [aw=wgt], $options
est store quintic_poly

estout * using ${OUTPUT}table7.txt,  drop(_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

/**
estout score2* using ${OUTPUT}table7_stars.txt,  drop(_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
starlevels(* 0.10 ** 0.05 *** 0.01) ///
cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 
 **/
