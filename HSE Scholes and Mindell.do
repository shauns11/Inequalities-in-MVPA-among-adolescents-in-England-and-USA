*********************************************************************************
*Income-based inequalities in self-reported moderate-to-vigorous physical activity 
*among adolescents in England and the USA: a cross-sectional study
*BMJ Open 2021;11:e040540
***********************************************************************************

*Dataset built on children with MVPA >=0.
*In England, 4897 adolescents aged 11-15 years participated in one of the three surveys (2008, 2012,
*2015), of whom 4874 had valid PA data. Of these, 855 had missing income data and were excluded
*from our complete-case analysis, leaving an analytical sample of 4019 adolescents. 

use "N:\Temp\HSE_analysis_dataset.dta", clear
renvars, lower
generate male = sex==1
generate female = sex==2
label define sexlbl 1 "Boys" 2 "Girls"
label values sex sexlbl
keep if ag015g4==3    
recode kcigsum (-9 = -1)

*Inclusion (N=4019)/exclusion (N=878) in the analytical sample.

generate flag1=0
replace flag1=1 if inlist(chpa08,0,1,2,3) & inlist(eqv3,1,2,3)
tab1 flag1

****************************
*Table S1.
***************************

*Unweighted counts.
tab sex flag1, missing 
tab age2 flag1, missing
tab qimd flag1, missing
tab bmicat1 flag1, missing
tab kcigsum flag1, missing

*Weighted estimates.
svyset [pweight=wt_child], psu(point1)
svy: tab sex flag1, col per format(%9.0f)
svy: tab age2 flag1, col per format(%9.0f)
svy: tab qimd flag1, col per format(%9.0f)
svy: tab bmicat1 flag1, col per format(%9.0f)
svy: tab kcigsum flag1, col per format(%9.0f)

*Exclude missing from the p-values.
svy: tab bmicat1 flag1 if inlist(bmicat1,1,2,3), col per format(%9.0f)
svy: tab kcigsum flag1 if inlist(kcigsum,1,2), col per format(%9.0f)

*Analytical sample = 4874 with PA data.
mvdecode eqv3,mv(-90/-1)
keep if inlist(chpa08,0,1,2,3)

***************************
*Table 1.
****************************

tab age2 eqv3 if sex==1, missing
tab bmicat1 eqv3 if sex==1, missing
tab age2 eqv3 if sex==2, missing
tab bmicat1 eqv3 if sex==2, missing

*Total.
svy,subpop(male): tab age2, col  count
svy,subpop(male): tab bmicat1, col count
svy,subpop(female): tab age2, col  count
svy,subpop(female): tab bmicat1, col count

*By Income: Column %'s.
svy,subpop(male): tab age2 eqv3, col  missing  
svy,subpop(male): tab bmicat1 eqv3, col missing
svy,subpop(female): tab age2 eqv3, col missing
svy,subpop(female): tab bmicat1 eqv3, col missing

*P-values.

gen a = sex==1 & inrange(bmicat1,1,3) & inrange(eqv3,1,3)
gen b = sex==2 & inrange(bmicat1,1,3) & inrange(eqv3,1,3)
svy,subpop(a): tab bmicat1 eqv3 if inrange(bmicat1,1,3) & inrange(eqv3,1,3), col missing
svy,subpop(b): tab bmicat1 eqv3 if inrange(bmicat1,1,3) & inrange(eqv3,1,3), col missing

*Overall: variables in minutes.
mvdecode actranwt, mv(-9/-1)
summ mvpa sportsmvpa informalmvpa
summ mvpa sportsmvpa informalmvpa actranwt if year==1
summ mvpa sportsmvpa informalmvpa actranwt if year==2
summ mvpa sportsmvpa informalmvpa actranwt if year==3

*Truncate at 40hours/week.
replace mvpa = 2400 if (mvpa>=2400)                    /* Truncate for N=67*/
replace sportsmvpa = 2400 if (sportsmvpa>=2400)        /* Truncate for N=3*/
replace informalmvpa = 2400 if (informalmvpa>=2400)    /* Truncate for N=29*/

*recode to hours/minutes per day.
foreach var of varlist mvpa sportsmvpa informalmvpa  {
replace `var' = `var'/7
}

summ mvpa sportsmvpa informalmvpa
summ mvpa if mvpa>0    /* Min=0.714; Max=342.857 */

*Histograms.
*preserve
*histogram mvpa,ylabel(0 0.05 0.1,ang(hor) nogrid) fraction discrete  color(black)  ///
*xtitle("Minutes/day spent in moderate-to-vigorous intensity physical activity") ytitle("Proportion") ///
*note("") by(sex,title("",pos(11)) graphregion(color(white)) bgcolor(white) note("")) xlabel(0(60)360)
*restore

