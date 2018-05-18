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
log using "regressions.log", replace

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
	
local shipsToVars shipsToUS shipsToNL ///
	shipsToFR shipsToGB ///
	shipsToCA shipsToDE ///
	shipsToAU shipsToEU ///
	shipsToES shipsToNAMERICA ///
	shipsToBE shipsToWW ///
	shipsToSI shipsToIT ///
	shipsToDK shipsToSAMERICA ///
	shipsToCH shipsToBR shipsToCZ ///
	shipsToSE shipsToCO ///
	shipsToCN shipsToPL shipsToGR ///
	
	
local shipsFromVars shipsFromUS ///
	shipsFromNL shipsFromFR ///
	shipsFromGB shipsFromCA ///
	shipsFromDE shipsFromAU ///
	shipsFromEU shipsFromES ///
	shipsFromNAMERICA shipsFromBE ///
	shipsFromWW shipsFromSI shipsFromIT ///
	shipsFromDK shipsFromSAMERICA ///
	shipsFromCH shipsFromBR ///
	shipsFromCZ shipsFromSE shipsFromCO ///
	shipsFromCN shipsFromPL ///
	shipsFromGR
	
	
use cocainePrices


reg lnUSPricePerGramPure escrow 

reg lnUSPricePerGramPure escrow successful_trans

reg lnUSPricePerGramPure escrow lnSuccessfulTrans

reg lnUSPricePerGramPure escrow lnSuccessfulTrans flake

// Older vendors charge ten percent more at a significant level
reg lnUSPricePerGramPure escrow lnSuccessfulTrans flake inMarket2016

reg lnUSPricePerGramPure escrow lnSuccessfulTrans flake inMarket2016

reg lnUSPricePerGramPure escrow lnSuccessfulTrans flake inMarket2016 shipsFromAU shipsFromFR

areg lnUSPricePerGramPure escrow lnSuccessfulTrans flake inMarket2016 shipsFromAU shipsFromFR, absorb(vendor_name)

//reg lnUSPricePerGramPure escrow lnSuccessfulTrans flake escrowYoung ratingYoung youngVendor rating






capture log close
