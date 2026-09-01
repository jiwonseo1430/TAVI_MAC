# Quantified Mitral Annular Calcification and First-Year Mortality after Transcatheter Aortic Valve Implantation

**Authors:** [TO CONFIRM — author list, affiliations, corresponding author]

**Word count:** ~3,200 (excluding abstract, references, legends)

---

## Abstract

**Background:** Mitral annular calcification (MAC) is common in patients undergoing transcatheter aortic valve implantation (TAVI), but its prognostic value has mostly been assessed with qualitative grading, and the time course of its associated risk is unknown.

**Methods:** We retrospectively analyzed 525 consecutive patients who underwent TAVI at [TO CONFIRM: center, enrollment period]. MAC volume was quantified on pre-procedural cardiac computed tomography (CT). The primary exposure was log2-transformed MAC volume (hazard ratio [HR] per doubling); MAC presence (volume >0) and volume categories (none / below vs above the median of positive volumes) were secondary. The outcome was all-cause mortality. Multivariable Cox models used covariates selected by backward elimination (univariable p<0.10 entry, retention p<0.05) with MAC forced in. Because the proportional-hazards assumption was violated for MAC, period-specific HRs (0–1 year, >1 year) were estimated.

**Results:** MAC was present in 256 patients (48.8%). Over a median follow-up of 3.2 years (reverse Kaplan–Meier), 102 patients (19.4%) died (24.6% with MAC vs 14.5% without; p=0.005). Adjusted for sex, body mass index, Society of Thoracic Surgeons score, chronic kidney disease, atrial fibrillation, and low-density lipoprotein cholesterol, MAC volume was associated with mortality (HR per doubling 1.09, 95% CI 1.04–1.15; MAC presence: HR 1.92, 95% CI 1.27–2.91). The association was confined to the first year after TAVI (MAC presence: 0–1 year HR 3.46, 95% CI 1.90–6.31; >1 year HR 0.99, 95% CI 0.54–1.80; interaction p=0.003); among 1-year survivors, survival curves were superimposable (log-rank p=0.41). Results were consistent across covariate-selection strategies.

**Conclusions:** CT-quantified MAC is an independent, dose-dependent predictor of mortality after TAVI, with the excess risk concentrated in — and confined to — the first post-procedural year. MAC quantification may identify patients who warrant intensified surveillance during the first year after TAVI.

**Keywords:** mitral annular calcification; transcatheter aortic valve implantation; computed tomography; mortality; aortic stenosis

---

## Introduction

Mitral annular calcification (MAC) is a chronic degenerative process of the mitral annulus fibrosus that shares risk factors and pathobiology with atherosclerosis and is highly prevalent in elderly patients with aortic stenosis; up to one-half of patients evaluated for transcatheter aortic valve implantation (TAVI) have some degree of MAC [1,2]. In TAVI candidates, MAC has been associated with all-cause and cardiovascular mortality [3], and severe MAC complicates transcatheter and surgical treatment of mitral disease [1].

Most prognostic studies of MAC in the TAVI population have relied on qualitative or semi-quantitative severity grading, which suffers from inter-observer variability and threshold effects. Cardiac computed tomography (CT), which is universally acquired for TAVI planning, permits reproducible volumetric quantification of MAC [4], but whether quantified MAC burden carries dose-dependent prognostic information after TAVI — and over what time horizon the associated risk operates — has not been established.

We therefore examined the association between CT-quantified MAC volume and all-cause mortality in a consecutive TAVI cohort, modeling MAC as a continuous exposure, and characterized the time structure of the associated risk.

## Methods

### Study population

We retrospectively studied 525 consecutive patients who underwent TAVI for severe aortic stenosis at [TO CONFIRM: center] between [TO CONFIRM: enrollment period]. Clinical, laboratory, and echocardiographic variables were collected from electronic records. The study was approved by the institutional review board of [TO CONFIRM], which waived the requirement for informed consent [TO CONFIRM]. All data were de-identified before analysis.

