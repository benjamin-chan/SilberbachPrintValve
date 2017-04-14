# PrintValve case-control analysis

Attribute | Value
:---|:---
Principal investigator | Michael Silberbach, silberbm@ohsu.edu, 503-494-3189
Main contact | Michael Silberbach, silberbm@ohsu.edu, 503-494-3189
Statistician | Benjamin Chan, chanb@ohsu.edu, 503-494-5491
eIRB # | 


## Objective

Compare cases (patients diagnosed with bicuspid aortic valves) and controls
(patients diagnosed with tricuspid aortic valves), and to describe the
geometry among the cases


## Delieverables

1. Between cases and controls, compare orifice area, coaptation area, ceiling
plane and bottom plane centroid points, and the centroid line (“triple line”)
angle relative to the ceiling plane and bottom plane and the centroid line
length. Provide statistical tests comparing cases and control.
2. Within cases, compare same variables as above, as well as coaptation area
in terms of the chart review that describes type of BAV fusion (RL, RN,
functional BAV), degree of insufficiency, degree of stenosis, age, BSA.
Provide descriptive statistics or central tendency (means or medians) and
variation (standard deviations, interquartile ranges, etc.).
3. Prepare presentation of results, including tables and figures.
4. Provide a draft of a methods section describing the statistical analysis
suitable for a peer-reviewed manuscript or grant submission.


## Results

Due to missing data, the sample size for each group is not 50.

|type    |  n|
|:-------|--:|
|Case    | 48|
|Control | 49|

### Compare means

Raw, unadjusted comparisons.

|Variable                                               |Mean (SD), Cases |Mean (SD), Controls | Mean difference| P-value|Significance |
|:------------------------------------------------------|:----------------|:-------------------|---------------:|-------:|:------------|
|Total coaptation area, value                           |649 (189)        |515 (224)           |         133.609|   0.002|TRUE         |
|Orifice area                                           |637 (197)        |487 (120)           |         149.995|   0.000|TRUE         |
|Valve diameter                                         |32.1 (4.49)      |26.7 (4.59)         |           5.434|   0.000|TRUE         |
|Valve area                                             |825 (235)        |575 (199)           |         250.121|   0.000|TRUE         |
|Total valve coaptation area relative to valve diameter |20.1 (4.37)      |18.7 (5.57)         |           1.341|   0.191|FALSE        |
|Total valve coaptation area relative to orifice area   |1.06 (0.266)     |1.05 (0.321)        |           0.012|   0.840|FALSE        |
|Total valve coaptation area relative to valve area     |0.807 (0.191)    |0.893 (0.203)       |          -0.086|   0.035|TRUE         |
|Coaptation line length                                 |12.4 (3.75)      |13 (4)              |          -0.656|   0.407|FALSE        |

Adjusted for **orifice area**, `orifice_area`.
After adjusting for orifice area,
the difference in coaptation line lengths of cases and controls is significant.
*Interpretation:*
If we had one case patient and one control patient, both with the same orifice areas,
then their coaptation line lengths would be significantly different.

|Variable               | Mean difference| P-value|Significance |
|:----------------------|---------------:|-------:|:------------|
|Coaptation line length |          -2.213|   0.006|TRUE         |


### Compare total coaptation areas

![Boxplots](figures/boxplotsTotalCoaptationArea.png)
![Violin plots](figures/violinplotsTotalCoaptationArea.png)

### Compare leaflet coaptation fractions

![Line plot](figures/lineplotsLeafletsCoapFrac.png)

* Among cases
  * NR and LN are not significantly different (p = 0.635)
  * RL is significantly different from NR and LN (p = 0.000)
* Among controls
  * NR and LN are not significantly different (p = 0.979)
  * RL is not significantly different from NR and LN (p = 0.855)
  * NR, RL, and LN are not significantly different from each other (p = 0.876)
* Between cases and controls
  * RL is significantly different (p = 0.000)

### Compare coaptation lines in 3D space

Observed ceiling plane coordinates (before rotation).
[Interactive HTML](figures/webGL/sphereplotObservedCoapLines.html)

Predicted coaptation lines.
[Interactive HTML](figures/webGL/sphereplotPredictedCoapLines.html)

**Coaptation lines are not significantly different (p = 0.166).**
Adjust for scaled orifice area, `orificeAreaScaled`.

### Compare ceiling plane coordinates

![Plot](figures/plotCeilingPlaneCoordinates.png)

Predicted ceiling plane coordinates from MANOVA.
Adjust for scaled orifice area, `orificeAreaScaled`.

|type    | orificeAreaScaled| centroidCalcX| centroidCalcY|
|:-------|-----------------:|-------------:|-------------:|
|Case    |                 0|         15.02|          6.16|
|Control |                 0|         11.63|          6.66|

**Ceiling plane coordinates (before rotation) are significantly different (p = 0.000).**
Adjust for scaled orifice area, `orificeAreaScaled`.


## Method

Example coaptation line (triple point) is below.
An interactive representation of the coaptation line geometry is [here](https://ggbm.at/CeF95YMN).

![Line of coaptation](figures/Line_of_coaptation.png)

The ceiling points of all coaptation lines were shifted to coordinate (0, 0, 0).
Coaptation lines were compared using multivariate ANOVA (MANOVA) with the bottom plane coaptation line coordinates, ($x$, $y$, $z$), as the dependent vector.
Cohort membership (case versus control) was a main effect.
Orifice area (scaled) was included in the MANOVA model as a covariate as a proxy for body size.

Leaflet coaptation fractions were compared using a linear model.
The model included main effects for cohort membership (case versus control) and leaflet (NR, RL, or LN).
An interaction between cohort membership and leaflet was included, as well.
Linear contrasts were used to test comparisons.


## Outputs

* Observed coaptation line [interactive HTML](figures/webGL/sphereplotObservedCoapLines.html)
Predicted coaptation line [interactive HTML](figures/webGL/sphereplotPredictedCoapLines.html)
* Ceiling plane coordinates, before rotation plot: [PNG](figures/plotCeilingPlaneCoordinates.png), [SVG](figures/plotCeilingPlaneCoordinates.svg)
* Leaflet coaptation fractions comparison plots: [PNG](figures/lineplotsLeafletsCoapFrac.png), [SVG](figures/lineplotsLeafletCoapFrac.svg)
* Total coaptation area plots
  * Boxplots: [PNG](figures/boxplotsTotalCoaptationArea.png), [SVG](figures/boxplotsTotalCoaptationArea.svg)
  * Violin plots: [PNG](figures/violinplotsTotalCoaptationArea.png), [SVG](figures/violinplotsTotalCoaptationArea.svg)
* Complete analysis: [HTML](docs/index.html) or [Markdown](docs/index.md)


## References

Citation for [R](https://www.R-project.org/).

```
## 
## To cite R in publications use:
## 
##   R Core Team (2016). R: A language and environment for
##   statistical computing. R Foundation for Statistical Computing,
##   Vienna, Austria. URL https://www.R-project.org/.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {R: A Language and Environment for Statistical Computing},
##     author = {{R Core Team}},
##     organization = {R Foundation for Statistical Computing},
##     address = {Vienna, Austria},
##     year = {2016},
##     url = {https://www.R-project.org/},
##   }
## 
## We have invested a lot of time and effort in creating R, please
## cite it when using it for data analysis. See also
## 'citation("pkgname")' for citing R packages.
```


## Reproducibility

To recreate this analysis in this Git repository, execute `script.R` from the `scripts` directory.

```
$ cd scripts
$ /usr/bin/Rscript script.R
```

R package versions are listed in [`scripts/session.log`](scripts/session.log).
