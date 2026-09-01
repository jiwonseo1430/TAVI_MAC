# Quantified Mitral Annular Calcification and First-Year Mortality after Transcatheter Aortic Valve Implantation

**Authors:** [TO CONFIRM — author list, affiliations, corresponding author]

**Word count:** ~2,900 body (excluding abstract, references, legends); abstract 248

---

## Abstract

**Background:** Mitral annular calcification (MAC) is common in patients undergoing transcatheter aortic valve implantation (TAVI), but prior prognostic studies used qualitative grading, and the time course of the associated risk is unknown.

**Methods:** We retrospectively analyzed 525 consecutive TAVI patients ([TO CONFIRM: center, period]). MAC volume was quantified on pre-procedural computed tomography (CT). Exposures were MAC presence, log2-transformed volume (hazard ratio [HR] per doubling), and volume categories. The outcome was all-cause mortality. Cox models were adjusted for covariates selected by backward elimination with the MAC exposure forced in; because proportional hazards were violated for MAC, period-specific HRs (0–1 and >1 year) were estimated.

**Results:** MAC was present in 256 patients (48.8%). Over a median follow-up of 3.2 years, 102 patients (19.4%) died (24.6% with MAC vs 14.5% without; p=0.005). MAC presence was independently associated with mortality (adjusted HR 1.92, 95% CI 1.27–2.91), as was volume (HR per doubling 1.09, 95% CI 1.04–1.15). The association was present in the first year (MAC presence: HR 3.46, 95% CI 1.90–6.31) but not thereafter (HR 0.99, 95% CI 0.54–1.80; interaction p=0.003). Adding MAC did not significantly improve model discrimination (C-index 0.725 to 0.742; p=0.15).

**Conclusions:** CT-quantified MAC is independently associated with mortality after TAVI, and the excess risk is observed only during the first post-procedural year. MAC quantification may help identify candidates for closer early follow-up, pending prospective evaluation.

**Keywords:** mitral annular calcification; transcatheter aortic valve implantation; computed tomography; mortality; aortic stenosis

---

## Introduction

Mitral annular calcification (MAC) is a chronic degenerative process of the mitral annulus fibrosus that shares risk factors and pathobiology with atherosclerosis and is highly prevalent in elderly patients with aortic stenosis; up to one-half of patients evaluated for transcatheter aortic valve implantation (TAVI) have some degree of MAC [1,2]. In TAVI candidates, MAC has been associated with all-cause and cardiovascular mortality [3], and severe MAC complicates transcatheter and surgical treatment of mitral disease [1].

Most prognostic studies of MAC in the TAVI population have relied on qualitative or semi-quantitative severity grading, which suffers from inter-observer variability and threshold effects. Cardiac computed tomography (CT), which is universally acquired for TAVI planning, permits volumetric quantification of MAC [4], but whether quantified MAC burden carries prognostic information after TAVI — and over what time horizon the associated risk operates — has not been established.

We therefore examined the association between CT-quantified MAC volume and all-cause mortality in a consecutive TAVI cohort and characterized the time structure of the associated risk.

## Methods

### Study population

We retrospectively studied 525 consecutive patients who underwent TAVI for severe aortic stenosis at [TO CONFIRM: center] between [TO CONFIRM: enrollment period]. [TO CONFIRM: number screened, exclusions (e.g., non-analyzable CT), and a participant flow diagram; definition of severe aortic stenosis.] Clinical, laboratory, and echocardiographic variables were collected from electronic records. [TO CONFIRM: definitions of comorbidities (e.g., CKD criterion), STS score version.] Death was ascertained from [TO CONFIRM: source]. The study was approved by the institutional review board of [TO CONFIRM] with a waiver of informed consent [TO CONFIRM]. All data were de-identified before analysis. The report follows the STROBE recommendations.

### CT quantification of MAC

MAC was assessed on pre-procedural cardiac CT. [TO CONFIRM: scanner(s), acquisition protocol, contrast phase.] MAC volume was measured volumetrically [TO CONFIRM: software, attenuation threshold, number of readers, blinding to outcome, and inter-/intra-observer reproducibility]; volumes measured on contrast-enhanced scans were transformed to the non-contrast scale in [TO CONFIRM: n] patients using [TO CONFIRM: transformation method]. The primary exposure was MAC volume, log2(volume + 1)-transformed so that HRs are expressed per doubling of volume. Secondary parameterizations were MAC presence (volume >0) and a three-level volume category (no MAC; positive volume at or below the median of positive volumes [108.6 mm³], "low"; above the median, "high"); this cut is used consistently in all tables and figures.

