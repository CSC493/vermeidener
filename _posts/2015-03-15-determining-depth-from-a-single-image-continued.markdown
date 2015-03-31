---
layout: post
title:  "Chris: Determining Depth From A Single Image Continued"
date:   2015-03-15 20:48:00
categories: jekyll update
---

This week I continued researching the concepts discussed in the paper from last time. I tried to look into Laws' Masks to see what they were and how they are used to help determine the depth, but could not find anything very useful. So I continued on trying to understand the Gaussian function that they were using to determine depth.

\\[ P\left(d\mid X;\theta,\sigma\right) = \frac{1}{Z}exp\left(-\sum_{i=1}^{M}\frac{(d _i(1) - x _i^T\theta _r)^2}{2\sigma _{1r}^2} - \sum _{s=1}^3\sum _{i=1}^M\sum _{j\in N _s(i)} \frac{(d _i(s) - d _j(s))^2}{2\sigma _{2rs}^2}\right) \\]

I was able to understand most of the function, but I still do not understand how some of the extra parameters affect the function outcome. Put very simply the function takes the sum of each nodes neighbours depths, then sums those across each node, and then sums those for each of the 3 scales of image. This is then subtracted from the sum across each node of the nodes absolute depth features. This is all then scaled to be a proper probability between 0 and 1.

### Conclusion

Due to the lack of understanding and the effort needed to attempt to understand this method of determining depth it seems that this approach to determining depth of a single image is not worth pursuing due to the time and effort need to fully understand this approach and also to write an implementation and duplicate their results. Also since they only talk about their method and do not have any details about implementation, if we were to figure out their method and be able to write an implementation it still may not work properly and need even more time spent to make it work.