function [manyGridSizesSigmasAmenityAmenityCorrelations, manyTimes] = getManyGridSizesSigmasAmenityAmenityCorrelations(amenityTags, places, gridSizes, sigmas, populationWeighted)
% Returns the correlation of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags(m) (String) - Name of the amenities to consider
%           places(n) (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           manyGridSizesSigmasAmenityAmenityCorrelation{m,n}(i,j) (Double) 
%               Correlation between amenity map of amenityTags{m} of given 
%               places{n} in grid format for various gridSizes(i) and sigmas(j)
%           manyTimes{m,n}(i,j) (Double) - Time taken to process manyGridSizesSigmasAmenityAmenityCorrelation{m,n}(i,j)
% EXAMPLE:
%           [manyGridSizesSigmasAmenityAmenityCorrelation, manyTimes] = getManyGridSizesSigmasAmenityAmenityCorrelations({'hospital','bar'},{'Bristol','Manchester'},[150:50:5100],[0.1:0.1:10],true)

g = length(gridSizes);
s = length(sigmas);

a = length(amenityTags);
p = length(places);

manyGridSizesSigmasAmenityAmenityCorrelations = cell(p,a,a);
manyTimes = cell(p,a,a);

for m = 1:length(places)
    place = places{m};
    for n = 1:length(amenityTags)
        for o = (n+1):length(amenityTags)

                amenityTag1 = amenityTags{n};
                amenityTag2 = amenityTags{o};

                fCorr = ['./results/AAC/manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag1 '-' amenityTag2];
                fCorrR = ['./results/AAC/manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag2 '-' amenityTag1];
                fTime = ['./results/AAC/time-manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag1 '-' amenityTag2];
                fTimeR = ['./results/AAC/time-manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag2 '-' amenityTag1];

                if exist(fCorr,'file') && exist(fTime,'file')
                    correlation = csvread(fCorr);
                    time = csvread(fTime);
                elseif exist(fCorrR,'file') && exist(fTimeR,'file')
                    correlation = csvread(fCorrR);
                    time = csvread(fTimeR);
                else
                    correlation = zeros(g,s);
                    time = zeros(g,s);

                    step = ['Processing ' place ':' amenityTag1 ':' amenityTag2 '...'];
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
                           
                            correlation(i,j) = getAmenityAmenityCorrelation({amenityTag1 amenityTag2}, place, gridSize, sigma, populationWeighted);
                            time(i,j) = toc;
                        end
                    end

                    close(h);

                    disp(['Saving results to file ' fCorr '...']);
                    csvwrite(fCorr,correlation);
                    disp(['Saving times to file ' fTime '...']);
                    csvwrite(fTime,time);
                end

                manyGridSizesSigmasAmenityAmenityCorrelations{m,n,o} = correlation;
                manyTimes{m,n,o} = time;

        end
    end
end