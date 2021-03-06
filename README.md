# OSM LAB README #

This program makes use of a local PostGIS server with OpenStreetMap database and raster population data layer of the world. At the moment, the following features are available.

## Point Analysis ##
Point analysis encompasses anything to do with looking at static points of interests. In this context, it primarily refers to amenities presented on OpenStreetMap database.

To run point related analysis, alter and execute the following as required:

runPointAnalysis.m

## Highway Analysis ##
Highway analysis looks at road networks on OpenStreetMaps and performs analysis to calculate Trips, Maximum Flow and Shortest path. The objective of this part of the program is to see how well these correlate across different geographical locations and how well the results we find match up with census data.

To run highway related analyses, alter and execute the following as required:

runHighwayAnalysis.m