function [area] = haversineArea(longitude,latitude,unitLongitude,unitLatitude)
% Calculates the area of a grid cell at a given longitude and latitude from
% its unitLatitude and unitLongitude
%
% INPUT:
%       longitude (Double) - Longitude in degrees
%       latitude (Double) - Latitude in degrees
%       unitLongitude (Double) - Unit longitude of the gridcell in degrees
%       unitLatitude (Double) - Unit latitude of the gridcell in degrees
% OUTPUT:
%       area (Double) - Area in m^2
%
unitHeight = haversine([longitude longitude],[latitude (latitude + unitLatitude)]);
unitWidth = haversine([longitude (longitude + unitLongitude)],[latitude latitude]);

area = unitHeight * unitWidth;