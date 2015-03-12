load('Training.mat');

k1 = 0.0000005;
k2 = 0.0000005;
e1 = zeros(1,137);

    for i=1:137
        temp1 = k1 - (0.0001*1/(2*137) * dE1(k1,k2,yLog));
        temp2 = k2 - (0.0001*1/(2*137) * dE2(k1,k2,yLog));
        k1 = temp1;
        k2 = temp2;
        e1(i) = (yLog(i)-50 - k1*log(cosh(k2*i)))^2;
    end
k1
k2
plot(e1);