### Outcome and follow-up

The outcome was all-cause death, measured from the TAVI procedure to death or last follow-up. Cause of death was not available. One patient who died on the day of the procedure was assigned a survival time of 0.5 days in analyses requiring positive time.

### Statistical analysis

Continuous variables are summarized as mean ± SD (median [IQR] for triglycerides, which were right-skewed) and compared with Welch's t-test or ANOVA (Wilcoxon or Kruskal–Wallis tests for triglycerides); categorical variables as n (%) with chi-square or Fisher's exact tests.

Candidate covariates for multivariable modeling were the demographic, clinical, and laboratory variables and LVEF listed in Table 2. Echocardiographic hemodynamic variables (E/e′, right ventricular systolic pressure [RVSP], mitral regurgitation grade) were not considered as covariates because they are plausible mediators of MAC-related risk and because of missingness (12.2%, 7.4%, and 2.1%, respectively); all other candidate covariates were complete except HDL cholesterol (3 missing). Variables with univariable p<0.10 entered the multivariable model; because total and LDL cholesterol are collinear, only LDL was retained (rule fixed a priori). Backward elimination was performed with a retention threshold of p<0.05, with the MAC exposure forced into all models. All primary and secondary models used the full cohort (N=525); the univariable HDL model used 522 patients. Lipids were analyzed per 10 mg/dL.

Dose–response was examined with a natural cubic spline of log2(volume + 1) (3 df, interior knots at the tertiles of positive volumes) in the adjusted model, with a likelihood-ratio test for nonlinearity. Because the exposure distribution contains a point mass at zero (51.2% of patients), a post-hoc analysis restricted to MAC-positive patients assessed whether the continuous association was separable from the presence–absence contrast, and a post-hoc test for trend across the volume categories (ordinal score) was performed.

The proportional-hazards (PH) assumption was assessed with scaled Schoenfeld residuals for every parameterization. Because it was violated for the MAC exposure, period-specific HRs for 0–1 year and >1 year were estimated from a counting-process model split at 365.25 days (period difference tested by a Wald test of the interaction contrast); this remedy was specified in the analysis plan after the violation was detected. Post-hoc analyses comprised: a further split of the first year at 30 days; Kaplan–Meier analyses within the first year and among 1-year survivors (1-year landmark); the covariate profiles of first-year versus later mortality (identical covariates plus age); the trend test; and the MAC-positive-only analysis. Post-hoc analyses are labeled as such and should be considered hypothesis-generating; no adjustment for multiple testing was applied.

Incremental discrimination was assessed by comparing Harrell's C-index of the clinical covariate model with and without MAC (method of Kang et al. [5]). Three pre-specified sensitivity analyses addressed covariate selection: (S1) a clinically pre-specified model (STS score, chronic kidney disease, atrial fibrillation, MAC); (S2) LASSO-penalized Cox regression with MAC unpenalized (10-fold cross-validation, λ at one standard error; N=521 after exclusion of 3 patients with missing HDL and the day-0 death, which the software cannot accommodate); and (S3) AIC-based backward elimination. The three-level grouping used in an initial exploratory analysis of this cohort (cut-off 717.2 mm³) was retained as a sensitivity analysis; this cut-off was derived from the present cohort by maximally selected rank statistics (adjusted p=0.012) and was not used for primary inference.

Analyses used R version 4.5.0 (survival, survminer, glmnet, MASS, compareC, maxstat) with a fixed random seed; session information is recorded with every script output. Two-sided p<0.05 was considered significant.

## Results

### Cohort

Of 525 patients (mean age 81.9 ± 5.2 years; 56.4% female; mean STS score 4.8 ± 3.8%), MAC was present on CT in 256 (48.8%). Among MAC-positive patients, the median volume was 108.6 mm³ (IQR 24.2–352.9; range 0.1–7,917.3). Patients with MAC had higher body mass index, more atrial fibrillation (25.0% vs 17.5%, p=0.045), and higher E/e′ (22.7 ± 9.2 vs 19.9 ± 9.8, p=0.002); other characteristics, including age, sex, STS score, and LVEF, were similar (Table 1).

### Mortality

