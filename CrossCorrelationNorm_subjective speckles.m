function [ cc,xmove,ymove,crossI] = CrossCorrelationNorm717( I1,I,ifShow,f1)
%CROSSCORELATIONNORM Calcluate the Cross Correlation Factor between two
%images
%   ifShow is optional
    %c.c is acronym for Cross Correlation
        s = inputname(2);
        condition1=exist('ifShow', 'var');
        condition2=exist('f1', 'var');
       
        
    if (~condition1) % cheking optional input variable
        ifShow = 1;
    
        if (~condition2 && ifShow == 1) % cheking optional input variable
            f1 = figure('Name',['The processed variable is ''' s '''.'],'NumberTitle','off','Color',[1 1 1]);
        end
    end
     % normalize for envelope
env_size=100;
envelope1=conv2fft(I1,ones(env_size),'same');
I1=I1./envelope1;
envelope2=conv2fft(I,ones(env_size),'same');
I=I./envelope2;
    interpFactor = 1;
    colormap hot
    sz = size(I1);
    r = 200;
    n = sz(1);
    m = sz(2);
    if interpFactor~= 1
        I1 = interpft(interpft(I1,interpFactor*n,1),interpFactor*m,2);
        I = interpft(interpft(I,interpFactor*n,1),interpFactor*m,2);
        r = interpFactor * r;
        n = interpFactor * n;
        m = interpFactor * m;
    end
    %creating a circle around input image I1 for cheking c.c
    partI1 = I1(round(n/2-r):round(n/2+r),round(m/2-r):round(m/2+r));
    crossI=abs(fftshift(ifft2(fft2(I1).*conj(fft2(I)))));
    [ymax, xmax] = find(crossI==max(max(crossI)));
    if length(ymax)>1
        xmax = xmax(1);
        ymax = ymax(1);doc
    end
    xmove = xmax - m/2-1;
    ymove = ymax - n/2-1;
    
    partI = I(round(max(1,n/2-ymove-r)):round(min(n,n/2-ymove+r)),round(max(1,m/2-xmove-r)):round(min(m,m/2-xmove+r)));
    if ifShow == 1
           colormap hot
        figure(f1);
        %f1.Color=[0.18 rand/10 0.12];
        hold off
         %annotation(f1,'textbox',[0.13175 0.587412 0.208207 0.076923],...
        %'String',datestr(now),'Fontsize',30,'Color','w','FitBoxToText','on');
        f1.Name=['The processed variable is ''' s '''.'];
        subplot(2,2,[1 2])
        imagesc(crossI)
        title('Cross Correlation','Color', 'k')
        colorbar
%         caxis ([0.5 1])
    end
    
    
%     partI = I1(100-ymove:500-ymove,100-xmove:500-xmove);
    if size(partI)==size(partI1)
        cc = corr2(partI1,partI);
    else
        a = 1;
         disp('size part I ~= part I1')
         cross_cutted = conv2fft(partI1,rot90(partI,2)); % calc cross correlation
         cross_cutted = cross_cutted / sqrt(max(max(conv2fft(partI1,rot90(partI1,2)))) * max(max(conv2fft(partI,flipud(fliplr(partI)))))); % normalize
         cc= max(max(cross_cutted)); % coefficient of correlation
    end
    %cross_cutted = conv2fft(partI1,flipud(fliplr(partI))); % calc cross correlation
    %cross_cutted = cross_cutted / sqrt(max(max(conv2fft(partI1,flipud(fliplr(partI1))))) * max(max(conv2fft(partI,flipud(fliplr(partI))))));
    %cc= max(max(cross_cutted)); % coefficient of correlation
    if ifShow==1    
        subplot(2,2,3)
        imagesc(partI1)
        title('Reference Image','Color', 'k')
        colorbar
        axis image                  
        subplot(2,2,4)
        imagesc(partI)
        title('New Image','Color', 'k')
        colorbar
        axis image
        drawnow
    end
    xmove = xmove / interpFactor;
    ymove = ymove / interpFactor;
end