### CT quantification of MAC

MAC was assessed on pre-procedural cardiac CT. [TO CONFIRM: scanner(s), acquisition protocol, contrast phase used.] MAC volume was measured volumetrically [TO CONFIRM: software and attenuation threshold]; volumes measured on contrast-enhanced scans were transformed to the non-contrast scale [TO CONFIRM: transformation method]. The primary exposure was MAC volume as a continuous variable, log2(volume + 1)-transformed so that hazard ratios (HRs) are expressed per doubling of volume. Two pre-specified secondary parameterizations were used for presentation and analysis: MAC presence (volume >0) and a three-level volume category (none; positive volume at or below the median of positive volumes [108.6 mm³]; above the median).

### Outcome and follow-up

The outcome was all-cause death. Follow-up time was measured from the TAVI procedure to death or last follow-up. Cause of death was not available.

### Statistical analysis

Continuous variables are summarized as mean ± SD and compared with Welch's t-test or one-way ANOVA; categorical variables as n (%) and compared with the chi-square test (Fisher's exact test when expected counts were <5).

Univariable Cox proportional-hazards models were fitted for each candidate predictor. Variables with univariable p<0.10 entered the multivariable model; because total and LDL cholesterol are collinear, only LDL was retained (rule fixed a priori). Backward elimination was then performed with a retention threshold of p<0.05, with the MAC exposure forced into all models. No model covariate had missing values, so all models used the full cohort (N=525). Total cholesterol, triglycerides, LDL, and HDL were analyzed per 10 mg/dL.

Dose–response was examined with a natural cubic spline of log2(MAC volume + 1) (3 df, interior knots at the tertiles of positive volumes) in the adjusted model; nonlinearity was tested with a likelihood-ratio test against the linear term. The proportional-hazards (PH) assumption was assessed with scaled Schoenfeld residuals. Because the PH assumption was violated for the MAC exposure, period-specific HRs for 0–1 year and >1 year were estimated from a counting-process model split at 365.25 days, with the difference between periods tested by a Wald test of the interaction contrast; this remedy was specified in the analysis plan after the violation was detected. As post-hoc analyses, we (i) further split the first year at 30 days to distinguish periprocedural from early-phase mortality, (ii) constructed Kaplan–Meier curves within the first year and, using a 1-year landmark, among 1-year survivors, and (iii) compared the covariate profiles of first-year versus later mortality (identical covariates plus age) to explore whether late mortality was driven by age-related background risk.

The incremental discriminative value of MAC was assessed by comparing Harrell's C-index of the clinical covariate model with and without the MAC exposure, using the method of Kang et al. (compareC).

Three pre-specified sensitivity analyses addressed covariate selection: (S1) a clinically pre-specified model (STS score + chronic kidney disease + atrial fibrillation + MAC); (S2) LASSO-penalized Cox regression with the MAC exposure unpenalized (10-fold cross-validation, λ at one standard error); and (S3) AIC-based backward elimination. In addition, the three-level grouping used in a preliminary analysis of this cohort (cut-off 717.2 mm³) was retained as a sensitivity analysis; because this cut-off was derived from the present cohort by maximally selected rank statistics, it is reported with the maxstat-adjusted p-value (p=0.012) and was not used for the primary inference.

Analyses used R version 4.5.0 (packages survival, survminer, glmnet, MASS, compareC, maxstat) with a fixed random seed; session information is recorded with every script output. Two-sided p<0.05 was considered significant.

## Results

### Cohort

Of 525 patients (mean age 81.9 ± 5.2 years; 56.4% female; mean STS score 4.8 ± 3.8%), MAC was present on CT in 256 (48.8%); 128 had volumes ≤108.6 mm³ (low) and 128 above (high). Patients with MAC had higher body mass index, more atrial fibrillation (25.0% vs 17.5%, p=0.045), and higher E/e′ (22.7 ± 9.2 vs 19.9 ± 9.8, p=0.002) than patients without MAC; other characteristics, including age, sex, STS score, and LVEF, were similar (Table 1).

