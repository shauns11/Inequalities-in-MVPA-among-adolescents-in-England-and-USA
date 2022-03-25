*********************************************************************************
*Income-based inequalities in self-reported moderate-to-vigorous physical activity 
*among adolescents in England and the USA: a cross-sectional study
*BMJ Open 2021;11:e040540
***********************************************************************************

*-----------.
* 2007-08.
*-------------

import sasxport5 "N:\NHANES\BMX_E.XPT", clear
keep seqn bmxbmi bmxht bmxwt 
save "N:\Temp\Temp1.dta", replace

import sasxport5 "N:\NHANES\PAQ_E.XPT", clear
sort seqn
keep seqn paq605 paq610 pad615 paq620 paq625 pad630 paq635 paq640 pad645 paq650 paq655 pad660 paq665 paq670 pad675 
save "N:\Temp\Temp2.dta", replace

import sasxport5 "N:\NHANES\SMQ_E.XPT", clear
sort seqn
keep seqn smq620
label define smokelbl 1 "Yes" 2 "No" 
label values smq620 smokelbl

gen smoke=-1
replace smoke=0 if inlist(smq620,2)
replace smoke=1 if inlist(smq620,1)
label drop smokelbl
label define smokelbl 0 "never smoked" 1 "ever smoked"
label values smoke smokelbl
save "N:\Temp\Temp3.dta", replace

* Demographics.
import sasxport5 "N:\NHANES\DEMO_E.XPT", clear
label variable seqn "Respondent sequence number"
sort seqn
count
keep if inrange(ridageyr,12,19)

* ratio of family income to poverty.
generate familySES=-1
replace familySES=1 if inrange(indfmpir,0,0.99)
replace familySES=2 if inrange(indfmpir,1,1.99)
replace familySES=3 if inrange(indfmpir,2,2.99)
replace familySES=4 if inrange(indfmpir,3,3.99)
replace familySES=5 if inrange(indfmpir,4,1000)
label define SESlbl 1 "Lowest" 2 "2nd" 3 "3rd" 4 "4th" 5 "Highest"
label values familySES SESlbl
rename riagendr sex
rename ridageyr age

merge 1:1 seqn using "N:\Temp\Temp1.dta"
keep if _merge==1|_merge==3
drop _merge
merge 1:1 seqn using "N:\Temp\Temp2.dta"
keep if _merge==1|_merge==3
drop _merge
count                             /* N = 1316  */
merge 1:1 seqn using "N:\Temp\Temp3.dta"
keep if _merge==1|_merge==3
drop _merge
count                             

egen zbmius = zanthro(bmxbmi,ba,US), xvar(ridageex) gender(sex) gencode(male=1, female=2) ageunit(month)
generate bmdbmic=.
replace bmdbmic=1 if zbmius < (-1.645)
replace bmdbmic=2 if inrange(zbmius, -1.64, 1.036)
replace bmdbmic=3 if inrange(zbmius, 1.037, 1.644)
replace bmdbmic=4 if inrange(zbmius,1.645,4.0)

*--------------------------------------------.
* Vigorous work: (days * minutes).
*--------------------------------------------.

generate VigWorkTime=-1
replace VigWorkTime=0 if (paq605==2)
replace VigWorkTime=(paq610 * pad615) if (paq605==1) & inrange(paq610,1,7) & inrange(pad615,10,1080)
label variable VigWorkTime "Vigorous (Min/week)"
mvdecode VigWorkTime,mv(-1)

*--------------------------------------------.
* Moderate work: (days * minutes).
*--------------------------------------------.

mvdecode paq625,mv(99)
generate ModWorkTime=-1
replace ModWorkTime=0 if (paq620==2)
replace ModWorkTime=(paq625 * pad630) if (paq620==1) & inrange(paq625,1,7) & inrange(pad630,10,1440)
label variable ModWorkTime "Moderate (Min/week)"
mvdecode ModWorkTime,mv(-1)

*-------------------------.
* Transportation.
*----------------------.

mvdecode pad645,mv(9999)
generate TravelTime=-1
replace TravelTime=0 if (paq635==2)
replace TravelTime=(paq640 * pad645) if (paq635==1) & inrange(paq640,1,7) & inrange(pad645,10,960)
label variable TravelTime "Walking/bicycling (Min/week)"
mvdecode TravelTime,mv(-1)

*------------------------.
** Vigorous recreational.
*-------------------------.

mvdecode pad660,mv(9999)
generate VigSportsTime=-1
replace VigSportsTime=0 if (paq650==2)
replace VigSportsTime=(paq655 * pad660) if (paq650==1) & inrange(paq655,1,7) & inrange(pad660,10,990)
label variable VigSportsTime "Vigorous recreational (Min/week)"
mvdecode VigSportsTime,mv(-1)

*-------------------------.
* Moderate (recreational).
*--------------------------.

mvdecode pad675,mv(9999)

generate ModSportsTime=-1
replace ModSportsTime=0 if (paq665==2)
replace ModSportsTime=(paq670 * pad675) if (paq665==1) & inrange(paq670,1,7) & inrange(pad675,10,900)
label variable ModSportsTime "Moderate recreational (Min/week)"
mvdecode ModSportsTime,mv(-1)

* Summary (N = 1232).

