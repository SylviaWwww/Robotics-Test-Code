clear all
close all

%addpath("../../exampleData/DataSets")
%addpath("../include")
%addpath("../include")

%addpath("../dictionary")
%load('dataSet_CIRCLE.mat')
load("arucoDict.mat")
load("calibrationSession.mat")

marker_length = 0.1;

image = imread('get.png');

[marker_nums, landmark_centres, marker_corners] = detectArucoPoses(image, marker_length, calibrationSession, arucoDict)
