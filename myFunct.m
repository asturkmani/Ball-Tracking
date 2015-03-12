function Y = myFunct( x,a,b,c )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Y = zeros(size(x));
for i=1:size(x,2)
    Y(i) = b*log(cosh(c*x(i))) + a;
end
Y = Y;