Over a median follow-up of 3.2 years (reverse Kaplan–Meier; observed median 2.6 years, IQR 1.3–4.1), 102 patients (19.4%) died: 63 (24.6%) with MAC versus 39 (14.5%) without (p=0.005). Fifty-seven deaths occurred within the first year and 45 thereafter. Kaplan–Meier survival was lower with MAC (log-rank p=0.006) and across volume categories (p=0.021) (Figure 1A–B).

### MAC and mortality

In univariable analysis, mortality was associated with MAC volume (HR per doubling 1.08, 95% CI 1.03–1.14), MAC presence (HR 1.74, 95% CI 1.17–2.60), and both volume categories (low: HR 1.67, 95% CI 1.04–2.67; high: HR 1.82, 95% CI 1.14–2.91) (Table 2).

Backward elimination retained sex, body mass index, STS score, chronic kidney disease, atrial fibrillation, and LDL cholesterol. With these covariates, MAC presence was independently associated with mortality (HR 1.92, 95% CI 1.27–2.91; p=0.002), as were MAC volume (HR 1.09 per doubling, 95% CI 1.04–1.15; p<0.001) and the volume categories (low: HR 1.83, 95% CI 1.12–2.97; high: HR 2.02, 95% CI 1.25–3.27; post-hoc p for trend=0.003) (Table 3). The MAC coefficient was materially unchanged in the full candidate model that included LVEF (HR 1.09, 95% CI 1.03–1.15). Variance inflation factors were <1.2 in the final model (maximum 1.29 in the full candidate model).

The shape of the association was not uniform across the volume range. In the adjusted spline analysis over the whole follow-up (Figure 2A), the hazard was elevated over most of the positive range in a nonlinear pattern (nonlinearity p=0.010): a rise at small volumes, an approximate plateau through the mid-range, and a steep increase above approximately 500 mm³ (point estimates vs no MAC of approximately 2.0 at 717 mm³ and 4.6 at 2,000 mm³; confidence bands in Figure 2). Consistent with this, the adjusted HRs of the low and high median-split categories were similar (1.83 vs 2.02), and in the post-hoc analysis restricted to MAC-positive patients the linear per-doubling association was small and not significant (HR 1.04, 95% CI 0.94–1.15; 63 deaths). The continuous association in the full cohort therefore predominantly reflects the contrast between absent and present MAC, together with high hazards at the extreme of the volume distribution, rather than a smooth gradient across the whole positive range.

### Time structure of the association

The PH assumption was violated for the MAC exposure (Schoenfeld p=0.021 continuous; p=0.03 for the median-split categories; the 717.2 mm³ grouping did not show a significant violation, p=0.12). In period-specific models (Table 4), the association was strong in the first year (per doubling: HR 1.16, 95% CI 1.08–1.24; MAC presence: HR 3.46, 95% CI 1.90–6.31; both p<0.001) and absent thereafter (per doubling: HR 0.99, 95% CI 0.91–1.08; MAC presence: HR 0.99, 95% CI 0.54–1.80); interaction p=0.005 and 0.003, respectively. Within the first year the dose–response was compatible with log-linearity (nonlinearity p=0.18; Figure 2B).

In the post-hoc three-interval analysis, the first-year excess was not limited to the periprocedural window: the adjusted HR for MAC presence was 3.67 (95% CI 1.83–7.35) for days 31–365, with a similar but imprecise estimate for days 0–30 (HR 2.90, 95% CI 0.91–9.30; 14 deaths). Kaplan–Meier curves within the first year separated across volume categories (log-rank p<0.0001; Figure 1C), whereas among the 447 patients surviving one year no significant differences were observed (volume categories: log-rank p=0.41, Figure 1D; MAC presence: p=0.71, Figure S1); given 45 late deaths, the confidence interval of the late HR does not exclude moderate effects.

The covariate profile of mortality also shifted at one year (post-hoc; Table S4): first-year deaths were associated with MAC volume, chronic kidney disease, and LDL (atrial fibrillation borderline, p=0.053), but not with age (HR 0.97 per year, p=0.19), whereas deaths beyond one year were associated with age (HR 1.07 per year, p=0.020) and STS score (which was associated in both periods but more strongly late: HR 1.06 first year, 1.14 thereafter), with no association for MAC, chronic kidney disease, or LDL.

### Discrimination and sensitivity analyses