generate base=0
replace base=1 if (VigWorkTime!=.) & (ModWorkTime!=.) & (TravelTime!=.) & (VigSportsTime!=.) & (ModSportsTime!=.)

*sum the items (but do not count vigorous as double)
generate mvpa = (VigWorkTime) + (ModWorkTime) + (TravelTime) + (VigSportsTime) + (ModSportsTime)  if base==1
generate work = (VigWorkTime) + (ModWorkTime) 
generate sports = (VigSportsTime) + (ModSportsTime) 

generate indfmpir2 = -2
replace indfmpir2=1 if inrange(indfmpir,0,1.29)
replace indfmpir2=2 if inrange(indfmpir,1.30000,3.4999)
replace indfmpir2=3 if inrange(indfmpir,3.50000,5)

*compile all the datasets for 12-19 year-olds.
generate year="2007-08"
keep sex age year base VigWorkTime ModWorkTime TravelTime VigSportsTime ModSportsTime mvpa work sports wtmec2yr sdmvpsu sdmvstra indfmpir2 bmdbmic ridreth1 smoke
save "N:\Temp\NHANES2007-08.dta", replace

*-------------.
* 2009-10.
*--------------.

import sasxport5 "N:\NHANES\BMX_F.XPT", clear
keep seqn bmxbmi bmxht bmxwt
save "N:\Temp\Temp1.dta", replace

* PA(2009-10).
import sasxport5 "N:\NHANES\PAQ_F.XPT", clear
sort seqn
keep seqn paq605 paq610 pad615 paq620 paq625 pad630 paq635 paq640 pad645 paq650 paq655 pad660 paq665 paq670 pad675 
save "N:\Temp\Temp2.dta", replace

*Smoke(2009-10).
import sasxport5 "N:\NHANES\SMQ_F.XPT", clear
sort seqn
keep seqn smq620
label define smokelbl 1 "Yes" 2 "No" 
label values smq620 smokelbl
gen smoke=-1
replace smoke=0 if inlist(smq620,2)
replace smoke=1 if inlist(smq620,1)
label drop smokelbl
label define smokelbl 0 "never smoked" 1 "ever smoked"
label values smoke smokelbl
save "N:\Temp\Temp3.dta", replace

* Demographics.
import sasxport5 "N:\NHANES\DEMO_F.XPT", clear
label variable seqn "Respondent sequence number"
sort seqn
keep if inrange(ridageyr,12,19)

* ratio of family income to poverty.
generate familySES=-1
replace familySES=1 if inrange(indfmpir,0,0.99)
replace familySES=2 if inrange(indfmpir,1,1.99)
replace familySES=3 if inrange(indfmpir,2,2.99)
replace familySES=4 if inrange(indfmpir,3,3.99)
replace familySES=5 if inrange(indfmpir,4,1000)

label define SESlbl 1 "Lowest" 2 "2nd" 3 "3rd" 4 "4th" 5 "Highest"
label values familySES SESlbl
rename riagendr sex
rename ridageyr age
merge 1:1 seqn using "N:\Temp\Temp1.dta"
keep if _merge==1|_merge==3
drop _merge
merge 1:1 seqn using "N:\Temp\Temp2.dta"
keep if _merge==1|_merge==3
drop _merge
merge 1:1 seqn using "N:\Temp\Temp3.dta"
keep if _merge==1|_merge==3
drop _merge
egen zbmius = zanthro(bmxbmi,ba,US), xvar(ridageex) gender(sex) gencode(male=1, female=2) ageunit(month)
generate bmdbmic=.
replace bmdbmic=1 if zbmius < (-1.645)
replace bmdbmic=2 if inrange(zbmius, -1.64, 1.036)
replace bmdbmic=3 if inrange(zbmius, 1.037, 1.644)
replace bmdbmic=4 if inrange(zbmius,1.645,4.0)

*--------------------------------------------.
* Vigorous work: (days * minutes).
*--------------------------------------------.
mvdecode paq605,mv(9)
mvdecode pad615,mv(9999)

generate VigWorkTime=-1
replace VigWorkTime=0 if (paq605==2)
replace VigWorkTime=(paq610 * pad615) if (paq605==1) & inrange(paq610,1,7) & inrange(pad615,10,1080)
label variable VigWorkTime "Vigorous (Min/week)"
mvdecode VigWorkTime,mv(-1)

*--------------------------------------------.
* Moderate work: (days * minutes).
*--------------------------------------------.

mvdecode paq620,mv(9)
mvdecode pad630,mv(9999)

generate ModWorkTime=-1
replace ModWorkTime=0 if (paq620==2)
replace ModWorkTime=(paq625 * pad630) if (paq620==1) & inrange(paq625,1,7) & inrange(pad630,10,1440)
label variable ModWorkTime "Moderate (Min/week)"
mvdecode ModWorkTime,mv(-1)

*-------------------------.
* Transportation.
*----------------------.

mvdecode paq635,mv(9)
mvdecode pad645,mv(9999)

generate TravelTime=-1
replace TravelTime=0 if (paq635==2)
replace TravelTime=(paq640 * pad645) if (paq635==1) & inrange(paq640,1,7) & inrange(pad645,10,960)
label variable TravelTime "Walking/bicycling (Min/week)"
mvdecode TravelTime,mv(-1)

*------------------------.
** Vigorous recreational.
*-------------------------.
mvdecode paq650,mv(9)
mvdecode pad660,mv(9999)

