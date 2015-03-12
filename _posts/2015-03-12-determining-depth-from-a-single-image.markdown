---
layout: post
title:  "Chris: Determining Depth From A Single Image"
date:   2015-03-12 19:09:00
categories: jekyll update
---

When searching for possible ways to determine the depth of objects in a single still image I came across [this][paper] paper. So I took my time reading it through multiple times to make sure as to not miss anything.

As it turns out this paper is rather complex and covers many topics that I had never seen before. The paper talks about using Markov Random Fields for its machine learning and since I didn't have any knowledge about either I started more research looking into Markov Random Fields.

### Markov Random Fields (MRF)

A quick definition from Wikipedia is that a MRF is a set of random variables which have a Markov Property described by an undirected graph.

So a Markov Property is actually a fairly simple concept. A Markov Property states that a future state depends only upon the current state and not upon any state that preceded the current. If we think of this from a statistics point of view, the probability of drawing a ball from a pot only depends upon the previous ball drawn, not any before that.

This means that a MRF can be thought of as an undirected graph of nodes, where the probability of each node depends only on the nodes directly connected to it.


### Conclusion

After reading the paper a couple of times and learning about Markov Random Fields there are still many things that I need to research to fully understand this paper. It did seem at the moment that it was worth putting the time into researching and understanding these topics so that I could understand the paper. As the publishers of the paper had seemed to have quite good results with their experiments I thought it definitely worth trying to continue with this possible approach for determining the depth of objects in an image.

[paper]: http://machinelearning.wustl.edu/mlpapers/paper_files/NIPS2005_684.pdf