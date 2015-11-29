
est clear



**
* Regression options
**
global options = " robust cluster(grouping_id) absorb(tourncat) "
xi i.round




areg scorerd handicap hand_i _I* [aw=wgt], $options
est store baseline

**
* "Poor-man's" measurement-error correction
*  (see table4_me.do for measurement-error-corrected estimator)
**
local b = _b[handicap]
lincom _b[hand_i] / `b'




**
* Result with leave-me-out mean control
**
areg scorerd handicap hand_i mean_handicap _I* [aw=wgt], $options

**
* Results w/out round FE and with tourn-by-round FE
**
preserve
xi i.tourn*i.round
areg scorerd handicap hand_i _Ir* [aw=wgt], $options
areg scorerd handicap hand_i [aw=wgt], $options
restore



preserve
xi i.round i.tourncat
areg scorerd hand_i _I* [aw=wgt], robust cluster(grouping_id) absorb(player)
est store player_fe
restore


**
* Results for alternative measures of ability
**
preserve
keep if use_in_skill == 1

assert(round == 1 | round == 2)

areg scorerd drivdist drivdist_i _I* [aw=wgt], $options
est store score3
areg scorerd putts putts_i _I* [aw=wgt], $options
est store score4
*areg scorerd fairrd fairrd_i _I* [aw=wgt], $options
*est store score5
areg scorerd greenrd greenrd_i _I* [aw=wgt], $options
est store score6
areg scorerd putts putts_i  greenrd greenrd_i drivdist drivdist_i _I* [aw=wgt], $options
est store score8

restore


**
* Results by category 
*  (NOT in paper)
**
areg scorerd handicap hand_i _I* if cat == "1" [aw=wgt], $options
**est store score1a1cat1
areg scorerd handicap hand_i _I* if (cat == "2" | cat == "1a") [aw=wgt], $options
**est store score1a2
areg scorerd handicap hand_i _I* if cat == "3" [aw=wgt], $options
**est store score1a3
areg scorerd handicap hand_i _I* if cat != "1" [aw=wgt], $options
**est store score1a_not1


estout baseline player_fe using ${OUTPUT}table4.txt, drop(_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 
est drop player_fe


estout * using ${OUTPUT}table5.txt, drop(_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

/**
estout * using ${OUTPUT}table5_stars.txt, drop(mean_*) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15) ///
starlevels(* 0.10 ** 0.05 *** 0.01) ///
cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 
 **/







