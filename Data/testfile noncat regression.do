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
summ purse, meanonly
replace purse = purse - r(mean)
summ log_purse, meanonly
replace log_purse = log_purse - r(mean)
assert handicap_c2 < .
gen wgt = 1 / (handicap_c2 / ntourn)
label variable wgt "Weight used in regressions; inverse of sampling error in player ability"
desc, full

preserve 
bys player year: keep if _n == 1
bys player year: assert(handicap[1] == handicap[_N])
summ handicap, det
local hand1 = r(p1)
local hand5 = r(p5)
local hand10 = r(p10)
local hand25 = r(p25)
local hand90 = r(p90)
local hand99 = r(p99)
restore 

gen cat1_max = .
gen cat1_scoremin = .
gen cat1_min = . 
gen cat1_top1 = .
gen cat1_top5 = .
gen cat1_top10 = .
gen cat1_top25 = .
gen cat1_bot10 = .
gen cat1_bot1 = .

sort grouping_id handicap

by grouping_id: replace cat1_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace cat1_max= cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3 
by grouping_id: replace cat1_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3 
by grouping_id: replace cat1_max = handicap[2] if _n == 1 & _N == 2 
by grouping_id: replace cat1_max = handicap[1] if _n == 2 & _N == 2

by grouping_id: replace cat1_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace cat1_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3
by grouping_id: replace cat1_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3 
by grouping_id: replace cat1_min = handicap[2] if _n == 1 & _N == 2 
by grouping_id: replace cat1_min = handicap[1] if _n == 2 & _N == 2 

by grouping_id: replace cat1_scoremin = cond(scorerd[2] < scorerd[3], scorerd[2], scorerd[3]) if _n == 1 & _N == 3
by grouping_id: replace cat1_scoremin = cond(scorerd[1] < scorerd[3], scorerd[1], scorerd[3]) if _n == 2 & _N == 3
by grouping_id: replace cat1_scoremin = cond(scorerd[1] < scorerd[2], scorerd[1], scorerd[2]) if _n == 3 & _N == 3 
by grouping_id: replace cat1_scoremin = scorerd[2] if _n == 1 & _N == 2 
by grouping_id: replace cat1_scoremin = scorerd[1] if _n == 2 & _N == 2 

by grouping_id: replace cat1_top1 = handicap[2] < `hand1' | handicap[3] < `hand1' if _n == 1 & _N == 3 
by grouping_id: replace cat1_top1 = handicap[1] < `hand1' | handicap[3] < `hand1' if _n == 2 & _N == 3
by grouping_id: replace cat1_top1 = handicap[1] < `hand1' | handicap[2] < `hand1' if _n == 3 & _N == 3 
by grouping_id: replace cat1_top1 = handicap[1] < `hand1' if _n == 2 & _N == 2 
by grouping_id: replace cat1_top1 = handicap[2] < `hand1' if _n == 1 & _N == 2 

by grouping_id: replace cat1_top5 = handicap[2] < `hand5' | handicap[3] < `hand5' if _n == 1 & _N == 3 
by grouping_id: replace cat1_top5 = handicap[1] < `hand5' | handicap[3] < `hand5' if _n == 2 & _N == 3 
by grouping_id: replace cat1_top5 = handicap[1] < `hand5' | handicap[2] < `hand5' if _n == 3 & _N == 3 
by grouping_id: replace cat1_top5 = handicap[1] < `hand5' if _n == 2 & _N == 2 
by grouping_id: replace cat1_top5 = handicap[2] < `hand5' if _n == 1 & _N == 2 

by grouping_id: replace cat1_top10  = handicap[2] < `hand10' | handicap[3] < `hand10' if _n == 1 & _N == 3 
by grouping_id: replace cat1_top10  = handicap[1] < `hand10' | handicap[3] < `hand10' if _n == 2 & _N == 3 
by grouping_id: replace cat1_top10  = handicap[1] < `hand10' | handicap[2] < `hand10' if _n == 3 & _N == 3
by grouping_id: replace cat1_top10  = handicap[1] < `hand10' if _n == 2 & _N == 2
by grouping_id: replace cat1_top10  = handicap[2] < `hand10' if _n == 1 & _N == 2