Adding MAC to the clinical covariate model did not significantly improve Harrell's C-index (0.725 to 0.742 for the continuous exposure, ΔC p=0.15; 0.725 to 0.746 for the volume categories, p=0.062) (Table S5). The adjusted continuous association was consistent across covariate-selection strategies: HR per doubling 1.07 (95% CI 1.02–1.13) in the clinically pre-specified model and 1.09 (95% CI 1.04–1.15) with AIC-based selection; the LASSO procedure retained no clinical covariates, so its estimate (1.08, 95% CI 1.03–1.14) corresponds to the unadjusted association in that subset (N=521). In the sensitivity analysis using the exploratory 717.2 mm³ grouping, the high-MAC association was large (HR 4.94, 95% CI 2.65–9.22), whereas the low-MAC association was not robust across selection strategies (p=0.12 in the pre-specified clinical model and p=0.067 with LASSO) (Table S3).

## Discussion

In this consecutive cohort of 525 TAVI patients, CT-quantified MAC was independently associated with all-cause mortality. The principal findings are, first, that the association is driven by the presence of MAC and by very large calcific burdens rather than by a smooth gradient across the whole volume range; and second, that the association has a distinct time structure — an approximately 3.5-fold adjusted hazard during the first post-procedural year, with no detectable association thereafter (interaction p=0.003).

Our findings extend prior work associating MAC with mortality after TAVI [3] in two ways. First, volumetric quantification on routinely acquired planning CT replaces qualitative grading, and the analysis makes explicit which contrasts carry the risk information: presence versus absence (adjusted HR 1.92) and the extreme upper tail of the volume distribution (adjusted spline; HR ≈4.9 for the exploratory ≥717 mm³ category), whereas among MAC-positive patients the per-doubling association was small and non-significant (HR 1.04). This threshold-like pattern argues for reporting MAC both as presence and as burden, rather than assuming log-linearity. Second, the first-year concentration of risk is, to our knowledge, a novel observation in this population.

The first-year excess was not merely periprocedural: the adjusted hazard was already high in days 31–365 (HR 3.67), and the 0–30-day estimate, although imprecise, was of similar magnitude. We propose two complementary, non-exclusive explanations for the attenuation after one year. Clinically, in a population with a mean age of 82 years, mortality beyond the first year is increasingly dominated by age-related, multifactorial background risk; consistent with this, late deaths were associated with age and STS score but not with MAC, chronic kidney disease, or LDL, whereas first-year deaths showed the opposite pattern. Statistically, depletion of susceptibles will contribute: the most vulnerable patients with MAC die during the first year, leaving a selected, more robust group — a caveat that also warns against interpreting the late curves (in which the high-MAC group appears to fare well) as any protective effect. We also note that adjustment slightly increased the MAC estimates (e.g., presence: 1.74 to 1.92), reflecting negative confounding by body mass index and LDL, both of which behaved as markers of nutritional status rather than as conventional risk factors in this elderly cohort. Because cause of death was unavailable, mechanistic interpretations remain speculative.

These observations suggest a potential clinical use: MAC quantification from the TAVI planning CT identifies patients whose excess mortality risk is concentrated in a defined window, and could be evaluated prospectively as a trigger for closer surveillance and comorbidity optimization during the first post-procedural year. Because the improvement in model discrimination was not statistically significant, MAC should be regarded as a prognostic marker rather than as a component of risk scores, and no change in management can be recommended from these data.

### Limitations

This is a retrospective single-center study; unmeasured confounding cannot be excluded, and no procedural variables (valve type, access route, procedural era, paravalvular leak, new pacemaker) were available for adjustment — a relevant limitation for a finding concerning early post-procedural mortality. Cause of death was unavailable, precluding competing-risks analyses and direct separation of the proposed mechanisms. Echocardiographic hemodynamic variables (E/e′, RVSP, mitral regurgitation) were not included as covariates, as potential mediators and because of missingness; residual confounding through these pathways is possible, although they may equally lie on the causal pathway of MAC-related risk. The exposure distribution is zero-inflated, and the per-doubling HR blends the presence contrast with the volume gradient; the positive-only analysis addresses this but had limited power (63 deaths). The full candidate model had 7.8 events per parameter, below the conventional threshold of 10. The claim that the association is limited to the first year rests on a non-significant late-period estimate whose confidence interval reached 1.80; it is a statement of absence of evidence, not of equivalence. All time-structure analyses beyond the 1-year split, the trend test, and the positive-only analysis were post-hoc. Reader blinding and measurement reproducibility for MAC volume are reported in [TO CONFIRM]; the volume cut-points (median split; 717.2 mm³) are cohort-defined and require external validation. Finally, numerous secondary and sensitivity analyses were performed without multiplicity adjustment.

