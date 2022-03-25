* Encoding: UTF-8.
****************************************
*Inequalities in PA among children
***************************************.

********************************************
*2008: N=5555.
********************************************

dataset close all.
GET FILE="N:\Updated archive files\hse08ai.sav"
/keep age sex wt_int sport08 chpa08
spatt1 spatt6 spatt11 spatt16 spatt21 spatt26 spatt31 spatt36 spatt41 spatt46 spatT61 spatT66 spatT71 spatT76 spatT81
spatt2 spatt7 spatt12 spatt17 spatt22 spatt27 spatt32 spatt37 spatt42 spatt47 spatT62 spatT67 spatT72 spatT77 spatT82
spatt3 spatt8 spatt13 spatt18 spatt23 spatt28 spatt33 spatt38 spatt43 spatt48 spatT63 spatT68 spatT73 spatT78 spatT83
spatt4 spatt9 spatt14 spatt19 spatt24 spatt29 spatt34 spatt39 spatt44 spatt49 spatT64 spatT69 spatT74 spatT79 spatT84
spatt5 spatt10 spatt15 spatt20 spatt25 spatt30 spatt35 spatt40 spatt45 spatt50 spatT65 spatT70 spatT75 spatT80 spatT85
spwepat1 spwepat3 spwepat5 spwepat7 spwepat9 spwepat11 spwepat13 spwepat15 spwepat17 spwepat19 spwepat31 spwepat33 spwepat35 spwepat37 spwepat39
spwepat2 spwepat4 spwepat6 spwepat8 spwepat10 spwepat12 spwepat14 spwepat16 spwepat18 spwepat20 spwepat32 spwepat34 spwepat36 spwepat38 spwepat40
nspatT1 nspatT6 nspatT11 nspatT16 nspatT21 nspatT26 nspatT31 nspatT36 nspatT41
nspatT2 nspatT7 nspatT12 nspatT17 nspatT22 nspatT27 nspatT32 nspatT37 nspatT42
nspatT3 nspatT8 nspatT13 nspatT18 nspatT23 nspatT28 nspatT33 nspatT38 nspatT43
nspatT4 nspatT9 nspatT14 nspatT19 nspatT24 nspatT29 nspatT34 nspatT39 nspatT44
nspatT5 nspatT10 nspatT15 nspatT20 nspatT25 nspatT30 nspatT35 nspatT40 nspatT45
WEPAT1 WEPAT3 WEPAT5 WEPAT7 WEPAT9 WEPAT11 WEPAT13 WEPAT15 WEPAT17
WEPAT2 WEPAT4 WEPAT6 WEPAT8 WEPAT10 WEPAT12 WEPAT14 WEPAT16 WEPAT18 infact08
MonMVPA	TueMVPA	WedMVPA	ThurMVPA	FriMVPA	SatMVPA	SunMVPA
PAany PA60t PA30t chPA08 eqv3 psu bmicat1
SchDays Sch7D JWlkCyc JWlkDt  JWlkDF JWLKTIM JCycDF JCycDT JCYCTIM
SprtTMon SprtTTue SprtTWed SprtTThur SprtTFri SprtTSat SprtTSun 
nstmon nsttue nstwed nstthur nstfri nstsat nstsun wt_child
TotalValidMVPAMinutes2
MVPAMinutesMonday2
MVPAMinutesTuesday2
MVPAMinutesWednesday2
MVPAMinutesThursday2
MVPAMinutesFriday2
MVPAMinutesSaturday2
MVPAMinutesSunday2
LongerMVPAMinutesMonday2
LongerMVPAMinutesTuesday2
LongerMVPAMinutesWednesday2
LongerMVPAMinutesThursday2
LongerMVPAMinutesFriday2
LongerMVPAMinutesSaturday2
LongerMVPAMinutesSunday2
NumberofValidDays_corrected2 kcigevr kcigreg qimd.

COMPUTE kcigsum = 0.
recode kcigreg (1=1)(2 thru 6=2)(else=copy) into kcigsum.
VAR LAB kcigsum "cigarette smoking status".
VAL LAB kcigsum
   1 "never smoked"
   2 "have ever smoked".
EXECUTE.
compute age2=0.
if range(age,11,12) age2=1.
if range(age,13,15) age2=2.
val labels age2 1 "11-12" 2 "13-15".
exe.
compute ag015g4=-8.
if range(age,5,10) ag015g4=2.
if range(age,11,15) ag015g4=3.
EXECUTE.
val labels ag015g4 
2 "5-10"
3 "11-15".
exe.
compute psu99=psu.
EXECUTE.

* recode numeric to string.

STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

* N 11-15 (2618).

select if range(age,5,15).
exe.

compute MonMVPA = (SprtTMon + nstmon).
compute TueMVPA = (SprtTTue + nsttue).
compute WedMVPA = (SprtTWed + nstwed).
compute ThurMVPA = (SprtTThur + nstthur).
compute FriMVPA = (SprtTFri + nstfri).
compute SatMVPA = (SprtTSat + nstsat).
compute SunMVPA = (SprtTSun + nstsun).
EXECUTE.

