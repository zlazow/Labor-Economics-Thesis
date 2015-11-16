
clear
set more off

global fontface = "fontface('Times-Roman')"

clear
use bootstrap10000_0_55
rename Bvals1 Bvals0_50
rename pvals1 pvals0_50
gen myn = _n
sort myn
save tmp_0.dta, replace

clear
use bootstrap10000_1_55
rename Bvals1 Bvals1_50
rename pvals1 pvals1_50
gen myn = _n
sort myn
save tmp_1.dta, replace

clear
use bootstrap10000_1_550
rename Bvals1 Bvals1_500
rename pvals1 pvals1_500
gen myn = _n
sort myn
save tmp_1_550.dta, replace

clear
use bootstrap10000_0_550
rename Bvals1 Bvals0_500
rename pvals1 pvals0_500
gen myn = _n
sort myn
save tmp_0_550.dta, replace



clear

use tmp_1.dta

capture drop _merge
sort myn
merge myn using tmp_0

capture drop _merge
sort myn
merge myn using tmp_1_550

capture drop _merge
sort myn
merge myn using tmp_0_550

summ, det

gen val = 5
gen x   = myn / _N



count
count if pvals0_500 < 0.05
count if pvals1_500 < 0.05
count if pvals0_50 < 0.05
count if pvals1_50 < 0.05

twoway (kdensity Bvals1_50, width(0.0025) yaxis(1)), ///
       title("Figure 3a: Kernel density of coefficients on partners' ability" "(Small urn, M=45)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
       xtitle("Beta") xlabel(-.02(0.005).02) ytitle("density", axis(1)) ysc(r(0))
graph save betaDensities_a_50.gph, replace

twoway (kdensity Bvals1_500, width(0.0001) yaxis(1)), ///
       title("Figure 3b: Kernel density of coefficients on partners' ability" "(Large urn, M=450)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
       xtitle("Beta") xlabel(-.01(0.005).01) ytitle("density", axis(1))  ysc(r(0))
graph save betaDensities_a_500.gph, replace

twoway (histogram pvals1_50, width(0.05) gap(5) percent) ///
       (line val x), ///
       title("Figure 3c: Histogram of p-values" "(Small urn, M=45)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
       legend(region(style(none))) ///
       legend(cols(1)) ///
       legend(label(1 "Modified randomization test")) ///
       legend(label(2 "Expected density")) ///
       xtitle("p-value") xlabel(0(0.1)1) ylabel(0(5)40.0) ysc(r(0 40.0)) ytitle("percent")
graph save pvalDensities0_a_50.gph, replace

twoway (histogram pvals1_500, width(0.05) gap(5) percent) ///
       (line val x), ///
       title("Figure 3d: Histogram of p-values" "(Large urn, M=450)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
       legend(region(style(none))) ///
       legend(cols(1)) ///
       legend(label(1 "Modified randomization test")) ///
       legend(label(2 "Expected density")) ///
       xtitle("p-value") xlabel(0(0.1)1) ylabel(0(5)40.0) ysc(r(0 40.0)) ytitle("percent")
graph save pvalDensities0_a_500.gph, replace

graph combine betaDensities_a_50.gph betaDensities_a_500.gph  pvalDensities0_a_50.gph  pvalDensities0_a_500.gph , ///
 col(2) ysize(4.5) xsize(6.1) title("Figure 3: Monte Carlo of Modified Randomization Tests") iscale(0.45) ///
 scheme(s2mono) graphregion(fcolor(white))
graph export pga_fig3.eps, replace $fontface



*       legend(region(style(none))) ///
*       legend(cols(1)) ///
*       legend(label(1 "(1) Sacerdote-style OLS randomization test")) ///

twoway (kdensity Bvals0_50, width(0.025) yaxis(1)), ///
       title("Figure 2a: Kernel density of coefficients on partners' ability" "(Small urn, M=45)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
       xtitle("Beta") xlabel(-.2(0.05).2) ytitle("density", axis(1)) 
graph save betaDensities_a_50.gph, replace

twoway (kdensity Bvals0_500, width(0.01) yaxis(1)), ///
       title("Figure 2b: Kernel density of coefficients on partners' ability" "(Large urn, M=450)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) legend(off) ///
       xtitle("Beta") xlabel(-.2(0.05).2) ytitle("density", axis(1)) 
graph save betaDensities_a_500.gph, replace

twoway (histogram pvals0_50, width(0.05) gap(5) percent) ///
       (line val x), ///
       title("Figure 2c: Histogram of p-values" "(Small urn, M=45)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
       legend(region(style(none))) ///
       legend(cols(1)) ///
       legend(label(1 "OLS randomization test")) ///
       legend(label(2 "Expected density")) ///
       xtitle("p-value") xlabel(0(0.1)1) ylabel(0(5)40.0) ysc(r(0 40.0)) ytitle("percent")
graph save pvalDensities0_a_50.gph, replace

twoway (histogram pvals0_500, width(0.05) gap(5) percent) ///
       (line val x), ///
       title("Figure 2d: Histogram of p-values" "(Large urn, M=450)") ///
       scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
       legend(region(style(none))) ///
       legend(cols(1)) ///
       legend(label(1 "OLS randomization test")) ///
       legend(label(2 "Expected density")) ///
       xtitle("p-value") xlabel(0(0.1)1) ylabel(0(5)40.0) ysc(r(0 40.0)) ytitle("percent")
graph save pvalDensities0_a_500.gph, replace


graph combine betaDensities_a_50.gph betaDensities_a_500.gph pvalDensities0_a_50.gph pvalDensities0_a_500.gph, ///
 col(2) ysize(4.5) xsize(6.1) title("Figure 2: Monte Carlo of OLS Randomization Tests") iscale(0.45) ///
 scheme(s2mono) graphregion(fcolor(white))
graph export pga_fig2.eps, replace $fontface








