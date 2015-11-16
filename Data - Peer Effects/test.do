clear
set mem 300m
set type double, permanently

use pga_data


sort teegprd1 round
by teegprd1 round: egen temp = sum(scorerd)
capture drop myN
by teegprd1 round: gen myN = _N
by teegprd1 round: gen temp_i = (temp - scorerd) / (myN - 1)

list teegprd1 round player scorerd score_i temp_i cat if abs(score_i - temp_i) >= 1e-6
assert(abs(score_i - temp_i) < 1e-6)

exit

summ handicap hand_i, det
exit

bys cat: summ handicap hand_i


sort teegprd1 round
by teegprd1 round: drop if cat[1] != cat[_N]

bys cat: summ handicap hand_i


