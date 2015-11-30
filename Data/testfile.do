//Make Table 1
//Look at top players in each category. If there is only an effect in category 1 then that is b/c of television,etc.

global PATH "N:\Thesis\Data\"
set more off
clear
use ${PATH}pga_data


//Capture terminates errors
sort cat
by cat: summ handicap, det
by cat: summ hand_i, det


summ handicap, meanonly
replace handicap = handicap - r(mean)
summ hand_i, meanonly
replace hand_i = hand_i - r(mean)
summ putts, meanonly
replace putts = putts - r(mean)
summ drivdist, meanonly
replace drivdist = drivdist - r(mean)
summ fairrd, meanonly
replace fairrd = fairrd - r(mean)
summ greenrd, meanonly
replace greenrd = greenrd - r(mean)
preserve 

bys player year: keep if _n == 1
bys player year: assert(handicap[1] == handicap[_N])
summ handicap if cat=="1", det
local hand1 = r(p1)
local hand5 = r(p5)
local hand10 = r(p10)
local hand25 = r(p25)
local hand90 = r(p90)
local hand99 = r(p99)
restore 

gen cat1_max = .
gen cat1_scoremax = .
gen cat1_min = . 
gen cat1_top1 = .
gen cat1_top5 = .
gen cat1_top10 = .
gen cat1_top25 = .
gen cat1_bot10 = .
gen cat1_bot1 = .

sort grouping_id handicap

by grouping_id: replace cat1_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_max= cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_max = handicap[2] if _n == 1 & _N == 2 & cat == "1"
by grouping_id: replace cat1_max = handicap[1] if _n == 2 & _N == 2 & cat == "1"

by grouping_id: replace cat1_scoremin = cond(scorerd[2] < scorerd[3], scorerd[2], scorerd[3]) if _n == 1 & _N == 3
by grouping_id: replace cat1_scoremin = cond(scorerd[1] < scorerd[3], scorerd[1], scorerd[3]) if _n == 2 & _N == 3
by grouping_id: replace cat1_scoremin = cond(scorerd[1] < scorerd[2], scorerd[1], scorerd[2]) if _n == 3 & _N == 3 
by grouping_id: replace cat1_scoremin = scorerd[2] if _n == 1 & _N == 2 
by grouping_id: replace cat1_scoremin = scorerd[1] if _n == 2 & _N == 2

by grouping_id: replace cat1_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_min = handicap[2] if _n == 1 & _N == 2 & cat == "1"
by grouping_id: replace cat1_min = handicap[1] if _n == 2 & _N == 2 & cat == "1"

by grouping_id: replace cat1_top1 = handicap[2] < `hand1' | handicap[3] < `hand1' if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top1 = handicap[1] < `hand1' | handicap[3] < `hand1' if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top1 = handicap[1] < `hand1' | handicap[2] < `hand1' if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top1 = handicap[1] < `hand1' if _n == 2 & _N == 2 & cat == "1"	
by grouping_id: replace cat1_top1 = handicap[2] < `hand1' if _n == 1 & _N == 2 & cat == "1"


by grouping_id: replace cat1_top5 = handicap[2] < `hand5' | handicap[3] < `hand5' if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top5 = handicap[1] < `hand5' | handicap[3] < `hand5' if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top5 = handicap[1] < `hand5' | handicap[2] < `hand5' if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top5 = handicap[1] < `hand5' if _n == 2 & _N == 2 & cat == "1"
by grouping_id: replace cat1_top5 = handicap[2] < `hand5' if _n == 1 & _N == 2 & cat == "1"

by grouping_id: replace cat1_top10  = handicap[2] < `hand10' | handicap[3] < `hand10' if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top10  = handicap[1] < `hand10' | handicap[3] < `hand10' if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top10  = handicap[1] < `hand10' | handicap[2] < `hand10' if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top10  = handicap[1] < `hand10' if _n == 2 & _N == 2 & cat == "1"
by grouping_id: replace cat1_top10  = handicap[2] < `hand10' if _n == 1 & _N == 2 & cat == "1"

by grouping_id: replace cat1_top25 = handicap[2] < `hand25' | handicap[3] < `hand25' if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top25 = handicap[1] < `hand25' | handicap[3] < `hand25' if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top25 = handicap[1] < `hand25' | handicap[2] < `hand25' if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_top25 = handicap[2] < `hand25' if _n == 1 & _N == 2 & cat == "1"
by grouping_id: replace cat1_top25 = handicap[1] < `hand25' if _n == 2 & _N == 2 & cat == "1"


