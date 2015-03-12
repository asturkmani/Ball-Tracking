function [ error ] = untitled5( k1,k2,y )
error = 0;

for i=1:137
    error = error + 2*(k1*log(cosh(k2*i)) - y(i))*(i*tanh(k2*i));
end