### Mortality

Over a median follow-up of 3.2 years (reverse Kaplan–Meier; observed median 2.6 years, IQR 1.3–4.1), 102 patients (19.4%) died: 63 (24.6%) with MAC versus 39 (14.5%) without (p=0.005). Fifty-seven deaths occurred within the first year and 45 thereafter. Kaplan–Meier survival was lower with MAC (log-rank p=0.006) with a graded pattern across volume categories (p=0.021) (Figure 1A–B).

### MAC volume and mortality

In univariable analysis, MAC volume was associated with mortality (HR per doubling 1.08, 95% CI 1.03–1.14; p=0.002), as were MAC presence (HR 1.74, 95% CI 1.17–2.60) and volume categories (low: HR 1.67, 95% CI 1.04–2.67; high: HR 1.82, 95% CI 1.14–2.91) (Table 2).

Backward elimination retained sex, body mass index, STS score, chronic kidney disease, atrial fibrillation, and LDL cholesterol. Adjusted for these covariates, MAC volume remained independently associated with mortality: HR 1.09 per doubling (95% CI 1.04–1.15; p<0.001). MAC presence (HR 1.92, 95% CI 1.27–2.91; p=0.002) and volume categories (low: HR 1.83, 95% CI 1.12–2.97; high: HR 2.02, 95% CI 1.25–3.27) gave concordant results (Table 3). Variance inflation factors were all <1.2.

The adjusted spline analysis showed increasing hazard across the observed volume range (Figure 2A); over the whole follow-up period the association deviated from log-linearity (p=0.010), driven by a steep increase above approximately 500 mm³ (adjusted HR vs no MAC: ≈1.4 at 100 mm³, ≈2.0 at 717 mm³, ≈4.6 at 2,000 mm³).

### Time structure: risk confined to the first year

The PH assumption was violated for the MAC exposure (Schoenfeld p=0.021 for the continuous term). In period-specific models, the association was strong in the first year (per doubling: HR 1.16, 95% CI 1.08–1.24; MAC presence: HR 3.46, 95% CI 1.90–6.31; both p<0.001) and absent thereafter (per doubling: HR 0.99, 95% CI 0.91–1.08; MAC presence: HR 0.99, 95% CI 0.54–1.80); interaction p=0.005 and 0.003, respectively (Table 4). Within the first year, restricted to which the dose–response was log-linear (nonlinearity p=0.18), the spline showed higher adjusted hazards at all volumes (≈2.6 at 100 mm³, ≈3.7 at 717 mm³, ≈7.1 at 2,000 mm³; Figure 2B).

In post-hoc analyses, the excess risk was not confined to the periprocedural window: adjusted HRs for MAC presence were 3.84 (95% CI 1.05–14.0) for 0–30 days and 3.58 (95% CI 1.78–7.19) for 31–365 days. Kaplan–Meier curves within the first year separated in a dose-dependent manner (log-rank p<0.0001; Figure 1C), whereas among the 447 patients surviving one year the curves were superimposable (log-rank p=0.41; Figure 1D).

The covariate profile of mortality also shifted at one year (post-hoc; Supplementary Table): first-year deaths were associated with MAC volume, chronic kidney disease, and LDL, but not age (HR 0.97 per year, p=0.19), whereas deaths beyond one year were associated with age (HR 1.07 per year, p=0.020) and STS score (HR 1.14, p<0.001) with no association for MAC or other cardiac covariates.

### Discrimination and sensitivity analyses

