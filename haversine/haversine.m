function d=haversine(longitude,latitude)

% HAVERSINE     Computes the  haversine (great circle) distance in metres
% between successive points on the surface of the Earth. These points are
% specified as vectors of latitudes and longitudes.
%
%This was written to compute the distance between
%
%   Examples
%       haversine([53.463056 53.483056],[-2.291389 -2.200278]) returns
%       6.4270e+03
%
%   Inputs
%       Two vectors of latitudes and longitudes expressed in decimal
%       degrees. Each vector must contain at least two elements.
%
%   Notes
%       This function was written to process data imported from a GPS
%       logger used to record mountain bike journeys around a course.

longitude=deg2rad(longitude);
latitude=deg2rad(latitude);

dLatitude=diff(latitude);
dLongitude=diff(longitude);

a=sin(dLatitude/2).^2+cos(latitude(1:end-1)).*cos(latitude(2:end)).*sin(dLongitude/2).^2;
c=2*atan2(sqrt(a),sqrt(1-a));

R=6371000; %in metres
d=R.*c;