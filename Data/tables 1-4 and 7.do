global PATH "N:\Thesis\Data\"
set more off
clear
//use ${PATH}backup.dta
import excel "N:\Thesis\Data\pgaData.xlsx", sheet("Sheet1") firstrow

//Capture terminates errors
sort cat
by cat: summ handicap, det
by cat: summ hand_i, det

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
local hand75 = r(p75)
local hand80 = r(p80)
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

gen top10 = 0
gen top10_25 = 0
gen top25_50 = 0
gen mid50_75 = 0
gen bot75_90 = 0
gen bot90_100 = 0

replace top10 = 1 if handicap <= `hand10'
replace top10_25 = 1 if ((handicap > `hand10') & (handicap <= `hand25'))
replace top25_50 = 1 if ((handicap > `hand25') & (handicap <= `hand50'))
replace mid50_75 = 1 if ((handicap > `hand50') & (handicap <= `hand75'))
replace bot75_90 = 1 if ((handicap > `hand75') & (handicap <= `hand90'))
replace bot90_100 = 1 if (handicap > `hand90')

//drop if cat == "1a"
//drop if cat == "2"
//drop if cat == "3"

sort grouping_id handicap

by grouping_id: replace cat1_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace cat1_max = cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3 
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

by grouping_id: replace cat1_top50 = handicap[2] < `hand50' | handicap[3] < `hand50' if _n == 1 & _N == 3
by grouping_id: replace cat1_top50 = handicap[1] < `hand50' | handicap[3] < `hand50' if _n == 2 & _N == 3
by grouping_id: replace cat1_top50 = handicap[1] < `hand50' | handicap[2] < `hand50' if _n == 3 & _N == 3
by grouping_id: replace cat1_top50 = handicap[2] < `hand50' if _n == 1 & _N == 2
by grouping_id: replace cat1_top50 = handicap[1] < `hand50' if _n == 2 & _N == 2

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
//areg scorerd handicap hand_i _I* [aw=wgt], $options 

/*foreach var of varlist cat1_max cat1_min cat1_scoremin cat1_top1 cat1_top5 cat1_top10 cat1_top25 cat1_bot10 cat1_bot1 {
 areg scorerd handicap _I* `var'  [aw=wgt], $options 
}


gen hand_iXdiff  = hand_i * (hand_i - handicap)


foreach var of varlist hand_iXdiff cat1_maxXdiff cat1_minXdiff {
 areg scorerd handicap `var' _I* [aw=wgt], $options 
}
*/

gen cat1_maxXdiff = cat1_max * (cat1_max - handicap)

gen p_superstar = 0
gen superstar = istiger

sort grouping_id
by grouping_id: replace p_superstar = 1 if _n == 1 & ((player[2] == "tiger woods" | player[2] == "phil mickelson" | player[2] == "vijay singh" | player[2] == "ernie els" | player[2] == "retief goosen" ) | (player[3] == "tiger woods" | player[3] == "phil mickelson" | player[3] == "vijay singh" | player[3] == "ernie els" | player[3] == "retief goosen"))
by grouping_id: replace p_superstar = 1 if _n == 2 & ((player[1] == "tiger woods" | player[1] == "phil mickelson" | player[1] == "vijay singh" | player[1] == "ernie els" | player[1] == "retief goosen" ) | (player[3] == "tiger woods" | player[3] == "phil mickelson" | player[3] == "vijay singh" | player[3] == "ernie els" | player[3] == "retief goosen"))
by grouping_id: replace p_superstar = 1 if _n == 3 & ((player[2] == "tiger woods" | player[2] == "phil mickelson" | player[2] == "vijay singh" | player[2] == "ernie els" | player[2] == "retief goosen" ) | (player[1] == "tiger woods" | player[1] == "phil mickelson" | player[1] == "vijay singh" | player[1] == "ernie els" | player[1] == "retief goosen"))
sort player
by player: replace superstar = 1 if player == "tiger woods" | player == "phil mickelson" | player == "vijay singh" | player == "ernie els" | player == "retief goosen"

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

/* Tiger Woods Only 
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
gen tsuperstarXhandi = handicap*t_superstar

//Table 2
areg scorerd handicap p_superstar [aw=wgt], $options
areg scorerd handicap cat1_maxXdiff if p_superstar ==1, $options 
areg scorerd handicap p_superstar hand_i

//Table 3
areg scorerd handicap t_superstar p_superstar _I* [aw=wgt], $options
areg scorerd handicap t_superstar p_superstar tsuperstarXhandi _I* [aw=wgt], $options



gen supXcat1 = 0
replace supXcat1 = t_superstar if cat == "1"
gen supXcat1a = 0
replace supXcat1a = t_superstar if cat == "1a"
gen supXcat2 = 0
replace supXcat2 = t_superstar if cat == "2"
gen supXcat3 = 0
replace supXcat3 = t_superstar if cat == "3"

//Table 4
areg scorerd handicap t_superstar supXcat1 _I* [aw=wgt], robust cluster(grouping_id) absorb(tourn)
areg scorerd handicap t_superstar supXcat1a _I* [aw=wgt], robust cluster(grouping_id) absorb(tourn)
areg scorerd handicap t_superstar supXcat2 _I* [aw=wgt], robust cluster(grouping_id) absorb(tourn)
areg scorerd handicap t_superstar supXcat3 _I* [aw=wgt], robust cluster(grouping_id) absorb(tourn)

gen ptf_superstar = 0

replace ptf_superstar = 	0	if tourn ==	"advil western open_2002"
replace ptf_superstar = 	1	if tourn ==	"air canada championship_2002"
replace ptf_superstar = 	1	if tourn ==	"b.c. open_2002"
replace ptf_superstar = 	4	if tourn ==	"bay hill invitational_2002"
replace ptf_superstar = 	1	if tourn ==	"bell canadian open_2002"
replace ptf_superstar = 	1	if tourn ==	"bellsouth classic_2002"
replace ptf_superstar = 	2	if tourn ==	"buick challenge_2002"
replace ptf_superstar = 	1	if tourn ==	"buick classic_2002"
replace ptf_superstar = 	1	if tourn ==	"buick invitational_2002"
replace ptf_superstar = 	3	if tourn ==	"buick open_2002"
replace ptf_superstar = 	1	if tourn ==	"canon greater hartford open_2002"
replace ptf_superstar = 	1	if tourn ==	"compaq classic_2002"
replace ptf_superstar = 	2	if tourn ==	"fedex st. jude classic_2002"
replace ptf_superstar = 	2	if tourn ==	"genuity championship_2002"
replace ptf_superstar = 	0	if tourn ==	"greater greensboro chrysler classic_2002"
replace ptf_superstar = 	2	if tourn ==	"greater milwaukee open_2002"
replace ptf_superstar = 	0	if tourn ==	"honda classic_2002"
replace ptf_superstar = 	2	if tourn ==	"invensys classic at las vegas_2002"
replace ptf_superstar = 	1	if tourn ==	"john deere classic_2002"
replace ptf_superstar = 	1	if tourn ==	"kemper insurance open_2002"
replace ptf_superstar = 	3.5	if tourn ==	"mastercard colonial_2002"
replace ptf_superstar = 	4	if tourn ==	"memorial tournament_2002"
replace ptf_superstar = 	3	if tourn ==	"michelob championship at kingsmill_2002"
replace ptf_superstar = 	1	if tourn ==	"nec invitational_2002"
replace ptf_superstar = 	5	if tourn ==	"nissan open_2002"
replace ptf_superstar = 	0	if tourn ==	"phoenix open_2002"
replace ptf_superstar = 	2	if tourn ==	"reno-tahoe open_2002"
replace ptf_superstar = 	1	if tourn ==	"sei pennsylvania classic_2002"
replace ptf_superstar = 	2	if tourn ==	"shell houston open_2002"
replace ptf_superstar = 	1	if tourn ==	"sony open_2002"
replace ptf_superstar = 	2	if tourn ==	"southern farm bureau classic_2002"
replace ptf_superstar = 	2	if tourn ==	"tampa bay classic_2002"
replace ptf_superstar = 	1	if tourn ==	"touchstone energy tucson open_2002"
replace ptf_superstar = 	1	if tourn ==	"valero texas open_2002"
replace ptf_superstar = 	3	if tourn ==	"verizon byron nelson classic_2002"
replace ptf_superstar = 	1	if tourn ==	"worldcom classic_2002"
replace ptf_superstar = 	3	if tourn ==	"84 lumber classic_2005"
replace ptf_superstar = 	0	if tourn ==	"b.c. open_2005"
replace ptf_superstar = 	2	if tourn ==	"bank of america colonial_2005"
replace ptf_superstar = 	4	if tourn ==	"barclays classic_2005"
replace ptf_superstar = 	2	if tourn ==	"bay hill invitational_2005"
replace ptf_superstar = 	0	if tourn ==	"bell canadian open_2005"
replace ptf_superstar = 	1	if tourn ==	"bellsouth classic_2005"
replace ptf_superstar = 	3	if tourn ==	"booz allen classic_2005"
replace ptf_superstar = 	0	if tourn ==	"buick championship_2005"
replace ptf_superstar = 	1	if tourn ==	"mci heritage_2005"
replace ptf_superstar = 	2	if tourn ==	"buick open_2005"
replace ptf_superstar = 	3	if tourn ==	"chrysler championship_2005"
replace ptf_superstar = 	3	if tourn ==	"chrysler classic of greensboro_2005"
replace ptf_superstar = 	0	if tourn ==	"chrysler classic of tucson_2005"
replace ptf_superstar = 	0	if tourn ==	"cialis western open_2005"
replace ptf_superstar = 	2	if tourn ==	"deutsche bank championship_2005"
replace ptf_superstar = 	1	if tourn ==	"fedex st. jude classic_2005"
replace ptf_superstar = 	3	if tourn ==	"ford championship at doral_2005"
replace ptf_superstar = 	2	if tourn ==	"honda classic_2005"
replace ptf_superstar = 	0	if tourn ==	"john deere classic_2005"
replace ptf_superstar = 	3	if tourn ==	"memorial tournament_2005"
replace ptf_superstar = 	2	if tourn ==	"nissan open_2005"
replace ptf_superstar = 	0	if tourn ==	"reno-tahoe open_2005"
replace ptf_superstar = 	0	if tourn ==	"shell houston open_2005"
replace ptf_superstar = 	0	if tourn ==	"sony open in hawaii_2005"
replace ptf_superstar = 	1	if tourn ==	"u.s. bank championship in milwaukee_2005"
replace ptf_superstar = 	2	if tourn ==	"wachovia championship_2005"
replace ptf_superstar = 	0	if tourn ==	"zurich classic of new orleans_2005"
replace ptf_superstar = 	3	if tourn ==	"bank of america colonial_2006"
replace ptf_superstar = 	2	if tourn ==	"valero texas open_2005"
replace ptf_superstar = 	3	if tourn ==	"barclays classic_2006"
replace ptf_superstar = 	2	if tourn ==	"bay hill invitational_2006"
replace ptf_superstar = 	1	if tourn ==	"bellsouth classic_2006"
replace ptf_superstar = 	0	if tourn ==	"booz allen classic_2006"
replace ptf_superstar = 	0	if tourn ==	"chrysler classic of tucson_2006"
replace ptf_superstar = 	2	if tourn ==	"fedex st. jude classic_2006"
replace ptf_superstar = 	0	if tourn ==	"ford championship at doral_2006"
replace ptf_superstar = 	1	if tourn ==	"honda classic_2006"
replace ptf_superstar = 	4	if tourn ==	"memorial tournament_2006"
replace ptf_superstar = 	2	if tourn ==	"nissan open_2006"
replace ptf_superstar = 	1	if tourn ==	"shell houston open_2006"
replace ptf_superstar = 	1	if tourn ==	"sony open in hawaii_2006"
replace ptf_superstar = 	1	if tourn ==	"verizon heritage_2006"
replace ptf_superstar = 	4	if tourn ==	"wachovia championship_2006"
replace ptf_superstar = 	3	if tourn ==	"zurich classic of new orleans_2006"

bys player tourn: replace ptf_superstar = ptf_superstar - 1 if pt_superstar == 1
drop if superstar == 1

//Table 7
areg scorerd handicap ptf_superstar _I*, $options


