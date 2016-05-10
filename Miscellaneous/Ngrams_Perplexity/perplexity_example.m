% Understanding Perplexity in Language modeling
% 2016-04-12 by. Yejin Cho
% Perplexity of uniform dist. vs. gaussian dist.

uniform = repmat(.01,[1,100]);
gauss = randn(1,100);
gauss = gauss/sum(gauss);

subplot(1,2,1)
histogram(uniform); title('Uniform dist.')
subplot(1,2,2)
histogram(gauss,10); title('Gaussian dist.')

if perplexity(uniform) > perplexity(gauss)
    fprintf('log perp. of Uniform: %.4f\n', log(perplexity(uniform)))
    fprintf('log perp. of Gaussian: %.4f\n', log(perplexity(gauss)))
    fprintf('Gaussian has a LOWER perplexity!\n')
end
