---
title: "PrintValve case-control analysis"
date: "2017-02-09 11:15:03"
author: Benjamin Chan (chanb@ohsu.edu)
output:
  html_document:
    toc: true
    theme: simplex
---

# Read anonymized data

Read and clean data.
See [`read.Rmd`](../scripts/read.Rmd) for full details.

1. Read the Excel file
1. Rename columns
1. Remove patients with missing values for `nl`, `rl`, and `ln`
  * 2 cases, 1 control
1. Remove extraneous columns
1. Fix sign of `centroidBottomZ`
  * All values should be $<0$; a few were $>0$
1. Rotate the calculated centroid coordinates relative to "north", as defined by `nstar_X` and `nstar_Y`.
  * Rotate both the calculated and bottom centroids
1. Convert cartesian coordinates of rotated coaptation line to spherical coordinates
  * See function [`cart2sph`](../lib/cart2sph.R)
  * $\rho$ = radial distance
  * $\theta$ = polar angle (inclination) bounded between $(\frac{-\pi}{2}, \frac{\pi}{2})$ or $(-90^{\circ}, +90^{\circ})$; default units is radians
  * $\phi$ = azimuthal angle bounded between $(-\pi, pi)$ or $(-180^{\circ}, +180^{\circ})$; default units is radians
  * $\rho, \theta, \phi$ will be used to describe the coaptation line
1. Normalize the orientation of the coaptation line to the unit sphere

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

Scale the size variables by `bsa`.


```r
df <- 
  df %>%
  mutate(total_area_valueScaled = total_area_value / bsa,
         total_areaScaled = total_area / bsa,
         orifice_areaScaled = orifice_area / bsa,
         valve_diameterScaled = valve_diameter / bsa,
         valve_areaScaled = valve_area / bsa,
         radialScaled = radial / bsa)
```

Output a subset for spot-checking.


```
## File ../data/processed/sphericalCoordinates.csv was written on 2017-02-09 11:15:05
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
## File ../data/processed/compare.csv was written on 2017-02-09 11:15:17
```
# Directional analysis of coaptation line

> From: Benjamin Chan   
> Sent: Wednesday, February 08, 2017 8:15 AM  
> To: G. Michael Silberbach <silberbm@ohsu.edu>  
> Cc: Xiao-Yue Han <hanxi@ohsu.edu>  
> Subject: RE: update  
> 
> Hi Michael,
> 
> Yes, I was thinking along the same path as you. The analysis needs to think of
> the "outcome" as the set of the 3 numbers (or 2 numbers, if you want to think
> of the length separately from the angles) that fully describe the centroid
> line. This brings the statistical analysis into what's called a multivariate
> analysis. It's a little more complicated, but possible. Planning on devoting
> some time on Friday to work it out.
> 
> From: G. Michael Silberbach   
> Sent: Tuesday, February 07, 2017 9:29 PM  
> To: Benjamin Chan <chanb@ohsu.edu>  
> Cc: Xiao-Yue Han <hanxi@ohsu.edu>  
> Subject: RE: update  
> 
> Hi Ben,
> 
> Thinking about the centroid line in space, it may be  incorrect to separate it
> into two numbers and compare cases to controls separately.  We are interested
> in comparing the lines not the angles. The two angles (azimuthal and polar )
> separately may not be different from their control separately but a
> combination of the angles could be different.  Also, what about the
> variability in the centroid length AND angle; is it a big cone or a little
> cone? Let's talk about this some more.
> 
> Assuming that we don't need to analyze the centroid angle and length more,
> these data suggest that the sinus mirror hypothesis predicts a normal aortic
> valve in terms of coaptation area and "shape".
> 
> Michael

Correlations between coaptation line measures.


|             |   bsa| orifice_area| radial| polar| azimuthal|
|:------------|-----:|------------:|------:|-----:|---------:|
|bsa          |  1.00|         0.38|   0.29| -0.20|     -0.02|
|orifice_area |  0.38|         1.00|   0.36| -0.21|     -0.05|
|radial       |  0.29|         0.36|   1.00| -0.34|      0.19|
|polar        | -0.20|        -0.21|  -0.34|  1.00|     -0.24|
|azimuthal    | -0.02|        -0.05|   0.19| -0.24|      1.00|

Scatterplot matrix of coaptation line measures.

![plot of chunk scatterplotMatrixCoaptationLine](../figures/scatterplotMatrixCoaptationLine-1.png)

```
## Saving 7 x 7 in image
```

![plot of chunk polarplot](../figures/polarplot-1.png)

```
## Saving 7 x 7 in image
```


```r
x <- matrix(as.numeric(c(df$coapUnitX, df$coapUnitY, df$coapUnitZ)), ncol = 3)
ina <- factor(df$type)
hcf.aov(x, ina)
```

```
##       test    p-value      kappa 
##  1.7657268  0.1738577 21.6647313
```

```r
lr.aov(x, ina)
```

```
##         w   p-value 
## 3.5742089 0.1674443
```

```r
embed.aov(x, ina)
```

```
##         F   p-value 
## 1.7768999 0.1719612
```

```r
het.aov(x, ina)
```

```
##      test   p-value 
## 3.5920396 0.1659581
```

```r
spherconc.test(x, ina)
```

```
## $mess
## [1] "The mean resultant length is more than 0.67. U3 was calculated"
## 
## $res
##      test   p-value 
## 2.2234523 0.1359288
```


```r
x <- matrix(as.numeric(c(df$centroidCalcRotatedX - df$centroidBottomRotatedX,
                         df$centroidCalcRotatedY - df$centroidBottomRotatedY,
                         df$centroidBottomZ)),
            ncol = 3)
ina <- factor(df$type)
hcf.aov(x, ina)
```

```
##       test    p-value      kappa 
##  1.7657268  0.1738577 21.6647313
```

```r
lr.aov(x, ina)
```

```
##         w   p-value 
## 3.5742089 0.1674443
```

```r
embed.aov(x, ina)
```

```
##         F   p-value 
## 1.7768999 0.1719612
```

```r
het.aov(x, ina)
```

```
##      test   p-value 
## 3.5920396 0.1659581
```

```r
spherconc.test(x, ina)
```

```
## $mess
## [1] "The mean resultant length is more than 0.67. U3 was calculated"
## 
## $res
##      test   p-value 
## 2.2234523 0.1359288
```


```r
x <- matrix(as.numeric(c(df$polar, df$azimuthal) * pi / 180), ncol = 2)
head(x)
```

```
##            [,1]      [,2]
## [1,] -1.5164492 -1.044248
## [2,] -1.1942449 -2.897106
## [3,] -0.7611503 -2.733477
## [4,] -1.4215427 -1.049521
## [5,] -1.2239016  1.166450
## [6,] -1.5183364  3.121065
```

```r
ina <- factor(df$type)
hcf.circaov(x, ina, rads = TRUE)
```

```
##      test   p-value     kappa 
##        NA        NA 0.8824992
```

```r
lr.circaov(x, ina, rads = TRUE)
```

```
##      test   p-value     kappa 
## 0.3455403 0.5566486 0.8824992
```

```r
embed.circaov(x, ina, rads = TRUE)
```

```
##         test      p-value        kappa 
## 1.055183e+02 5.253342e-20 8.824992e-01
```

```r
het.circaov(x, ina, rads = TRUE)
```

```
##         test      p-value 
## 9.198439e+01 8.736269e-22
```

```r
conc.test(x, ina, rads = TRUE)
```

```
## Warning in asin(sqrt(3/8) * 2 * Rbi): NaNs produced
```

```
## Error in conc.test(x, ina, rads = TRUE): object 'U3' not found
```
