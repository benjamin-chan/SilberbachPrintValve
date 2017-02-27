---
title: "PrintValve case-control analysis"
date: "2017-02-27 11:26:29"
author: Benjamin Chan (chanb@ohsu.edu)
output:
  html_document:
    toc: true
    theme: simplex
---

# Read anonymized data

Read and clean data.
R code is suppressed for brevity.
See [`read.Rmd`](../scripts/read.Rmd) for full details.

1. Read the Excel file
1. Rename columns
1. Remove patients with missing values for `nl`, `rl`, and `ln`
  * 2 cases, 1 control
1. Remove extraneous columns
1. Add logical indicator for `type` *Case*
1. Fix sign of `centroidBottomZ`
  * All values should be $<0$; a few were $>0$
1. Rotate the calculated centroid coordinates relative to "north", as defined by `nstar_X` and `nstar_Y`.
  * Rotate both the calculated and bottom centroids
1. Convert cartesian coordinates of rotated coaptation line to spherical coordinates
  * See function [`cart2sph`](../lib/cart2sph.R)
  * $\rho$ = radial distance
  * $\theta$ = latitude (i.e., polar angle or inclination) bounded between $(0, \pi)$ or $(0^{\circ}, 180^{\circ})$; default units is radians
  * $\phi$ = langitude (i.e., azimuthal angle or direction) bounded between $(-\pi, \pi)$ or $(-180^{\circ}, +180^{\circ})$; default units is radians
  * $\rho, \theta, \phi$ will be used to describe the coaptation line
1. Shift cartesian coordinates of the coaptation line to start at (0, 0, 0)
1. Normalize the orientation of the coaptation line to the unit sphere
1. Scale body size measures, `bsa` and `orifice_area`, to have mean = 0 and SD = 1
1. Lump categories of aortic stenosis, `as`, and aortic regurgitation (insufficiency), `ar`

