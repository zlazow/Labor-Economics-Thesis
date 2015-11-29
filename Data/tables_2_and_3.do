
est clear



**
* Regression options
**
global options = " robust cluster(grouping_id) absorb(tourncat) "



areg handicap hand_i mean_handicap if round==1 , absorb(tourncat) robust cluster(grouping_id)
est store handicap1d

areg handicap hand_i if round==1 , absorb(tourn) robust cluster(grouping_id)
est store handicap1a
areg handicap hand_i if round==1 , absorb(cat) robust cluster(grouping_id)
est store handicap1b
areg handicap hand_i if round==1 , absorb(tourncat) robust cluster(grouping_id)
est store handicap1c


preserve

keep if use_in_skill == 1

foreach v in drivdist greenrd putts first_year namelen {
 di "========="
 di "ability=`v' ..."
 di "========="

 capture drop handicap hand_i mean_handicap
 rename `v' handicap
 rename `v'_i hand_i
 rename mean_`v' mean_handicap

 areg handicap hand_i if round==1 , absorb(tourncat) robust cluster(grouping_id)
 est store `v'_ols
 areg handicap hand_i mean_handicap if round==1 , absorb(tourncat) robust cluster(grouping_id)
 est store `v'_mod

}
restore

estout handicap1d handicap1a handicap1b handicap1c using ${OUTPUT}table2.txt,  drop( _* ) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15)  ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

estout handicap1d *_mod using ${OUTPUT}table3a.txt,  drop( _* ) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15)  ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

estout handicap1c *_ols using ${OUTPUT}table3b.txt,  drop( _* ) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15)  ///
cells(b( fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

exit

/**
estout handicap1d handicap*_x2 using ${OUTPUT}table3b_stars.txt,  drop( _cons ) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15)  starlevels(* 0.10 ** 0.05 *** 0.01) ///
cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

estout handicap1c handicap*_x using ${OUTPUT}table3a_stars.txt,  drop( _cons ) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15)  starlevels(* 0.10 ** 0.05 *** 0.01) ///
cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 

estout handicap1a handicap1b handicap1c handicap1d using ${OUTPUT}table2_stars.txt,  drop( _cons ) ///
stats(r2 N, fmt(%9.3f %9.0g)) modelwidth(15)  starlevels(* 0.10 ** 0.05 *** 0.01) ///
cells(b(star fmt(%9.3f)) se(fmt(%9.3f)) ) style(tab) replace notype mlabels(, numbers ) 
 **/
