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

areg scorerd handicap hand_i t_superstar [aw=wgt], $options
areg scorerd handicap hand_i t_superstar p_superstar tsuperstarXfirst_year [aw=wgt], $options

gen drivdistXpsuperstar= p_superstar * drivdist
areg scorerd handicap p_superstar t_superstar drivdist drivdistXpsuperstar [aw=wgt], $options