Example coaptation line (triple point) is below.
An interactive representation of the coaptation line geometry is [here](https://ggbm.at/CeF95YMN).

![Line of coaptation](../figures/Line_of_coaptation.png)



Check calculation of `magnitude` against given `coapt_line_length`; it should be 1.0


```
## Correlation between coapt_line_length and calculated magnitude is: 1.00000
```

Check correlation between body surface area, `bsa`, and other size variables.


|                    |       bsa|
|:-------------------|---------:|
|bsa                 | 1.0000000|
|total_area_value    | 0.4338917|
|total_area          | 0.4338311|
|orifice_area        | 0.3803151|
|valve_diameter      | 0.4380317|
|valve_area          | 0.4158363|
|a_coap_size_valve   | 0.3426494|
|a_coap_orifice_area | 0.1744180|
|a_coap_valve_area   | 0.0338661|
|magnitude           | 0.2923220|
|bsaScaled           | 1.0000000|
|orificeAreaScaled   | 0.3803151|
|magnitudeScaled     | 0.2923220|

Output a subset for spot-checking.


```
## File ../data/processed/sphericalCoordinates.csv was written on 2017-02-27 11:26:31
```

Summarize the entire data set.


|type    |  n|
|:-------|--:|
|Case    | 48|
|Control | 49|
# Compare cases and controls

The case-control variable is `type`.

Plot comparisons.
Use multiple visualizations, density plots and scatterplots.
Each has their advantages and disadvantages.

## Density plots

[PNG](../figures/densityplots.png), [SVG](../figures/densityplots.svg)

![Density plot](../figures/densityplots.png)



## Scatterplots

[PNG](../figures/scatterplots.png), [SVG](../figures/scatterplots.svg)

![Scatterplots](../figures/scatterplots.png)



## Unadjusted/unscaled comparisons

Calculate mean (SD) and ranges.
Calculate differences in means.
Adjust p-values for multiple comparisons.



Output results.
Results save as [CSV](../data/processed/compareUnadjusted.csv).


|variable                                               | nCases|meanSDCases       |rangeCases          | nControls|meanSDControls    |rangeControls       |  difference|     seDiff| tStatistic|    pValue|   pAdjust|sig   |formula                    |
|:------------------------------------------------------|------:|:-----------------|:-------------------|---------:|:-----------------|:-------------------|-----------:|----------:|----------:|---------:|---------:|:-----|:--------------------------|
|Body surface area                                      |     48|2.026 (0.202)     |(1.572, 2.497)      |        49|1.866 (0.313)     |(0.964, 2.782)      |   0.1601531|  0.0536110|  2.9873184| 0.0035808| 0.0066501|TRUE  |bsa ~ type                 |
|NR fraction                                            |     48|0.391 (0.120)     |(0.037, 0.637)      |        49|0.335 (0.068)     |(0.157, 0.481)      |   0.0560878|  0.0197899|  2.8341556| 0.0056126| 0.0091205|TRUE  |nr_frac ~ type             |
|RL fraction                                            |     48|0.228 (0.133)     |(0.009, 0.559)      |        49|0.331 (0.091)     |(0.067, 0.616)      |  -0.1029746|  0.0230101| -4.4751853| 0.0000212| 0.0000689|TRUE  |rl_frac ~ type             |
|LN fraction                                            |     48|0.381 (0.094)     |(0.152, 0.602)      |        49|0.334 (0.081)     |(0.088, 0.504)      |   0.0468868|  0.0178691|  2.6239108| 0.0101284| 0.0146299|TRUE  |ln_frac ~ type             |
|Total coaptation area, value                           |     48|648.704 (189.488) |(398.000, 1171.000) |        49|515.095 (224.243) |(206.000, 1087.660) | 133.6092730| 42.1952467|  3.1664532| 0.0020747| 0.0045102|TRUE  |total_area_value ~ type    |
|Total coaptation area, calculated                      |     48|649.323 (189.494) |(398.560, 1171.491) |        49|515.761 (224.234) |(206.820, 1088.279) | 133.5623861| 42.1947005|  3.1653830| 0.0020816| 0.0045102|TRUE  |total_area ~ type          |
|Orifice area                                           |     48|636.750 (196.511) |(341.000, 1221.000) |        49|486.755 (119.977) |(299.000, 812.000)  | 149.9948980| 32.9828869|  4.5476583| 0.0000160| 0.0000689|TRUE  |orifice_area ~ type        |
|Valve diameter                                         |     48|32.110 (4.487)    |(22.450, 47.260)    |        49|26.676 (4.594)    |(18.480, 36.680)    |   5.4336692|  0.9223465|  5.8911368| 0.0000001| 0.0000008|TRUE  |valve_diameter ~ type      |
|Valve area                                             |     48|825.262 (234.532) |(395.843, 1754.193) |        49|575.142 (199.141) |(268.222, 1056.692) | 250.1206244| 44.1437443|  5.6660491| 0.0000002| 0.0000010|TRUE  |valve_area ~ type          |
|Total valve coaptation area relative to valve diameter |     48|20.084 (4.365)    |(12.528, 32.113)    |        49|18.743 (5.574)    |(9.409, 34.659)     |   1.3406005|  1.0179301|  1.3169868| 0.1910110| 0.2257403|FALSE |a_coap_size_valve ~ type   |
|Total valve coaptation area relative to orifice area   |     48|1.059 (0.266)     |(0.559, 1.577)      |        49|1.047 (0.321)     |(0.449, 1.725)      |   0.0121495|  0.0599023|  0.2028216| 0.8397082| 0.8397082|FALSE |a_coap_orifice_area ~ type |
|Total valve coaptation area relative to valve area     |     48|0.807 (0.191)     |(0.471, 1.338)      |        49|0.893 (0.203)     |(0.407, 1.405)      |  -0.0855492|  0.0400184| -2.1377445| 0.0351042| 0.0456355|TRUE  |a_coap_valve_area ~ type   |
|Coaptation line length                                 |     48|12.380 (3.753)    |(3.129, 22.951)     |        49|13.036 (4.003)    |(5.630, 23.724)     |  -0.6562349|  0.7882625| -0.8325081| 0.4072102| 0.4411444|FALSE |magnitude ~ type           |

```
## File ../data/processed/compareUnadjusted.csv was written on 2017-02-27 11:26:49
```

## Adjusted comparisons

Adjusted for **orifice area.**

Calculate mean (SD) and ranges.
Calculate differences in means.
Adjust p-values for multiple comparisons.



Output results.
Results save as [CSV](../data/processed/compareAdjusted.csv).


|variable                                               | nCases|meanSDCases       |rangeCases          | nControls|meanSDControls    |rangeControls       |  difference|     seDiff| tStatistic|    pValue|   pAdjust|sig   |formula                                        |
|:------------------------------------------------------|------:|:-----------------|:-------------------|---------:|:-----------------|:-------------------|-----------:|----------:|----------:|---------:|---------:|:-----|:----------------------------------------------|
|Body surface area                                      |     48|2.026 (0.202)     |(1.572, 2.497)      |        49|1.866 (0.313)     |(0.964, 2.782)      |   0.0880013|  0.0568092|  1.5490692| 0.1247254| 0.1870882|FALSE |bsa ~ type + orificeAreaScaled                 |
|NR fraction                                            |     48|0.391 (0.120)     |(0.037, 0.637)      |        49|0.335 (0.068)     |(0.157, 0.481)      |   0.0594769|  0.0219383|  2.7110929| 0.0079731| 0.0191353|TRUE  |nr_frac ~ type + orificeAreaScaled             |
|RL fraction                                            |     48|0.228 (0.133)     |(0.009, 0.559)      |        49|0.331 (0.091)     |(0.067, 0.616)      |  -0.1106108|  0.0254582| -4.3448074| 0.0000352| 0.0004227|TRUE  |rl_frac ~ type + orificeAreaScaled             |
|LN fraction                                            |     48|0.381 (0.094)     |(0.152, 0.602)      |        49|0.334 (0.081)     |(0.088, 0.504)      |   0.0511340|  0.0197959|  2.5830569| 0.0113350| 0.0207082|TRUE  |ln_frac ~ type + orificeAreaScaled             |
|Total coaptation area, value                           |     48|648.704 (189.488) |(398.000, 1171.000) |        49|515.095 (224.243) |(206.000, 1087.660) |  24.1502198| 38.4466254|  0.6281493| 0.5314294| 0.5322816|FALSE |total_area_value ~ type + orificeAreaScaled    |
|Total coaptation area, calculated                      |     48|649.323 (189.494) |(398.560, 1171.491) |        49|515.761 (224.234) |(206.820, 1088.279) |  24.0990858| 38.4451682|  0.6268430| 0.5322816| 0.5322816|FALSE |total_area ~ type + orificeAreaScaled          |
|Valve diameter                                         |     48|32.110 (4.487)    |(22.450, 47.260)    |        49|26.676 (4.594)    |(18.480, 36.680)    |   3.2558008|  0.8744716|  3.7231636| 0.0003352| 0.0020113|TRUE  |valve_diameter ~ type + orificeAreaScaled      |
|Valve area                                             |     48|825.262 (234.532) |(395.843, 1754.193) |        49|575.142 (199.141) |(268.222, 1056.692) | 146.9124618| 42.0033528|  3.4976365| 0.0007188| 0.0028752|TRUE  |valve_area ~ type + orificeAreaScaled          |
|Total valve coaptation area relative to valve diameter |     48|20.084 (4.365)    |(12.528, 32.113)    |        49|18.743 (5.574)    |(9.409, 34.659)     |  -0.7948366|  1.0019113| -0.7933204| 0.4295891| 0.5155070|FALSE |a_coap_size_valve ~ type + orificeAreaScaled   |
|Total valve coaptation area relative to orifice area   |     48|1.059 (0.266)     |(0.559, 1.577)      |        49|1.047 (0.321)     |(0.449, 1.725)      |   0.0650553|  0.0651872|  0.9979759| 0.3208532| 0.4278042|FALSE |a_coap_orifice_area ~ type + orificeAreaScaled |
|Total valve coaptation area relative to valve area     |     48|0.807 (0.191)     |(0.471, 1.338)      |        49|0.893 (0.203)     |(0.407, 1.405)      |  -0.1123824|  0.0439091| -2.5594337| 0.0120798| 0.0207082|TRUE  |a_coap_valve_area ~ type + orificeAreaScaled   |
|Coaptation line length                                 |     48|12.380 (3.753)    |(3.129, 22.951)     |        49|13.036 (4.003)    |(5.630, 23.724)     |  -2.2127766|  0.7877198| -2.8090910| 0.0060435| 0.0181304|TRUE  |magnitude ~ type + orificeAreaScaled           |

```
## File ../data/processed/compareAdjusted.csv was written on 2017-02-27 11:26:50
```
# Linear model of coaptation line length

## Unadjusted

Summary from linear model estimating coaptation line length by case or control group status,
**unadjusted.**

* Model statistics
* ANOVA table
* Predicted values, and confidence and prediction intervals


| r.squared| adj.r.squared| sigma| statistic| p.value| df|   logLik|     AIC|     BIC| deviance| df.residual|
|---------:|-------------:|-----:|---------:|-------:|--:|--------:|-------:|-------:|--------:|-----------:|
|     0.007|        -0.003| 3.882|     0.693|   0.407|  2| -268.181| 542.362| 550.086| 1431.301|          95|



|term        | estimate| std.error| statistic| p.value|
|:-----------|--------:|---------:|---------:|-------:|
|(Intercept) |    12.38|      0.56|     22.10|  0.0000|
|typeControl |     0.66|      0.79|      0.83|  0.4072|



|type    |   fit| lowerConf| upperConf| lowerPred| upperPred|
|:-------|-----:|---------:|---------:|---------:|---------:|
|Case    | 12.38|     11.27|     13.49|      4.59|     20.17|
|Control | 13.04|     11.93|     14.14|      5.25|     20.82|

**Interpretation**
Coaptation line length in the control population is, on average,
0.66 mm longer 
(95% CI: 
-0.89, 
2.2;
p-value:
0.4072)
than in the case population,
unadjusted.


## Adjusted for body surface area

Summary from linear model estimating coaptation line length by case or control group status,
**adjusted for body surface area.**

* Model statistics
* ANOVA table
* Predicted values, and confidence and prediction intervals


| r.squared| adj.r.squared| sigma| statistic| p.value| df|   logLik|     AIC|     BIC| deviance| df.residual|
|---------:|-------------:|-----:|---------:|-------:|--:|--------:|-------:|-------:|--------:|-----------:|
|     0.117|         0.099| 3.679|     6.249|   0.003|  3| -262.479| 532.959| 543.258| 1272.551|          94|



|term        | estimate| std.error| statistic| p.value|
|:-----------|--------:|---------:|---------:|-------:|
|(Intercept) |    11.98|      0.54|     22.05|  0.0000|
|typeControl |     1.44|      0.78|      1.84|  0.0685|
|bsaScaled   |     1.34|      0.39|      3.42|  0.0009|



|type    | bsaScaled|scaling             |   fit| lowerConf| upperConf| lowerPred| upperPred|
|:-------|---------:|:-------------------|-----:|---------:|---------:|---------:|---------:|
|Case    |        -1|-1 SD from mean BSA | 10.64|      9.18|     12.10|      3.19|     18.09|
|Case    |         0|Mean BSA            | 11.98|     10.90|     13.06|      4.60|     19.37|
|Case    |         1|+1 SD from mean BSA | 13.33|     12.14|     14.52|      5.93|     20.73|
|Control |        -1|-1 SD from mean BSA | 12.08|     10.90|     13.26|      4.68|     19.48|
|Control |         0|Mean BSA            | 13.42|     12.36|     14.49|      6.04|     20.81|
|Control |         1|+1 SD from mean BSA | 14.77|     13.32|     16.22|      7.32|     22.22|

**Interpretation**
Coaptation line length in the control population is, on average,
1.44 mm longer 
(95% CI: 
-0.09, 
2.97;
p-value:
0.0685)
than in the case population,
adjusted for body surface area.


## Adjusted for orifice area

Summary from linear model estimating coaptation line length by case or control group status,
**adjusted for orifice area.**

* Model statistics
* ANOVA table
* Predicted values, and confidence and prediction intervals


| r.squared| adj.r.squared| sigma| statistic| p.value| df|   logLik|     AIC|     BIC| deviance| df.residual|
|---------:|-------------:|-----:|---------:|-------:|--:|--------:|-------:|-------:|--------:|-----------:|
|     0.194|         0.177| 3.515|    11.343|       0|  3| -258.048| 524.097| 534.396| 1161.443|          94|



|term              | estimate| std.error| statistic| p.value|
|:-----------------|--------:|---------:|---------:|-------:|
|(Intercept)       |    11.59|      0.53|     21.69|   0.000|
|typeControl       |     2.21|      0.79|      2.81|   0.006|
|orificeAreaScaled |     1.85|      0.40|      4.67|   0.000|



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
3.76;
p-value:
0.006)
than in the case population,
adjusted for orifice area.
# Directional analysis of coaptation line

