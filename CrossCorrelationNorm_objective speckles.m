function [CrossCorrelationMat] = CrossCorrelationNorm518( I1,I,ifShow,f1)
%CROSSCORELATIONNORM Calcluate the Cross Correlation Factor between two
%images
%   ifShow is optional
    %c.c is acronym for Cross Correlation
        s = inputname(2);
        condition1=exist('ifShow', 'var');
        condition2=exist('f1', 'var');        
    if (~condition1) % cheking optional input variable
        ifShow = 1;
    %making defualt figure if no ifShow is False
        if (~condition2 && ifShow == 1) % cheking optional input variable
            f1 = figure('Name',['The processed variable is ''' s '''.'],'NumberTitle','off','Color',[1 1 1]);
        end
    end
    %Divide an image up into blocks by using mat2cell().
    blockSizeR = 64; % Rows in block.
    blockSizeC = 64; % Columns in block.
    
     
   %I = rgb2gray(I);
    %I1 = rgb2gray(I1);
    
    
    % normalize for envelope
     env_size=100;
     frame_size=round(env_size/2);
     envelope1=conv2fft(I1,ones(env_size),'same');
     I1=I1./envelope1;
     I1=I1(frame_size:end-frame_size,frame_size:end-frame_size);
     envelope2=conv2fft(I,ones(env_size),'same');
     I=I./envelope2;
     I=I(frame_size:end-frame_size,frame_size:end-frame_size);
    interpFactor = 1;
    if interpFactor~= 1
        I1 = interpft(interpft(I1,interpFactor*n,1),interpFactor*m,2);
        I = interpft(interpft(I,interpFactor*n,1),interpFactor*m,2);
    end

% Most will be blockSizeR but there may be a remainder amount of less than that.
[rows,columns] = size(I);
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns.
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

    ca = mat2cell(I, blockVectorR, blockVectorC); % Create the cell array, ca. 
    ca1 = mat2cell(I1, blockVectorR, blockVectorC); % Each cell (except for the remainder cells at the end of the image)
    numRows = size(ca, 1);
    numCols = size(ca, 2);
    CrossCorrelationMat=zeros(numRows,numCols);
    plotIndex = 1;
    for r = 1 : numRows
      for c = 1 : numCols
        %fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
        % Specify the location for display of the image.
        
        %subplot(numRows, numCols, plotIndex);
          referenceimageBlock = ca{r,c};% Extract the numerical array out of the cell
          inputimageBlock = ca1{r,c};
          CrossCorrelationMat(r,c) = corr2( referenceimageBlock,inputimageBlock);
          [rowsB,columnsB ] = size(inputimageBlock);
%        if ifShow == 1
%        figure(f1)
        %imagesc(CrossCorrelationMat(r,c));
        %colorbar
        % Make the caption the block number.
          %caption = sprintf('CC block #%d of %d\n%d rows by %d columns', ...
          %    plotIndex, numRows*numCols, rowsB, columnsB);
          %title(caption);
          %drawnow;
          
 %       end
          
          
          % Increment the subplot to the next location.
          plotIndex = plotIndex + 1;
      end
    end
    %CrossCorrelationValue = max(max(CrossCorrelationMat));
end




