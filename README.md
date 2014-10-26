---
title: "readme"
author: "Lakshmi Narasimhan Ramakrishnan"
date: "October 26, 2014"
output: html_document
---

# Human Activity Recognition From Samsung Galazy S Phones

The initial dataset went through a series of subsetting and merging transformations as explained below. The test and train sets have were merged and the subject identifiers and activity labels were pulled in to create a common dataset. 

The activity identifiers were translated from factors into human-readable names. Of the entire bulk of values only the mean and standard deviation  were preserved.  Mean for each subject/activity pair were taken. 

The final data set can be found in the `tidyMeans.txt` file, which can be read into R with `read.table("tidyMeans.txt", header = TRUE)`. This dataset obeys all the rules for a tidy dataset as described in the course. A detailed description of the variables can be found in `CodeBook.md`. The basic naming convention is:

  Mean{timeOrFreq}{measurement}{meanOrStd}{XYZ}

Where `timeOrFreq` is either Time or Frequency, indicating whether the measurement comes from the time or frequency domain, `measurement` is one of the original measurement features, `meanOrStd` is either Mean or StdDev, indicating whether the measurement was a mean or standard deviation variable, and `XYZ` is X, Y, or Z, indicating the axis along which the measurement was taken, or nothing, for magnitude measurements.
