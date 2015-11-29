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
local hand1 = r(p1)
local hand3 = r(p3)
local hand5 = r(p5)
local hand10 = r(p10)
local hand25 = r(p25)
local hand75 = r(p75)
local hand90 = r(p90)
restore

capture drop myn
bys grouping_id: gen myn = _n
gen hand_max = .
gen hand_min = .
gen hand_top1 = .
gen hand_top5 = .
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

by grouping_id: replace hand_top1 = handicap[2] < `hand1' | handicap[3] < `hand1' if _n == 1 & _N == 3
by grouping_id: replace hand_top1 = handicap[1] < `hand1' | handicap[3] < `hand1' if _n == 2 & _N == 3
by grouping_id: replace hand_top1 = handicap[1] < `hand1' | handicap[2] < `hand1' if _n == 3 & _N == 3
by grouping_id: replace hand_top1 = handicap[1] < `hand1' if _n == 2 & _N == 2
by grouping_id: replace hand_top1 = handicap[2] < `hand1' if _n == 1 & _N == 2


by grouping_id: replace hand_top3 = handicap[2] < `hand3' | handicap[3] < `hand3' if _n == 1 & _N == 3
by grouping_id: replace hand_top3 = handicap[1] < `hand3' | handicap[3] < `hand3' if _n == 2 & _N == 3
by grouping_id: replace hand_top3 = handicap[1] < `hand3' | handicap[2] < `hand3' if _n == 3 & _N == 3
by grouping_id: replace hand_top3 = handicap[1] < `hand3' if _n == 2 & _N == 2
by grouping_id: replace hand_top3 = handicap[2] < `hand3' if _n == 1 & _N == 2


by grouping_id: replace hand_top5 = handicap[2] < `hand5' | handicap[3] < `hand5' if _n == 1 & _N == 3
by grouping_id: replace hand_top5 = handicap[1] < `hand5' | handicap[3] < `hand5' if _n == 2 & _N == 3
by grouping_id: replace hand_top5 = handicap[1] < `hand5' | handicap[2] < `hand5' if _n == 3 & _N == 3
by grouping_id: replace hand_top5 = handicap[1] < `hand5' if _n == 2 & _N == 2
by grouping_id: replace hand_top5 = handicap[2] < `hand5' if _n == 1 & _N == 2

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
