function x = convexSampler(A,b,x)
% Sampling of uniformly distributed vectors x satisfying the linear system
% of inequalities A.x <= b. It is assumed that the convex region described
% by A.x <= b is not unbounded.
if ~all(A*x<=b)
    error('initial point infeasible');
end
x = sampleStepGibbs(A,b,x);
%x = sampleStepHitAndRun(A,b,x);

function x = sampleStepHitAndRun(A,b,x)
% Generate a random direction vector (uniformly covering the surface of a
% unit sphere)
r = randn(size(A,2),1);
r = r/norm(r);
[d_neg,d_pos] = distToConstraints(A,b,x,r);
% a random number [-d_neg,d_pos)
t = -d_neg+(d_pos+d_neg)*rand(1);
% next sample
x = x + t*r;

function x = sampleStepGibbs(A,b,x)
r = zeros(size(A,2),1);
for j=1:size(A,2)
    % generate a unit vector e_j
    r(j) = 1;
    if j>1, r(j-1) = 0; end
    [d_neg,d_pos] = distToConstraints(A,b,x,r);
    % a random number [-d_neg,d_pos)
    t = -d_neg+(d_pos+d_neg)*rand(1);
    % element j of next sample
    x(j) = x(j) + t;
end

function [d_neg,d_pos] = distToConstraints(A,b,x,r)
% Determine the minimum distances between point x and the (two) intersection
% points of constraints A.x <= b and line g(t)=x+t*r (in directions -r and +r).
d_pos = Inf;
d_neg = Inf;
for i=1:size(A,1)
    rho = (A(i,:)*x-b(i))/(A(i,:)*r);
    xci = x - r*rho; % intersection point with constraint i
    d_x_xci = norm(xci - x); % distance
    if r'*(xci - x) >= 0.0 % xci is in direction +r
        if d_x_xci < d_pos
            d_pos = d_x_xci;
        end
    else % xci is in direction -r
        if d_x_xci < d_neg
            d_neg = d_x_xci;
        end
    end
end