Adding MAC to the clinical covariate model increased Harrell's C-index from 0.725 to 0.742 (continuous; ΔC p=0.15) and to 0.746 (volume categories; ΔC p=0.062); the improvements were not statistically significant. The adjusted association of MAC volume with mortality was consistent across covariate-selection strategies: HR per doubling 1.07 (95% CI 1.02–1.13) in the clinically pre-specified model, 1.08 (95% CI 1.03–1.14) with LASSO selection, and 1.09 (95% CI 1.04–1.15) with AIC-based selection. The preliminary 717.2 mm³ grouping likewise showed an association (high MAC: HR 4.94, 95% CI 2.65–9.22), noting that this cut-off is cohort-derived (Supplementary Tables).

## Discussion

In this consecutive cohort of 525 TAVI patients, CT-quantified MAC volume was an independent, dose-dependent predictor of all-cause mortality. The principal and novel finding is the time structure of this risk: the association was strong during the first post-procedural year — with an approximately 3.5-fold adjusted hazard for any MAC — and disappeared entirely thereafter, both statistically (interaction p=0.003) and visually, with superimposable survival curves among 1-year survivors.

Our findings extend prior work associating MAC with mortality after TAVI [3], in three ways. First, by quantifying MAC volumetrically on routinely acquired planning CT, we demonstrate a graded dose–response (9% higher hazard per doubling of volume) rather than a threshold effect tied to a qualitative grade. Second, the pre-specified continuous analysis proved robust across four covariate-selection strategies, addressing a common criticism of stepwise modeling. Third, and most importantly, we show that MAC-associated mortality is a first-year phenomenon.

The first-year concentration of risk was not merely periprocedural: the adjusted hazard was similar in the 0–30-day and 31–365-day windows, arguing against a purely procedure-related mechanism. We propose two complementary explanations for the disappearance of the association after one year. Clinically, in a population with a mean age of 82 years, mortality beyond the first year is increasingly driven by age-related, multifactorial background risk; consistent with this, late deaths in our cohort were predicted by age and STS score but by none of the cardiac-specific covariates, whereas first-year deaths were predicted by MAC, chronic kidney disease, and atrial fibrillation but not by age. Statistically, depletion of susceptibles will also contribute: the patients with MAC who are most vulnerable die during the first year, leaving a selected, more robust group thereafter — a caveat that also cautions against interpreting the late curves as showing any protective effect of MAC. MAC likely acts as an integrative marker of systemic and cardiac calcific burden and of subclinical vulnerability that becomes manifest under the physiological stress of the peri- and early post-procedural period.

These observations have a practical implication: MAC quantification, available at no extra cost from every TAVI planning CT, identifies patients whose excess mortality risk is concentrated in a defined and actionable window. Such patients may benefit from closer clinical surveillance, optimization of comorbidities, and structured follow-up during the first post-procedural year. Conversely, MAC patients who survive the first year can be reassured that their subsequent prognosis appears no different from that of patients without MAC. Because the gain in model discrimination was modest and not statistically significant, we view MAC as a prognostic marker and a trigger for surveillance rather than as a component of formal risk scores.

### Limitations

This is a retrospective single-center study; unmeasured confounding cannot be excluded. Cause of death was unavailable, so we could not separate cardiovascular from non-cardiovascular mortality or perform competing-risks analyses, and the two proposed mechanisms for the late attenuation cannot be directly distinguished. The full candidate multivariable model had approximately 8.5 events per parameter, below the conventional threshold of 10, although the parsimonious final model and the concordant sensitivity analyses mitigate this concern. The time-structure analyses (30-day split, landmark analyses, period-specific covariate profiles) were post-hoc, prompted by the proportional-hazards violation, and should be regarded as hypothesis-generating. The median volume cut-point used for the three-level presentation is cohort-defined, as is the 717.2 mm³ threshold of the preliminary analysis; external validation of any categorization is required. Finally, [TO CONFIRM: any relevant detail of the volume-transformation method and its validation].

### Conclusions

