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

Unadjusted/unscaled comparisons, case vs controls

![Boxplots](figures/boxplots.png)

|variable                                               |meanSDCases    |meanSDControls | difference|
|:------------------------------------------------------|:--------------|:--------------|----------:|
|Body surface area                                      |2.03 (0.202)   |1.87 (0.313)   |     0.1600|
|NR fraction                                            |0.391 (0.12)   |0.335 (0.0682) |     0.0561|
|RL fraction                                            |0.228 (0.133)  |0.331 (0.0906) |    -0.1030|
|LN fraction                                            |0.381 (0.0945) |0.334 (0.0812) |     0.0469|
|Total coaptation area, value                           |649 (189)      |515 (224)      |   134.0000|
|Total coaptation area, calculated                      |649 (189)      |516 (224)      |   134.0000|
|Orifice area                                           |637 (197)      |487 (120)      |   150.0000|
|Valve diameter                                         |32.1 (4.49)    |26.7 (4.59)    |     5.4300|
|Valve area                                             |825 (235)      |575 (199)      |   250.0000|
|Total valve coaptation area relative to valve diameter |20.1 (4.37)    |18.7 (5.57)    |     1.3400|
|Total valve coaptation area relative to orifice area   |1.06 (0.266)   |1.05 (0.321)   |     0.0121|
|Total valve coaptation area relative to valve area     |0.807 (0.191)  |0.893 (0.203)  |    -0.0855|
|Coaptation line length                                 |12.4 (3.75)    |13 (4)         |    -0.6560|
|Ceiling centroid point X-coordinate                    |9.73 (3.96)    |6.96 (2.55)    |     2.7700|
|Ceiling centroid point Y-coordinate                    |13.8 (3.72)    |10.8 (3.25)    |     3.0100|

Adjusted for **orifice area.**
p-values adjusted for multiple comparisons.

|variable                                               | difference|  seDiff|  pAdjust|sig   |
|:------------------------------------------------------|----------:|-------:|--------:|:-----|
|Body surface area                                      |     0.0880|  0.0568| 0.175000|FALSE |
|NR fraction                                            |     0.0595|  0.0219| 0.015900|TRUE  |
|RL fraction                                            |    -0.1110|  0.0255| 0.000493|TRUE  |
|LN fraction                                            |     0.0511|  0.0198| 0.018800|TRUE  |
|Total coaptation area, value                           |    24.2000| 38.4000| 0.532000|FALSE |
|Total coaptation area, calculated                      |    24.1000| 38.4000| 0.532000|FALSE |
|Valve diameter                                         |     3.2600|  0.8740| 0.002350|TRUE  |
|Valve area                                             |   147.0000| 42.0000| 0.003350|TRUE  |
|Total valve coaptation area relative to valve diameter |    -0.7950|  1.0000| 0.501000|FALSE |
|Total valve coaptation area relative to orifice area   |     0.0651|  0.0652| 0.408000|FALSE |
|Total valve coaptation area relative to valve area     |    -0.1120|  0.0439| 0.018800|TRUE  |
|Coaptation line length                                 |    -2.2100|  0.7880| 0.015900|TRUE  |
|Ceiling centroid point X-coordinate                    |     1.9700|  0.7230| 0.015900|TRUE  |
|Ceiling centroid point Y-coordinate                    |     2.1000|  0.7550| 0.015900|TRUE  |


### 3D plot

[Interactive HTML](figures/webGL/sphereplot.html)


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

Cases vs controls
![Spherical coordinates](figures/plotSpherical.png)

Cases vs controls and aortic stenosis
![Spherical coordinates by aortic stenosis](figures/plotSphericalStenosis.png)

Cases vs controls and aortic regurgitation
![Spherical coordinates by aortic regurgitation](figures/plotSphericalRegurgitation.png)

Circular summary statistics.

|type                               | latitude| longitude|
|:----------------------------------|--------:|---------:|
|All                                |    -75.3|       156|
|Cases                              |    -73.6|       161|
|Controls                           |    -77.1|       150|
|Aortic stenosis: none-trivial      |    -75.4|       153|
|Aortic stenosis: mild-severe       |    -74.2|       179|
|Aortic regurgitation: none-trivial |    -75.3|       152|
|Aortic regurgitation: mild-severe  |    -75.7|       175|

There does not appear to be statistically different directions by 
group (case vs control), 
aortic stenosis (none-trivial vs mild-severe), or 
aortic regurgitation (none-trivial vs mild-severe). 

|effect                                            |  test| p.value| kappa|
|:-------------------------------------------------|-----:|-------:|-----:|
|Group: case vs control                            | 1.770|   0.174|  21.7|
|Aortic stenosis: none-trivial vs mild-severe      | 1.520|   0.221|  21.7|
|Aortic regurgitation: none-trivial vs mild-severe | 0.196|   0.822|  21.7|


## Method

Example coaptation line (triple point) is below.
An interactive representation of the coaptation line geometry is [here](https://ggbm.at/CeF95YMN).

![Line of coaptation](figures/Line_of_coaptation.png)


## Outputs

* Plots of body size, valve area, and coaptation line length variables (same information in different formats)
  * Density plots: [PNG](figures/densityplots.png), [SVG](figures/densityplots.svg)
  * Scatterplots: [PNG](figures/scatterplots.png), [SVG](figures/scatterplots.svg)
  * Boxplots: [PNG](figures/boxplots.png), [SVG](figures/boxplots.svg)
  * Violin plots: [PNG](figures/violinplots.png), [SVG](figures/violinplots.svg)
* Spherical cooardinates of coaptation lines
  * Cases vs controls: [PNG](figures/plotSpherical.png), [SVG](figures/plotSpherical.svg)
  * Cases vs controls and aortic stenosis: [PNG](figures/plotSphericalStenosis.png), [SVG](figures/plotSphericalStenosis.svg)
  * Cases vs controls and aortic regurgitation: [PNG](figures/plotSphericalRegurgitation.png), [SVG](figures/plotSphericalRegurgitation.svg)
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
