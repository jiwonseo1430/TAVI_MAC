# Adversarial Reviewer Checklist

## How to run this
Start a **fresh session / subagent** with no access to `plan/` and no memory of why choices were made.
Load only: `manuscript/`, `analysis/output/`, figures, tables, supplement.

Prompt: *"You are Reviewer 2 at a top-tier cardiology journal. You are skeptical and you are looking for reasons to reject. Do not summarize the paper's strengths. Work through the checklist below and report every discrepancy, unsupported claim, and methodological weakness, with file and line references. If a number cannot be verified from the outputs provided, flag it as unverifiable."*

Output format: a table of `Severity (Major/Minor) | Location | Finding | What a reviewer will say`.

---

## A. Internal consistency (highest yield — check first)
- [ ] Does every number in the abstract appear identically in the body, tables, and supplement?
- [ ] Do N values reconcile across: CONSORT/flow diagram → Table 1 → each model → each figure? Account for every excluded patient.
- [ ] Are cut-offs and thresholds stated identically everywhere? (e.g., a velocity threshold quoted as ≥2.8 in one place and ≥3.2 in another is an automatic major flag)
- [ ] Do the covariates listed in the Methods match the covariates actually in the main-table model — and in the supplemental model?
- [ ] Do figure legends match what the figure actually plots (axis units, group labels, n per group)?
- [ ] Are abbreviations defined at first use and used consistently thereafter?

## B. Statistical adequacy
- [ ] Events-per-variable: is EPV ≥10 for every multivariable model? If not, is it acknowledged?
- [ ] Is variable selection method stated (and justified if stepwise)? Are the selection criteria pre-specified or post-hoc?
- [ ] Proportional hazards assumption: tested? reported?
- [ ] Are continuous predictors modeled linearly without checking non-linearity? If splines were used, is the knot placement stated?
- [ ] Rescaling of continuous variables (per 1 unit vs per SD vs per 10 units) — stated and consistent with the HR magnitude reported?
- [ ] Multiple comparisons: how many models/subgroups were fitted? Is any adjustment or acknowledgment present?
- [ ] Incremental value (ΔC-index / NRI / IDI): is the **base model** explicitly defined? Is the comparison fair (same N, same events, same follow-up)?
- [ ] Are NRI/IDI computed with an appropriate method for censored data, and is the package/approach named?
- [ ] Model comparison (AIC/BIC): computed on an identical complete-case dataset? State N.
- [ ] Are confidence intervals given for every point estimate that carries a claim?
- [ ] Subgroup findings: presented as hypothesis-generating, or overstated as definitive? Is the interaction p-value reported (not just stratified p-values)?

## C. Plausibility of the data itself
- [ ] Are physiologic values within plausible ranges? (Scan Table 1 and any physiology-derived variables for impossible or implausible means/SDs.)
- [ ] Do SDs imply values crossing biologically impossible bounds?
- [ ] Are follow-up duration, event counts, and event rates mutually consistent?
- [ ] For derived indices: is the formula stated, and does the reported range match the formula?

## D. Clustering / unsupervised analyses (if applicable)
- [ ] Is the algorithm choice justified against at least one alternative, with the comparison **reported**, not just asserted?
- [ ] Are internal validity metrics (silhouette, Dunn, Jaccard stability) reported — including when they are weak?
- [ ] Is a weak separation metric addressed head-on in Limitations rather than omitted?
- [ ] Is cluster number selection pre-specified or chosen post-hoc on outcome?
- [ ] Is there any external or temporal validation? If none, is that stated as a limitation?

## E. Claims vs evidence
- [ ] Does any Discussion sentence claim causation from an observational design?
- [ ] Does the Conclusion claim more than the primary endpoint result supports?
- [ ] Is "predicts" used where only "is associated with" is supported?
- [ ] Is prognostic/discriminative improvement claimed without a formal incremental-value test?
- [ ] Are the Limitations honest and specific, or generic boilerplate?

## F. Reporting completeness
- [ ] Trial/registry number present and correct?
- [ ] IRB approval and consent statement present?
- [ ] Missing data: quantified per variable, handling method stated?
- [ ] Relevant reporting guideline (STROBE / TRIPOD / CONSORT) followed? Any required item missing?
- [ ] Software and package versions named?

## G. Peer-review response letters (when applicable)
- [ ] Does every "Changes made" bullet correspond to text that **actually exists in the current manuscript**? Verify by opening the file and locating the sentence.
- [ ] Are response and change clearly separated (rationale vs. edit)?
- [ ] Are page/line references correct against the current version, not a previous one?
- [ ] Is any reviewer sub-question left unanswered?
- [ ] Is the tone non-defensive — concedes what should be conceded, defends only what is defensible with evidence?
