n = 10000  ;

% -x+y>=2
% 5*x+y>=5
% -1/2*x+y<=5
% 3*x+y<=10
A=[1 -1; -5 -1; -0.5 1; 3 1];
b=[-2; -5; 5; 10];

R = zeros(n,2);
x = [.5;4];

for k=1:size(R,1)
    x = convexSampler(A,b,x);
    R(k,:) = x';
end

plot(R(:,1),R(:,2),'.');

sand = 100 - R(:,1) ;
clay =  R(:,2)*2/1.71 ;
silt = 100 - sand - clay ;
soil_sample = cat(2, sand, clay, silt);