generate VigSportsTime=-1
replace VigSportsTime=0 if (paq650==2)
replace VigSportsTime=(paq655 * pad660) if (paq650==1) & inrange(paq655,1,7) & inrange(pad660,10,990)
label variable VigSportsTime "Vigorous recreational (Min/week)"
mvdecode VigSportsTime,mv(-1)

*-------------------------.
* Moderate (recreational).
*--------------------------.

mvdecode paq665,mv(9)
mvdecode paq670,mv(99)
mvdecode pad675,mv(9999)

generate ModSportsTime=-1
replace ModSportsTime=0 if (paq665==2)
replace ModSportsTime=(paq670 * pad675) if (paq665==1) & inrange(paq670,1,7) & inrange(pad675,10,900)
label variable ModSportsTime "Moderate recreational (Min/week)"
mvdecode ModSportsTime,mv(-1)

* Summary (N = 1232).
generate base=0
replace base=1 if (VigWorkTime!=.) & (ModWorkTime!=.) & (TravelTime!=.) & (VigSportsTime!=.) & (ModSportsTime!=.)

* sum the items (but do not count vigorous as double)

generate mvpa = (VigWorkTime) + (ModWorkTime) + (TravelTime) + (VigSportsTime) + (ModSportsTime)  if base==1
generate work = (VigWorkTime) + (ModWorkTime) 
generate sports = (VigSportsTime) + (ModSportsTime) 

generate indfmpir2 = -2
replace indfmpir2=1 if inrange(indfmpir,0,1.29)
replace indfmpir2=2 if inrange(indfmpir,1.30000,3.4999)
replace indfmpir2=3 if inrange(indfmpir,3.50000,5)

* compile all the datasets for 12-19 year-olds.

generate year="2009-10"
keep sex age year base VigWorkTime ModWorkTime TravelTime VigSportsTime ModSportsTime mvpa work sports wtmec2yr sdmvpsu sdmvstra indfmpir2 bmdbmic ridreth1 smoke
save "N:\Temp\NHANES2009-10.dta", replace

*---------------.
* 2011-12.
*---------------.

import sasxport5 "N:\NHANES\BMX_G.XPT", clear
keep seqn bmxbmi bmxht bmxwt bmdbmic 
save "N:\Temp\Temp1.dta", replace

* PA(2011-12).
import sasxport5 "N:\NHANES\PAQ_G.XPT", clear
sort seqn
keep seqn paq605 paq610 pad615 paq620 paq625 pad630 paq635 paq640 pad645 paq650 paq655 pad660 paq665 paq670 pad675 
save "N:\Temp\Temp2.dta", replace

*smoke(2011-12).
import sasxport5 "N:\NHANES\SMQ_G.XPT", clear
sort seqn
keep seqn smq621
label define smokelbl ///
1 "I have never smoked, not even a puff" ///
2 "1 or more puffs, but never a whole cigarette" ///
3 "1 cigarette" ///
4 "2 to 5" ///
5 "6 to 15" ///
6 "16 to 25" ///
7 "26 to 99" ///
8 "100+" ///
77 "Refused" ///
99 "Don't know"
label values smq621 smokelbl
gen smoke=-1
replace smoke=0 if inlist(smq621,1,2)
replace smoke=1 if inlist(smq621,3,4,5,6,7,8)
label drop smokelbl
label define smokelbl 0 "never smoked" 1 "ever smoked"
label values smoke smokelbl
save "N:\Temp\Temp3.dta", replace


* Demographics.
import sasxport5 "N:\NHANES\DEMO_G.XPT", clear
label variable seqn "Respondent sequence number"
sort seqn
keep if inrange(ridageyr,12,19)

* ratio of family income to poverty.
generate familySES=-1
replace familySES=1 if inrange(indfmpir,0,0.99)
replace familySES=2 if inrange(indfmpir,1,1.99)
replace familySES=3 if inrange(indfmpir,2,2.99)
replace familySES=4 if inrange(indfmpir,3,3.99)
replace familySES=5 if inrange(indfmpir,4,1000)

label define SESlbl 1 "Lowest" 2 "2nd" 3 "3rd" 4 "4th" 5 "Highest"
label values familySES SESlbl
rename riagendr sex
rename ridageyr age

merge 1:1 seqn using "N:\Temp\Temp1.dta"
keep if _merge==1|_merge==3
drop _merge

merge 1:1 seqn using "N:\Temp\Temp2.dta"
keep if _merge==1|_merge==3
drop _merge

merge 1:1 seqn using "N:\Temp\Temp3.dta"
keep if _merge==1|_merge==3
drop _merge

*--------------------------------------------.
* Vigorous work: (days * minutes).
*--------------------------------------------.

generate VigWorkTime=-1
replace VigWorkTime=0 if (paq605==2)
replace VigWorkTime=(paq610 * pad615) if (paq605==1) & inrange(paq610,1,7) & inrange(pad615,10,1080)
label variable VigWorkTime "Vigorous (Min/week)"
mvdecode VigWorkTime,mv(-1)

*--------------------------------------------.
* Moderate work: (days * minutes).
*--------------------------------------------.