### Conclusions

CT-quantified MAC is independently associated with mortality after TAVI. The association is driven by MAC presence and extreme calcific burden and is observed only during the first post-procedural year. MAC assessment on routine planning CT may help identify patients who warrant closer early follow-up; this strategy, and the prognostic thresholds suggested here, require prospective validation.

---

## Tables

- **Table 1.** Baseline characteristics by MAC presence. *(source: output/table1_binary.csv)*
- **Table 2.** Univariable Cox regression for all-cause mortality. *(source: output/table2.csv)*
- **Table 3.** Multivariable Cox models: MAC volume (continuous, primary), MAC presence, and volume categories. *(source: output/table3c_final.csv, table3c_binary.csv, table3c_categories.csv)*
- **Table 4.** Period-specific adjusted hazard ratios (0–1 year vs >1 year). *(source: output/table_time_interval.csv)*

## Figure legends

**Figure 1. Kaplan–Meier survival after TAVI.** (A) By MAC presence and (B) by MAC volume category (no MAC; positive volume ≤ vs > the median of positive volumes, 108.6 mm³), both over the whole follow-up with the x-axis truncated at 7 years; y-axis 0–1. (C) Within the first year after TAVI, by volume category (x-axis in months; y-axis truncated to 0.75–1.00 to resolve the curves). (D) Among 1-year survivors (1-year landmark), by volume category (y-axis truncated to 0.50–1.00). Panels C and D are post-hoc analyses. P-values are log-rank. Numbers at risk are shown below each panel; curve segments beyond ~5 years reflect few patients at risk. *(source: output/fig1_km_4panel)*

**Figure 2. Adjusted association between MAC volume and mortality.** Hazard ratio (95% CI) versus no MAC from Cox models with a natural cubic spline of log2(volume+1), adjusted for sex, body mass index, STS score, chronic kidney disease, atrial fibrillation, and LDL cholesterol: (A) whole follow-up; (B) first-year mortality (censored at 1 year). Rug marks show the distribution of positive volumes; x-axis log-scaled. *(source: output/fig2_spline)*

## Supplementary material

- **Table S1.** Characteristics by vital status. *(suppl_table1.csv)*
- **Table S2.** Characteristics by MAC volume category (median split). *(table1_medgroup.csv)*
- **Table S3.** Sensitivity analyses of covariate selection and the exploratory 717.2 mm³ grouping. *(sensitivity_continuous.csv)*
- **Table S4.** Covariate profiles of first-year vs post-1-year mortality (post-hoc). *(suppl_period_riskfactors.csv)*
- **Table S5.** Incremental discrimination (Harrell's C-index). *(table4c.csv)*
- **Figure S1.** First-year and landmark Kaplan–Meier curves by MAC presence. *(figS_landmark_binary)*

## References

1. Writing Committee. Diagnosis, classification, and management strategies for mitral annular calcification: a Heart Valve Collaboratory position statement. JACC Cardiovasc Interv. 2023. [verify volume/pages]
2. Abramowitz Y, Jilaihawi H, Chakravarty T, Mack MJ, Makkar RR. Mitral annulus calcification. J Am Coll Cardiol. 2015;66:1934–1948. [verify]
3. [REF — MAC and mortality after TAVR cohort study (reported HR ~1.95 for all-cause mortality); candidate: Abramowitz Y et al., JACC Cardiovasc Interv 2017 — verify]
4. Guerrero M, et al. A cardiac computed tomography–based score to categorize mitral annular calcification severity and predict valve embolization. JACC Cardiovasc Imaging. 2020;13:1945–1957. [verify]
5. Kang L, Chen W, Petrick NA, Gallas BD. Comparing two correlated C indices with right-censored survival outcome: a one-shot nonparametric approach. Stat Med. 2015;34:685–703.
6. Heinze G, Wallisch C, Dunkler D. Variable selection — a review and recommendations for the practicing statistician. Biom J. 2018;60:431–449.
7. [REF — landmark analysis methodology — verify]
8–15. [REF — to be completed: MAC prevalence/prognosis in AS; TAVI outcome predictors; STS score; depletion of susceptibles / time-varying effects in elderly cohorts]
