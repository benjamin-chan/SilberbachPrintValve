# PrintValve case-control analysis

Attribute | Value
:---|:---
Principal investigator | Michael Silberbach, silberbm@ohsu.edu, 503-494-3189
Main contact | Michael Silberbach, silberbm@ohsu.edu, 503-494-3189
Statistician | Benjamin Chan, chanb@ohsu.edu, 503-494-5491
eIRB # | 
SilberbachPrintValve


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


### Coaptation line length

Summary from linear model estimating coaptation line length by case or control group status,
**adjusted for orifice area.**

**Model statistics**

| r.squared| adj.r.squared| sigma| statistic| p.value| df|   logLik|     AIC|     BIC| deviance| df.residual|
|---------:|-------------:|-----:|---------:|-------:|--:|--------:|-------:|-------:|--------:|-----------:|
|     0.194|         0.177| 3.515|    11.343|       0|  3| -258.048| 524.097| 534.396| 1161.443|          94|

**ANOVA table**

|term              | estimate| std.error| statistic| p.value|
|:-----------------|--------:|---------:|---------:|-------:|
|(Intercept)       |    11.59|      0.53|     21.69|   0.000|
|typeControl       |     2.21|      0.79|      2.81|   0.006|
|orificeAreaScaled |     1.85|      0.40|      4.67|   0.000|

**Predicted values**, and 95% confidence intervals for the mean, and 95% prediction intervals

|type    | orificeAreaScaled|scaling                      |   fit| lowerConf| upperConf| lowerPred| upperPred|
|:-------|-----------------:|:----------------------------|-----:|---------:|---------:|---------:|---------:|
|Case    |                -1|-1 SD from mean orifice area |  9.74|      8.24|     11.25|      2.60|     16.88|
|Case    |                 0|Mean orifice area            | 11.59|     10.53|     12.65|      4.53|     18.65|
|Case    |                 1|+1 SD from mean orifice area | 13.44|     12.34|     14.55|      6.38|     20.51|
|Control |                -1|-1 SD from mean orifice area | 11.96|     10.86|     13.05|      4.89|     19.02|
|Control |                 0|Mean orifice area            | 13.81|     12.76|     14.86|      6.75|     20.86|
|Control |                 1|+1 SD from mean orifice area | 15.66|     14.16|     17.15|      8.52|     22.79|

**Interpretation**
Coaptation line length in the control population is, on average,
2.21 mm longer 
(95% CI: 
0.67, 
3.76);
p-value:
0.006)
than in the case population,
adjusted for orifice area.


### Coaptation line direction

Polar plots of coaptation line angles

![Latitude](figures/plotLatitude.png)
![Longitude](figures/plotLongitude.png)

**NEED TO FILL IN**


## Method

Example coaptation line (triple point) is below.
An interactive representation of the coaptation line geometry is [here](https://ggbm.at/CeF95YMN).

![Line of coaptation](figures/Line_of_coaptation.png)


## Outputs

* Polar plots of coaptation line angles
  * Latitude: [PNG](figures/plotLatitude.png), [SVG](figures/plotLatitude.svg)  
  * Longitude: [PNG](figures/plotLongitude.png), [SVG](figures/plotLongitude.svg)  
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

Citaion for the [Directional](https://CRAN.R-project.org/package=Directional) package.

```
## 
## To cite package 'Directional' in publications use:
## 
##   Michail Tsagris, Giorgos Athineou and Anamul Sajib (2016).
##   Directional: Directional Statistics. R package version 2.3.
##   https://CRAN.R-project.org/package=Directional
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {Directional: Directional Statistics},
##     author = {Michail Tsagris and Giorgos Athineou and Anamul Sajib},
##     year = {2016},
##     note = {R package version 2.3},
##     url = {https://CRAN.R-project.org/package=Directional},
##   }
## 
## ATTENTION: This citation information has been auto-generated from
## the package DESCRIPTION file and may need manual editing, see
## 'help("citation")'.
```


## Reproducibility

To recreate this analysis in this Git repository, execute `script.R` from the `scripts` directory.

```
$ cd scripts
$ /usr/bin/Rscript script.R
```

R package versions are listed in [`scripts/session.log`](scripts/session.log).
