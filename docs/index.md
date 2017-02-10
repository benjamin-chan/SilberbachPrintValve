---
title: "PrintValve case-control analysis"
date: "2017-02-10 11:30:41"
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
  * $\theta$ = polar angle (inclination) bounded between $(\frac{-\pi}{2}, \frac{\pi}{2})$ or $(-90^{\circ}, +90^{\circ})$; default units is radians
  * $\phi$ = azimuthal angle bounded between $(-\pi, \pi)$ or $(-180^{\circ}, +180^{\circ})$; default units is radians
  * $\rho, \theta, \phi$ will be used to describe the coaptation line
1. Normalize the orientation of the coaptation line to the unit sphere
1. Scale body size measures, `bsa` and `orifice_area`, to have mean = 0 and SD = 1

Example coaptation line (triple point) is below.
An interactive representation of the coaptation line geometry is [here](https://ggbm.at/CeF95YMN).

![Coaptation line](../figures/CoaptationLine.png)



Check calculation of `radial` against given `coapt_line_length`; it should be 1.0


```
## Correlation between coapt_line_length and calculated radial is: 1.00000
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
|radial              | 0.2923220|
|bsaScaled           | 1.0000000|
|orificeAreaScaled   | 0.3803151|

Output a subset for spot-checking.


```
## File ../data/processed/sphericalCoordinates.csv was written on 2017-02-10 11:30:42
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

Images are saved as [PNG](../figures/densityplots-1.png) and [SVG](../figures/densityplots.svg) files.

![plot of chunk densityplots](../figures/densityplots-1.png)

![plot of chunk scatterplots](../figures/scatterplots-1.png)

## Unadjusted/unscaled comparisons

Calculate mean (SD) and ranges.
Calculate differences in means.
Adjust p-values for multiple comparisons.



Output results.
Results save as [CSV](../data/processed/compare.csv).


|variable                                               | nCases|meanSDCases       |rangeCases          | nControls|meanSDControls    |rangeControls       |  difference|     seDiff| tStatistic|    pValue|   pAdjust|sig   |
|:------------------------------------------------------|------:|:-----------------|:-------------------|---------:|:-----------------|:-------------------|-----------:|----------:|----------:|---------:|---------:|:-----|
|Body surface area                                      |     48|2.026 (0.202)     |(1.572, 2.497)      |        49|1.866 (0.313)     |(0.964, 2.782)      |   0.1601531|  0.0536110|  2.9873184| 0.0035808| 0.0076732|TRUE  |
|NR fraction                                            |     48|0.391 (0.120)     |(0.037, 0.637)      |        49|0.335 (0.068)     |(0.157, 0.481)      |   0.0560878|  0.0197899|  2.8341556| 0.0056126| 0.0105236|TRUE  |
|RL fraction                                            |     48|0.228 (0.133)     |(0.009, 0.559)      |        49|0.331 (0.091)     |(0.067, 0.616)      |  -0.1029746|  0.0230101| -4.4751853| 0.0000212| 0.0000795|TRUE  |
|LN fraction                                            |     48|0.381 (0.094)     |(0.152, 0.602)      |        49|0.334 (0.081)     |(0.088, 0.504)      |   0.0468868|  0.0178691|  2.6239108| 0.0101284| 0.0168807|TRUE  |
|Total coaptation area, value                           |     48|648.704 (189.488) |(398.000, 1171.000) |        49|515.095 (224.243) |(206.000, 1087.660) | 133.6092730| 42.1952467|  3.1664532| 0.0020747| 0.0052041|TRUE  |
|Total coaptation area, calculated                      |     48|649.323 (189.494) |(398.560, 1171.491) |        49|515.761 (224.234) |(206.820, 1088.279) | 133.5623861| 42.1947005|  3.1653830| 0.0020816| 0.0052041|TRUE  |
|Orifice area                                           |     48|636.750 (196.511) |(341.000, 1221.000) |        49|486.755 (119.977) |(299.000, 812.000)  | 149.9948980| 32.9828869|  4.5476583| 0.0000160| 0.0000795|TRUE  |
|Valve diameter                                         |     48|32.110 (4.487)    |(22.450, 47.260)    |        49|26.676 (4.594)    |(18.480, 36.680)    |   5.4336692|  0.9223465|  5.8911368| 0.0000001| 0.0000009|TRUE  |
|Valve area                                             |     48|825.262 (234.532) |(395.843, 1754.193) |        49|575.142 (199.141) |(268.222, 1056.692) | 250.1206244| 44.1437443|  5.6660491| 0.0000002| 0.0000012|TRUE  |
|Total valve coaptation area relative to valve diameter |     48|20.084 (4.365)    |(12.528, 32.113)    |        49|18.743 (5.574)    |(9.409, 34.659)     |   1.3406005|  1.0179301|  1.3169868| 0.1910110| 0.2387638|FALSE |
|Total valve coaptation area relative to orifice area   |     48|1.059 (0.266)     |(0.559, 1.577)      |        49|1.047 (0.321)     |(0.449, 1.725)      |   0.0121495|  0.0599023|  0.2028216| 0.8397082| 0.8397082|FALSE |
|Total valve coaptation area relative to valve area     |     48|0.807 (0.191)     |(0.471, 1.338)      |        49|0.893 (0.203)     |(0.407, 1.405)      |  -0.0855492|  0.0400184| -2.1377445| 0.0351042| 0.0526563|FALSE |
|Coaptation line length                                 |     48|12.380 (3.753)    |(3.129, 22.951)     |        49|13.036 (4.003)    |(5.630, 23.724)     |  -0.6562349|  0.7882625| -0.8325081| 0.4072102| 0.4362966|FALSE |
|Polar angle of coaptation line (top to bottom          |     48|-73.418 (12.494)  |(-88.720, -30.848)  |        49|-76.861 (10.433)  |(-88.508, -19.856)  |   3.4429561|  2.3351759|  1.4743883| 0.1436833| 0.1959318|FALSE |
|Azimuthal angle of coaptation line                     |     48|4.684 (133.204)   |(-178.788, 178.824) |        49|31.443 (116.612)  |(-167.841, 169.432) | -26.7591262| 25.4045403| -1.0533206| 0.2948658| 0.3402297|FALSE |

```
## File ../data/processed/compare.csv was written on 2017-02-10 11:30:56
```
# Linear model of coaptation line length

## Unadjusted


| r.squared| adj.r.squared|    sigma| statistic|   p.value| df|   logLik|     AIC|      BIC| deviance| df.residual|
|---------:|-------------:|--------:|---------:|---------:|--:|--------:|-------:|--------:|--------:|-----------:|
| 0.0072426|    -0.0032074| 3.881536| 0.6930697| 0.4072102|  2| -268.181| 542.362| 550.0861| 1431.301|          95|



|term        |   estimate| std.error|  statistic|   p.value|
|:-----------|----------:|---------:|----------:|---------:|
|(Intercept) | 12.3795844| 0.5602515| 22.0964777| 0.0000000|
|typeControl |  0.6562349| 0.7882625|  0.8325081| 0.4072102|



|type    |      fit|      lwr|      upr|
|:-------|--------:|--------:|--------:|
|Case    | 12.37958| 11.26734| 13.49182|
|Control | 13.03582| 11.93499| 14.13665|



|type    |      fit|      lwr|      upr|
|:-------|--------:|--------:|--------:|
|Case    | 12.37958| 4.593906| 20.16526|
|Control | 13.03582| 5.251762| 20.81988|

## Adjusted for body surface area


| r.squared| adj.r.squared|    sigma| statistic|   p.value| df|    logLik|      AIC|      BIC| deviance| df.residual|
|---------:|-------------:|--------:|---------:|---------:|--:|---------:|--------:|--------:|--------:|-----------:|
| 0.1173521|     0.0985724| 3.679372|  6.248866| 0.0028315|  3| -262.4793| 532.9587| 543.2575| 1272.551|          94|



|term        |  estimate| std.error| statistic|   p.value|
|:-----------|---------:|---------:|---------:|---------:|
|(Intercept) | 11.983427| 0.5435260| 22.047568| 0.0000000|
|typeControl |  1.440464| 0.7815147|  1.843170| 0.0684555|
|bsaScaled   |  1.344983| 0.3927664|  3.424384| 0.0009148|



|type    | bsaScaled|scaling             |      fit|       lwr|      upr|
|:-------|---------:|:-------------------|--------:|---------:|--------:|
|Case    |        -1|-1 SD from mean BSA | 10.63844|  9.178629| 12.09826|
|Control |        -1|-1 SD from mean BSA | 12.07891| 10.896950| 13.26087|
|Case    |         0|Mean BSA            | 11.98343| 10.904244| 13.06261|
|Control |         0|Mean BSA            | 13.42389| 12.356271| 14.49151|
|Case    |         1|+1 SD from mean BSA | 13.32841| 12.139067| 14.51775|
|Control |         1|+1 SD from mean BSA | 14.76887| 13.320108| 16.21764|



|type    | bsaScaled|scaling             |      fit|      lwr|      upr|
|:-------|---------:|:-------------------|--------:|--------:|--------:|
|Case    |        -1|-1 SD from mean BSA | 10.63844| 3.188539| 18.08835|
|Control |        -1|-1 SD from mean BSA | 12.07891| 4.678432| 19.47939|
|Case    |         0|Mean BSA            | 11.98343| 4.598668| 19.36819|
|Control |         0|Mean BSA            | 13.42389| 6.040813| 20.80697|
|Case    |         1|+1 SD from mean BSA | 13.32841| 5.926751| 20.73007|
|Control |         1|+1 SD from mean BSA | 14.76887| 7.321127| 22.21662|

## Adjusted for orifice area


| r.squared| adj.r.squared|    sigma| statistic|  p.value| df|    logLik|      AIC|      BIC| deviance| df.residual|
|---------:|-------------:|--------:|---------:|--------:|--:|---------:|--------:|--------:|--------:|-----------:|
| 0.1944174|     0.1772774| 3.515078|  11.34287| 3.87e-05|  3| -258.0483| 524.0967| 534.3955| 1161.443|          94|



|term              |  estimate| std.error| statistic|   p.value|
|:-----------------|---------:|---------:|---------:|---------:|
|(Intercept)       | 11.593290| 0.5345275| 21.688854| 0.0000000|
|typeControl       |  2.212777| 0.7877198|  2.809091| 0.0060435|
|orificeAreaScaled |  1.850127| 0.3958849|  4.673396| 0.0000099|



|type    | orificeAreaScaled|scaling                      |       fit|       lwr|      upr|
|:-------|-----------------:|:----------------------------|---------:|---------:|--------:|
|Case    |                -1|-1 SD from mean orifice area |  9.743163|  8.236703| 11.24962|
|Control |                -1|-1 SD from mean orifice area | 11.955940| 10.858407| 13.05347|
|Case    |                 0|Mean orifice area            | 11.593290| 10.531973| 12.65461|
|Control |                 0|Mean orifice area            | 13.806067| 12.756698| 14.85544|
|Case    |                 1|+1 SD from mean orifice area | 13.443417| 12.339298| 14.54754|
|Control |                 1|+1 SD from mean orifice area | 15.656194| 14.161708| 17.15068|



|type    | orificeAreaScaled|scaling                      |       fit|      lwr|      upr|
|:-------|-----------------:|:----------------------------|---------:|--------:|--------:|
|Case    |                -1|-1 SD from mean orifice area |  9.743163| 2.603161| 16.88317|
|Control |                -1|-1 SD from mean orifice area | 11.955940| 4.890900| 19.02098|
|Case    |                 0|Mean orifice area            | 11.593290| 4.533786| 18.65279|
|Control |                 0|Mean orifice area            | 13.806067| 6.748349| 20.86378|
|Case    |                 1|+1 SD from mean orifice area | 13.443417| 6.377351| 20.50948|
|Control |                 1|+1 SD from mean orifice area | 15.656194| 8.518708| 22.79368|
# Directional analysis of coaptation line

Scatterplot matrix of coaptation line measures.

![plot of chunk polarplot](../figures/polarplot-1.png)

```
## Saving 7 x 7 in image
```

Calculate median cartesian coordinates and latitude and longitude.


```r
cartCoord <- df %>% select(matches("^type$|coapUnit[XYZ]"))
matAll <- cartCoord %>% select(-1) %>% as.matrix
matCases <- cartCoord %>% filter(type == "Case") %>% select(-1) %>% as.matrix
matControls <- cartCoord %>% filter(type == "Control") %>% select(-1) %>% as.matrix
rbind(matAll %>% mediandir,
      matCases %>% mediandir,
      matControls %>% mediandir) %>%
  data.frame %>% 
  rename(x = X1, y = X2, z = X3) %>% 
  cbind(group = c("All", "Cases", "Controls"), .) %>% 
  kable
```



|group    |          x|         y|          z|
|:--------|----------:|---------:|----------:|
|All      | -0.1035612| 0.0428729| -0.9936986|
|Cases    | -0.1307252| 0.0319395| -0.9909040|
|Controls | -0.0788606| 0.0474871| -0.9957540|

```r
rbind(matAll %>% mediandir %>% euclid.inv,
      matCases %>% mediandir %>% euclid.inv,
      matControls %>% mediandir %>% euclid.inv) %>%
  data.frame %>% 
  cbind(group = c("All", "Cases", "Controls"), .) %>% 
  kable
```



|group    |      Lat|     Long|
|:--------|--------:|--------:|
|All      | 95.94428| 272.4705|
|Cases    | 97.51150| 271.8462|
|Controls | 94.52308| 272.7303|

Calculate maximum likelihood estimates of the von Mises-Fisher distribution.


```r
rbind(matAll %>% vmf %>% .[["mu"]],
      matCases %>% vmf %>% .[["mu"]],
      matControls %>% vmf %>% .[["mu"]]) %>%
  data.frame %>% 
  rename(x = X1, y = X2, z = X3) %>% 
  cbind(group = c("All", "Cases", "Controls"), .) %>% 
  kable
```



|group    |          x|         y|          z|
|:--------|----------:|---------:|----------:|
|All      | -0.1019622| 0.0225069| -0.9945336|
|Cases    | -0.1426048| 0.0346619| -0.9891726|
|Controls | -0.0625443| 0.0107320| -0.9979845|

```r
rbind(matAll %>% vmf %>% .[["mu"]] %>% euclid.inv,
      matCases %>% vmf %>% .[["mu"]] %>% euclid.inv,
      matControls %>% vmf %>% .[["mu"]] %>% euclid.inv) %>%
  data.frame %>% 
  cbind(group = c("All", "Cases", "Controls"), .) %>% 
  kable
```



|group    |      Lat|     Long|
|:--------|--------:|--------:|
|All      | 95.85218| 271.2964|
|Cases    | 98.19860| 272.0069|
|Controls | 93.58587| 270.6161|

ANOVA.


```r
hcf.aov(matAll, factor(df$type))
```

```
##       test    p-value      kappa 
##  1.7657268  0.1738577 21.6647313
```

```r
lr.aov(matAll, factor(df$type))
```

```
##         w   p-value 
## 3.5742089 0.1674443
```

```r
embed.aov(matAll, factor(df$type))
```

```
##         F   p-value 
## 1.7768999 0.1719612
```

```r
het.aov(matAll, factor(df$type))
```

```
##      test   p-value 
## 3.5920396 0.1659581
```

```r
spherconc.test(matAll, factor(df$type))
```

```
## $mess
## [1] "The mean resultant length is more than 0.67. U3 was calculated"
## 
## $res
##      test   p-value 
## 2.2234523 0.1359288
```

Calculate circular summary statistics.


```r
cirCoord <- df %>% select(matches("^type$|polar|azimuthal"))
matAll <- cirCoord %>% select(-1) %>% as.matrix
matCases <- cirCoord %>% filter(type == "Case") %>% select(-1) %>% as.matrix
matControls <- cirCoord %>% filter(type == "Control") %>% select(-1) %>% as.matrix
matAll[, "polar"] %>% circ.summary(rads = FALSE, plot = FALSE)
```

```
## $mesos
## [1] -75.34583
## 
## $confint
## [1] -75.41890 -75.27276
## 
## $kappa
## [1] 25.93036
## 
## $MRL
## [1] 0.980524
## 
## $circvariance
## [1] 0.01947597
## 
## $circstd
## [1] 0.1983337
```

```r
matAll[, "azimuthal"] %>% circ.summary(rads = FALSE, plot = FALSE)
```

```
## $mesos
## [1] 156.0474
## 
## $confint
## [1] 155.3553 156.7395
## 
## $kappa
## [1] 0.773375
## 
## $MRL
## [1] 0.3603926
## 
## $circvariance
## [1] 0.6396074
## 
## $circstd
## [1] 1.428679
```

```r
matCases[, "polar"] %>% circ.summary(rads = FALSE, plot = FALSE)
```

```
## $mesos
## [1] -73.58603
## 
## $confint
## [1] -73.69852 -73.47354
## 
## $kappa
## [1] 22.25913
## 
## $MRL
## [1] 0.9772728
## 
## $circvariance
## [1] 0.0227272
## 
## $circstd
## [1] 0.2144269
```

```r
matCases[, "azimuthal"] %>% circ.summary(rads = FALSE, plot = FALSE)
```

```
## $mesos
## [1] 160.8957
## 
## $confint
## [1] 160.0409 161.7505
## 
## $kappa
## [1] 0.9018208
## 
## $MRL
## [1] 0.4105231
## 
## $circvariance
## [1] 0.5894769
## 
## $circstd
## [1] 1.334409
```

```r
matControls[, "polar"]%>% circ.summary(rads = FALSE, plot = FALSE)
```

```
## $mesos
## [1] -77.05687
## 
## $confint
## [1] -77.14801 -76.96573
## 
## $kappa
## [1] 32.72235
## 
## $MRL
## [1] 0.9845994
## 
## $circvariance
## [1] 0.01540057
## 
## $circstd
## [1] 0.1761839
```

```r
matControls[, "azimuthal"]%>% circ.summary(rads = FALSE, plot = FALSE)
```

```
## $mesos
## [1] 149.8446
## 
## $confint
## [1] 148.7197 150.9695
## 
## $kappa
## [1] 0.663083
## 
## $MRL
## [1] 0.3145656
## 
## $circvariance
## [1] 0.6854344
## 
## $circstd
## [1] 1.520896
```

Scatterplot matrix of coaptation line measures. 
 
![plot of chunk scatterplotMatrixCoaptationLine](../figures/scatterplotMatrixCoaptationLine-1.png)

```
## Saving 7 x 7 in image
```
 
Correlations.


```r
circ.cor1(df$polar, df$azimuthal, rads = FALSE)
```

```
##        rho    p-value 
## 0.18384547 0.07485033
```

```r
circ.cor2(df$polar, df$azimuthal, rads = FALSE)
```

```
##        rho    p-value 
## 0.04200493 0.99654087
```

```r
circlin.cor(df$polar, df[, c("radial", "bsa", "orifice_area")], rads = FALSE)
```

```
##       R-squared      p-value
## [1,] 0.12007523 0.0000118665
## [2,] 0.05463061 0.0058553758
## [3,] 0.04236606 0.0185962606
```

```r
circlin.cor(df$azimuthal, df[, c("radial", "bsa", "orifice_area")], rads = FALSE)
```

```
##        R-squared   p-value
## [1,] 0.052024485 0.0074860
## [2,] 0.003150427 0.7436825
## [3,] 0.017708820 0.1892279
```

ANOVA.


```r
hcf.circaov(matAll[, "polar"], factor(df$type), rads = FALSE)
```

```
##       test    p-value      kappa 
##  2.2461896  0.1372596 25.9303615
```

```r
lr.circaov(matAll[, "polar"], factor(df$type), rads = FALSE)
```

```
##       test    p-value      kappa 
##  2.2629933  0.1324977 25.9303615
```

```r
embed.circaov(matAll[, "polar"], factor(df$type), rads = FALSE)
```

```
##       test    p-value      kappa 
##  2.2409746  0.1377114 25.9303615
```

```r
het.circaov(matAll[, "polar"], factor(df$type), rads = FALSE)
```

```
##      test   p-value 
## 2.3060975 0.1288672
```

```r
conc.test(matAll[, "polar"], factor(df$type), rads = FALSE)
```

```
## $mess
## [1] "The mean resultant length is more than 0.7. U3 was calculated"
## 
## $res
##      test   p-value 
## 1.7746721 0.1828049
```

```r
hcf.circaov(matAll[, "azimuthal"], factor(df$type), rads = FALSE)
```

```
##     test  p-value    kappa 
##       NA       NA 0.773375
```

```r
lr.circaov(matAll[, "azimuthal"], factor(df$type), rads = FALSE)
```

```
##      test   p-value     kappa 
## 0.2486268 0.6180437 0.7733750
```

```r
embed.circaov(matAll[, "azimuthal"], factor(df$type), rads = FALSE)
```

```
##      test   p-value     kappa 
## 0.2202366 0.6399350 0.7733750
```

```r
het.circaov(matAll[, "azimuthal"], factor(df$type), rads = FALSE)
```

```
##      test   p-value 
## 0.2411616 0.6233684
```

```r
conc.test(matAll[, "azimuthal"], factor(df$type), rads = FALSE)
```

```
## Error in conc.test(matAll[, "azimuthal"], factor(df$type), rads = FALSE): object 'U3' not found
```


## Circular regression for polar angle

Unadjusted.


```
## $runtime
##    user  system elapsed 
##    0.08    0.00    0.05 
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



|type    |typeCase |      pred|
|:-------|:--------|---------:|
|Case    |TRUE     | -74.03466|
|Control |FALSE    | -77.52930|

Adjusted for body surface area.


```
## $runtime
##    user  system elapsed 
##    0.06    0.00    0.05 
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



|type    |typeCase | bsaScaled|scaling             |      pred|
|:-------|:--------|---------:|:-------------------|---------:|
|Case    |TRUE     |        -1|-1 SD from mean BSA | -68.07226|
|Control |FALSE    |        -1|-1 SD from mean BSA | -76.87128|
|Case    |TRUE     |         0|Mean BSA            | -73.92796|
|Control |FALSE    |         0|Mean BSA            | -78.19523|
|Case    |TRUE     |         1|+1 SD from mean BSA | -76.32610|
|Control |FALSE    |         1|+1 SD from mean BSA | -78.97519|

Adjusted for orifice area area.


```
## $runtime
##    user  system elapsed 
##    0.12    0.00    0.07 
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



|type    |typeCase | orificeAreaScaled|scaling                      |      pred|
|:-------|:--------|-----------------:|:----------------------------|---------:|
|Case    |TRUE     |                -1|-1 SD from mean orifice area | -62.87641|
|Control |FALSE    |                -1|-1 SD from mean orifice area | -75.97007|
|Case    |TRUE     |                 0|Mean orifice area            | -73.33573|
|Control |FALSE    |                 0|Mean orifice area            | -78.81728|
|Case    |TRUE     |                 1|+1 SD from mean orifice area | -77.24663|
|Control |FALSE    |                 1|+1 SD from mean orifice area | -80.36730|


## Circular regression for azimuthal angle

Unadjusted.


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



|type    |typeCase |      pred|
|:-------|:--------|---------:|
|Case    |TRUE     | -196.2712|
|Control |FALSE    | -210.4904|

Adjusted for body surface area.


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



|type    |typeCase | bsaScaled|scaling             |      pred|
|:-------|:--------|---------:|:-------------------|---------:|
|Case    |TRUE     |        -1|-1 SD from mean BSA | -191.9931|
|Control |FALSE    |        -1|-1 SD from mean BSA | -205.4875|
|Case    |TRUE     |         0|Mean BSA            | -195.0271|
|Control |FALSE    |         0|Mean BSA            | -212.7379|
|Case    |TRUE     |         1|+1 SD from mean BSA | -199.0516|
|Control |FALSE    |         1|+1 SD from mean BSA | -222.9398|

Adjusted for orifice area area.


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



|type    |typeCase | orificeAreaScaled|scaling                      |      pred|
|:-------|:--------|-----------------:|:----------------------------|---------:|
|Case    |TRUE     |                -1|-1 SD from mean orifice area | -191.8783|
|Control |FALSE    |                -1|-1 SD from mean orifice area | -204.7182|
|Case    |TRUE     |                 0|Mean orifice area            | -193.7545|
|Control |FALSE    |                 0|Mean orifice area            | -215.8971|
|Case    |TRUE     |                 1|+1 SD from mean orifice area | -197.3276|
|Control |FALSE    |                 1|+1 SD from mean orifice area | -247.9910|
