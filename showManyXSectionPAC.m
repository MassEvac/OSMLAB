function showManyXSectionPAC(amenityTags, places, gridSizes, sigmas, XSectionOf, XSectionAt, saveFigures)
% Plot the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{j} (String Cell) - Name of the amenities to consider
%           places{m} (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer) - Grid granularity in metres
%           sigmas(i) (Float) - Standard deviation to use for gaussian blurring
%           XSectionOf (String) - Switch to indicate whether to take
%              x-section of 'sigma' or 'gridSize'
%           XSectionAt (Integer/Float) - Where to take the cross section
%           saveFigures (boolean) - Optional boolean switch for saving figures
% OUTPUT:
%           Image of population and amenity correlation in grid format
% EXAMPLE:
%           showManyXSectionPAC({'fuel' 'fire_station' 'police'},{'London'},[100:100:4000],[0.2:0.2:8],'sigma',2,true)

%% Retrieve the data
[PAC, ~] = getManyPAC(amenityTags,places,gridSizes,sigmas);

[p,a] = size(PAC);

%% Iterative Process
for m = 1:p
    place = places{m};
    %% Retrieve the cross sectional data
    for j = 1:a
        correlation = PAC{m,j};
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
        manyPAC(:,j) = correlation;
    end
    
    manyPACT = manyPAC';
    unitManyPACT = bsxfun(@rdivide, manyPACT,manyPACT(1,:));
    unitManyPAC = unitManyPACT';
    
    %% Generate output
    % If it is a cross section of sigma...
    if strmatch(XSectionOf,'sigma')
        figure;
        imagesc(1,gridSizes,manyPAC,[-1 1]);
        set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')));
        xlabel('Amenity');
        ylabel('Cell Grid Size (metres)');
        colorbar;
        
        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/image-manyGridSizesPAC-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end
        
        %
        figure;
        plot(gridSizes, manyPAC);
        legend(upper(strrep(amenityTags, '_', ' ')));

        xlabel('Cell Grid Size (metres)');
        ylabel('Population Amenity Correlation Coefficient');

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/corr-manyGridSizesPAC-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

        %
        figure;
        plot(gridSizes, unitManyPAC);
        legend(upper(strrep(amenityTags, '_', ' ')));
        xlabel('Cell Grid Size (metres)');
        ylabel(['Correlation Coefficient / ' upper(strrep(amenityTags{1}, '_', ' ')) ' CorrCoef']);

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/corr-unitManyGridSizesPAC-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end
        
    % If it is a cross section of gridSize...
    elseif strmatch(XSectionOf,'gridSize')
        %
        figure;
        imagesc(1,sigmas,manyPAC,[-1 1]);
        set(gca,'XTick',1:length(amenityTags),'XTickLabel',upper(strrep(amenityTags, '_', ' ')));
        xlabel('Amenity');
        ylabel('Sigma');
        colorbar;

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/image-manySigmasPAC-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

        % 
        figure;
        plot(sigmas, manyPAC);
        legend(upper(strrep(amenityTags, '_', ' ')));

        xlabel('Sigma');
        ylabel('Population Amenity Correlation Coefficient');

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/corr-manySigmasPAC-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end

        %
        figure;
        plot(sigmas, unitManyPAC);
        legend(upper(strrep(amenityTags, '_', ' ')));
        xlabel('Sigma');
        ylabel(['Correlation Coefficient / ' upper(strrep(amenityTags{1}, '_', ' ')) ' CorrCoef']);

        if saveFigures
            set(gcf,'Position', [0, 0, 800, 300]);
            set(gcf, 'Color', 'w');
            export_fig(['./figures/point_analysis/corr-unitManySigmasPAC-' XSectionOf '-' num2str(XSectionAt) '-' place '.pdf']);
        end
    end     
end