by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "1"
by grouping_id: replace cat1_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "1"

by grouping_id: replace cat1_bot1 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "1"
by grouping_id: replace cat1_bot1 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "1"
by grouping_id: replace cat1_bot1 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "1"
by grouping_id: replace cat1_bot1 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "1"
by grouping_id: replace cat1_bot1 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "1"

gen tourncat = tourn + "_" + cat
global options = " robust cluster(grouping_id) absorb(tourncat) "

areg scorerd handicap hand_i first_year, $options 

foreach var of varlist cat1_max cat1_min cat1_scoremin cat1_top1 cat1_top5 cat1_top10 cat1_top25 cat1_bot10 cat1_bot1 {
 areg scorerd handicap `var' first_year, $options 
 est store `var'
}


gen hand_iXdiff  = hand_i * (hand_i - handicap)
gen cat1_maxXdiff = cat1_max * (cat1_max - handicap)
gen cat1_minXdiff = cat1_min * (cat1_min - handicap)

foreach var of varlist hand_iXdiff cat1_maxXdiff cat1_minXdiff {
 areg scorerd handicap `var' first_year, $options 
 est store `var'
}


summ handicap if cat=="1a", det

local hand1 = r(p1)
local hand5 = r(p5)
local hand10 = r(p10)
local hand25 = r(p25)
local hand90 = r(p90)
local hand99 = r(p99)


gen cat1a_max = .
gen cat1a_min = . 
gen cat1a_top1 = .
gen cat1a_top5 = .
gen cat1a_top10 = .
gen cat1a_top25 = .
gen cat1a_bot10 = .
gen cat1a_bot1 = .

sort grouping_id handicap

by grouping_id: replace cat1a_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_max= cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_max = handicap[2] if _n == 1 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_max = handicap[1] if _n == 2 & _N == 2 & cat == "1a"

by grouping_id: replace cat1a_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_min = handicap[2] if _n == 1 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_min = handicap[1] if _n == 2 & _N == 2 & cat == "1a"

by grouping_id: replace cat1a_top1 = handicap[2] < `hand1' | handicap[3] < `hand1' if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top1 = handicap[1] < `hand1' | handicap[3] < `hand1' if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top1 = handicap[1] < `hand1' | handicap[2] < `hand1' if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top1 = handicap[1] < `hand1' if _n == 2 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_top1 = handicap[2] < `hand1' if _n == 1 & _N == 2 & cat == "1a"


by grouping_id: replace cat1a_top5 = handicap[2] < `hand5' | handicap[3] < `hand5' if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top5 = handicap[1] < `hand5' | handicap[3] < `hand5' if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top5 = handicap[1] < `hand5' | handicap[2] < `hand5' if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top5 = handicap[1] < `hand5' if _n == 2 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_top5 = handicap[2] < `hand5' if _n == 1 & _N == 2 & cat == "1a"

by grouping_id: replace cat1a_top10  = handicap[2] < `hand10' | handicap[3] < `hand10' if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top10  = handicap[1] < `hand10' | handicap[3] < `hand10' if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top10  = handicap[1] < `hand10' | handicap[2] < `hand10' if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top10  = handicap[1] < `hand10' if _n == 2 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_top10  = handicap[2] < `hand10' if _n == 1 & _N == 2 & cat == "1a"

by grouping_id: replace cat1a_top25 = handicap[2] < `hand25' | handicap[3] < `hand25' if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top25 = handicap[1] < `hand25' | handicap[3] < `hand25' if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top25 = handicap[1] < `hand25' | handicap[2] < `hand25' if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_top25 = handicap[2] < `hand25' if _n == 1 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_top25 = handicap[1] < `hand25' if _n == 2 & _N == 2 & cat == "1a"


by grouping_id: replace cat1a_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "1a"

by grouping_id: replace cat1a_bot1 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_bot1 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_bot1 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "1a"
by grouping_id: replace cat1a_bot1 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "1a"
by grouping_id: replace cat1a_bot1 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "1a"

foreach var of varlist cat1a_max cat1a_min cat1a_top1 cat1a_top5 cat1a_top10 cat1a_top25 cat1a_bot10 cat1a_bot1 {
 areg scorerd handicap first_year `var', $options 
 est store `var'
}

