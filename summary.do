clear
cap clear matrix
set more off


/* Name:
Steven Chun
*/

* change to your folder
cd "."
capture log close
log using "developerSurvey.log", replace


import delimited using "./data/agora-balanced-daily.csv"
		

gen drop = (rating - rating[_n - 1]) < 0

sort vendor

by vendor: egen numDrops = total(drop)

summ vendor rating sales age payoff max_age drop numDrops

table numDrops, content(mean rating sum in_market mean payoff)
sum rating age payoff in_market

*table Gender, content(mean Salary mean js mean java)

capture log close