compute sportsMVPA = SUM(spatt1,spatt6,spatt11,spatt16,spatt21,spatt26,spatt31,spatt36,spatt41,spatt46,
spatt2,spatt7,spatt12,spatt17,spatt22,spatt27,spatt32,spatt37,spatt42,spatt47,
spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48,
spatt4,spatt9,spatt14,spatt19,spatt24,spatt29,spatt34,spatt39,spatt44,spatt49,
spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50,
spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19,
spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20).
EXECUTE.

temp.
sel if sport08>=0.
desc var sportsMVPA sport08.

** Informal.

Compute AcTranWT=0.
IF ((SchDays>0) & RANGE(Sch7D, 1,3)) & ANY(JWlkCyc, 1, 3) & (JWlkDT>=0 & JWLKTIM>=0) AcTranWT=AcTranWT+(JWlkDT *JWlkTim).
IF ((SchDays>0) & RANGE(Sch7D, 1,3)) & ANY(JWlkCyc, 1, 3) & (JWlkDF>=0 & JWLKTIM>=0)AcTranWT=AcTranWT+(JWlkDF*JWlkTim).
IF ((SchDays>0) & RANGE(Sch7D, 1,3)) & ANY(JWlkCyc, 2, 3) & (JCycDT>=0 & JCYCTIM>=0) AcTranWT=AcTranWT+(JCycDT *JCycTim).
IF ((SchDays>0) & RANGE(Sch7D, 1,3)) & ANY(JWlkCyc, 2, 3) & (JCycDF>=0 & JCYCTIM>=0) AcTranWT=AcTranWT+(JCycDF*JCycTim).
IF any(-8, Jwlktim, JWlkDT, JWlkDF, JCycTim, JCycDT, JCycDF) AcTranWT=-8.
IF any(-9, Jwlktim, JWlkDT, JWlkDF, JCycTim, JCycDT, JCycDF) AcTranWT=-9.
VAR LAB AcTranWT '(D) Weekly time for active transportation to and from school (minutes)'.
exe.
compute informalMVPA = sum(nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41,
nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42,
nspatT3, nspatT8, nspatT13, nspatT18, nspatT23, nspatT28, nspatT33, nspatT38, nspatT43,
nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44,
nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45,
WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17,
WEPAT2, WEPAT4, WEPAT6, WEPAT8, WEPAT10, WEPAT12, WEPAT14, WEPAT16, WEPAT18).
exe.
compute d = informalMVPA + actranwt.
exe.

temp.
sel if infact08>=0.
desc var infact08 d.

*Monday (sports[+others] and informal).
compute a1 = sum(spatt1, spatt6, spatt11, spatt16, spatt21, spatt26, spatt31, spatt36, spatt41, spatt46, 
spatT61, spatT66, spatT71, spatT76, spatT81,
nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41).
EXECUTE.

temp.
sel if monmvpa>=0.
desc var a1 monmvpa.

compute a1sports = sum(spatt1, spatt6, spatt11, spatt16, spatt21, spatt26, spatt31, spatt36, spatt41, spatt46).
EXECUTE.
compute a1informal= sum(nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41).
EXECUTE.

* Tuesday (sports[+others] and informal).
compute a2 = sum(spatt2,spatt7,spatt12,spatt17,
spatt22, spatt27, spatt32, spatt37, spatt42, spatt47, spatT62, spatT67, spatT72, spatT77, spatT82,
nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42).
EXECUTE.
compute a2sports = sum(spatt2,spatt7,spatt12,spatt17,spatt22, spatt27, spatt32, spatt37, spatt42, spatt47).
EXECUTE.
compute a2informal = sum(nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42).
EXECUTE.

*Wednesday (sports[+others] and informal).
compute a3 = sum(spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48,spatT63,spatT68,spatT73,spatT78,spatT83,
nspatT3,nspatT8,nspatT13,nspatT18,nspatT23,nspatT28,nspatT33,nspatT38,nspatT43).
EXECUTE.
compute a3sports = sum(spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48).
EXECUTE.
compute a3informal = sum(nspatT3,nspatT8,nspatT13,nspatT18,nspatT23,nspatT28,nspatT33,nspatT38,nspatT43).
EXECUTE.

*Thursday (sports[+others] and informal).
compute a4 = sum(spatt4, spatt9, spatt14, spatt19, spatt24, spatt29, spatt34, spatt39, spatt44, spatt49, spatT64, spatT69, spatT74, spatT79, spatT84,
nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44).
exe.
compute a4sports = sum(spatt4, spatt9, spatt14, spatt19, spatt24, spatt29, spatt34, spatt39, spatt44, spatt49).
exe.
compute a4informal = sum(nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44).
EXECUTE.

* Friday (sports[+others] and informal).
compute a5 = sum(spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50,spatT65,spatT70,spatT75,spatT80,spatT85,
nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45).
exe.
compute a5sports = sum(spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50).
EXECUTE.
compute a5informal = sum(nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45).
EXECUTE.

*Saturday (sports[+others] and informal).
compute a6 = sum(spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19,spwepat31,spwepat33,spwepat35,spwepat37,spwepat39,
WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17).
EXECUTE.
compute a6sports = sum(spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19).
EXECUTE.
compute a6informal = sum(WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17).
EXECUTE.