summ handicap if cat=="2", det

local hand1 = r(p1)
local hand5 = r(p5)
local hand10 = r(p10)
local hand25 = r(p25)
local hand90 = r(p90)
local hand99 = r(p99)


gen cat2_max = .
gen cat2_min = . 
gen cat2_top1 = .
gen cat2_top5 = .
gen cat2_top10 = .
gen cat2_top25 = .
gen cat2_bot10 = .
gen cat2_bot1 = .

sort grouping_id handicap

by grouping_id: replace cat2_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_max= cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_max = handicap[2] if _n == 1 & _N == 2 & cat == "2"
by grouping_id: replace cat2_max = handicap[1] if _n == 2 & _N == 2 & cat == "2"

by grouping_id: replace cat2_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_min = handicap[2] if _n == 1 & _N == 2 & cat == "2"
by grouping_id: replace cat2_min = handicap[1] if _n == 2 & _N == 2 & cat == "2"

by grouping_id: replace cat2_top1 = handicap[2] < `hand1' | handicap[3] < `hand1' if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top1 = handicap[1] < `hand1' | handicap[3] < `hand1' if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top1 = handicap[1] < `hand1' | handicap[2] < `hand1' if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top1 = handicap[1] < `hand1' if _n == 2 & _N == 2 & cat == "2"
by grouping_id: replace cat2_top1 = handicap[2] < `hand1' if _n == 1 & _N == 2 & cat == "2"


by grouping_id: replace cat2_top5 = handicap[2] < `hand5' | handicap[3] < `hand5' if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top5 = handicap[1] < `hand5' | handicap[3] < `hand5' if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top5 = handicap[1] < `hand5' | handicap[2] < `hand5' if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top5 = handicap[1] < `hand5' if _n == 2 & _N == 2 & cat == "2"
by grouping_id: replace cat2_top5 = handicap[2] < `hand5' if _n == 1 & _N == 2 & cat == "2"

by grouping_id: replace cat2_top10  = handicap[2] < `hand10' | handicap[3] < `hand10' if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top10  = handicap[1] < `hand10' | handicap[3] < `hand10' if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top10  = handicap[1] < `hand10' | handicap[2] < `hand10' if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top10  = handicap[1] < `hand10' if _n == 2 & _N == 2 & cat == "2"
by grouping_id: replace cat2_top10  = handicap[2] < `hand10' if _n == 1 & _N == 2 & cat == "2"

by grouping_id: replace cat2_top25 = handicap[2] < `hand25' | handicap[3] < `hand25' if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top25 = handicap[1] < `hand25' | handicap[3] < `hand25' if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top25 = handicap[1] < `hand25' | handicap[2] < `hand25' if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_top25 = handicap[2] < `hand25' if _n == 1 & _N == 2 & cat == "2"
by grouping_id: replace cat2_top25 = handicap[1] < `hand25' if _n == 2 & _N == 2 & cat == "2"


by grouping_id: replace cat2_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "2"
by grouping_id: replace cat2_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "2"

by grouping_id: replace cat2_bot1 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "2"
by grouping_id: replace cat2_bot1 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "2"
by grouping_id: replace cat2_bot1 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "2"
by grouping_id: replace cat2_bot1 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "2"
by grouping_id: replace cat2_bot1 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "2"

foreach var of varlist cat2_max cat2_min cat2_top1 cat2_top5 cat2_top10 cat2_top25 cat2_bot10 cat2_bot1 {
 areg scorerd handicap first_year `var', $options 
 est store `var'
}

summ handicap if cat=="3", det

local hand1 = r(p1)
local hand5 = r(p5)
local hand10 = r(p10)
local hand25 = r(p25)
local hand90 = r(p90)
local hand99 = r(p99)


gen cat3_max = .
gen cat3_min = . 
gen cat3_top1 = .
gen cat3_top5 = .
gen cat3_top10 = .
gen cat3_top25 = .
gen cat3_bot10 = .
gen cat3_bot1 = .

sort grouping_id handicap

by grouping_id: replace cat3_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_max= cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_max = handicap[2] if _n == 1 & _N == 2 & cat == "3"
by grouping_id: replace cat3_max = handicap[1] if _n == 2 & _N == 2 & cat == "3"

