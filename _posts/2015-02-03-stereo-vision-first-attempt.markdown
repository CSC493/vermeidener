---
layout: post
title:  "Yuliya: Stereo Vision: First Attempt"
date:   2015-02-06 14:28:53
categories: jekyll update
---



### Stereo Vision: First Attempt
-------------

During the meeting, we have discussed possibilities for project implementation, and Chris mentioned that he would like to experiment with phone's camera to see if we can use jitter of the phone as the owner walks as a sufficient source of different images. There was more to it than that, of course, but this is his idea and so I will not go into much detail as Chris will discuss it into his section. As for me, I thought that if this succeeds, then the pictures will be taken from different angles, and so we might proceed with the stereo vision approach from the paper I have mentioned in my previous post. 

I have planned for my first attempt to be something small, so that I get the general feeling about the approach, and it will be relatively easy to implement without a lot of time investment. Thus, I have thought I would look into a ground plane detection, but it turned out a bit more complicated than I thought. The reason for that was that the authors of the paper consider ground floor detection after the disparity map is done, and creating a disparity map was something I have not done before. Thus, my first step was creating a disparity map. 

There are several formulas in the paper, yet there is no code at all that could be looked at. So, I had to look at the formulas and attempted to recreate the process. I have actually learned a bit about the way the camera in my phone works and which parameters I should consider, such as camera sensor width, where to set the principal points, etc. Yet in the meantime I have realized there is a more simple approach to this problem. The name of the approach is OpenCV, as it can be used to create disparity maps.

I took some pictures to be used for testing and started to experiment with OpenCV StereoBM (computes stereo correspondence using the block matching algorithm) and StereoSGBM (computes stereo correspondence using the semi-global block matching algorithm). In order to avoid complications with channels belonging to color imagers, I have turned the sample images to a grayscale format before passign them to the algorithm.

SGBM seemed to produce better results, yet the quality of the map produced still was not the greatest. The quality of the map produced depends on several factors, from lighting in original left and right pictures to the parameters being passed to the algorithm. The latter called for a more serious experimentation and my next blog post will cover it. 