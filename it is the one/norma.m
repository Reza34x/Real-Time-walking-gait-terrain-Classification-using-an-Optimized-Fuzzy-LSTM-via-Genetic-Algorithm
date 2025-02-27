function [output] = norma(data)

output = normalize(smoothdata(data, 'movmean', 20), "medianiqr");
% output = smoothdata(data, 'sgolay', 40);
end