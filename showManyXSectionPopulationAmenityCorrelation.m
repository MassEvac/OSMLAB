function showManyXSectionPopulationAmenityCorrelation(amenityTags, places, gridSizes, sigmas, XSectionOf, XSectionAt, populationWeighted, saveFigures)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{j} (String Cell) - Name of the amenities to consider
%           places{m} (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer) - Grid granularity in metres
%           sigma(i) (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?% OUTPUT:
% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showManyGridSizesPopulationAmenityCorrelation({'bar','atm','hospital'},'Bristol',[100:100:2000],1,true)

if (nargin < 8)
    saveFigures = false;
end

%% Retrieve the data
[manyGridSizesSigmasPopulationAmenityCorrelations, ~] = getManyGridSizesSigmasPopulationAmenityCorrelations(amenityTags,places,gridSizes,sigmas,populationWeighted);

[p,a] = size(manyGridSizesSigmasPopulationAmenityCorrelations);

%% Retrieve the cross sectional data
for m = 1:p
    for j = 1:a
        correlation = manyGridSizesSigmasPopulationAmenityCorrelations{m,j};
        % If the following throws an error saying
        % 'Improper assignment with rectangular empty matrix.',
        % your XSectionOf probably does not respect XSectionAt.
        % Check both values.
        if strmatch(XSectionOf,'sigma')
            index = abs(sigmas-XSectionAt)<10e-4;
            correlation = correlation(:, index);
        elseif strmatch(XSectionOf,'gridSize')
            index = abs(gridSizes-XSectionAt)<10e-3;
            correlation = correlation(index, :).';
        end
        manyPopulationAmenityCorrelation(:,j) = correlation;
    end
    
    manyPopulationAmenityCorrelationT = manyPopulationAmenityCorrelation';
    unitManyPopulationAmenityCorrelationT = bsxfun(@rdivide, manyPopulationAmenityCorrelationT,manyPopulationAmenityCorrelationT(1,:));
    unitManyPopulationAmenityCorrelation = unitManyPopulationAmenityCorrelationT';
end

%% Iterate through places
for m = 1:p
    place = places{m};

    %% Generate output
    % If it is a cross section of sigma...
    if strmatch(XSectionOf,'sigma')
        %
        figure;
        imagesc(1,gridSizes,manyPopulationAmenityCorrelation,[-1 1]);
        set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')));
        xlabel('Amenity');
        ylabel('Cell Grid Size (metres)');
        colorbar;

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/image-manyGridSizesPopulationAmenityCorrelation-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end
        
        %
        figure;
        plot(gridSizes, manyPopulationAmenityCorrelation);
        legend(upper(strrep(amenityTags, '_', ' ')));

        xlabel('Cell Grid Size (metres)');
        ylabel('Population Amenity Correlation Coefficient');

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/corr-manyGridSizesPopulationAmenityCorrelation-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

        %
        figure;
        plot(gridSizes, unitManyPopulationAmenityCorrelation);
        legend(upper(strrep(amenityTags, '_', ' ')));
        xlabel('Cell Grid Size (metres)');
        ylabel(['Correlation Coefficient / ' upper(strrep(amenityTags{1}, '_', ' ')) ' CorrCoef']);

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/corr-unitManyGridSizesPopulationAmenityCorrelation-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end
        
    % If it is a cross section of gridSize...
    elseif strmatch(XSectionOf,'gridSize')
        %
        figure;
        imagesc(1,sigmas,manyPopulationAmenityCorrelation,[-1 1]);
        set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')));
        xlabel('Amenity');
        ylabel('Sigma');
        colorbar;

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/image-manySigmasPopulationAmenityCorrelation-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

        % 
        figure;
        plot(sigmas, manyPopulationAmenityCorrelation);
        legend(upper(strrep(amenityTags, '_', ' ')));

        xlabel('Sigma');
        ylabel('Population Amenity Correlation Coefficient');

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/corr-manySigmasPopulationAmenityCorrelation-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

        %
        figure;
        plot(sigmas, unitManyPopulationAmenityCorrelation);
        legend(upper(strrep(amenityTags, '_', ' ')));
        xlabel('Sigma');
        ylabel(['Correlation Coefficient / ' upper(strrep(amenityTags{1}, '_', ' ')) ' CorrCoef']);

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/corr-unitManySigmasPopulationAmenityCorrelation-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

    end
end