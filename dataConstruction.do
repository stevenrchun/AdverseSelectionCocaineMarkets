clear
cap clear matrix
set more off
set trace off


/* Name:
Steven Chun
*/

* change to your folder
cd "."
capture log close
log using "dataConstruction.log", replace


// Generate dummy for old variables
clear
import delimited using "./Dream-4-17-16.csv"

duplicates drop vendor_name, force

drop hash market_name item_link price name description image_link add_time ship_from v11

gen inMarket2016 = 1

save dream2016, replace

// Work on 2017 cocaine prices
clear

local shipVars ships_to_us ships_from_us ships_to_nl ///
	ships_from_nl ships_to_fr ships_from_fr ships_to_gb ///
	ships_from_gb ships_to_ca ships_from_ca ships_to_de ///
	ships_from_de ships_to_au ships_from_au ships_to_eu ///
	ships_from_eu ships_to_es ships_from_es ships_to_namerica ///
	ships_from_namerica ships_to_be ships_from_be ships_to_ww ///
	ships_from_ww ships_to_si ships_from_si ships_to_it ships_from_it ///
	ships_to_dk ships_from_dk ships_to_samerica ships_from_samerica ///
	ships_to_ch ships_from_ch ships_to_br ships_from_br ships_to_cz ///
	ships_from_cz ships_to_se ships_from_se ships_to_co ships_from_co ///
	ships_to_cn ships_from_cn ships_to_pl ships_from_pl ships_to_gr ///
	ships_from_gr 

local encodedShipVars shipsToUS shipsFromUS shipsToNL ///
	shipsFromNL shipsToFR shipsFromFR shipsToGB ///
	shipsFromGB shipsToCA shipsFromCA shipsToDE ///
	shipsFromDE shipsToAU shipsFromAU shipsToEU ///
	shipsFromEU shipsToES shipsFromES shipsToNAMERICA ///
	shipsFromNAMERICA shipsToBE shipsFromBE shipsToWW ///
	shipsFromWW shipsToSI shipsFromSI shipsToIT shipsFromIT ///
	shipsToDK shipsFromDK shipsToSAMERICA shipsFromSAMERICA ///
	shipsToCH shipsFromCH shipsToBR shipsFromBR shipsToCZ ///
	shipsFromCZ shipsToSE shipsFromSE shipsToCO shipsFromCO ///
	shipsToCN shipsFromCN shipsToPL shipsFromPL shipsToGR ///
	shipsFromGR

local n : word count `shipVars'

import delimited using "./data/dream_market_cocaine_listings.csv" 

forvalues i = 1/`n' {
    local a : word `i' of `shipVars'
    local b : word `i' of `encodedShipVars'
	di "`a' `b'"
	gen `b' = (`a' == "TRUE")
	//encode `a', generate(`b')
	drop `a'
}

//Fix prices!!
// 														1.5 then 1,5 then .5 then ,5 then 5
gen stringGrams = regexs(0) if(regexm(product_title, "[0-9]\.[0-9]+[ ]?[Gg]|[0-9]\,[0-9]+[ ]?[Gg]|\.[0-9]+[ ]?[Gg]|\,[0-9]+[ ]?[Gg]|\.?[0-9]+[ ]?[Gg]"))

gen stringKilos = regexs(0) if(regexm(product_title, "[0-9]\.[0-9]+[ ]?[Kk]|[0-9]\,[0-9]+[ ]?[Kk]|\.[0-9]+[ ]?[Kk]|\,[0-9]+[ ]?[Kk]|\.?[0-9]+[ ]?[Kk]"))

// destring periods and commas
destring stringGrams, ignore(" " "g" "G") generate(numGrams) force

destring stringGrams, ignore(" " "g" "G") dpcomma generate(numCommaGrams) force

// destring kils

destring stringKilos, ignore(" " "k" "K") generate(numKilos)

// set fixed Grams to the appropriate amoun
gen fixedGrams = numCommaGrams
replace fixedGrams = numGrams if (missing(fixedGrams))
replace fixedGrams = numKilos * 1000 if (missing(fixedGrams))

// recalculate btc prices
replace grams = fixedGrams
replace cost_per_gram = btc_price / fixedGrams
replace cost_per_gram_pure = btc_price / (fixedGrams *(quality / 100))

// From Coindex, average for the week the scraper was running.
local btcInDollars = 2284.165

// Convert to US dollars
gen usPrice = btc_price * `btcInDollars'
gen usPricePerGram = cost_per_gram * `btcInDollars'
gen usPricePerGramPure = cost_per_gram_pure * `btcInDollars'

// Generate flake dummy
gen flake = regexm(lower(product_title), "fish|scale|flake")

// Shipping dummies


// Generate logs
gen lnUSPricetPerGram = ln(usPricePerGram)
gen lnUSPricePerGramPure = ln(usPricePerGramPure)
gen lnSuccessfulTrans = ln(successful_transactions)
gen lnRating = ln(rating)

// Generate interactions
//gen escrowlnSuccessfulTrans = lnSuccessfulTrans * escrow
egen medianTransactions = median(successful_transactions)
gen youngVendor = successful_transactions < medianTransactions
gen escrowYoung = escrow*youngVendor
gen ratingYoung = rating*youngVendor



table escrow, content(mean rating sd rating mean cost_per_gram sd cost_per_gram mean cost_per_gram_pure)
// sum rating age payoff in_market

//drop unneeded variables
drop fixedGrams
drop numKilos
drop numCommaGrams
drop numGrams
drop stringGrams
drop stringKilos
drop medianTransactions

// Merge the datasets

merge m:1 vendor_name using dream2016.dta
drop if _merge == 2

replace inMarket2016 = 0 if (inMarket2016 == .)

save cocainePrices, replace








capture log close
