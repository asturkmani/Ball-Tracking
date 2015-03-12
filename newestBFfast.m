t = cputime;
% initial reading
vid = VideoReader('/Users/asturkmani/Documents/MATLAB/Robotics Project/Version2/CIMG1337.mov');
training = read(vid,6800);
ball = training(120:130,264:274,:);
save('training.mat','training')
minRed = min(min(ball(:,:,1)));
maxRed = max(max(ball(:,:,1)));

% ball picture limits
sizePic = read(vid,2400);
currentSize = size(sizePic);

ballLog = zeros(137,2);

% t = cputime - t;
% t = cputime;

frames = length(ballLog);

for q = 1:frames    
    current = read(vid,q+2522);
    data = zeros(10000,2);
    count = 1;

    for i = 10 : currentSize(1) - 10
        for j = 10 : currentSize(2) - 10
            if current(i,j,1) > minRed + 20 && current(i,j,1) < maxRed + 20
                data(count,:) = [i j];
                count = count + 1;
            end
        end
    end
        
    data = data(1:count - 1,:);
    M =  10000000 * ones(currentSize(1:2));
    
    for i = 1:size(data,1)
        M(data(i,1),data(i,2)) = sum(sum(sum(current(data(i,1)-5:data(i,1)+5,data(i,2)-5:data(i,2)+5,:) - ball(:,:,:)).^2));
    end

    [maxR,indexR] = min(M);             % a = minimum in each row, b = index of minimum (row)
    [maxC,indexC] = min(maxR);          % c = minimum in picture, d = index of minimum (column)             
    ballLog(q,:) = [indexC, indexR(indexC)];  % x and y coordinate of ball 
end

imagesc(M)

% t = cputime - t;

% time = 1:frames;
% 
% yLog = ballLog(:,1);
% xLog = ballLog(:,2);
% save('Training.mat','xLog','yLog');
% plot(time, ballLog(:,1), time, 57.47+573.1*log(cosh(0.009747*time)))  
% A + Blog(cosh(C*t))/C
