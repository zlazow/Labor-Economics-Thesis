//Make Table 1
//Look at top players in each category. If there is only an effect in category 1 then that is b/c of television,etc.

global PATH "N:\Thesis\Data\"
set more off
clear
use ${PATH}backup.dta


//Capture terminates errors
sort cat
by cat: summ handicap, det
by cat: summ hand_i, det

/*
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
*/
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
local hand50 = r(p50)
local hand40 = r(p40)
local hand60 = r(p60)
local hand75 = r(p75)
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
gen cat1_top50 = .
gen cat1_bot25 = .
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

by grouping_id: replace cat1_top50 = handicap[2] < `hand60' & handicap[2] > `hand40' | handicap[3] < `hand60' & handicap[3] > `hand40' if _n == 1 & _N == 3
by grouping_id: replace cat1_top50 = handicap[1] < `hand60' & handicap[1] > `hand40' | handicap[3] < `hand60' & handicap[3] > `hand40' if _n == 2 & _N == 3
by grouping_id: replace cat1_top50 = handicap[1] < `hand60' & handicap[1] > `hand40' | handicap[2] < `hand60' & handicap[2] > `hand40' if _n == 3 & _N == 3
by grouping_id: replace cat1_top50 = handicap[2] < `hand60' & handicap[2] > `hand40' if _n == 1 & _N == 2
by grouping_id: replace cat1_top50 = handicap[1] < `hand60' & handicap[1] > `hand40' if _n == 2 & _N == 2