generate ModWorkTime=-1
replace ModWorkTime=0 if (paq620==2)
replace ModWorkTime=(paq625 * pad630) if (paq620==1) & inrange(paq625,1,7) & inrange(pad630,10,1440)
label variable ModWorkTime "Moderate (Min/week)"
mvdecode ModWorkTime,mv(-1)

*-------------------------.
* Transportation.
*----------------------.

generate TravelTime=-1
replace TravelTime=0 if (paq635==2)
replace TravelTime=(paq640 * pad645) if (paq635==1) & inrange(paq640,1,7) & inrange(pad645,10,960)
label variable TravelTime "Walking/bicycling (Min/week)"
mvdecode TravelTime,mv(-1)

*------------------------.
** Vigorous recreational.
*-------------------------.

mvdecode paq650,mv(9)
generate VigSportsTime=-1
replace VigSportsTime=0 if (paq650==2)
replace VigSportsTime=(paq655 * pad660) if (paq650==1) & inrange(paq655,1,7) & inrange(pad660,10,990)
label variable VigSportsTime "Vigorous recreational (Min/week)"
mvdecode VigSportsTime,mv(-1)

*-------------------------.
* Moderate (recreational).
*--------------------------.

generate ModSportsTime=-1
replace ModSportsTime=0 if (paq665==2)
replace ModSportsTime=(paq670 * pad675) if (paq665==1) & inrange(paq670,1,7) & inrange(pad675,10,900)
label variable ModSportsTime "Moderate recreational (Min/week)"
mvdecode ModSportsTime,mv(-1)

generate base=0
replace base=1 if (VigWorkTime!=.) & (ModWorkTime!=.) & (TravelTime!=.) & (VigSportsTime!=.) & (ModSportsTime!=.)

* sum the items (but do not count vigorous as double)
generate mvpa = (VigWorkTime) + (ModWorkTime) + (TravelTime) + (VigSportsTime) + (ModSportsTime)  if base==1
generate work = (VigWorkTime) + (ModWorkTime) 
generate sports = (VigSportsTime) + (ModSportsTime) 

generate indfmpir2 = -2
replace indfmpir2=1 if inrange(indfmpir,0,1.29)
replace indfmpir2=2 if inrange(indfmpir,1.30000,3.4999)
replace indfmpir2=3 if inrange(indfmpir,3.50000,5)

* compile all the datasets for 12-19 year-olds.
generate year="2011-12"
keep sex age year base VigWorkTime ModWorkTime TravelTime VigSportsTime ModSportsTime mvpa work sports wtmec2yr sdmvpsu sdmvstra indfmpir2 bmdbmic ridreth1 smoke
save "N:\Temp\NHANES2011-12.dta", replace

*---------.
*2013-14.
*----------.

import sasxport5 "N:\NHANES\BMX_H.XPT", clear
keep seqn bmxbmi bmxht bmxwt bmdbmic 
save "N:\Temp\Temp1.dta", replace

* PA(2013-14).
import sasxport5 "N:\NHANES\PAQ_H.XPT", clear
sort seqn
keep seqn paq605 paq610 pad615 paq620 paq625 pad630 paq635 paq640 pad645 paq650 paq655 pad660 paq665 paq670 pad675 
save "N:\Temp\Temp2.dta", replace

*Smoke(2013-14).
import sasxport5 "N:\NHANES\SMQ_H.XPT", clear
sort seqn
keep seqn smq621
label define smokelbl ///
1 "I have never smoked, not even a puff" ///
2 "1 or more puffs, but never a whole cigarette" ///
3 "1 cigarette" ///
4 "2 to 5" ///
5 "6 to 15" ///
6 "16 to 25" ///
7 "26 to 99" ///
8 "100+" ///
77 "Refused" ///
99 "Don't know"
label values smq621 smokelbl
gen smoke=-1
replace smoke=0 if inlist(smq621,1,2)
replace smoke=1 if inlist(smq621,3,4,5,6,7,8)
label drop smokelbl
label define smokelbl 0 "never smoked" 1 "ever smoked"
label values smoke smokelbl
save "N:\Temp\Temp3.dta", replace

* Demographics.
import sasxport5 "N:\NHANES\DEMO_H.XPT", clear
label variable seqn "Respondent sequence number"
sort seqn
keep if inrange(ridageyr,12,19)

* ratio of family income to poverty.
generate familySES=-1
replace familySES=1 if inrange(indfmpir,0,0.99)
replace familySES=2 if inrange(indfmpir,1,1.99)
replace familySES=3 if inrange(indfmpir,2,2.99)
replace familySES=4 if inrange(indfmpir,3,3.99)
replace familySES=5 if inrange(indfmpir,4,1000)

label define SESlbl 1 "Lowest" 2 "2nd" 3 "3rd" 4 "4th" 5 "Highest"
label values familySES SESlbl
rename riagendr sex
rename ridageyr age

merge 1:1 seqn using "N:\Temp\Temp1.dta"
keep if _merge==1|_merge==3
drop _merge

merge 1:1 seqn using "N:\Temp\Temp2.dta"
keep if _merge==1|_merge==3
drop _merge
count                             

merge 1:1 seqn using "N:\Temp\Temp3.dta"
keep if _merge==1|_merge==3
drop _merge
count                             

*--------------------------------------------.
* Vigorous work: (days * minutes).
*--------------------------------------------.

mvdecode paq610,mv(99)

