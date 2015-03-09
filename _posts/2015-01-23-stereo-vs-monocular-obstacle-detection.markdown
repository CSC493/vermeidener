---
layout: post
title:  "Yuliya: Stereo vs Monocular Vision for Obstacle Detection"
date:   2015-01-23 12:48:56
categories: jekyll update
---


Week 1: Before Class Readings
-------------

These are the links I have looked at over the break and first week of classes.

[Project Tango](https://www.google.com/atap/projecttango/#project)

[An article about image-recognition software](http://www.nytimes.com/2014/11/18/science/researchers-announce-breakthrough-in-content-recognition-software.html?_r=0)

[Stanford approach to image descriptions](http://cs.stanford.edu/people/karpathy/deepimagesent/)

[Stanford technical report](http://cs.stanford.edu/people/karpathy/deepimagesent/devisagen_arxiv.pdf)

[Stanford Neuraltalk Git repo](https://github.com/karpathy/neuraltalk)

Also, [another fun idea](http://www.livescience.com/46236-vibrating-clothes-help-blind-navigate.html)

#### Conclusion:
It seemed to me like most of inventions in the area focus on custom device creation. Given the nature of the problem it seems even more so justified, yet this is not really the approach we want to take. It would be really cool to lay our hands on something like project Tango, so that we could build on top of existing software, but obstacle detection with a smartphone seems like an interesting and difficult problem to attack. That, of course, means we have to scope our project down, but it seems more realistic this way. 

One thing I would really like to avoid while working on the project is machine learning, as we are constrained by time and cannot devote a lot of time solely to learning that area. That means we have to investigate different ways to perform obstacle detection.


Week 3: Readings and Conclusions
-------------


### Assisting the Visually Impaired: Obstacle Detection and Warning System by Acoustic Feedback

This paper describes a system that focuses on obstacle avoidance. Key features of the system are 3D information calculation using stereo vision, polar grid representation of the sectors the user cares about, and audio feedback.

As the system is using stereo vision, given known stereo calibration parameters, left and right images have to undergo distortion correction and stereo rectification. After this, the system can calculate 3D depth of the point. This gives us a disparity map, which is not actually 3D, but gives enough information to start looking for obstacles. 

First, the system attempts to detect the ground plane. It operates on the assumption that the ground plane is the biggest area on the bottom of the image. 

After this, the system attempts to determine potential obstacles. In order to do so, it first projects a polar grid on the image. The polar grid represents an angle of vision and is divided into radial depths and angular sections. Radial depth serve as markers for how close the object is, and angular sections help to determine direction. 

The system then goes through every pixel on the image, discarding those that are not on the grid or belong to the ground plane. Remaining pixels are filtered into the bins with respect to the sector on the polar grid they would fall into. The system also tries to exclude objects that are too high from the ground as they would not be an obstacle. 

It also uses rather clever encoding of acoustic signals which, according to their studies, proves to be not annoying. This is rather important, as I remember the experiment with already existing software over last session, and that was clearly something that uses too much of a feedback. The system can tell whether the object is on the left, right, or in front of the user, it also distinguishes objects on the corner of the sight such as walls. The user can infer distance to the object from the frequency of the signal. 

#### Conclusion:
I love the fact there is no neural networks in this approach. This is great because I actually doubt we would be able to quickly pick up machine learning to be able to use it well enough for the project. We still need to know a lot about 3D, image processing, and linear algebra.

The authors mention lots of approaches used by other teams, describing potential pros and cons. I actually started reading this paper simply because of this, and I was very sceptical about stereo vision, mainly because my desire was to use single device for the project. The challenge for a single device was distance detection, and stereo vision attempts to solve it rather well. 

Another thing that I liked is that the authors dedicate a lot of attention to the feedback provided to them by participants. It helped me to understand the problem better and actually answered some questions I either had or should have had in the first place. For example, a couple of days ago Chris and I had a discussion on at what distance do the objects matter for as and where should we stop caring. It turned out, we had a rather good estimate developed, but it all boiled down to the fact that we should probably ask the users in order to be sure. This paper describes initial polar grid (that represents the floor area we care for), it's division into sectors, and how it was revised based on the users' feedback. In fact, it is the feedback that makes it most interesting. I was thinking about the audio feedback as well, and after reading this paper, I have a much more clear idea what to do. 

Note: this system it is not fault proof. It can produce false positives, for example, claiming sunshine reflections on a polished floor to be obstacles. 

Another note: while stereo vision seems to be very nice, it would, for one, require two devices as well as communication between them. Another question is whether to process the data on one device, split the work, or use something else for computational power.


### A Smartphone-Based Obstacle Detection and Classification System for Assisting Visually Impaired People

This paper seemed very interesting to me as it sounded very closely related to our research problem. The main difference between it and the previous paper is that it focuses on a smartphone, thus, a single camera is used, which leads to a totally different approach which is definitely worth investigating. 

There are two parts to the proposed approach: obstacle detection and obstacle classification. 

Obstacle detection is done as following: the takes a sequence of images. Each image is split into grid. For each point in the grid of the image, the system attempts to predict its position on the successive image using motion vectors. If something deviates from the estimated error threshold, it is marked as belonging to the foreground objects. Then the system attempts to detect moving objects by clustering the motion vectors of points and further refining it to eliminate possible errors from previous calculations and deviations resulting from noise, image distortion, pose change, etc. Obstacle relevance is done similarly to the approach in the previous paper, by projecting a polar grid on the image and classifying the objects based on their position with respect to the polar grid. 

Obstacle classification is accomplished with the help of machine learning, where the training images are split into blocks with respect to the interest points (and their adjacency), visual words are computed for each block, and the final image representation is a histogram of visual words. For each object detected in detection phase, a frequency histogram is created to be used in processing of further images. Then, the classifier classifies the objects based on this information. 

#### Conclusion:
This idea seems much better in terms of it requires less hardware. Machine learning component might prove to be difficult and object detection seems to be more complicated due to the lack of stereo vision from the previous paper. On the other hand, we can attempt to omit the classification phase and use the results obtained from obstacle detection phase only as in this phase this is the thing we focus on. 
