% Gets the number of amenities in the OSM database
% 
% INPUT:
%           'amenity.txt' - List of amenities to look at
% OUTPUT:
%           result(:,1:2) (Double) - Longitude and Latitude of the amenity
% EXAMPLE:
%           [result] = getAmenity('bar', 'Bristol')

tic;

amenityTags = textread('osm_keys/point_tags_keys.txt','%s','delimiter','\n');

a = length(amenityTags);
amenityCount = zeros(a,1);

for i = 1:a
    amenityTag = amenityTags{i};
    
    query = ['SELECT COUNT(p) '...
            'FROM planet_osm_point AS p '...
            'WHERE (p.amenity=''' amenityTag ''')'];% OR p.tags ? ''' amenityTag '''
    amenityCount(i) = getFileOrQuery(['./cache/countx/' amenityTag ], query);
end

[amenityCount,index] = sort(amenityCount,'descend');

% basically use this
% select p.amenity,count(*) as count_all from planet_osm_point as p group by p.amenity order by count_all desc;


%%

amenityTags = amenityTags(index);

toc;