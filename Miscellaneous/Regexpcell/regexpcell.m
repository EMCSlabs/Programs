function cellIdx = regexpcell(cellArray,expression)
is_a_match = ~cellfun(@isempty,regexp(cellArray,expression));
cellIdx = find(is_a_match);