/*
by grouping_id: replace cat1_top50 = handicap[2] < `hand50' | handicap[3] < `hand50' if _n == 1 & _N == 3
by grouping_id: replace cat1_top50 = handicap[1] < `hand50' | handicap[3] < `hand50' if _n == 2 & _N == 3
by grouping_id: replace cat1_top50 = handicap[1] < `hand50' | handicap[2] < `hand50' if _n == 3 & _N == 3
by grouping_id: replace cat1_top50 = handicap[2] < `hand50' if _n == 1 & _N == 2
by grouping_id: replace cat1_top50 = handicap[1] < `hand50' if _n == 2 & _N == 2
*/
by grouping_id: replace cat1_bot25 = (handicap[2] > `hand75') | (handicap[3] > `hand75') if _n == 1 & _N == 3
by grouping_id: replace cat1_bot25 = (handicap[1] > `hand75') | (handicap[3] > `hand75') if _n == 2 & _N == 3
by grouping_id: replace cat1_bot25 = (handicap[2] > `hand75') | (handicap[1] > `hand75') if _n == 3 & _N == 3
by grouping_id: replace cat1_bot25 = (handicap[2] > `hand75') if _n == 1 & _N == 2 
by grouping_id: replace cat1_bot25 = (handicap[1] > `hand75') if _n == 2 & _N == 2

by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') | (handicap[3] > `hand90') if _n == 1 & _N == 3
by grouping_id: replace cat1_bot10 = (handicap[1] > `hand90') | (handicap[3] > `hand90') if _n == 2 & _N == 3
by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') | (handicap[1] > `hand90') if _n == 3 & _N == 3
by grouping_id: replace cat1_bot10 = (handicap[2] > `hand90') if _n == 1 & _N == 2 
by grouping_id: replace cat1_bot10 = (handicap[1] > `hand90') if _n == 2 & _N == 2

by grouping_id: replace cat1_bot1 = (handicap[2] > `hand99') | (handicap[3] > `hand99') if _n == 1 & _N == 3
by grouping_id: replace cat1_bot1 = (handicap[1] > `hand99') | (handicap[3] > `hand99') if _n == 2 & _N == 3 
by grouping_id: replace cat1_bot1 = (handicap[2] > `hand99') | (handicap[1] > `hand99') if _n == 3 & _N == 3 
by grouping_id: replace cat1_bot1 = (handicap[2] > `hand99') if _n == 1 & _N == 2
by grouping_id: replace cat1_bot1 = (handicap[1] > `hand99') if _n == 2 & _N == 2

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

/*
sort round tourn teegprd1
by round tourn: gen grp = teegprd1 - teegprd1[1]
gen grpSq = grp*grp
gen grpT = grp*grp*grp
summ grp, det


xi i.round i.tourn*grp
areg scorerd t_superstar drivdist drivdistXtsuperstar putts puttsXtsuperstar fairrd fairrdXtsuperstar  _I* [aw=wgt], $options
xi i.round i.tourn*grp i.tourn*grpSq i.tourn*grpT
areg scorerd handicap t_superstar drivdist putts puttsXtsuperstar fairrd fairrdXtsuperstar drivdistXtsuperstar _I* [aw=wgt], $options
*/
// gen sd(putts,greenrd,fairrd,drivdist)/mean(putts,greenrd,fairrd,drivdist) per round in a tournament

foreach v in scorerd putts greenrd fairrd drivdist{
	bysort tourn round: egen m_`v'= mean(`v')
	bysort tourn round: egen sd_`v' =sd(`v')
	gen cv_`v' = 100 * (m_`v'/sd_`v')
}
//areg cv_scorerd handicap t_superstar, robust cluster(grouping_id) absorb(tourncat)
gen supXcat1 = 0
replace supXcat1 = t_superstar if cat == "1"
gen supXcat1a = 0
replace supXcat1a = t_superstar if cat == "1a"
gen supXcat2 = 0
replace supXcat2 = t_superstar if cat == "2"
gen supXcat3 = 0
replace supXcat3 = t_superstar if cat == "3"

gen tsupXround2 = t_superstar * (round-1)

gen supXtop5 = t_superstar * cat1_top5
gen supXtop10 = t_superstar * cat1_top10
gen supXtop25 = t_superstar * cat1_top25
gen supXtop50 = t_superstar * cat1_top50
gen supXbot25 = t_superstar * cat1_bot25
gen supXbot10 = t_superstar * cat1_bot10

//round by round superstar effect
gen playerXyear = player * year
xi i.round
areg cv_drivdist handicap t_superstar tsupXround2 _I*, robust cluster(tourn) absorb(playerXyear)
areg cv_putts handicap t_superstar tsupXround2 _I*, robust cluster(tourn) absorb(playerXyear)
areg cv_greenrd handicap t_superstar tsupXround2 _I*, robust cluster(tourn) absorb(playerXyear)
areg cv_fairrd handicap t_superstar tsupXround2 _I*, robust cluster(tourn) absorb(playerXyear)
areg cv_scorerd handicap t_superstar tsupXround2 _I*, robust cluster(tourn) absorb(playerXyear)

//Superstar effect across categories and across rounds
areg cv_drivdist handicap t_superstar tsupXround2 _I* supXcat1 supXcat1a supXcat2 , robust cluster(grouping_id) absorb(tourn)  
areg cv_putts handicap t_superstar tsupXround2 _I* supXcat1 supXcat1a supXcat2 , robust cluster(grouping_id) absorb(tourn)
areg cv_greenrd handicap t_superstar tsupXround2 _I* supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)
areg cv_fairrd handicap t_superstar tsupXround2 _I* supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)
areg cv_scorerd handicap t_superstar tsupXround2 _I* supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)

//Superstar Effect across categories
areg cv_drivdist handicap supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)
areg cv_putts handicap supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)
areg cv_greenrd handicap supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)
areg cv_fairrd handicap supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)
areg cv_scorerd handicap supXcat1 supXcat1a supXcat2, robust cluster(grouping_id) absorb(tourn)

//top 5, 10, 25, fixed effects
areg cv_drivdist handicap supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10 , robust cluster(grouping_id) absorb(tourncat)
areg cv_putts handicap supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10 , robust cluster(grouping_id) absorb(tourncat)
areg cv_greenrd handicap supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10, robust cluster(grouping_id) absorb(tourncat)
areg cv_fairrd handicap supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10 , robust cluster(grouping_id) absorb(tourncat)
areg cv_scorerd handicap supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10, robust cluster(grouping_id) absorb(tourncat)