Citation for package `Directional`.


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


## Plots

Spherical coordinates of coaptation lines

### Overall 

[PNG](../figures/plotSpherical.png), [SVG](../figures/plotSpherical.svg)

![Spherical coordinates](../figures/plotSpherical.png)


```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

### By aortic stenosis

[PNG](../figures/plotSphericalStenosis.png), [SVG](../figures/plotSphericalStenosis.svg)

![Spherical coordinates by aortic stenosis](../figures/plotSphericalStenosis.png)


```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

### By aortic regurgitation

[PNG](../figures/plotSphericalRegurgitation.png), [SVG](../figures/plotSphericalRegurgitation.svg)

![Spherical coordinates by aortic regurgitation](../figures/plotSphericalRegurgitation.png)


```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

Create data matrices.


```r
vecCoord <- df %>% select(matches("^type$|(coapUnit[XYZ])"))
cirCoord <- df %>% select(matches("^type$|((lat)|(long))itude"))
matAll <- cirCoord %>% select(-1) %>% as.matrix
matCases <- cirCoord %>% filter(type == "Case") %>% select(-1) %>% as.matrix
matControls <- cirCoord %>% filter(type == "Control") %>% select(-1) %>% as.matrix
```

Test whether Kent's ovalness parameter (beta) is equal to zero.
The null hypothesis is whether a von Mises-Fisher distribution fits the data well. 
The altenrative is that Kent distribution is more suitable.


```r
test <- vecCoord %>% select(-1) %>% as.matrix %>% fishkent
message(sprintf("Bootstrap p-value is %.04f\n%s null hypothesis",
                test[["Bootstrap p-value"]],
                ifelse(test[["Bootstrap p-value"]] < 0.05, "Reject", "Fail to reject")))
