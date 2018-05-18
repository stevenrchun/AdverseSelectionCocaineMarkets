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


import delimited using "./data/agora-reviews.csv"
		



sort vendor

by vendor: egen numDrops = total(drop)

summ

// table numDrops, content(mean rating sum in_market mean payoff)
// sum rating age payoff in_market

capture log close
