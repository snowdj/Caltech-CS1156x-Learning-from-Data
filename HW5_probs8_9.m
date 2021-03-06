%%%%%5 HW 5 problems 8 and 9

% Initialization
clear ; close all; clc
totalIter = 0;
OutSampleErrorTotal = 0;
d = 2; % dimension of x vector
a = -1; b = 1;  % sample from [a,b]^d
N = 100; % number of points to sample
m = 100; % number of runs
K = 10000;  % number of points in test sample for probability calculation

%rng('default'); % set up random number generator

for i=1:m
    %Get dataset
    [X, Y, fNormVec] = GenSepUniformPts(N, d, a, b);
   
    % Run stochastic gradient descent for logistic regression
    num_iter = 0;
    eps = 0.01;
    eta = 0.01;
    error = 1;
    w = double(zeros(d+1, 1));
        
    while(error >= 0.01)
        w_t1 = double(w);
        indices = randi([1, N], N, 1); % randomize indices
        for j = 1:length(indices)
            w = w - eta.*grad_error_logistic(X(j, :), Y(j,1), w);
        end;
        error = norm(w_t1 - w);
        num_iter = num_iter + 1;
    end;
    
    totalIter = totalIter + num_iter;
    
    % Generate sample to compute out of sample error
    xOut = a + (b-a).*rand(K, 2);   % X test sample points
    xOut = [ones(K, 1), xOut]; % now x = {1} X [-1,1]^d
    
    % Classify xTest points using f and g
    yOut = sign(xOut*fNormVec);
    OutSampleError = 0;
    for j = 1:K
        OutSampleError = OutSampleError + error_logistic(xOut(j,:), yOut(j,1), w);
    end;
    OutSampleErrorTotal = OutSampleErrorTotal + OutSampleError;
end;
avgIter = totalIter/m
Eout = OutSampleErrorTotal/(m*K) % Out of sample error of logistic regression