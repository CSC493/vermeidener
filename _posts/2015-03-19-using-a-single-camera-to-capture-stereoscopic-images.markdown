---
layout: post
title:  "Chris: Using A Single Camera To Capture Stereoscopic Images"
date:   2015-03-19 22:23:00
categories: jekyll update
---

Due to Yuliya's research into determining depth from stereoscopic images from the past week I am going to be looking into the possibility of using a single camera to record stereoscopic images. The idea behind this is that while a person is walking with their phone/camera they will be unable to hold it perfectly still and will therefore introduce movement. If images are captured at a high enough rate we will have two images that were taken from different points of view of approximately the same subject. Pairing this with accelerometer/movement data we can determine exactly how the two images relate to each other in 3D space. This hopefully will allow us to treat the two images as if they were taken from two different cameras at the same time and at some known spacing, as normal stereoscopic images would be taken.

This week I have written an implementation of this idea that runs on iOS devices and captures images and accelerometer data at approximately 10Hz. Though the accelerometer data is instantaneous data since each data point was taken so close to the next we can assume that it was the same over the interval between data points. Using this we can do some basic math and physics to determine how far the phone has moved since the last data point. The images are saved to the phone to be able to be viewed later to make sure that the images were taken properly and are usable.

### Conclusion

So far this approach seems possible and the images and accelerometer data both seem valid. Given this Yuliya and I will continue to pursue this approach and try to combine her work with mine to determine the depth of objects in the images.