by grouping_id: replace cat3_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_min = handicap[2] if _n == 1 & _N == 2 & cat == "3"
by grouping_id: replace cat3_min = handicap[1] if _n == 2 & _N == 2 & cat == "3"

by grouping_id: replace cat3_top1 = handicap[2] < `hand1' | handicap[3] < `hand1' if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top1 = handicap[1] < `hand1' | handicap[3] < `hand1' if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top1 = handicap[1] < `hand1' | handicap[2] < `hand1' if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top1 = handicap[1] < `hand1' if _n == 2 & _N == 2 & cat == "3"
by grouping_id: replace cat3_top1 = handicap[2] < `hand1' if _n == 1 & _N == 2 & cat == "3"


by grouping_id: replace cat3_top5 = handicap[2] < `hand5' | handicap[3] < `hand5' if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top5 = handicap[1] < `hand5' | handicap[3] < `hand5' if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top5 = handicap[1] < `hand5' | handicap[2] < `hand5' if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top5 = handicap[1] < `hand5' if _n == 2 & _N == 2 & cat == "3"
by grouping_id: replace cat3_top5 = handicap[2] < `hand5' if _n == 1 & _N == 2 & cat == "3"

by grouping_id: replace cat3_top10  = handicap[2] < `hand10' | handicap[3] < `hand10' if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top10  = handicap[1] < `hand10' | handicap[3] < `hand10' if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top10  = handicap[1] < `hand10' | handicap[2] < `hand10' if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top10  = handicap[1] < `hand10' if _n == 2 & _N == 2 & cat == "3"
by grouping_id: replace cat3_top10  = handicap[2] < `hand10' if _n == 1 & _N == 2 & cat == "3"

by grouping_id: replace cat3_top25 = handicap[2] < `hand25' | handicap[3] < `hand25' if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top25 = handicap[1] < `hand25' | handicap[3] < `hand25' if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top25 = handicap[1] < `hand25' | handicap[2] < `hand25' if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_top25 = handicap[2] < `hand25' if _n == 1 & _N == 2 & cat == "3"
by grouping_id: replace cat3_top25 = handicap[1] < `hand25' if _n == 2 & _N == 2 & cat == "3"


by grouping_id: replace cat3_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "3"
by grouping_id: replace cat3_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "3"

by grouping_id: replace cat3_bot1 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3 & cat == "3"
by grouping_id: replace cat3_bot1 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 & cat == "3"
by grouping_id: replace cat3_bot1 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 & cat == "3"
by grouping_id: replace cat3_bot1 = (handicap[2] > `hand90') if _n == 1 & _N == 2 & cat == "3"
by grouping_id: replace cat3_bot1 = (handicap[1] > `hand90') if _n == 2 & _N == 2 & cat == "3"

foreach var of varlist cat3_max cat3_min cat3_top1 cat3_top5 cat3_top10 cat3_top25 cat3_bot10 cat3_bot1 {
 areg scorerd handicap first_year `var', $options 
 est store `var'
}

gen hand3_iXdiff  = hand_i * (hand_i - handicap)
gen cat3_maxXdiff = cat3_max * (cat3_max - handicap)
gen cat3_minXdiff = cat3_min * (cat3_min - handicap)

foreach var of varlist hand3_iXdiff cat3_maxXdiff cat3_minXdiff {
 areg scorerd handicap `var', $options 
 est store `var'
}

gen p_superstar = tigeringrp
gen superstar = istiger
by grouping_id: replace p_superstar = 1 if _n == 1 & (player[2] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen" ) | (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen")
by grouping_id: replace p_superstar = 1 if _n == 1 & (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen" ) | (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen")
by grouping_id: replace p_superstar = 1 if _n == 2 & (player[1] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen" ) | (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen")
by grouping_id: replace p_superstar = 1 if _n == 2 & (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen" ) | (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen")
by grouping_id: replace p_superstar = 1 if _n == 3 & (player[1] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen" ) | (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen")
by grouping_id: replace p_superstar = 1 if _n == 3 & (player[2] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen" ) | (player[3] == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen")
sort player
by player: replace superstar = 1 if player == "tiger woods" | player == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen"

gen psuperstarXfirst_year = p_superstar * first_year
*xi i.round

areg scorerd handicap p_superstar hand_i psuperstarXfirst_year, $options
areg scorerd handicap p_superstar score_i psuperstarXfirst_year, $options
areg scorerd handicap p_superstar psuperstarXfirst_year, $options



