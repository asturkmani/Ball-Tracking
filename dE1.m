function [ error ] = dE1( k1,k2,y )
error = 0;
for i=1:137
    a = cosh(k2*i);
    error = error + 2*k1*(log(cosh(k2*i))-y(i))*log(cosh(k2*i));
end

