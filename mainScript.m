n = 10000 

A=[-1.71 1; 1.71 1; 0 -1];
b=[0; 171; 0];

R = zeros(n,2);
x = [50;10];
for k=1:size(R,1)
    x = convexSampler(A,b,x);
    R(k,:) = x';
end

plot(R(:,1),R(:,2),'.');

sand = 100 - R(:,1) ;
clay =  R(:,2)*2/1.71 ;
silt = 100 - sand - clay ;
soil_sample = cat(2, sand, clay, silt);