CT-quantified MAC volume independently predicts mortality after TAVI in a dose-dependent manner, and the excess risk is confined to the first post-procedural year. MAC quantification on routine planning CT may serve as a simple tool to target intensified first-year surveillance after TAVI.

---

## Tables

- **Table 1.** Baseline characteristics by MAC presence. *(source: output/table1_binary.csv)*
- **Table 2.** Univariable Cox regression for all-cause mortality. *(source: output/table2.csv)*
- **Table 3.** Multivariable Cox models: continuous MAC volume (primary), MAC presence, and volume categories. *(source: output/table3c_final.csv, table3c_binary.csv, table3c_categories.csv — assembled from sensitivity_continuous.csv)*
- **Table 4.** Period-specific adjusted hazard ratios (0–1 year vs >1 year). *(source: output/table_time_interval.csv)*

## Figure legends

**Figure 1. Kaplan–Meier survival after TAVI.** (A) By MAC presence and (B) by MAC volume category (none; ≤ vs > median of positive volumes [108.6 mm³]) over the whole follow-up (truncated at 7 years). (C) Within the first year after TAVI and (D) among 1-year survivors (1-year landmark; both post-hoc). P-values are log-rank. *(source: output/fig1_km_4panel)*

**Figure 2. Adjusted dose–response between MAC volume and mortality.** Hazard ratio (95% CI) versus no MAC from Cox models with a natural cubic spline of log2(volume+1), adjusted for sex, body mass index, STS score, chronic kidney disease, atrial fibrillation, and LDL cholesterol: (A) whole follow-up; (B) first-year mortality (censored at 1 year). Rug marks show the distribution of positive volumes; x-axis is log-scaled. *(source: output/fig2_spline)*

## Supplementary material

- **Table S1.** Characteristics by vital status. *(suppl_table1.csv)*
- **Table S2.** Characteristics by MAC volume category. *(table1_medgroup.csv)*
- **Table S3.** Sensitivity analyses of covariate selection (pre-specified clinical model; LASSO; AIC backward) and the preliminary 717.2 mm³ grouping (cohort-derived cut-off, maxstat-adjusted p=0.012). *(sensitivity_continuous.csv)*
- **Table S4.** Covariate profiles of first-year vs post-1-year mortality (post-hoc). *(suppl_period_riskfactors.csv)*
- **Figure S1.** First-year and landmark Kaplan–Meier curves by MAC presence. *(figS_landmark_binary)*

## References

1. Writing Committee. Diagnosis, classification, and management strategies for mitral annular calcification: a Heart Valve Collaboratory position statement. JACC Cardiovasc Interv. 2023. [verify volume/pages]
2. Abramowitz Y, Jilaihawi H, Chakravarty T, Mack MJ, Makkar RR. Mitral annulus calcification. J Am Coll Cardiol. 2015;66:1934–1948. [verify]
3. [REF — MAC and mortality after TAVR cohort study (reported HR ~1.95 for all-cause mortality); candidate: Abramowitz Y et al., JACC Cardiovasc Interv 2017 — verify]
4. Guerrero M, et al. A cardiac computed tomography–based score to categorize mitral annular calcification severity and predict valve embolization. JACC Cardiovasc Imaging. 2020;13:1945–1957. [verify]
5. Kang L, Chen W, Petrick NA, Gallas BD. Comparing two correlated C indices with right-censored survival outcome: a one-shot nonparametric approach. Stat Med. 2015;34:685–703.
6. Heinze G, Wallisch C, Dunkler D. Variable selection — a review and recommendations for the practicing statistician. Biom J. 2018;60:431–449.
7. [REF — landmark analysis methodology, e.g., Dafni U. Landmark analysis at the 25-year landmark point. Circ Cardiovasc Qual Outcomes. 2011;4:363–371. — verify]
8–15. [REF — to be completed: MAC prevalence/prognosis in AS; TAVI outcome predictors; STS score; depletion of susceptibles / time-varying effects in elderly cohorts]
