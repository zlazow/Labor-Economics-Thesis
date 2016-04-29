gen ptfsupXcat1 = 0
replace ptfsupXcat1 = ptf_superstar if cat == "1"
gen ptfsupXcat1a = 0
replace ptfsupXcat1a = ptf_superstar if cat == "1a"
gen ptfsupXcat2 = 0
replace ptfsupXcat2 = ptf_superstar if cat == "2"
gen ptfsupXcat3 = 0
replace ptfsupXcat3 = ptf_superstar if cat == "3"


collapse (mean) scorerd handicap ptf_superstar ptfsupXcat1 ptfsupXcat2 ptfsupXcat3 ptfsupXcat1a  (sd) sd_scorerd=scorerd, by(tourn round cat)
gen cv_scorerd = (sd_scorerd/scorerd)

gen pftsupXround2 = ptf_superstar * (round-1)

xi i.round
//Table 7
areg sd_scorerd handicap ptf_superstar _I*, robust cluster(cat) absorb(tourn)
//Table 8
areg sd_scorerd handicap ptf_superstar ptfsupXcat1  , robust cluster(cat) absorb(tourn)
areg sd_scorerd handicap ptf_superstar ptfsupXcat1a , robust cluster(cat) absorb(tourn)
areg sd_scorerd handicap ptf_superstar ptfsupXcat2 , robust cluster(cat) absorb(tourn)
areg sd_scorerd handicap ptf_superstar ptfsupXcat3 , robust cluster(cat) absorb(tourn)
