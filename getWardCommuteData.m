function [trips, centroids, wardList] = getWardCommuteData
% Outputs ward commute trips from files in ./wardData/ in sparse format and their centroids
%
% INPUT:
%           ./wardData/wardArea.csv - File containing the areas of the wards in m^2
%           ./wardData/wardTrips.csv - File containing the trips between the wards
%           ./wardData/wardCentroid.csv - File containings the coordinate
%              of the centroid of the wards
% OUTPUT:
%           trips(i,j) (Integer) - Number of trips from ward centroids i to j
%           centroids(i) (2xDouble) - Longitude and latitude of ward centroids
%           wardList (String) - Names of the wards in the commute raw data
% NOTE:
%           At the moment, the ward areas are not being used in any way!
%           There was a purpose for it and currently I do not remember
%           it... maybe it was to present the trips as number of trips per
%           metre squared. Perhaps ask Anders what to do with it.

wardDataOutput = './wardData/output';
fTrips = [wardDataOutput 'Trips'];
fCentroids = [wardDataOutput 'Centroids'];
fWards = [wardDataOutput 'Wards'];

%% Generate output
if exist(fTrips,'file') && exist(fCentroids,'file') && exist(fWards,'file')
    %% If output file exists
    % Read the ward list
    d = fopen(fWards);
    data = textscan(d, '%s');
    wardList = data{1};
    fclose(d);
    nOD = length(wardList);
    % Read the centroids
    centroids = csvread(fCentroids);
    trips = getResizedAM(spconvert(csvread(fTrips)),nOD);
else
    %% If either of the files do not exist, process output
    wardData = './wardData/';

    %%
    d = fopen([wardData 'wardArea.csv']);
    wardArea = textscan(d, '%s %f','delimiter',',');
    fclose(d);

    %%
    d = fopen([wardData 'wardTrips.csv']);
    wardTrips = textscan(d, '%s %s %d','delimiter','\t');
    fclose(d);

    %%
    d = fopen([wardData 'wardCentroids.csv']);
    wardCentroids = textscan(d, '%s %f %f','delimiter',',');
    fclose(d);

    %% Chose ward area because this has the smallest list of wards compared to ward centroids
    wardAreaList = wardArea{1};
    wardCentroidList = wardCentroids{1};


    %% Unify ward area and centroid list into a single ward list that we have data for
    m = length(wardAreaList);

    lat = [];
    lon = [];
    wardList = {};
    wardCount = 1;

    for i = 1:m
        i
        idx = find(ismember(wardCentroidList,wardAreaList{i}));
        if idx
            lon(wardCount) = wardCentroids{2}(idx);
            lat(wardCount) = wardCentroids{3}(idx);
            wardList{wardCount} = wardAreaList{i};
            wardCount = wardCount + 1;
        end
    end

    %% Now process the trips

    trips = sparse(m,m);
    nOfTrips = wardTrips{3};
    n = length(nOfTrips);

    for i = 1:n
        i
        thisWard = wardTrips{1}{i};
        thatWard = wardTrips{2}{i};

        this=find(ismember(wardList,thisWard));
        that=find(ismember(wardList,thatWard));

        if ~isempty(this) && ~isempty(that)
            % Write to the sparse matrix on the basis of ward area list
            trips(this,that) = nOfTrips(i);
        end
    end

    %% Output to file
    % required: trips, lon, lat
    % and perhaps wardList for reference purposes? currently not required

    % Write trips file
    [m,n,o] = find(trips);
    trips_dump = [m,n,o];
    dlmwrite(fTrips, trips_dump, 'delimiter', ',', 'precision', 10);

    % Write centroids file
    centroids = [lon' lat'];
    csvwrite(fCentroids,centroids);

    % Write ward name file
    f=fopen(fWards,'wt');
    fprintf(f,'%s\n',wardList{:});
    fclose(f);
end    

