
function outMBReadyReverse = MBReadyReverse(MB_Res)
% This function to make the Macro block in reverse order without zeros 

% You can make this ZigZag function with a simple way using the indices to
% make it easy when making the RTL.
ZigZagscan = MB_Res_ZZ(MB_Res);
% Added check if all the MB is zeros make output flag called emptyMB = 1; 

% reverse the zigzag scan 
Rzigzagscan = flip(ZigZagscan) ;


% Note changed Remove the Trailing zeros
for i = 1 : 16
    if (Rzigzagscan(i)~=0)
        % Note this is not right Rzigzagscan = (Rzigzagscan(i):Rzigzagscan(16) );
        Rzigzagscan = Rzigzagscan(i:end);
        break;     
    end
end

% Make the Macro_Block in Reverse Order
outMBReadyReverse = Rzigzagscan;

% Calculate the totla number of zeros

end



