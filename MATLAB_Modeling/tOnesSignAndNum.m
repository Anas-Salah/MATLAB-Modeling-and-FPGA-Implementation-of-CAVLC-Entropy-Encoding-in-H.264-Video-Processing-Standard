
function [outTrOnesSign,TrailingOnesNum] = tOnesSignAndNum(MB_Ready_Reverse)
% This function to calc the number of trailing ones and the sign of the T1s
    % Count the number of positive and negative ones in the matrix
counter = 0;
T1Sign = [];
    if (MB_Ready_Reverse(1) == 1 || MB_Ready_Reverse(1) == -1)
        for i = 1 : length(MB_Ready_Reverse)
            if ((MB_Ready_Reverse(i) ~= 0) && (MB_Ready_Reverse(i) ~= 1) && (MB_Ready_Reverse(i) ~= -1))
                break;
            elseif(MB_Ready_Reverse(i) == 1  && counter<3) 
                counter = counter +1;
                add = "0";
            elseif( MB_Ready_Reverse(i) == -1 && counter<3)
                counter = counter +1;
                add = "1";
            else
                add = [];
            end
            T1Sign = [T1Sign add];
        end
    else 
        counter =0;
        T1Sign = [];
    end

    outTrOnesSign = T1Sign;
    TrailingOnesNum = min ( counter, 3 );
end



