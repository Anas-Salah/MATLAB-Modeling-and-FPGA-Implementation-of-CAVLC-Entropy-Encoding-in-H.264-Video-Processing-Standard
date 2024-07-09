function bits = levels(NZQs,T1s,MB_Ready_Reverse)

% Encode the levels of remaining non-zero coefficients
 % find the suffix length	
% i_total = NZQs
% i_trailing= T1s
 % New MB without any zeros
noZeroMB = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(MB_Ready_Reverse)
    if (MB_Ready_Reverse(i) ~= 0)
        noZeroMB = [noZeroMB MB_Ready_Reverse(i)];
    end
end
array_end = length(noZeroMB);

level  = noZeroMB(T1s +1 : array_end);


	%% you CAVCL comments 
	% Determine the suffix length based on the total number of coefficients and the number of trailing ones
if (NZQs>10)&(T1s<3)
   i_sufx_len = 1;
else
   i_sufx_len = 0;
end
bits = [];
% Loop through each of the remaining non-zero coefficients
%for i=(i_trailing + 1):i_total
for  i=1:length(level)
    
    % Calculate a level code that encodes the magnitude and sign of the coefficient
    if level(i)<0
        i_level_code = -2*level(i) - 1;
    else
        i_level_code = 2*level(i) - 2;
    end
    
    % If the current coefficient is the first one after the trailing ones and there are less than 3 trailing ones, subtract 2 from the level code
   % Note this is the old one if (i == i_trailing + 1)&(i_trailing<3).  
    if (i == 1)&(T1s<3)
       i_level_code = i_level_code - 2; 
    end
    
    % Encode the level code into a binary string made up of a prefix and a suffix
    % The prefix is a string of zeros followed by a one, with the number of zeros indicating the magnitude of the level code
    % The suffix is a binary representation of the level code, with a length equal to the calculated suffix length
    % Special cases are handled to accommodate large coefficients
%%
    if bitshift(i_level_code,-i_sufx_len)<14
	%intout = bitshift(A,k) returns A shifted to the left by k bits, equivalent to multiplying by 2k. 
	%Negative values of k correspond to shifting bits right or dividing by 2|k| and rounding to the nearest integer towards negative infinity. Any overflow bits are truncated.
        level_prfx = bitshift(i_level_code,-i_sufx_len);
        
% Note it's an interesting part to add in hardware
        while(level_prfx>0)
            bits = [bits '0'];
            level_prfx = level_prfx - 1;
        end
        bits = [bits '1'];
        
        if i_sufx_len>0 
            level_sufx = dec2bin(i_level_code,i_sufx_len);
            x = length(level_sufx);
            if x>i_sufx_len
                level_sufx = level_sufx(x-i_sufx_len+1:x);
            end
            bits = [bits level_sufx];
        end
        % here finishing handling prefix and suffix for the first case if bitshift(i_level_code,-i_sufx_len)<14


%{
    % Special handling of the encoding for larger coefficients (when level code is less than 30 and suffix length is 0)
    elseif (i_sufx_len==0)&(i_level_code<30)
       level_prfx = 14;
       while(level_prfx>0)
            bits = [bits '0'];
            level_prfx = level_prfx - 1;
        end
        bits = [bits '1'];
        
       level_sufx = dec2bin(i_level_code-14,4);
       x = length(level_sufx);
            if x>4
                level_sufx = level_sufx(x-4+1:x);
            end
       bits = [bits level_sufx];
    
    % Another special handling of the encoding for large coefficients (when level code shifted right by suffix length equals 14 and suffix length is greater than 0)
    elseif (i_sufx_len>0)&(bitshift(i_level_code,-i_sufx_len)==14)
        level_prfx = 14;
       while(level_prfx>0)
            bits = [bits '0'];
            level_prfx = level_prfx - 1;
        end
        bits = [bits '1'];
        
        level_sufx = dec2bin(i_level_code,i_sufx_len);
        x = length(level_sufx);
            if x>i_sufx_len
                level_sufx = level_sufx(x-i_sufx_len+1:x);
            end
        bits = [bits level_sufx];
    % Handling of scenario where prefix is set to 15
    else
        level_prfx = 15;
       while(level_prfx>0)
            bits = [bits '0'];
            level_prfx = level_prfx - 1;
        end
        bits = [bits '1'];
        
        i_level_code = i_level_code - bitshift(15,i_sufx_len);
        
        if i_sufx_len==0
           i_level_code = i_level_code - 15; 
        end
        
        if (i_level_code>=bitshift(1,12))|(i_level_code<0)
            disp('Overflow occured');
        end
        
        level_sufx = dec2bin(i_level_code,12);
        x = length(level_sufx);
            if x>12
                level_sufx = level_sufx(x-12+1:x);
            end
        bits = [bits level_sufx];
    end
%}  
%%
    % Update the suffix length for the next coefficient
    if i_sufx_len==0
        i_sufx_len = i_sufx_len + 1;
    end
    if ((abs(level(i)))>bitshift(3,i_sufx_len - 1))&(i_sufx_len<6)
        i_sufx_len = i_sufx_len + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