*Sunday (sports[+others] and informal).
compute a7 = sum(spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20,spwepat32,spwepat34,spwepat36,spwepat38,spwepat40,
WEPAT2, WEPAT4, WEPAT6, WEPAT8,WEPAT10,WEPAT12,WEPAT14,WEPAT16,WEPAT18).
exe.
compute a7sports = sum(spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20).
EXECUTE.
compute a7informal = sum(WEPAT2, WEPAT4, WEPAT6, WEPAT8,WEPAT10,WEPAT12,WEPAT14,WEPAT16,WEPAT18).
EXECUTE.

*Sport & informal (Number of days).

compute g=0.
IF MonMVPA>0 g=g+1.
IF TueMVPA>0 g=g+1.
IF WedMVPA>0 g=g+1.
IF ThurMVPA>0 g=g+1.
IF FriMVPA>0 g=g+1.
IF SatMVPA>0 g=g+1.
IF SunMVPA>0 g=g+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g=-9.
EXECUTE.

*Sport & informal (Number of days: 60+).
compute g60=0.
IF MonMVPA>59 g60=g60+1.
IF TueMVPA>59 g60=g60+1.
IF WedMVPA>59 g60=g60+1.
IF ThurMVPA>59 g60=g60+1.
IF FriMVPA>59 g60=g60+1.
IF SatMVPA>59 g60=g60+1.
IF SunMVPA>59 g60=g60+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g60=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g60=-9.
exe.

*Sport & informal (Number of days: 30-59).
compute g30=0.
IF (MonMVPA<60 & MonMVPA>=30) g30=g30+1.
IF (TueMVPA<60 & TueMVPA>=30) g30=g30+1.
IF (WedMVPA<60 & WedMVPA>=30) g30=g30+1.
IF (ThurMVPA<60 & ThurMVPA>=30) g30=g30+1.
IF (FriMVPA<60 & FriMVPA>=30) g30=g30+1.
IF (SatMVPA<60 & SatMVPA>=30) g30=g30+1.
IF (SunMVPA<60 & SunMVPA>=30) g30=g30+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g30=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g30=-9.
exe.

*Recommendations.

compute RECS=0.
IF PA60T>=3 & PA60T<7 RECS=1.
IF PA30T=7 RECS=2.
IF (MonMVPA>59 & TueMVPA>59 & WedMVPA>59 & ThurMVPA>59 & FriMVPA>59 & SatMVPA>59 & SunMVPA>59) RECS=3.
*IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA, nswa, nswb) Tiger=-8.
*IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA, nswa, nswb) Tiger=-9.
VALUE LABELS RECS
0 'Low' 1 'Med - 60mins+ on 3-6 days' 2 'Med - 30-59mins on all 7 days' 3 'High - 60mins+ on all 7 days'.
exe.

temp.
sel if CHPA08>=0.
fre CHPA08 RECS.

temp.
sel if RECS=3.
desc var MonMVPA TueMVPA WedMVPA ThurMVPA FriMVPA SatMVPA SunMVPA.

compute MVPA = sum(MonMVPA,TueMVPA,WedMVPA,ThurMVPA,FriMVPA,SatMVPA,SunMVPA).
exe.
compute year=1.
exe.
save outfile = "N:\Temp\Temp1.sav"
/keep year sex wt_child MonMVPA TueMVPA WedMVPA ThurMVPA FriMVPA SatMVPA SunMVPA eqv3 chpa08 point1 
MVPA sportsMVPA InformalMVPA actranwt ag015g4 bmicat1 RECS
a1sports a1informal
a2sports a2informal
a3sports a3informal
a4sports a4informal
a5sports a5informal
a6sports a6informal
a7sports a7informal age2 TotalValidMVPAMinutes2 kcigsum qimd.

************************************.
* 2012: N=1294.
************************************.

