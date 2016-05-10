
ovco1 = [];

for i = 1:length(ovc1)
    ovc = cell2mat(ovc1(i));
    for n = 1:height(co1)
        co = cell2mat(co1.uq_co(n));
        if ovc(end-1:end) == co(1:2)
            ovco1{end+1,1}=[ovc co(end-1:end)];
            ovco1{end,2}=(ovc1{i,2})*(co1.prob_co(n));

        end
    end
end