//top 5, 10, 25, 50, 75, 90 effects non-cv
areg scorerd handicap t_superstar supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10 , $options
areg putts handicap t_superstar supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10, $options
areg drivdist handicap t_superstar supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10, $options
areg greenrd handicap t_superstar supXtop5 supXtop10 supXtop25 supXtop50 supXbot25 supXbot10, $options


areg scorerd handicap t_superstar first_year, $options

gen tsupXpurse = t_superstar*purse
gen purse2 = purse *purse 

areg scorerd handicap t_superstar purse purse2 _I*, robust cluster(grouping_id) absorb(year)
areg scorerd handicap t_superstar purse purse2 tsupXpurse _I*, robust cluster(grouping_id) absorb(year)


gen pt_superstar = 0

replace pt_superstar = 	2	if tourn ==	"advil western open_2002"
replace pt_superstar = 	1	if tourn ==	"air canada championship_2002"
replace pt_superstar = 	1	if tourn ==	"b.c. open_2002"
replace pt_superstar = 	5	if tourn ==	"bay hill invitational_2002"
replace pt_superstar = 	1	if tourn ==	"bell canadian open_2002"
replace pt_superstar = 	2	if tourn ==	"bellsouth classic_2002"
replace pt_superstar = 	2	if tourn ==	"buick challenge_2002"
replace pt_superstar = 	1	if tourn ==	"buick classic_2002"
replace pt_superstar = 	2	if tourn ==	"buick invitational_2002"
replace pt_superstar = 	3	if tourn ==	"buick open_2002"
replace pt_superstar = 	1	if tourn ==	"canon greater hartford open_2002"
replace pt_superstar = 	1	if tourn ==	"compaq classic_2002"
replace pt_superstar = 	2	if tourn ==	"fedex st. jude classic_2002"
replace pt_superstar = 	3	if tourn ==	"genuity championship_2002"
replace pt_superstar = 	0	if tourn ==	"greater greensboro chrysler classic_2002"
replace pt_superstar = 	2	if tourn ==	"greater milwaukee open_2002"
replace pt_superstar = 	0	if tourn ==	"honda classic_2002"
replace pt_superstar = 	2	if tourn ==	"invensys classic at las vegas_2002"
replace pt_superstar = 	1	if tourn ==	"john deere classic_2002"
replace pt_superstar = 	1	if tourn ==	"kemper insurance open_2002"
replace pt_superstar = 	5	if tourn ==	"mastercard colonial_2002"
replace pt_superstar = 	4	if tourn ==	"memorial tournament_2002"
replace pt_superstar = 	3	if tourn ==	"michelob championship at kingsmill_2002"
replace pt_superstar = 	2	if tourn ==	"nec invitational_2002"
replace pt_superstar = 	4	if tourn ==	"nissan open_2002"
replace pt_superstar = 	1	if tourn ==	"phoenix open_2002"
replace pt_superstar = 	2	if tourn ==	"reno-tahoe open_2002"
replace pt_superstar = 	1	if tourn ==	"sei pennsylvania classic_2002"
replace pt_superstar = 	3	if tourn ==	"shell houston open_2002"
replace pt_superstar = 	1	if tourn ==	"sony open_2002"
replace pt_superstar = 	2	if tourn ==	"southern farm bureau classic_2002"
replace pt_superstar = 	2	if tourn ==	"tampa bay classic_2002"
replace pt_superstar = 	0	if tourn ==	"touchstone energy tucson open_2002"
replace pt_superstar = 	0	if tourn ==	"valero texas open_2002"
replace pt_superstar = 	3	if tourn ==	"verizon byron nelson classic_2002"
replace pt_superstar = 	1	if tourn ==	"worldcom classic_2002"
replace pt_superstar = 	4	if tourn ==	"84 lumber classic_2005"
replace pt_superstar = 	0	if tourn ==	"b.c. open_2005"
replace pt_superstar = 	3	if tourn ==	"bank of america colonial_2005"
replace pt_superstar = 	4	if tourn ==	"barclays classic_2005"
replace pt_superstar = 	3	if tourn ==	"bay hill invitational_2005"
replace pt_superstar = 	0	if tourn ==	"bell canadian open_2005"
replace pt_superstar = 	1	if tourn ==	"bellsouth classic_2005"
replace pt_superstar = 	4	if tourn ==	"booz allen classic_2005"
replace pt_superstar = 	1	if tourn ==	"buick championship_2005"
replace pt_superstar = 	1	if tourn ==	"mci heritage_2005"
replace pt_superstar = 	3	if tourn ==	"buick open_2005"
replace pt_superstar = 	4	if tourn ==	"chrysler championship_2005"
replace pt_superstar = 	4	if tourn ==	"chrysler classic of greensboro_2005"
replace pt_superstar = 	0	if tourn ==	"chrysler classic of tucson_2005"
replace pt_superstar = 	0	if tourn ==	"cialis western open_2005"
replace pt_superstar = 	2	if tourn ==	"deutsche bank championship_2005"
replace pt_superstar = 	1	if tourn ==	"fedex st. jude classic_2005"
replace pt_superstar = 	4	if tourn ==	"ford championship at doral_2005"
replace pt_superstar = 	2	if tourn ==	"honda classic_2005"
replace pt_superstar = 	0	if tourn ==	"john deere classic_2005"
replace pt_superstar = 	4	if tourn ==	"memorial tournament_2005"
replace pt_superstar = 	3	if tourn ==	"nissan open_2005"
replace pt_superstar = 	0	if tourn ==	"reno-tahoe open_2005"
replace pt_superstar = 	0	if tourn ==	"shell houston open_2005"
replace pt_superstar = 	0	if tourn ==	"sony open in hawaii_2005"
replace pt_superstar = 	0	if tourn ==	"u.s. bank championship in milwaukee_2005"
replace pt_superstar = 	6	if tourn ==	"wachovia championship_2005"
replace pt_superstar = 	1	if tourn ==	"zurich classic of new orleans_2005"
replace pt_superstar = 	3	if tourn ==	"bank of america colonial_2006"
replace pt_superstar = 	2	if tourn ==	"valero texas open_2005"
replace pt_superstar = 	3	if tourn ==	"barclays classic_2006"
replace pt_superstar = 	3	if tourn ==	"bay hill invitational_2006"
replace pt_superstar = 	1	if tourn ==	"bellsouth classic_2006"
replace pt_superstar = 	0	if tourn ==	"booz allen classic_2006"
replace pt_superstar = 	0	if tourn ==	"chrysler classic of tucson_2006"
replace pt_superstar = 	2	if tourn ==	"fedex st. jude classic_2006"
replace pt_superstar = 	1	if tourn ==	"ford championship at doral_2006"
replace pt_superstar = 	1	if tourn ==	"honda classic_2006"
replace pt_superstar = 	4	if tourn ==	"memorial tournament_2006"
replace pt_superstar = 	3	if tourn ==	"nissan open_2006"
replace pt_superstar = 	1	if tourn ==	"shell houston open_2006"
replace pt_superstar = 	1	if tourn ==	"sony open in hawaii_2006"
replace pt_superstar = 	1	if tourn ==	"verizon heritage_2006"
replace pt_superstar = 	5	if tourn ==	"wachovia championship_2006"
replace pt_superstar = 	4	if tourn ==	"zurich classic of new orleans_2006"

/*
foreach name in "phil mickelson","Len Mattiace", "Jim Furyk", "Bob Estes", "Chris Smith", "Tiger Woods"{
	replace pt_superstar = pt_superstar - 1	if player == `name' & tourn ==	"advil western open_2002" }
	*/
	
gen playerXyear = player * year
xi i.tourncat
areg scorerd t_superstar _I*, robust cluster(playerXyear) absorb(player)