dataset close all.
GET FILE="N:\Updated archive files\hse2012ai.sav"
/keep age sex wt_int sport08 chpa08
spatt1 spatt6 spatt11 spatt16 spatt21 spatt26 spatt31 spatt36 spatt41 spatt46 spatT61 spatT66 spatT71 spatT76 spatT81
spatt2 spatt7 spatt12 spatt17 spatt22 spatt27 spatt32 spatt37 spatt42 spatt47 spatT62 spatT67 spatT72 spatT77 spatT82
spatt3 spatt8 spatt13 spatt18 spatt23 spatt28 spatt33 spatt38 spatt43 spatt48 spatT63 spatT68 spatT73 spatT78 spatT83
spatt4 spatt9 spatt14 spatt19 spatt24 spatt29 spatt34 spatt39 spatt44 spatt49 spatT64 spatT69 spatT74 spatT79 spatT84
spatt5 spatt10 spatt15 spatt20 spatt25 spatt30 spatt35 spatt40 spatt45 spatt50 spatT65 spatT70 spatT75 spatT80 spatT85
spwepat1 spwepat3 spwepat5 spwepat7 spwepat9 spwepat11 spwepat13 spwepat15 spwepat17 spwepat19 spwepat31 spwepat33 spwepat35 spwepat37 spwepat39
spwepat2 spwepat4 spwepat6 spwepat8 spwepat10 spwepat12 spwepat14 spwepat16 spwepat18 spwepat20 spwepat32 spwepat34 spwepat36 spwepat38 spwepat40
nspatT1 nspatT6 nspatT11 nspatT16 nspatT21 nspatT26 nspatT31 nspatT36 nspatT41
nspatT2 nspatT7 nspatT12 nspatT17 nspatT22 nspatT27 nspatT32 nspatT37 nspatT42
nspatT3 nspatT8 nspatT13 nspatT18 nspatT23 nspatT28 nspatT33 nspatT38 nspatT43
nspatT4 nspatT9 nspatT14 nspatT19 nspatT24 nspatT29 nspatT34 nspatT39 nspatT44
nspatT5 nspatT10 nspatT15 nspatT20 nspatT25 nspatT30 nspatT35 nspatT40 nspatT45
WEPAT1 WEPAT3 WEPAT5 WEPAT7 WEPAT9 WEPAT11 WEPAT13 WEPAT15 WEPAT17
WEPAT2 WEPAT4 WEPAT6 WEPAT8 WEPAT10 WEPAT12 WEPAT14 WEPAT16 WEPAT18 infact08 AcTranWT
MonMVPA	TueMVPA	WedMVPA	ThurMVPA	FriMVPA	SatMVPA	SunMVPA
PAany PA60t PA30t chPA08 eqv3 psu bmicat1
SprtTMon SprtTTue SprtTWed SprtTThur SprtTFri SprtTSat SprtTSun 
nstmon nsttue nstwed nstthur nstfri nstsat nstsun Sch7D
SchDays kcigreg qimd.
COMPUTE kcigsum = 0.
recode kcigreg (1=1)(2 thru 6=2)(else=copy) into kcigsum.
VAR LAB kcigsum "cigarette smoking status".
VAL LAB kcigsum
   1 "never smoked"
   2 "have ever smoked".
EXECUTE.
compute age2=0.
if range(age,11,12) age2=1.
if range(age,13,15) age2=2.
val labels age2 1 "11-12" 2 "13-15".
exe.
compute ag015g4=-8.
if range(age,5,10) ag015g4=2.
if range(age,11,15) ag015g4=3.
EXECUTE.
val labels ag015g4 
2 "5-10"
3 "11-15".
exe.
compute psu99=psu.
EXECUTE.

* recode numeric to string.
STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.
compute wt_child = wt_int.
exe.
select if range(age,5,15).
exe.

* includes others.
compute aMVPAx = (SprtTMon + nstmon).
compute bMVPAx = (SprtTTue + nsttue).
compute cMVPAx = (SprtTWed + nstwed).
compute dMVPAx = (SprtTThur + nstthur).
compute eMVPAx = (SprtTFri + nstfri).
compute fMVPAx = (SprtTSat + nstsat).
compute gMVPAx = (SprtTSun + nstsun).
EXECUTE.

compute sportsMVPA = SUM(spatt1,spatt6,spatt11,spatt16,spatt21,spatt26,spatt31,spatt36,spatt41,spatt46,
spatt2,spatt7,spatt12,spatt17,spatt22,spatt27,spatt32,spatt37,spatt42,spatt47,
spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48,
spatt4,spatt9,spatt14,spatt19,spatt24,spatt29,spatt34,spatt39,spatt44,spatt49,
spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50,
spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19,
spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20).
EXECUTE.

temp.
sel if sport08>=0.
desc var sportsMVPA sport08.

** Informal.

compute informalMVPA = sum(nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41,
nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42,
nspatT3, nspatT8, nspatT13, nspatT18, nspatT23, nspatT28, nspatT33, nspatT38, nspatT43,
nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44,
nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45,
WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17,
WEPAT2, WEPAT4, WEPAT6, WEPAT8, WEPAT10, WEPAT12, WEPAT14, WEPAT16, WEPAT18).
exe.
compute d = informalMVPA + actranwt.
exe.

temp.
sel if infact08>=0.
desc var infact08 d.

* Monday (sports[+others] and informal).

compute a1 = sum(spatt1, spatt6, spatt11, spatt16, spatt21, spatt26, spatt31, spatt36, spatt41, spatt46, 
spatT61, spatT66, spatT71, spatT76, spatT81,
nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41).
EXECUTE.

temp.
sel if monmvpa>=0.
desc var a1 monmvpa.

compute a1sports = sum(spatt1, spatt6, spatt11, spatt16, spatt21, spatt26, spatt31, spatt36, spatt41, spatt46).
EXECUTE.
compute a1informal = sum(nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41).
EXECUTE.

*Tuesday (sports[+others] and informal).
compute a2 = sum(spatt2,spatt7,spatt12,spatt17,
spatt22, spatt27, spatt32, spatt37, spatt42, spatt47, spatT62, spatT67, spatT72, spatT77, spatT82,
nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42).
EXECUTE.

temp.
sel if tuemvpa>=0.
desc var a2 tuemvpa.

compute a2sports = sum(spatt2,spatt7,spatt12,spatt17,
spatt22, spatt27, spatt32, spatt37, spatt42, spatt47).
EXECUTE.
compute a2informal = sum(nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42).
EXECUTE.

