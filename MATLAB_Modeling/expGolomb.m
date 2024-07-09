function codeWord = expGolomb(code_num)
% [Zero prefix][1][INFO]
zeroPrefix = '';
 M = floor(log2 (code_num + 1));
 INFO = code_num + 1 - 2^M; 
 % convert it to binary 
 binaryINFO = dec2bin(INFO);
% code_num and code word I should generate code word
% zeroPrefix = (binaryINFO(1, :) = 0);
%zeroPrefix = char(zeros(1, length(binaryINFO)))
%zeroPrefix = double(binaryINFO(1, :) == '0'

for j=1:M
    zeroPrefix = [zeroPrefix '0'];
end

codeWord = horzcat((zeroPrefix), '1',binaryINFO)

end



