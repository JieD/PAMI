% MeanShift for color images
% test different values for bandwidth h
%function [RESULT] = MeanShift(ORIGINAL)
    
    directory = '/Users/jied/Documents/MATLAB/ImageSegmentation/Segmentation_Data/ColorImage';
    Files = dir(directory);
    sizes = size(Files);
    file_length = sizes(1);
    for k = 1:1
        image_name = Files(k+2).name;
        ORIGINAL = imread(strcat(directory, '/', image_name));
            
        %ORIGINAL = imread('Baboon.bmp');
        % resize to 64*64 for easy computation 
        sizes = size(ORIGINAL);
        factor = 64 / sizes(1);
        ORIGINAL = imresize(ORIGINAL, factor);

        % show original image
        s= subplot(1,2,1);      
        imagesc(ORIGINAL);
        title(s, strcat('Original ', image_name));

        ORIGINAL = double(ORIGINAL); 
        ORIGINAL = ORIGINAL(:); 
        number_points = 64*64; 
        for loop=1:3
            for i=1:number_points
                IM(i,loop) = ORIGINAL((i-1)*3+loop);
            end
        end
         
        % prepare meanshift procedure
        H = [4, 8, 12, 16]; % bandwidth
        c = 1;  % use Epanechnikov Kernel
        TH = 0.5;

        for j=2:2
            h = H(j); % test on different bandwidth
            h = h * h * h;
            stop = TH*TH*h*h;
            I = ORIGINAL;
            J = ORIGINAL;
            % debugging purposes, used to record the each shift result
            % CHANGES(:,1,j,k) = I;
            % shift_number = 2;

            while (true)
                for i=1:number_points
                    x = I(i,:);
                    gn = 0; % nominator
                    gd = 0; % denominator  
                    for n = 1:number_points
                        xn = I(n,:);
                        % Epanechnikov Kernel
                        if (norm(x - xn) <= h)
                            g = c;
                            gn = gn + xn * g;
                            gd = gd + g;
                        end                        
                    end
                    if gn ~= 0                        
                        y = gn / gd; % new shift destination
                    else
                        y = x;
                    end
                    J(i,:) = y;        
                end    
                I = J;

                % record intermediate result
                % CHANGES(:,shift_number,j,k) = J;               
                % shift_number = shift_number + 1;

                % stopping criteria
                if abs(y-x) < stop
                    break;
                end
            end
            % display meanshift results
            J = reshape(J, image_length, image_length);
            s=subplot(5,5,(k-1)*5+j+1);            
            imagesc(J);
            title(s, strcat('h = ', num2str(h)));
            J = reshape(J, image_length * image_length, 1);
            % RESULT(:,j,k) = J;
        end 
    end
%end

% resize imput image to 64*64
% function I = resizeTo64(IM)
%    sizes = size(IM);
%    factor = 64 / sizes(1);
%    I = imresize(IM, factor);
%end

%function vn = vector_norm(x)
%    vn = sqrt(x * x');
%end