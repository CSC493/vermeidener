---
layout: post
title:  "Yuliya and Chris: Stereo Vision: Disparity Map on iOS Part 2"
date:   2015-03-31 12:00:00
categories: jekyll update
---



### Stereo Vision: Disparity Map on iOS Part 2
-------------

#### Testing and Adjustment
Over the week we have looked into SGBM parameters in order to produce a better disparity map. We have also read Stereo Vision using the OpenCV library by Droppelmann et al, investigating their approach to stereo vision using OpenCV. This paper is a bit old as they mention one parameter that at least the iOS version does not have. On the other hand, the parameters are explained much better than in the actual OpenCV documentation. 

The method Droppelmann et al use does not work the best for our purposes as they use two webcams. They dedicate a lot of attention to calibration which is really hard to achieve in our approach, as the jitter is pretty much uncontrolled. It is possible to apply certain data from the accelerometer, but we cannot provide "actual" coordinates. As a consequence, we cannot rectify the images properly.  

We have managed to tune the performance a bit by adjusting the parameters, but that did not change disparity map quality. 

Finally, as this was not reflected in the previous blog post, we have translated audio component into iOS. We are using 440, 580, and 750 frequencies, mapping to left, front, and right respectively. Since we are doing this just for a proof of concept, we are playing the frequencies one after the other, with a pause corresponding to the calculation of a different disparity map. 


#### Conclusions
It seems to be quite difficult to adjust the quality of disparity map on the phone when two source are produced from the jitter of the phone. The distance between two pictures plays a very important role, and jitter does not allow much control over this aspect, which impacts the quality of the disparity map in a rather negative fashion. Having two cameras with fixed distance would produce better results. 