generate VigWorkTime=-1
replace VigWorkTime=0 if (paq605==2)
replace VigWorkTime=(paq610 * pad615) if (paq605==1) & inrange(paq610,1,7) & inrange(pad615,10,1080)
label variable VigWorkTime "Vigorous (Min/week)"
mvdecode VigWorkTime,mv(-1)

*--------------------------------------------.
* Moderate work: (days * minutes).
*--------------------------------------------.

mvdecode paq625,mv(99)
mvdecode pad630,mv(9999)

generate ModWorkTime=-1
replace ModWorkTime=0 if (paq620==2)
replace ModWorkTime=(paq625 * pad630) if (paq620==1) & inrange(paq625,1,7) & inrange(pad630,10,1440)
label variable ModWorkTime "Moderate (Min/week)"
mvdecode ModWorkTime,mv(-1)

*-------------------------.
* Transportation.
*----------------------.

mvdecode paq635,mv(9)
generate TravelTime=-1
replace TravelTime=0 if (paq635==2)
replace TravelTime=(paq640 * pad645) if (paq635==1) & inrange(paq640,1,7) & inrange(pad645,10,960)
label variable TravelTime "Walking/bicycling (Min/week)"
mvdecode TravelTime,mv(-1)

*------------------------.
** Vigorous recreational.
*-------------------------.

mvdecode paq650,mv(9)
mvdecode paq655,mv(99)
mvdecode pad660,mv(9999)

generate VigSportsTime=-1
replace VigSportsTime=0 if (paq650==2)
replace VigSportsTime=(paq655 * pad660) if (paq650==1) & inrange(paq655,1,7) & inrange(pad660,10,990)
label variable VigSportsTime "Vigorous recreational (Min/week)"
mvdecode VigSportsTime,mv(-1)

*-------------------------.
* Moderate (recreational).
*--------------------------.

mvdecode paq665,mv(9)
mvdecode paq670,mv(99)

generate ModSportsTime=-1
replace ModSportsTime=0 if (paq665==2)
replace ModSportsTime=(paq670 * pad675) if (paq665==1) & inrange(paq670,1,7) & inrange(pad675,10,900)
label variable ModSportsTime "Moderate recreational (Min/week)"

mvdecode ModSportsTime,mv(-1)

generate base=0
replace base=1 if (VigWorkTime!=.) & (ModWorkTime!=.) & (TravelTime!=.) & (VigSportsTime!=.) & (ModSportsTime!=.)
* sum the items (but do not count vigorous as double)

generate mvpa = (VigWorkTime) + (ModWorkTime) + (TravelTime) + (VigSportsTime) + (ModSportsTime)  if base==1
generate work = (VigWorkTime) + (ModWorkTime) 
generate sports = (VigSportsTime) + (ModSportsTime) 

generate indfmpir2 = -2
replace indfmpir2=1 if inrange(indfmpir,0,1.29)
replace indfmpir2=2 if inrange(indfmpir,1.30000,3.4999)
replace indfmpir2=3 if inrange(indfmpir,3.50000,5)

* compile all the datasets for 12-19 year-olds.
generate year="2013-14"
keep sex age year base VigWorkTime ModWorkTime TravelTime VigSportsTime ModSportsTime mvpa work sports wtmec2yr sdmvpsu sdmvstra indfmpir2 bmdbmic ridreth1 smoke
save "N:\Temp\NHANES2013-14.dta", replace

***************.
* 2015-16.
****************.

* BMI(2015-16).
import sasxport5 "N:\NHANES\BMX_I.XPT", clear
keep seqn bmxbmi bmxht bmxwt bmdbmic 
save "N:\Temp\Temp1.dta", replace

* PA(2015-16).
import sasxport5 "N:\NHANES\PAQ_I.XPT", clear
sort seqn
keep seqn paq605 paq610 pad615 paq620 paq625 pad630 paq635 paq640 pad645 paq650 paq655 pad660 paq665 paq670 pad675 
save "N:\Temp\Temp2.dta", replace

*Smoke (2015-16).
import sasxport5 "N:\NHANES\SMQ_I.XPT", clear
sort seqn
keep seqn smq621
label define smokelbl ///
1 "I have never smoked, not even a puff" ///
2 "1 or more puffs, but never a whole cigarette" ///
3 "1 cigarette" ///
4 "2 to 5" ///
5 "6 to 15" ///
6 "16 to 25" ///
7 "26 to 99" ///
8 "100+" ///
77 "Refused" ///
99 "Don't know"
label values smq621 smokelbl
gen smoke=-1
replace smoke=0 if inlist(smq621,1,2)
replace smoke=1 if inlist(smq621,3,4,5,6,7,8)
label drop smokelbl
label define smokelbl 0 "never smoked" 1 "ever smoked"
label values smoke smokelbl
save "N:\Temp\Temp3.dta", replace

* Demographics.
import sasxport5 "N:\NHANES\DEMO_I.XPT", clear
label variable seqn "Respondent sequence number"
sort seqn
keep if inrange(ridageyr,12,19)

* ratio of family income to poverty.
generate familySES=-1
replace familySES=1 if inrange(indfmpir,0,0.99)
replace familySES=2 if inrange(indfmpir,1,1.99)
replace familySES=3 if inrange(indfmpir,2,2.99)
replace familySES=4 if inrange(indfmpir,3,3.99)
replace familySES=5 if inrange(indfmpir,4,1000)