```

```
## Bootstrap p-value is 0.5580
## Fail to reject null hypothesis
```

## Circular summary statistics


```r
data.frame(type = c("All", "Cases", "Controls"),
           latitude = c(matAll[, "latitude"] %>% 
                          circ.summary(rads = FALSE, plot = FALSE) %>% 
                          .[["mesos"]],
                        matCases[, "latitude"] %>% 
                          circ.summary(rads = FALSE, plot = FALSE) %>% 
                          .[["mesos"]],
                        matControls[, "latitude"] %>% 
                          circ.summary(rads = FALSE, plot = FALSE) %>% 
                          .[["mesos"]]),
           longitude = c(matAll[, "longitude"] %>% 
                           circ.summary(rads = FALSE, plot = FALSE) %>% 
                           .[["mesos"]],
                         matCases[, "longitude"] %>% 
                           circ.summary(rads = FALSE, plot = FALSE) %>% 
                           .[["mesos"]],
                         matControls[, "longitude"] %>% 
                           circ.summary(rads = FALSE, plot = FALSE) %>% 
                           .[["mesos"]])) %>% kable
```



|type     |  latitude| longitude|
|:--------|---------:|---------:|
|All      | -75.34583|  156.0474|
|Cases    | -73.58603|  160.8957|
|Controls | -77.05687|  149.8446|


## ANOVA


```r
data.frame(variable = rep(c("Latitude", "Longitude"), 3),
           effect = c(rep("Group: case vs control", 2), 
                      rep("Aortic stenosis: none/trivial vs mild-severe", 2), 
                      rep("Aortic regurgitation: none/trivial vs mild-severe", 2)),
           bind_rows(matAll[, "latitude"] %>% 
                       lr.circaov(., factor(df$type), rads = FALSE) %>% 
                       t %>% data.frame,
                     matAll[, "longitude"] %>% 
                       lr.circaov(., factor(df$type), rads = FALSE) %>% 
                       t %>% data.frame,
                     matAll[, "latitude"] %>% 
                       lr.circaov(., factor(df$as), rads = FALSE) %>% 
                       t %>% data.frame,
                     matAll[, "longitude"] %>% 
                       lr.circaov(., factor(df$as), rads = FALSE) %>% 
                       t %>% data.frame,
                     matAll[, "latitude"] %>% 
                       lr.circaov(., factor(df$ar), rads = FALSE) %>% 
                       t %>% data.frame,
                     matAll[, "longitude"] %>% 
                       lr.circaov(., factor(df$ar), rads = FALSE) %>% 
                       t %>% data.frame)) %>% 
  kable
