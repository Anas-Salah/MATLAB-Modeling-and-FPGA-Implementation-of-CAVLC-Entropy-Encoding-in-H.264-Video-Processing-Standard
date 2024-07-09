%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% This is the main script %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  bitstream = CAVLC(MB_Res , nU,nL) 
 
%%%%%%%%%%%%%%%%%%%% Pre-processing steps %%%%%%%%%%%%%%%%%%%%
% Make the Reverse ZigZag Scanning
MB_Ready_Reverse = MBReadyReverse(MB_Res);
% Calc number of NZQs and T1s.
%function [outTrOnesSign,TrailingOnesNum] = tOnesSign(MB_Ready_Reverse)
%T1s = tTrailingOnesNum(MB_Ready_Reverse);
[~,T1s] = tOnesSignAndNum(MB_Ready_Reverse); 
NZQs = tCoeffNum(MB_Ready_Reverse);

%%%%%%%%%%%%%%%%%%%% The First Step %%%%%%%%%%%%%%%%%%%%%
% - % Choose_Number_VLC_Table
bitstream = numVlcTables(nU,nL,(NZQs+1),(T1s+1)); % There is a small conflict that the MATLAB is from one index but the coeff token is zero coefficent so add one to NZQs and T1s

%%%%%%%%%%%%%%%%%%%% The Second Step %%%%%%%%%%%%%%%%%%%%
% Encoding the Sign of trailing ones in reverse order.
% the trailing ones are of index zero
T1Sign= tOnesSignAndNum(MB_Ready_Reverse);
% Note modified here outside the for loop
bitstream = [ bitstream T1Sign ];

%%%%%%%%%%%%%%%%%%%% The Third Step %%%%%%%%%%%%%%%%%%%%%
% Encoding the Levels (Sign and Magnitude) ///starting with the highest frequency and working back towards the DC coefficient
levelsBit = levels(NZQs,T1s,MB_Ready_Reverse);
bitstream = [bitstream levelsBit ];

%%%%%%%%%%%%%%%%%%%% The Fourth Step %%%%%%%%%%%%%%%%%%%%
% Encoding the total number of zeros before the last coefficient(TotalZeros) 
%totalZeros = sum(~MB_Ready_Reverse(:)) ;
totalZerosEncoded = totalZeros(NZQs,MB_Ready_Reverse);
bitstream = [bitstream totalZerosEncoded ];

%%%%%%%%%%%%%%%%%%%% The Last Step %%%%%%%%%%%%%%%%%%%%%%
% The number of zeros preceding each non-zero coefficient (run before) is encoded in reverse order. (Encode each run of zeros)
%run = config(MB_Res);
out = runBefore(MB_Ready_Reverse );
bitstream = [bitstream out ];
bitstream = strjoin(bitstream);
end