label define SESlbl 1 "Lowest" 2 "2nd" 3 "3rd" 4 "4th" 5 "Highest"
label values familySES SESlbl
rename riagendr sex
rename ridageyr age

merge 1:1 seqn using "N:\Temp\Temp1.dta"
keep if _merge==1|_merge==3
drop _merge
merge 1:1 seqn using "N:\Temp\Temp2.dta"
keep if _merge==1|_merge==3
drop _merge
merge 1:1 seqn using "N:\Temp\Temp3.dta"
keep if _merge==1|_merge==3
drop _merge

*--------------------------------------------.
* Vigorous work: (days * minutes).
*--------------------------------------------.

mvdecode paq605,mv(7,9)
mvdecode paq610,mv(77,99)
mvdecode pad615,mv(7777,9999)

generate VigWorkTime=-1
replace VigWorkTime=0 if (paq605==2)
replace VigWorkTime=(paq610 * pad615) if (paq605==1) & inrange(paq610,1,7) & inrange(pad615,10,1080)
label variable VigWorkTime "Vigorous (Min/week)"
mvdecode VigWorkTime,mv(-1)

*--------------------------------------------.
* Moderate work: (days * minutes).
*--------------------------------------------.

mvdecode paq620,mv(7,9)
mvdecode paq625,mv(77,99)
mvdecode pad630,mv(7777,9999)

generate ModWorkTime=-1
replace ModWorkTime=0 if (paq620==2)
replace ModWorkTime=(paq625 * pad630) if (paq620==1) & inrange(paq625,1,7) & inrange(pad630,10,1440)
label variable ModWorkTime "Moderate (Min/week)"

mvdecode ModWorkTime,mv(-1)

*-------------------------.
* Transportation.
*----------------------.

mvdecode paq635,mv(7,9)
mvdecode paq640,mv(77,99)
mvdecode pad645,mv(7777,9999)

generate TravelTime=-1
replace TravelTime=0 if (paq635==2)
replace TravelTime=(paq640 * pad645) if (paq635==1) & inrange(paq640,1,7) & inrange(pad645,10,960)
label variable TravelTime "Walking/bicycling (Min/week)"

mvdecode TravelTime,mv(-1)

*------------------------.
** Vigorous recreational.
*-------------------------.

mvdecode paq650,mv(7,9)
mvdecode paq655,mv(77,99)
mvdecode pad660,mv(7777,9999)

generate VigSportsTime=-1
replace VigSportsTime=0 if (paq650==2)
replace VigSportsTime=(paq655 * pad660) if (paq650==1) & inrange(paq655,1,7) & inrange(pad660,10,990)
label variable VigSportsTime "Vigorous recreational (Min/week)"

mvdecode VigSportsTime,mv(-1)

*-------------------------.
* Moderate (recreational).
*--------------------------.

mvdecode paq665,mv(7,9)
mvdecode paq670,mv(77,99)
mvdecode pad675,mv(7777,9999)

generate ModSportsTime=-1
replace ModSportsTime=0 if (paq665==2)
replace ModSportsTime=(paq670 * pad675) if (paq665==1) & inrange(paq670,1,7) & inrange(pad675,10,900)
label variable ModSportsTime "Moderate recreational (Min/week)"

mvdecode ModSportsTime,mv(-1)

*Summary
generate base=0
replace base=1 if (VigWorkTime!=.) & (ModWorkTime!=.) & (TravelTime!=.) & (VigSportsTime!=.) & (ModSportsTime!=.)

*sum the items (but do not count vigorous as double)
generate mvpa = (VigWorkTime) + (ModWorkTime) + (TravelTime) + (VigSportsTime) + (ModSportsTime)  if base==1
generate work = (VigWorkTime) + (ModWorkTime) 
generate sports = (VigSportsTime) + (ModSportsTime) 

generate indfmpir2 = -2
replace indfmpir2=1 if inrange(indfmpir,0,1.29)
replace indfmpir2=2 if inrange(indfmpir,1.30000,3.4999)
replace indfmpir2=3 if inrange(indfmpir,3.50000,5)

*compile all the datasets for 12-19 year-olds.
generate year="2015-16"
keep sex age year base VigWorkTime ModWorkTime TravelTime VigSportsTime ModSportsTime mvpa work sports wtmec2yr sdmvpsu sdmvstra indfmpir2 bmdbmic ridreth1 ridexprg smoke
save "N:\Temp\NHANES2015-16.dta", replace

*Analysis dataset.

clear
use "N:\Temp\NHANES2007-08.dta"
append using "N:\Temp\NHANES2009-10.dta"
append using "N:\Temp\NHANES2011-12.dta"
append using "N:\Temp\NHANES2013-14.dta"
append using "N:\Temp\NHANES2015-16.dta"
generate year2=0
replace year2=1 if year=="2007-08"
replace year2=2 if year=="2009-10"
replace year2=3 if year=="2011-12"
replace year2=4 if year=="2013-14"
replace year2=5 if year=="2015-16"

*==================.
*12-17 year olds.
*===================.

keep if inrange(age,12,17)
keep if wtmec2yr>0
save "N:\Temp\NHANES_PA_dataset.dta", replace

use "N:\Temp\NHANES_PA_dataset.dta", clear
generate male=0
generate female=0
replace male=1 if sex==1
replace female=1 if sex==2