* Wednesday (sports[+others] and informal).
compute a3 = sum(spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48,spatT63,spatT68,spatT73,spatT78,spatT83,
nspatT3,nspatT8,nspatT13,nspatT18,nspatT23,nspatT28,nspatT33,nspatT38,nspatT43).
EXECUTE.

temp.
sel if wedmvpa>=0.
desc var a3 wedmvpa.

compute a3sports = sum(spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48).
EXECUTE.
compute a3informal = sum(nspatT3,nspatT8,nspatT13,nspatT18,nspatT23,nspatT28,nspatT33,nspatT38,nspatT43).
EXECUTE.

* Thursday (sports[+others] and informal).
compute a4 = sum(spatt4, spatt9, spatt14, spatt19, spatt24, spatt29, spatt34, spatt39, spatt44, spatt49, spatT64, spatT69, spatT74, spatT79, spatT84,
nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44).
exe.

temp.
sel if thurmvpa>=0.
desc var a4 thurmvpa.

compute a4sports = sum(spatt4, spatt9, spatt14, spatt19, spatt24, spatt29, spatt34, spatt39, spatt44, spatt49).
EXECUTE.
compute a4informal = sum(nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44).
EXECUTE.

* Friday (sports[+others] and informal).
compute a5 = sum(spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50,spatT65,spatT70,spatT75,spatT80,spatT85,
nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45).
exe.

temp.
sel if frimvpa>=0.
desc var a5 frimvpa.

compute a5sports = sum(spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50).
exe.
compute a5informal = sum(nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45).
exe.

* Saturday (sports[+others] and informal).
compute a6 = sum(spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19,spwepat31,spwepat33,spwepat35,spwepat37,spwepat39,
WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17).
EXECUTE.

temp.
sel if satmvpa>=0.
desc var a6 satmvpa.

compute a6sports = sum(spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19).
EXECUTE.
compute a6informal = sum(WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17).
EXECUTE.

* Sunday (sports[+others] and informal).
compute a7 = sum(spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20,spwepat32,spwepat34,spwepat36,spwepat38,spwepat40,
WEPAT2, WEPAT4, WEPAT6, WEPAT8,WEPAT10,WEPAT12,WEPAT14,WEPAT16,WEPAT18).
exe.

temp.
sel if sunmvpa>=0.
desc var a7 sunmvpa.

compute a7sports = sum(spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20).
EXECUTE.
compute a7informal = sum(WEPAT2, WEPAT4, WEPAT6, WEPAT8,WEPAT10,WEPAT12,WEPAT14,WEPAT16,WEPAT18).
exe.

*Sport & informal (Number of days).
compute g=0.
IF MonMVPA>0 g=g+1.
IF TueMVPA>0 g=g+1.
IF WedMVPA>0 g=g+1.
IF ThurMVPA>0 g=g+1.
IF FriMVPA>0 g=g+1.
IF SatMVPA>0 g=g+1.
IF SunMVPA>0 g=g+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g=-9.
EXECUTE.

*Sport & informal (Number of days: 60+).
compute g60=0.
IF MonMVPA>59 g60=g60+1.
IF TueMVPA>59 g60=g60+1.
IF WedMVPA>59 g60=g60+1.
IF ThurMVPA>59 g60=g60+1.
IF FriMVPA>59 g60=g60+1.
IF SatMVPA>59 g60=g60+1.
IF SunMVPA>59 g60=g60+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g60=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g60=-9.
exe.

*Sport & informal (Number of days: 30-59).
compute g30=0.
IF (MonMVPA<60 & MonMVPA>=30) g30=g30+1.
IF (TueMVPA<60 & TueMVPA>=30) g30=g30+1.
IF (WedMVPA<60 & WedMVPA>=30) g30=g30+1.
IF (ThurMVPA<60 & ThurMVPA>=30) g30=g30+1.
IF (FriMVPA<60 & FriMVPA>=30) g30=g30+1.
IF (SatMVPA<60 & SatMVPA>=30) g30=g30+1.
IF (SunMVPA<60 & SunMVPA>=30) g30=g30+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g30=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g30=-9.
exe.

*Recommendations.
compute RECS=0.
IF PA60T>=3 & PA60T<7 RECS=1.
IF PA30T=7 RECS=2.
IF (MonMVPA>59 & TueMVPA>59 & WedMVPA>59 & ThurMVPA>59 & FriMVPA>59 & SatMVPA>59 & SunMVPA>59) RECS=3.
*IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA, nswa, nswb) Tiger=-8.
*IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA, nswa, nswb) Tiger=-9.
VALUE LABELS RECS
0 'Low' 1 'Med - 60mins+ on 3-6 days' 2 'Med - 30-59mins on all 7 days' 3 'High - 60mins+ on all 7 days'.
exe.

temp.
sel if CHPA08>=0.
fre CHPA08 RECS.

temp.
sel if RECS=3.
desc var MonMVPA TueMVPA WedMVPA ThurMVPA FriMVPA SatMVPA SunMVPA.

compute MVPA = sum(MonMVPA,TueMVPA,WedMVPA,ThurMVPA,FriMVPA,SatMVPA,SunMVPA).
exe.
compute year=2.
exe.

