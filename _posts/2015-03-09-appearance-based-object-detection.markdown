---
layout: post
title:  "Appearance based obstacle detection"
date:   2014-04-06 15:40:56
categories: update research
---

The goal of this project is to assist visually impaired people to navigate an environment. I believe that the biggest problem they face is circumventing obstacles during the navigation. Therefore the first goal is to come up with a system that will help with avoiding obstacles.

Ease of use is also a major concern, so as a team we decided to focus on using a mobile phone equipped with a camera for this.

Due to a phone only having a single camera, and therefore not being able to detect depth accurately, my approach was to detect obstacles based on appearance.

When searching through Google scholar, [this](http://www.aaai.org/Papers/AAAI/2000/AAAI00-133.pdf) was one of the most cited papers on this topic. My first implementation for prototyping this approach was through Python using the OpenCV wrappers for python.

The methodology described in the paper can be summarized as stated below.

1. Use a Gaussian filter to reduce noise in the image;
2. Convert the image to HSI colour space. This will separate the image into Hue, Saturation and Intensity values. While Hue and Saturation describes the colour, Intensity describes the lightness or how bright it is.
3. Histogram Hue & Intensity.
4. Separate the image into 4 parts. Front, Left, Right and Far.
5. Generate a threshold on the Histogram using the Front partition.
6. Detect if there are obstacles at the Far,Left or Right using this threshold.

We make few assumptions when navigating an environment with this approach.

1. The current Front is a good sample of an area without obstacles.
2. There are no low hanging objects.

If we never move into objects, our Front partition will be free of obstacles, and thus we will always have a good reference point to decide what are obstacles in the environment.

Auditory feedback will be given depending on where we detect obstacles, to aid in navigating.
