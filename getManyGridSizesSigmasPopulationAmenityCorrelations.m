function [manyGridSizesSigmasPopulationAmenityCorrelations, manyTimes] = getManyGridSizesSigmasPopulationAmenityCorrelations(amenityTags, places, gridSizes, sigmas, populationWeighted)
% Returns the correlation of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags(m) (String) - Name of the amenities to consider
%           places(n) (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           manyGridSizesSigmasPopulationAmenityCorrelation{m,n}(i,j) (Double) 
%               Correlation of amenity map of amenityTags{m} and population
%               of given places{n} in grid format for various gridSizes(i)
%               and sigmas(j)
%           manyTimes{m,n}(i,j) (Double) - Time taken to process manyGridSizesSigmasPopulationAmenityCorrelation{m,n}(i,j)
% EXAMPLE:
%           [manyGridSizesSigmasPopulationAmenityCorrelation, manyTimes] = getManyGridSizesSigmasPopulationAmenityCorrelations({'hospital','bar'},{'Bristol','Manchester'},[100:100:5000],[1:10],true)

g = length(gridSizes);
s = length(sigmas);

a = length(amenityTags);
p = length(places);

manyGridSizesSigmasPopulationAmenityCorrelations = cell(p,a);
manyTimes = cell(p,a);

for m = 1:length(places)
    place = places{m};
    for n = 1:length(amenityTags)
        amenityTag = amenityTags{n};

        fCorr = ['./results/PAC/manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];
        fTime = ['./results/PAC/time-manyGridSizesSigmasPopulationAmenityCorrelation-' place '-' amenityTag];

        if exist(fCorr,'file') && exist(fTime,'file')
            correlation = csvread(fCorr);
            time = csvread(fTime);
        else
            correlation = zeros(g,s);
            time = zeros(g,s);

            step = ['Processing ' place ':' amenityTag '...'];
            disp(step);

            h = waitbar(0,step);

            for i=1:g
                gridSize = gridSizes(i);
                for j=1:s
                    tic;
                    completed = (i-1 + j/s)/g;
                    waitbar(completed,h,[step num2str(completed*100) '%']);
                    sigma = sigmas(j);
                    disp(['Processing gridSize:sigma (' num2str(gridSize) ':' num2str(sigma) ')...']);
                    correlation(i,j) = getPopulationAmenityCorrelation(amenityTags(n), place, gridSize, sigma, populationWeighted);
                    time(i,j) = toc;
                end
            end

            close(h);

            disp(['Saving results to file ' fCorr '...']);
            csvwrite(fCorr,correlation);
            disp(['Saving times to file ' fTime '...']);
            csvwrite(fTime,time);
        end
        
        manyGridSizesSigmasPopulationAmenityCorrelations{m,n} = correlation;
        manyTimes{m,n} = time;
    end
end