by grouping_id: replace cat1_top25 = handicap[2] < `hand25' | handicap[3] < `hand25' if _n == 1 & _N == 3
by grouping_id: replace cat1_top25 = handicap[1] < `hand25' | handicap[3] < `hand25' if _n == 2 & _N == 3
by grouping_id: replace cat1_top25 = handicap[1] < `hand25' | handicap[2] < `hand25' if _n == 3 & _N == 3
by grouping_id: replace cat1_top25 = handicap[2] < `hand25' if _n == 1 & _N == 2
by grouping_id: replace cat1_top25 = handicap[1] < `hand25' if _n == 2 & _N == 2


by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3
by grouping_id: replace cat1_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3
by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3
by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2 
by grouping_id: replace cat1_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2

by grouping_id: replace cat1_bot1 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3
by grouping_id: replace cat1_bot1 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3 
by grouping_id: replace cat1_bot1 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3 
by grouping_id: replace cat1_bot1 = (handicap[2] > `hand90') if _n == 1 & _N == 2
by grouping_id: replace cat1_bot1 = (handicap[1] > `hand90') if _n == 2 & _N == 2

gen tourncat = tourn + "_" + cat
global options = " robust cluster(grouping_id) absorb(tourncat) "
xi i.round

areg scorerd handicap hand_i _I* [aw=wgt], $options 
areg scorerd handicap score_i _I*[aw=wgt], $options 

foreach var of varlist cat1_max cat1_min cat1_scoremin cat1_top1 cat1_top5 cat1_top10 cat1_top25 cat1_bot10 cat1_bot1 {
 areg scorerd handicap _I* `var'  [aw=wgt], $options 
}


gen hand_iXdiff  = hand_i * (hand_i - handicap)
gen cat1_maxXdiff = cat1_max * (cat1_max - handicap)
gen cat1_minXdiff = cat1_min * (cat1_min - handicap)

foreach var of varlist hand_iXdiff cat1_maxXdiff cat1_minXdiff {
 areg scorerd handicap `var' _I* [aw=wgt], $options 
}


gen p_superstar = 0
gen superstar = istiger
sort grouping_id
by grouping_id: replace p_superstar = 1 if _n == 1 & ((player[2] == "tiger woods" | player[2] == "phil mickelson" | player[2] == "vijay singh" | player[2] == "ernie els" | player[2] == "retief goosen" ) | (player[3] == "tiger woods" | player[3] == "phil mickelson" | player[3] == "vijay singh" | player[3] == "ernie els" | player[3] == "retief goosen"))
by grouping_id: replace p_superstar = 1 if _n == 2 & ((player[1] == "tiger woods" | player[1] == "phil mickelson" | player[1] == "vijay singh" | player[1] == "ernie els" | player[1] == "retief goosen" ) | (player[3] == "tiger woods" | player[3] == "phil mickelson" | player[3] == "vijay singh" | player[3] == "ernie els" | player[3] == "retief goosen"))
by grouping_id: replace p_superstar = 1 if _n == 3 & ((player[2] == "tiger woods" | player[2] == "phil mickelson" | player[2] == "vijay singh" | player[2] == "ernie els" | player[2] == "retief goosen" ) | (player[1] == "tiger woods" | player[1] == "phil mickelson" | player[1] == "vijay singh" | player[1] == "ernie els" | player[1] == "retief goosen"))
sort player
by player: replace superstar = 1 if player == "tiger woods" | player == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen"
gen psuperstarXfirst_year = p_superstar * first_year

areg scorerd handicap p_superstar hand_i psuperstarXfirst_year [aw=wgt], $options
areg scorerd handicap p_superstar cat1_min psuperstarXfirst_year [aw=wgt], $options
areg scorerd handicap p_superstar cat1_scoremin psuperstarXfirst_year [aw=wgt], $options



/*
areg scorerd handicap hand_i putts putts_i greenrd greenrd_i[aw=wgt], $options

gen drivdistXpsuperstar= p_superstar * drivdist
areg scorerd handicap p_superstar psuperstarXfirst_year drivdist drivdistXpsuperstar [aw=wgt], $options

gen puttsXpsuperstar= p_superstar * putts
areg scorerd handicap p_superstar psuperstarXfirst_year putts puttsXpsuperstar [aw=wgt], $options

gen greenrdXpsuperstar= p_superstar * greenrd
areg scorerd handicap p_superstar psuperstarXfirst_year greenrd greenrdXpsuperstar [aw=wgt], $options

gen fairrdXpsuperstar = p_superstar *fairrd
areg scorerd handicap p_superstar psuperstarXfirst_year fairrd fairrdXpsuperstar [aw=wgt], $options
*/

gen t_superstar = 0
replace t_superstar = 2 if tourn == "84 lumber classic_2005"
replace t_superstar = 1 if tourn == "advil western open_2002"
replace t_superstar = 1 if tourn == "air canada championship_2002"
replace t_superstar = 1 if tourn == "bank of america colonial_2005"
replace t_superstar = 1 if tourn == "barclays classic_2005"
replace t_superstar = 2 if tourn == "barclays classic_2006"
replace t_superstar = 5 if tourn == "bay hill invitational_2002"
replace t_superstar = 4 if tourn == "bay hill invitational_2005"
replace t_superstar = 4 if tourn == "bay hill invitational_2006"
replace t_superstar = 1 if tourn == "bell canadian open_2005"
replace t_superstar = 1 if tourn == "bell canadian open_2002"
replace t_superstar = 3 if tourn == "bellsouth classic_2002"
replace t_superstar = 2 if tourn == "bellsouth classic_2005"
replace t_superstar = 2 if tourn == "bellsouth classic_2006"
replace t_superstar = 4 if tourn == "booz allen classic_2005"
replace t_superstar = 2 if tourn == "buick challenge_2002"
replace t_superstar = 4 if tourn == "buick classic_2002"
replace t_superstar = 3 if tourn == "buick invitational_2002"
replace t_superstar = 4 if tourn == "buick open_2002"
replace t_superstar = 2 if tourn == "buick open_2005"
replace t_superstar = 3 if tourn == "canon greater hartford open_2002"
replace t_superstar = 2 if tourn == "chrysler championship_2005"
replace t_superstar = 2 if tourn == "cialis western open_2005"
replace t_superstar = 2 if tourn == "compaq classic_2002"
replace t_superstar = 1 if tourn == "deutsche bank championship_2005"
replace t_superstar = 5 if tourn == "ford championship at doral_2005"
replace t_superstar = 4 if tourn == "ford championship at doral_2006"
replace t_superstar = 3 if tourn == "genuity championship_2002"
replace t_superstar = 2 if tourn == "honda classic_2002"
replace t_superstar = 1 if tourn == "honda classic_2005"
replace t_superstar = 2 if tourn == "mastercard colonial_2002"
replace t_superstar = 4 if tourn == "memorial tournament_2002"
replace t_superstar = 3 if tourn == "memorial tournament_2005"
replace t_superstar = 4 if tourn == "memorial tournament_2006"
replace t_superstar = 5 if tourn == "nec invitational_2002"
replace t_superstar = 1 if tourn == "nissan open_2002"
replace t_superstar = 1 if tourn == "nissan open_2005"
replace t_superstar = 2 if tourn == "nissan open_2006"
replace t_superstar = 2 if tourn == "phoenix open_2002"
replace t_superstar = 1 if tourn == "shell houston open_2002"
replace t_superstar = 1 if tourn == "shell houston open_2005"
replace t_superstar = 1 if tourn == "shell houston open_2006"
replace t_superstar = 3 if tourn == "sony open in hawaii_2005"
replace t_superstar = 1 if tourn == "sony open in hawaii_2006"
replace t_superstar = 4 if tourn == "verizon byron nelson classic_2002"
replace t_superstar = 1 if tourn == "verizon heritage_2006"
replace t_superstar = 3 if tourn == "wachovia championship_2005"
replace t_superstar = 4 if tourn == "wachovia championship_2006"
replace t_superstar = 2 if tourn == "worldcom classic_2002"
replace t_superstar = 1 if tourn == "zurich classic of new orleans_2005"
replace t_superstar = 2 if tourn == "zurich classic of new orleans_2006"

/*
replace t_superstar = 1 if tourn == "bay hill invitational_2002"
replace t_superstar = 1 if tourn == "bay hill invitational_2005"
replace t_superstar = 1 if tourn == "bay hill invitational_2006"
replace t_superstar = 1 if tourn == "buick invitational_2002"
replace t_superstar = 1 if tourn == "buick open_2002"
replace t_superstar = 1 if tourn == "buick open_2005"
replace t_superstar = 1 if tourn == "cialis western open_2005"
replace t_superstar = 1 if tourn == "deutsche bank championship_2005"
replace t_superstar = 1 if tourn == "ford championship at doral_2005"
replace t_superstar = 1 if tourn == "ford championship at doral_2006"
replace t_superstar = 1 if tourn == "genuity championship_2002"
replace t_superstar = 1 if tourn == "memorial tournament_2002"
replace t_superstar = 1 if tourn == "memorial tournament_2005"
replace t_superstar = 1 if tourn == "nec invitational_2002"
replace t_superstar = 1 if tourn == "nissan open_2005"
replace t_superstar = 1 if tourn == "nissan open_2006"
replace t_superstar = 1 if tourn == "verizon byron nelson classic_2002"
replace t_superstar = 1 if tourn == "wachovia championship_2005"
*/

bys player: replace t_superstar = t_superstar - 1 if superstar == 1

gen tsuperstarXfirst_year = t_superstar * first_year
gen tsuperstarXpurse = purse*t_superstar
gen tsuperstarXlogpurse = log_purse*t_superstar
areg scorerd handicap t_superstar p_superstar _I* [aw=wgt], $options
areg scorerd handicap t_superstar p_superstar tsuperstarXfirst_year _I* [aw=wgt], $options


gen drivdistXtsuperstar= t_superstar * drivdist
areg scorerd handicap drivdist drivdistXtsuperstar [aw=wgt], $options
gen greenrdXtsuperstar= t_superstar * greenrd
areg scorerd handicap greenrd greenrdXtsuperstar [aw=wgt], $options
gen puttsXtsuperstar= t_superstar * putts
areg scorerd handicap t_superstar putts puttsXtsuperstar [aw=wgt], $options
gen fairrdXtsuperstar= t_superstar * fairrd
areg scorerd handicap  fairrd fairrdXtsuperstar [aw=wgt], $options
areg scorerd handicap t_superstar putts puttsXtsuperstar fairrd fairrdXtsuperstar drivdist drivdistXtsuperstar [aw=wgt], $options

areg drivdist handicap t_superstar _I*, $options
areg putts handicap t_superstar _I*,$options
areg greenrd handicap t_superstar _I*, $options
areg fairrd handicap t_superstar _I*,  $options


sort round tourn teegprd1
by round tourn: gen grp = teegprd1 - teegprd1[1]
gen grpSq = grp*grp
gen grpT = grp*grp*grp
summ grp, det

/*
xi i.round i.tourn*grp
areg scorerd t_superstar drivdist drivdistXtsuperstar putts puttsXtsuperstar fairrd fairrdXtsuperstar  _I* [aw=wgt], $options
xi i.round i.tourn*grp i.tourn*grpSq i.tourn*grpT
areg scorerd handicap t_superstar drivdist putts puttsXtsuperstar fairrd fairrdXtsuperstar drivdistXtsuperstar _I* [aw=wgt], $options
*/
