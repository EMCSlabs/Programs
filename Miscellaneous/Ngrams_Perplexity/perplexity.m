function [val] = perplexity(varargin)
% Perplexity calculation in Language modeling
% 2016-04-12 by. Yejin Cho
% The smaller the perplexity, the better the language model is at modeling unseen data.
% ex: <model1: uniform dist.> perplexity(1/4,1/4,1/4,1/4) -> 4
%     <model2: biased dist.>  perplexity(3/4,1/4)         -> 2.3094
if numel(varargin) == 1
    if iscell(varargin{1})
        taskProbs = cell2mat(varargin{1});
    elseif isnumeric(varargin{1})
        taskProbs = varargin{1};
    end
else
    taskProbs = cell2mat(varargin);
end

% Compute Perplexity
val = prod(taskProbs)^(-1/numel(taskProbs));

end