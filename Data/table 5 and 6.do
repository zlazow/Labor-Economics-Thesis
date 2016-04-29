collapse (mean) scorerd handicap t_superstar supXcat1 supXcat2 supXcat3 supXcat1a  (sd) sd_scorerd=scorerd, by(tourn round cat)

gen cv_scorerd = (sd_scorerd/scorerd)

xi i.round
//Table 5
areg sd_scorerd handicap t_superstar _I*, robust cluster(cat) absorb(tourn)
//Table 6
areg sd_scorerd handicap t_superstar supXcat1, robust cluster(cat) absorb(tourn)
areg sd_scorerd handicap t_superstar supXcat1a, robust cluster(cat) absorb(tourn)
areg sd_scorerd handicap t_superstar supXcat2, robust cluster(cat) absorb(tourn)
areg sd_scorerd handicap t_superstar supXcat3, robust cluster(cat) absorb(tourn)