save outfile = "N:\Temp\Temp2.sav"
/keep year sex wt_child MonMVPA TueMVPA WedMVPA ThurMVPA FriMVPA SatMVPA SunMVPA eqv3 chpa08 point1 MVPA
sportsMVPA InformalMVPA actranwt ag015g4 bmicat1 RECS
a1sports a1informal
a2sports a2informal
a3sports a3informal
a4sports a4informal
a5sports a5informal
a6sports a6informal
a7sports a7informal age2 kcigsum qimd.




******************************************************.
*2015: Sports/Informal/active transport but not other.
******************************************************.

dataset close all.
GET FILE="N:\Updated archive files\HSE2015ai.sav"
/keep seriala sex sport08 AcTranWT ag015g4 wt_child wt_int
spatt1 spatt6 spatt11 spatt16 spatt21 spatt26 spatt31 spatt36 spatt41 spatt46 spatT61 spatT66 spatT71 spatT76 spatT81
spatt2 spatt7 spatt12 spatt17 spatt22 spatt27 spatt32 spatt37 spatt42 spatt47 spatT62 spatT67 spatT72 spatT77 spatT82
spatt3 spatt8 spatt13 spatt18 spatt23 spatt28 spatt33 spatt38 spatt43 spatt48 spatT63 spatT68 spatT73 spatT78 spatT83
spatt4 spatt9 spatt14 spatt19 spatt24 spatt29 spatt34 spatt39 spatt44 spatt49 spatT64 spatT69 spatT74 spatT79 spatT84
spatt5 spatt10 spatt15 spatt20 spatt25 spatt30 spatt35 spatt40 spatt45 spatt50 spatT65 spatT70 spatT75 spatT80 spatT85
spwepat1 spwepat3 spwepat5 spwepat7 spwepat9 spwepat11 spwepat13 spwepat15 spwepat17 spwepat19 spwepat31 spwepat33 spwepat35 spwepat37 spwepat39
spwepat2 spwepat4 spwepat6 spwepat8 spwepat10 spwepat12 spwepat14 spwepat16 spwepat18 spwepat20 spwepat32 spwepat34 spwepat36 spwepat38 spwepat40
nspatT1 nspatT6 nspatT11 nspatT16 nspatT21 nspatT26 nspatT31 nspatT36 nspatT41
nspatT2 nspatT7 nspatT12 nspatT17 nspatT22 nspatT27 nspatT32 nspatT37 nspatT42
nspatT3 nspatT8 nspatT13 nspatT18 nspatT23 nspatT28 nspatT33 nspatT38 nspatT43
nspatT4 nspatT9 nspatT14 nspatT19 nspatT24 nspatT29 nspatT34 nspatT39 nspatT44
nspatT5 nspatT10 nspatT15 nspatT20 nspatT25 nspatT30 nspatT35 nspatT40 nspatT45
WEPAT1 WEPAT3 WEPAT5 WEPAT7 WEPAT9 WEPAT11 WEPAT13 WEPAT15 WEPAT17
WEPAT2 WEPAT4 WEPAT6 WEPAT8 WEPAT10 WEPAT12 WEPAT14 WEPAT16 WEPAT18 infact08 
MonMVPA	TueMVPA	WedMVPA	ThurMVPA	FriMVPA	SatMVPA	SunMVPA
SCHMONMVPA SCHTUEMVPA SCHWEDMVPA SCHTHURMVPA SCHFRIMVPA SCHSATMVPA SCHSUNMVPA
CHACTMON	CHACTTUE	CHACTWED	CHACTTHU	CHACTFRI CHACTSAT	CHACTSUN
PAany PA60t PA30t chPA08 eqv3 psu
SprtTMon SprtTTue SprtTWed SprtTThur SprtTFri SprtTSat SprtTSun BMIcat1
BMIcat2
BMIcat3
nstmon nsttue nstwed nstthur nstfri nstsat nstsun porfv15 Involve Age35g kcigevrd kcigreg qimd.

COMPUTE kcigsum = 0.
recode kcigreg (1=1)(2 thru 6=2)(else=copy) into kcigsum.
VAR LAB kcigsum "cigarette smoking status".
VAL LAB kcigsum
   1 "never smoked"
   2 "have ever smoked".
EXECUTE.
compute age2=0.
if (age35g=5) age2=1.
if (age35g=6) age2=2.
val labels age2 1 "11-12" 2 "13-15".
fre age2.
rename variables (porfv15=porfv).
exe.
compute psu99=psu.
EXECUTE.
STRING point1 (A8).
COMPUTE point1 = STRING(psu99, F7.0).
EXECUTE.

******************.
*11-15 (N=1719).
******************.

select if range(ag015g4,2,3).
exe.
missing values involve ().
exe.

* MVPA includes sport & others.

compute aMVPAx = (SprtTMon + nstmon).
compute bMVPAx = (SprtTTue + nsttue).
compute cMVPAx = (SprtTWed + nstwed).
compute dMVPAx = (SprtTThur + nstthur).
compute eMVPAx = (SprtTFri + nstfri).
compute fMVPAx = (SprtTSat + nstsat).
compute gMVPAx = (SprtTSun + nstsun).
EXECUTE.