```



|variable  |effect                                            |      test|   p.value|     kappa|
|:---------|:-------------------------------------------------|---------:|---------:|---------:|
|Latitude  |Group: case vs control                            | 2.2629933| 0.1324977| 25.930362|
|Longitude |Group: case vs control                            | 0.2486268| 0.6180437|  0.773375|
|Latitude  |Aortic stenosis: none/trivial vs mild-severe      | 0.0699664| 0.7913857| 25.930362|
|Longitude |Aortic stenosis: none/trivial vs mild-severe      | 0.5389925| 0.4628505|  0.773375|
|Latitude  |Aortic regurgitation: none/trivial vs mild-severe | 0.0214637| 0.8835227| 25.930362|
|Longitude |Aortic regurgitation: none/trivial vs mild-severe | 0.5707245| 0.4499712|  0.773375|


## Circular regression for latitude (polar angle)

Unadjusted.


```r
new <- df$typeCase %>% unique
M <- spml.reg(df$latitude, 
              as.matrix(df[, "typeCase"]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##    0.03    0.00    0.02 
## 
## $beta
##          Cosinus of y Sinus of y
##           1.331727706  -6.021609
## typeCase  0.006409535   1.344292
## 
## $seb
##          Cosinus of y Sinus of y
##             0.1404381  0.1042759
## typeCase    0.2035170  0.2031161
## 
## $loglik
## [1] 25.35768
## 
## $est
## [1] 285.9653 282.4707
```

```r
data.frame(type = df$type %>% unique, 
           typeCase = new,
           pred = as.vector(M$est) - 360) %>% kable
```



|type    |typeCase |      pred|
|:-------|:--------|---------:|
|Case    |TRUE     | -74.03466|
|Control |FALSE    | -77.52930|

Adjusted for body surface area.


```r
new <- data.frame(typeCase = rep(df$typeCase %>% unique, 3), 
                  bsaScaled = rep(-1:1, each = 2))
M <- spml.reg(df$latitude, 
              as.matrix(df[, c("typeCase", "bsaScaled")]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##    0.06    0.03    0.04 
## 
## $beta
##           Cosinus of y Sinus of y
##              1.7520884  -8.383290
## typeCase    -0.3037059   3.356043
## bsaScaled    0.3094801  -2.198097
## 
## $seb
##           Cosinus of y Sinus of y
##              0.1428666  0.1098323
## typeCase     0.2143050  0.2125200
## bsaScaled    0.1086668  0.1069531
## 
## $loglik
## [1] 42.12291
## 
## $est
## [1] 291.9277 283.1287 286.0720 281.8048 283.6739 281.0248
```

```r
data.frame(type = rep(df$type %>% unique, 3),
           new,
           scaling = rep(c("-1 SD from mean BSA",
                           "Mean BSA",
                           "+1 SD from mean BSA"), each = 2),
           pred = as.vector(M$est) - 360) %>% kable
```



|type    |typeCase | bsaScaled|scaling             |      pred|
|:-------|:--------|---------:|:-------------------|---------:|
|Case    |TRUE     |        -1|-1 SD from mean BSA | -68.07226|
|Control |FALSE    |        -1|-1 SD from mean BSA | -76.87128|
|Case    |TRUE     |         0|Mean BSA            | -73.92796|
|Control |FALSE    |         0|Mean BSA            | -78.19523|
|Case    |TRUE     |         1|+1 SD from mean BSA | -76.32610|
|Control |FALSE    |         1|+1 SD from mean BSA | -78.97519|

Adjusted for orifice area area.


```r
new <- data.frame(typeCase = rep(df$typeCase %>% unique, 3), 
                  orificeAreaScaled = rep(-1:1, each = 2))
M <- spml.reg(df$latitude, 
              as.matrix(df[, c("typeCase", "orificeAreaScaled")]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##    0.07    0.00    0.03 
## 
## $beta
##                   Cosinus of y Sinus of y
##                      1.6054003  -8.120715
## typeCase            -0.1043417   3.106066
## orificeAreaScaled    0.1893907  -2.454024
## 
## $seb
##                   Cosinus of y Sinus of y
##                      0.1462691  0.1160903
## typeCase             0.2266974  0.2242708
## orificeAreaScaled    0.1144086  0.1127463
## 
## $loglik
## [1] 40.81098
## 
## $est
## [1] 297.1236 284.0299 286.6643 281.1827 282.7534 279.6327
```

```r
data.frame(type = rep(df$type %>% unique, 3),
           new,
           scaling = rep(c("-1 SD from mean orifice area",
                           "Mean orifice area",
                           "+1 SD from mean orifice area"), each = 2),
           pred = as.vector(M$est) - 360) %>% kable
```



|type    |typeCase | orificeAreaScaled|scaling                      |      pred|
|:-------|:--------|-----------------:|:----------------------------|---------:|
|Case    |TRUE     |                -1|-1 SD from mean orifice area | -62.87641|
|Control |FALSE    |                -1|-1 SD from mean orifice area | -75.97007|
|Case    |TRUE     |                 0|Mean orifice area            | -73.33573|
|Control |FALSE    |                 0|Mean orifice area            | -78.81728|
|Case    |TRUE     |                 1|+1 SD from mean orifice area | -77.24663|
|Control |FALSE    |                 1|+1 SD from mean orifice area | -80.36730|

Adjusted for coaptation line length.


```r
new <- data.frame(typeCase = rep(df$typeCase %>% unique, 3), 
                  magnitudeScaled = rep(-1:1, each = 2))
M <- spml.reg(df$latitude, 
              as.matrix(df[, c("typeCase", "magnitudeScaled")]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##    0.06    0.00    0.03 
## 
## $beta
##                 Cosinus of y Sinus of y
##                  1.586798896  -7.239862
## typeCase         0.001468562   1.076555
## magnitudeScaled  0.265255221  -1.947143
## 
## $seb
##                 Cosinus of y Sinus of y
##                    0.1427796  0.1050458
## typeCase           0.2044080  0.2038451
## magnitudeScaled    0.1054557  0.1026069
## 
## $loglik
## [1] 43.11253
## 
## $est
## [1] 287.4216 284.0196 284.4506 282.3623 282.8730 281.3978
```

```r
data.frame(type = rep(df$type %>% unique, 3),
           new,
           scaling = rep(c("-1 SD from mean coaptation line length",
                           "Mean coaptation line length",
                           "+1 SD from mean coaptation line length"), each = 2),
           pred = as.vector(M$est) - 360) %>% kable
```



|type    |typeCase | magnitudeScaled|scaling                                |      pred|
|:-------|:--------|---------------:|:--------------------------------------|---------:|
|Case    |TRUE     |              -1|-1 SD from mean coaptation line length | -72.57839|
|Control |FALSE    |              -1|-1 SD from mean coaptation line length | -75.98043|
|Case    |TRUE     |               0|Mean coaptation line length            | -75.54943|
|Control |FALSE    |               0|Mean coaptation line length            | -77.63766|
|Case    |TRUE     |               1|+1 SD from mean coaptation line length | -77.12698|
|Control |FALSE    |               1|+1 SD from mean coaptation line length | -78.60222|

## Circular regression for longitude (azimuthal angle)

Unadjusted.


```r
new <- df$typeCase %>% unique
M <- spml.reg(df$longitude, 
              as.matrix(df[, "typeCase"]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##       0       0       0 
## 
## $beta
##          Cosinus of y  Sinus of y
##            -0.4600674  0.27089631
## typeCase   -0.2294334 -0.06964816
## 
## $seb
##          Cosinus of y Sinus of y
##             0.1192794  0.1347447
## typeCase    0.1991933  0.2034726
## 
## $loglik
## [1] -164.3917
## 
## $est
## [1] 163.7288 149.5096
```

```r
data.frame(type = df$type %>% unique, 
           typeCase = new,
           pred = as.vector(M$est)) %>% kable
```



|type    |typeCase |     pred|
|:-------|:--------|--------:|
|Case    |TRUE     | 163.7288|
|Control |FALSE    | 149.5096|

Adjusted for body surface area.


```r
new <- data.frame(typeCase = rep(df$typeCase %>% unique, 3), 
                  bsaScaled = rep(-1:1, each = 2))
M <- spml.reg(df$longitude, 
              as.matrix(df[, c("typeCase", "bsaScaled")]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##       0       0       0 
## 
## $beta
##           Cosinus of y  Sinus of y
##             -0.4277925  0.27503757
## typeCase    -0.3015519 -0.07924063
## bsaScaled    0.1144437  0.01654991
## 
## $seb
##           Cosinus of y Sinus of y
##              0.1275069  0.1376270
## typeCase     0.2062491  0.2128108
## bsaScaled    0.1050178  0.1066545
## 
## $loglik
## [1] -163.9478
## 
## $est
## [1] 168.0069 154.5125 164.9729 147.2621 160.9484 137.0602
```

```r
data.frame(type = rep(df$type %>% unique, 3),
           new,
           scaling = rep(c("-1 SD from mean BSA",
                           "Mean BSA",
                           "+1 SD from mean BSA"), each = 2),
           pred = as.vector(M$est)) %>% kable
```



|type    |typeCase | bsaScaled|scaling             |     pred|
|:-------|:--------|---------:|:-------------------|--------:|
|Case    |TRUE     |        -1|-1 SD from mean BSA | 168.0069|
|Control |FALSE    |        -1|-1 SD from mean BSA | 154.5125|
|Case    |TRUE     |         0|Mean BSA            | 164.9729|
|Control |FALSE    |         0|Mean BSA            | 147.2621|
|Case    |TRUE     |         1|+1 SD from mean BSA | 160.9484|
|Control |FALSE    |         1|+1 SD from mean BSA | 137.0602|

Adjusted for orifice area area.


```r
new <- data.frame(typeCase = rep(df$typeCase %>% unique, 3), 
                  orificeAreaScaled = rep(-1:1, each = 2))
M <- spml.reg(df$longitude, 
              as.matrix(df[, c("typeCase", "orificeAreaScaled")]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##       0       0       0 
## 
## $beta
##                   Cosinus of y  Sinus of y
##                     -0.3582187  0.25927990
## typeCase            -0.4622895 -0.05843433
## orificeAreaScaled    0.2644774 -0.02736773
## 
## $seb
##                   Cosinus of y Sinus of y
##                      0.1395525  0.1447753
## typeCase             0.2122474  0.2241783
## orificeAreaScaled    0.1048306  0.1117893
## 
## $loglik
## [1] -162.4629
## 
## $est
## [1] 168.1217 155.2818 166.2455 144.1029 162.6724 112.0090
```

```r
data.frame(type = rep(df$type %>% unique, 3),
           new,
           scaling = rep(c("-1 SD from mean orifice area",
                           "Mean orifice area",
                           "+1 SD from mean orifice area"), each = 2),
           pred = as.vector(M$est)) %>% kable
```



|type    |typeCase | orificeAreaScaled|scaling                      |     pred|
|:-------|:--------|-----------------:|:----------------------------|--------:|
|Case    |TRUE     |                -1|-1 SD from mean orifice area | 168.1217|
|Control |FALSE    |                -1|-1 SD from mean orifice area | 155.2818|
|Case    |TRUE     |                 0|Mean orifice area            | 166.2455|
|Control |FALSE    |                 0|Mean orifice area            | 144.1029|
|Case    |TRUE     |                 1|+1 SD from mean orifice area | 162.6724|
|Control |FALSE    |                 1|+1 SD from mean orifice area | 112.0090|

Adjusted for coaptation line length.


```r
new <- data.frame(typeCase = rep(df$typeCase %>% unique, 3), 
                  magnitudeScaled = rep(-1:1, each = 2))
M <- spml.reg(df$longitude, 
              as.matrix(df[, c("typeCase", "magnitudeScaled")]), 
              rads = FALSE, 
              xnew = as.matrix(new))
M
```

```
## $runtime
##    user  system elapsed 
##       0       0       0 
## 
## $beta
##                 Cosinus of y  Sinus of y
##                   -0.4974260  0.26512957
## typeCase          -0.2111204 -0.06780247
## magnitudeScaled    0.2630104  0.17459808
## 
## $seb
##                 Cosinus of y Sinus of y
##                   0.12375762  0.1357451
## typeCase          0.20127301  0.2041262
## magnitudeScaled   0.09461067  0.1020062
## 
## $loglik
## [1] -161.1152
## 
## $est
## [1] 178.6598 173.2108 164.4377 151.9422 140.1455 118.0617
```

```r
data.frame(type = rep(df$type %>% unique, 3),
           new,
           scaling = rep(c("-1 SD from mean coaptation line length",
                           "Mean coaptation line length",
                           "+1 SD from mean coaptation line length"), each = 2),
           pred = as.vector(M$est)) %>% kable
```



|type    |typeCase | magnitudeScaled|scaling                                |     pred|
|:-------|:--------|---------------:|:--------------------------------------|--------:|
|Case    |TRUE     |              -1|-1 SD from mean coaptation line length | 178.6598|
|Control |FALSE    |              -1|-1 SD from mean coaptation line length | 173.2108|
|Case    |TRUE     |               0|Mean coaptation line length            | 164.4377|
|Control |FALSE    |               0|Mean coaptation line length            | 151.9422|
|Case    |TRUE     |               1|+1 SD from mean coaptation line length | 140.1455|
|Control |FALSE    |               1|+1 SD from mean coaptation line length | 118.0617|