*4929.

*In the United States, 4705 adolescents aged 12-17 had valid PA data. Of these, 393 had missing income data and
*were excluded from our complete-case analysis, leaving an analytical sample of 4312 adolescents.

generate flag=0
replace flag=1 if (base==1) & inlist(indfmpir2,1,2,3)
tab1 flag

*Exclude (617); Include (4312)
*Analyse missing data.

gen age2=1 if inrange(age,12,15)
replace age2=2 if inrange(age,16,17)
label define age2lbl 1 "12-15" 2 "16-17"
label values age2 age2lbl

*Race/ethnicity.

tab ridreth1
generate ETHNIC = 0
replace ETHNIC = 2 if ridreth1==1
replace ETHNIC = 1 if ridreth1==3
replace ETHNIC = 3 if ridreth1==4
replace ETHNIC = 4 if ridreth1==2|ridreth1==5
label define ethniclbl 1 "Non-Hispanic White" 2 "Mexican American"  3 "Non-Hispanic Black" 4 "Other race"
label values ETHNIC ethniclbl

*by ethnicity.
gen ethnic2=0
replace ethnic2=1 if ETHNIC==1
replace ethnic2=3 if ETHNIC==2
replace ethnic2=2 if ETHNIC==3
replace ethnic2=4 if ETHNIC==4
label define ethnic2lbl 1 "Non-Hispanic White"  2 "Non-Hispanic Black" 3 "Mexican American" 4 "Other race"
label values ethnic2 ethnic2lbl
tab ethnic2


*******************
*Table S2.
*******************

tab sex flag, missing 
tab age2 flag, missing
tab ethnic2 flag, missing
tab bmdbmic flag, missing
tab smoke flag, missing

svyset [pweight=wtmec2yr], psu(sdmvpsu) strata(sdmvstra)
svy: tab sex flag, col per format(%9.0f)
svy: tab age2 flag, col per format(%9.0f)
svy: tab ethnic2 flag, col per format(%9.0f)

mvencode bmdbmic, mv(9)
svy: tab bmdbmic flag, col per format(%9.0f)
svy: tab bmdbmic flag if inlist(bmdbmic,1,2,3,4), col per format(%9.0f)

svy: tab smoke flag, col per format(%9.0f)
svy: tab smoke flag if inlist(smoke,0,1), col per format(%9.0f)

*********************
** analytical sample
** Table 1 (N=4705)
*********************

keep if base==1

drop age2
gen age2=0 if inrange(age,12,15)
replace age2=1 if inrange(age,16,17)

tab sex indfmpir2
tab age2 indfmpir2 if sex==1
tab age2 indfmpir2 if sex==2
tab ethnic2 indfmpir2 if sex==1
tab ethnic2 indfmpir2 if sex==2

preserve
keep if inrange(bmdbmic,2,4)
tab bmdbmic indfmpir2 if sex==1
tab bmdbmic indfmpir2 if sex==2
restore

svy,subpop(male): tab age2, col obs 
svy,subpop(male): tab ethnic2, col obs
svy,subpop(male): tab bmdbmic if inrange(bmdbmic,2,4), col obs

svy,subpop(female): tab age2, col obs 
svy,subpop(female): tab ethnic2, col obs
svy,subpop(female): tab bmdbmic if inrange(bmdbmic,2,4), col obs

svy,subpop(male): tab age2 indfmpir2, col  missing             
svy,subpop(female): tab age2 indfmpir2, col missing

svy,subpop(male): tab ethnic2 indfmpir2, col  missing             
svy,subpop(female): tab ethnic2 indfmpir2, col missing



*****************************
*** Hurdle models ***********
*****************************

generate a = sex==1 & inrange(bmdbmic,2,4) & inrange(indfmpir2,1,3)
generate b = sex==2 & inrange(bmdbmic,2,4) & inrange(indfmpir2,1,3)
tab1 a b

svy,subpop(a): tab bmdbmic indfmpir2 if inrange(bmdbmic,2,4) & inrange(indfmpir2,1,3), col missing
svy,subpop(b): tab bmdbmic indfmpir2 if inrange(bmdbmic,2,4) & inrange(indfmpir2,1,3), col missing



*Truncation.
*101 OF 4312 (2.3%).

preserve
keep if inrange(indfmpir2,1,3)
summ mvpa
summ mvpa if mvpa>=2400
restore

replace mvpa = 2400 if mvpa>=2400       /* truncate */
replace sports = 2400 if sports>=2400       /* truncate */
replace work = 2400 if work>=2400       /* truncate */
replace TravelTime = 2400 if TravelTime>=2400       /* truncate*/

*now per-day.
foreach var of varlist mvpa sports work TravelTime {
replace `var' = `var'/7
}

*100 and 67 min/day (boys & girls).
svy:mean mvpa, over(sex)

*Graph the distributions.
*label define sexlbl 1 "Boys" 2 "Girls"
*label values sex sexlbl
preserve
histogram mvpa,ylabel(0 0.05 0.1 0.15,ang(hor) nogrid) fraction discrete  color(black)  ///
xtitle("Minutes/day spent in moderate-to-vigorous intensity physical activity") ytitle("Proportion") ///
note("") by(sex,title("",pos(11)) graphregion(color(white)) bgcolor(white) note("")) ///
xlabel(0(60)360)
restore