*Time in Sports (excludes others)..

compute sportsMVPA = SUM(spatt1,spatt6,spatt11,spatt16,spatt21,spatt26,spatt31,spatt36,spatt41,spatt46,
spatt2,spatt7,spatt12,spatt17,spatt22,spatt27,spatt32,spatt37,spatt42,spatt47,
spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48,
spatt4,spatt9,spatt14,spatt19,spatt24,spatt29,spatt34,spatt39,spatt44,spatt49,
spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50,
spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19,
spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20).
EXECUTE.

temp.
sel if sport08>=0.
desc var sportsMVPA sport08.

*Time in informal.

compute InformalMVPA = sum(nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41,
nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42,
nspatT3, nspatT8, nspatT13, nspatT18, nspatT23, nspatT28, nspatT33, nspatT38, nspatT43,
nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44,
nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45,
WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17,
WEPAT2, WEPAT4, WEPAT6, WEPAT8, WEPAT10, WEPAT12, WEPAT14, WEPAT16, WEPAT18).
exe.

compute d = InformalMVPA + actranwt.
exe.

temp.
sel if infact08>=0.
desc var infact08 d.

*Monday: sports[+others] and informal[excludes active travel): used in recommendations.

compute a1 = sum(spatt1, spatt6, spatt11, spatt16, spatt21, spatt26, spatt31, spatt36, spatt41, spatt46, 
spatT61, spatT66, spatT71, spatT76, spatT81,
nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41).
EXECUTE.

*split into sports (exclude others) and informal.
compute a1sports = sum(spatt1, spatt6, spatt11, spatt16, spatt21, spatt26, spatt31, spatt36, spatt41, spatt46).
EXECUTE.
compute a1informal = sum(nspatT1, nspatT6, nspatT11, nspatT16, nspatT21, nspatT26, nspatT31, nspatT36, nspatT41).
EXECUTE.

temp.
sel if monmvpa>=0.
desc var a1 monmvpa a1sports a1informal.

* Tuesday (sports[+others] and informal).

compute a2 = sum(spatt2,spatt7,spatt12,spatt17,
spatt22, spatt27, spatt32, spatt37, spatt42, spatt47, spatT62, spatT67, spatT72, spatT77, spatT82,
nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42).
EXECUTE.

* split into sports and informal.
compute a2sports = sum(spatt2,spatt7,spatt12,spatt17,
spatt22, spatt27, spatt32, spatt37, spatt42, spatt47).
EXECUTE.
compute a2informal = sum(nspatT2, nspatT7, nspatT12, nspatT17, nspatT22, nspatT27, nspatT32, nspatT37, nspatT42).
EXECUTE.

temp.
sel if tuemvpa>=0.
desc var a2 tuemvpa a2sports a2informal.

*Wednesday (sports[+others] and informal).
compute a3 = sum(spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48,spatT63,spatT68,spatT73,spatT78,spatT83,
nspatT3,nspatT8,nspatT13,nspatT18,nspatT23,nspatT28,nspatT33,nspatT38,nspatT43).
EXECUTE.

* split into sports and informal.
compute a3sports = sum(spatt3,spatt8,spatt13,spatt18,spatt23,spatt28,spatt33,spatt38,spatt43,spatt48).
EXECUTE.
compute a3informal = sum(nspatT3,nspatT8,nspatT13,nspatT18,nspatT23,nspatT28,nspatT33,nspatT38,nspatT43).
EXECUTE.

temp.
sel if wedmvpa>=0.
desc var a3 wedmvpa a3sports a3informal.

*Thursday (sports[+others] and informal).
compute a4 = sum(spatt4, spatt9, spatt14, spatt19, spatt24, spatt29, spatt34, spatt39, spatt44, spatt49, spatT64, spatT69, spatT74, spatT79, spatT84,
nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44).
exe.

*split into sports and informal.
compute a4sports = sum(spatt4, spatt9, spatt14, spatt19, spatt24, spatt29, spatt34, spatt39, spatt44, spatt49).
exe.
compute a4informal = sum(nspatT4, nspatT9, nspatT14, nspatT19, nspatT24, nspatT29, nspatT34, nspatT39, nspatT44).
exe.

temp.
sel if thurmvpa>=0.
desc var a4 thurmvpa a4sports a4informal.


* Friday (sports[+others] and informal).
compute a5 = sum(spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50,spatT65,spatT70,spatT75,spatT80,spatT85,
nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45).
exe.
* split into sports and informal.
compute a5sports = sum(spatt5,spatt10,spatt15,spatt20,spatt25,spatt30,spatt35,spatt40,spatt45,spatt50).
exe.
compute a5informal = sum(nspatT5, nspatT10, nspatT15, nspatT20, nspatT25, nspatT30, nspatT35, nspatT40, nspatT45).
exe.

temp.
sel if frimvpa>=0.
desc var a5 frimvpa a5sports a5informal.

* Saturday (sports[+others] and informal).
compute a6 = sum(spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19,spwepat31,spwepat33,spwepat35,spwepat37,spwepat39,
WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17).
EXECUTE.