*Exclude missing income.
keep if inrange(eqv3,1,3) & ag015g4==3

*96 & 70 min/day (boys; girls).
svy:mean mvpa, over(sex)      

tab sex eqv3             /* N = 4019 */

keep if inrange(bmicat1,1,3)
tab1 eqv3 bmicat1 age2    /* N = 3541 */

*MVPA (formal and informal).
summ mvpa sportsmvpa informalmvpa actranwt

**************************************.
********** Table 2 *******************
*hurdle model: no 10 requirement for kids
*(i) overall
*(ii) formal
*(iii) informal
*(iv) active travel
**************************************

*MVPA (formal and informal).
svy,subpop(male): churdle exponential mvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)    /* Any */                    																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)      /* Unconditional */                                																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)     /* Conditional */  

*exponential option = OLS model of natural log.
**exponential specifications of the value equation,
**gen a = exp(mvpa)
**svy,subpop(male): regress a i.eqv3 i.age2 i.bmicat1 if a>0
**margins, dydx(eqv3) at(age2==1 bmicat1==1)  

svy,subpop(female): churdle exponential mvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)    /* Any */                      																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)      /* Unconditional */                           																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)     /* Conditional */  

*MVPA (formal).
svy,subpop(male): churdle exponential sportsmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)           /* Any */                            																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)             /* Unconditional */                            																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)            /* Conditional */ 

svy,subpop(female): churdle exponential sportsmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)           /* Any */                    																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)             /* Unconditional */                       																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)            /* Conditional */ 

*MVPA (informal).
svy,subpop(male): churdle exponential informalmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)          /* Any */                      																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)            /* Unconditional */                            																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)           /* Conditional */ 

svy,subpop(female): churdle exponential informalmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)          /* Any */                       																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)            /* Unconditional */                                																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)           /* Conditional */ 

*MVPA (active travel).
svy,subpop(male): churdle exponential actranwt i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)         /* Any */                       																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)          /* Unconditional */                       																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)         /* Conditional */ 

svy,subpop(female): churdle exponential actranwt i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)        /* Any */                        																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)         /* Unconditional */                        																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)        /* Conditional */ 


*********************************
*No truncation (Table S3).
*********************************

use "N:\Temp\HSE_analysis_dataset.dta", clear
renvars, lower
generate male=0
generate female=0
replace male=1 if sex==1
replace female=1 if sex==2
label define sexlbl 1 "Boys" 2 "Girls"
label values sex sexlbl
keep if ag015g4==3    

*Weighted estimates.
svyset [pweight=wt_child], psu(point1)
keep if inlist(chpa08,0,1,2,3)

*Overall: variables in minutes.

mvdecode actranwt, mv(-9/-1)
foreach var of varlist mvpa sportsmvpa informalmvpa  {
replace `var' = `var'/7
}

*Exclude missing income.

keep if inrange(eqv3,1,3) & ag015g4==3
count             /* N = 4019 */
keep if inrange(bmicat1,1,3)
count    /* N = 3541 */

*MVPA (formal and informal).
svy,subpop(male): churdle exponential mvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)    /* Any */                    																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)      /* Unconditional */                                																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)     /* Conditional */  

svy,subpop(female): churdle exponential mvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)        /* Any */                      																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)          /* Unconditional */                           																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)          /* Conditional */  

*MVPA (formal).
svy,subpop(male): churdle exponential sportsmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)           /* Any */                            																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)             /* Unconditional */                            																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)            /* Conditional */ 

svy,subpop(female): churdle exponential sportsmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)               /* Any */                    																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)                 /* Unconditional */                       																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)                 /* Conditional */ 

*MVPA (informal).
svy,subpop(male): churdle exponential informalmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)       /* Any */                      																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)       /* Unconditional */                            																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)       /* Conditional */ 

svy,subpop(female): churdle exponential informalmvpa i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)     /* Any */                       																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)       /* Unconditional */                                																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)       /* Conditional */ 

*MVPA (active travel).
svy,subpop(male): churdle exponential actranwt i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)         /* Any */                       																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)          /* Unconditional */                       																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)         /* Conditional */ 

svy,subpop(female): churdle exponential actranwt i.eqv3 i.age2 i.bmicat1, select(i.eqv3 i.age2 i.bmicat1) ll(0.001)        
margins, dydx(eqv3) predict(pr(0.001,,)) at(age2==1 bmicat1==1)        /* Any */                        																					
margins, dydx(eqv3) predict(ystar(0,)) at(age2==1 bmicat1==1)         /* Unconditional */                        																			
margins, dydx(eqv3) predict(e(0.001,,)) at(age2==1 bmicat1==1)        /* Conditional */ 
