mvdecode indfmpir2,mv(-2)

*********************************
*exclusion of those underweight.
*********************************

keep if inrange(bmdbmic,2,4) 

*MVPA (total: recreational, work, transport).
svy,subpop(male): churdle exponential mvpa i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins,dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any*/                    																					
margins,dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Unconditional */                  
margins,dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Conditional */

svy,subpop(female): churdle exponential mvpa i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins,dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)    /*Any*/                       																		
margins,dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)     /*Unconditional*/                                   													
margins,dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)    /*Conditional */ 

*MVPA (recreational).
svy,subpop(male): churdle exponential sports i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any */                       																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Unconditional */                                													
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Conditional */

svy,subpop(female): churdle exponential sports i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)   /* Any */                      																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)     /* Unconditional */                               													
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1) /* Conditional */

*MVPA (work).
svy,subpop(male): churdle exponential work i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any */                      																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)         /* Unconditional */                        														
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Conditional */

svy,subpop(female): churdle exponential work i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any */                      																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Unconditional */                                													
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1) /* Conditional */

*MVPA (transport).
svy,subpop(male): churdle exponential TravelTime i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)                      																					
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)                                 																			
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  

svy,subpop(female): churdle exponential TravelTime i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)                      																					
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)                                 																			
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)

*---------------------.
*Avoid the truncation.
*Table S4.
*---------------------.

use "N:\Temp\NHANES_PA_dataset.dta", clear
generate male=0
generate female=0
replace male=1 if sex==1
replace female=1 if sex==2

gen age2=1 if inrange(age,12,15)
replace age2=2 if inrange(age,16,17)
label define age2lbl 1 "12-15" 2 "16-17"
label values age2 age2lbl

*Race/ethnicity.
tab ridreth1
generate ETHNIC = 0
replace ETHNIC = 2 if ridreth1==1
replace ETHNIC = 1 if ridreth1==3
replace ETHNIC = 3 if ridreth1==4
replace ETHNIC = 4 if ridreth1==2|ridreth1==5
tab1 ETHNIC
label define ethniclbl 1 "Non-Hispanic White" 2 "Mexican American"  3 "Non-Hispanic Black" 4 "Other race"
label values ETHNIC ethniclbl

*by ethnicity.
gen ethnic2=0
replace ethnic2=1 if ETHNIC==1
replace ethnic2=3 if ETHNIC==2
replace ethnic2=2 if ETHNIC==3
replace ethnic2=4 if ETHNIC==4
label define ethnic2lbl 1 "Non-Hispanic White"  2 "Non-Hispanic Black" 3 "Mexican American" 4 "Other race"
label values ethnic2 ethnic2lbl
svyset [pweight=wtmec2yr], psu(sdmvpsu) strata(sdmvstra)

keep if inrange(indfmpir2,1,3) & inlist(bmdbmic,2,3,4)

* Truncation.
* 101 OF 4312 (2.3%).

preserve
summ mvpa
summ mvpa if mvpa>=2400
restore

*replace mvpa = 2400 if mvpa>=2400       /* truncate for N=168*/
*replace sports = 2400 if sports>=2400       /* truncate for N=5*/
*replace work = 2400 if work>=2400       /* truncate for N=101*/
*replace TravelTime = 2400 if TravelTime>=2400       /* truncate for N=101*/

summ mvpa sports work TravelTime

* now per-day.

foreach var of varlist mvpa sports work TravelTime {
replace `var' = `var'/7
}

summ mvpa sports work TravelTime

drop age2
gen age2=0 if inrange(age,12,15)
replace age2=1 if inrange(age,16,17)


*MVPA (total: recreational, work, transport).
svy,subpop(male): churdle exponential mvpa i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins,dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any*/                    																					
margins,dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Unconditional */                  
margins,dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Conditional */

svy,subpop(female): churdle exponential mvpa i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins,dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)    /*Any*/                       																		
margins,dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)     /*Unconditional*/                                   													
margins,dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)    /*Conditional */ 

*MVPA (recreational).
svy,subpop(male): churdle exponential sports i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any */                       																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Unconditional */                                													
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Conditional */

svy,subpop(female): churdle exponential sports i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)   /* Any */                      																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)     /* Unconditional */                               													
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1) /* Conditional */

*MVPA (work).
svy,subpop(male): churdle exponential work i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any */                      																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)         /* Unconditional */                        														
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Conditional */

svy,subpop(female): churdle exponential work i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  /* Any */                      																		
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)    /* Unconditional */                                													
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1) /* Conditional */

*MVPA (transport).
svy,subpop(male): churdle exponential TravelTime i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)                      																					
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)                                 																			
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)  

svy,subpop(female): churdle exponential TravelTime i.indfmpir2 i.age2 i.bmdbmic i.ethnic2, select(i.indfmpir2 i.age2 i.bmdbmic i.ethnic2) ll(0.001)        
margins, dydx(indfmpir2) predict(pr(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)                      																					
margins, dydx(indfmpir2) predict(ystar(0,)) at(age2==0 bmdbmic==2 ethnic2==1)                                 																			
margins, dydx(indfmpir2) predict(e(0.001,,)) at(age2==0 bmdbmic==2 ethnic2==1)



























































 





































































































































	