*split into sports and informal.
compute a6sports = sum(spwepat1,spwepat3,spwepat5,spwepat7,spwepat9,spwepat11,spwepat13,spwepat15,spwepat17,spwepat19).
EXECUTE.
compute a6informal = sum(WEPAT1, WEPAT3, WEPAT5, WEPAT7, WEPAT9, WEPAT11, WEPAT13, WEPAT15, WEPAT17).
EXECUTE.

temp.
sel if satmvpa>=0.
desc var a6 satmvpa a6sports a6informal.

* Sunday (sports[+others] and informal).

compute a7 = sum(spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20,spwepat32,spwepat34,spwepat36,spwepat38,spwepat40,
WEPAT2, WEPAT4, WEPAT6, WEPAT8,WEPAT10,WEPAT12,WEPAT14,WEPAT16,WEPAT18).
exe.

*split into sports and informal.
compute a7sports = sum(spwepat2,spwepat4,spwepat6,spwepat8,spwepat10,spwepat12,spwepat14,spwepat16,spwepat18,spwepat20).
exe.
compute a7informal = sum(WEPAT2, WEPAT4, WEPAT6, WEPAT8,WEPAT10,WEPAT12,WEPAT14,WEPAT16,WEPAT18).
EXECUTE.

temp.
sel if sunmvpa>=0.
desc var a7 sunmvpa a7sports a7informal.

*Sport & informal (Number of days).
compute g=0.
IF MonMVPA>0 g=g+1.
IF TueMVPA>0 g=g+1.
IF WedMVPA>0 g=g+1.
IF ThurMVPA>0 g=g+1.
IF FriMVPA>0 g=g+1.
IF SatMVPA>0 g=g+1.
IF SunMVPA>0 g=g+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g=-9.
EXECUTE.

*Sport & informal (Number of days: 60+).
compute g60=0.
IF MonMVPA>59 g60=g60+1.
IF TueMVPA>59 g60=g60+1.
IF WedMVPA>59 g60=g60+1.
IF ThurMVPA>59 g60=g60+1.
IF FriMVPA>59 g60=g60+1.
IF SatMVPA>59 g60=g60+1.
IF SunMVPA>59 g60=g60+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g60=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g60=-9.
exe.

*Sport & informal (Number of days: 30-59).
compute g30=0.
IF (MonMVPA<60 & MonMVPA>=30) g30=g30+1.
IF (TueMVPA<60 & TueMVPA>=30) g30=g30+1.
IF (WedMVPA<60 & WedMVPA>=30) g30=g30+1.
IF (ThurMVPA<60 & ThurMVPA>=30) g30=g30+1.
IF (FriMVPA<60 & FriMVPA>=30) g30=g30+1.
IF (SatMVPA<60 & SatMVPA>=30) g30=g30+1.
IF (SunMVPA<60 & SunMVPA>=30) g30=g30+1.
IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g30=-8.
IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA) g30=-9.
exe.

*Recommendations.

compute RECS=0.
IF PA60T>=3 & PA60T<7 RECS=1.
IF PA30T=7 RECS=2.
IF (MonMVPA>59 & TueMVPA>59 & WedMVPA>59 & ThurMVPA>59 & FriMVPA>59 & SatMVPA>59 & SunMVPA>59) RECS=3.
*IF any(-8, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA, nswa, nswb) Tiger=-8.
*IF any(-9, MonMVPA, TueMVPA, WedMVPA, ThurMVPA, FriMVPA, SatMVPA, SunMVPA, nswa, nswb) Tiger=-9.
VALUE LABELS RECS
0 'Low' 1 'Med - 60mins+ on 3-6 days' 2 'Med - 30-59mins on all 7 days' 3 'High - 60mins+ on all 7 days'.
exe.

temp.
sel if CHPA08>=0.
fre CHPA08 RECS.

temp.
sel if RECS=3.
desc var MonMVPA TueMVPA WedMVPA ThurMVPA FriMVPA SatMVPA SunMVPA.

compute MVPA = sum(MonMVPA,TueMVPA,WedMVPA,ThurMVPA,FriMVPA,SatMVPA,SunMVPA).
exe.

compute year=3.
exe.

save outfile = "N:\Temp\Temp3.sav"
/keep year sex wt_child MonMVPA TueMVPA WedMVPA ThurMVPA FriMVPA SatMVPA SunMVPA eqv3 chpa08 point1 
sportsMVPA InformalMVPA actranwt ag015g4 bmicat1 MVPA porfv RECS
a1sports a1informal
a2sports a2informal
a3sports a3informal
a4sports a4informal
a5sports a5informal
a6sports a6informal
a7sports a7informal age2 kcigsum qimd.

* Put the datasets together.

dataset close all.
get file = "N:\Temp\Temp1.sav".
add files/file=*/file =  "N:\Temp\Temp2.sav".
add files/file=*/file =  "N:\Temp\Temp3.sav".
EXECUTE.

compute Inactive=0.
if MVPA=0 Inactive=1.
EXECUTE.

SAVE TRANSLATE OUTFILE='N:\Temp\HSE_analysis_dataset.dta'
  /TYPE=STATA
  /VERSION=8
  /EDITION=SE
  /MAP
  /REPLACE.

































