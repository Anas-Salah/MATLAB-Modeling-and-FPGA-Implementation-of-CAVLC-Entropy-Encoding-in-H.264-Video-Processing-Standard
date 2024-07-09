function  stream = runBefore(MB_Ready_Reverse ) 

% Runsleft vs Run Before
% Define the Runsleft table as a cell array
%{
runsTablee = [
%    1	   2	3	   4	 5	   6	  >6
    "1"   "1"  "01"   "01"  "01"  "01"   "000" ;
    "0"   "01" "00"   "00"  "00"  "00"   "010" ;
    "-"   "00" "11"   "11"  "11"  "101"  "101" ;
    "-"   "-"  "10"   "101" "101" "100"  "100" ;
    "-"   "-"  "-"    "100" "1001" "111"  "111" ;
    "-"   "-"  "-"    "-"   "1000" "1101" "110" ;
    "-"   "-"  "-"    "-"   "-"    "1100" "0011" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "0010" ;
    ""    "-"  "-"    "-"   "-"    "-"    "00011" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "00010" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "00001" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "0000011" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "0000010" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "0000001" ;
    "-"   "-"  "-"    "-"   "-"    "-"    "00000001" ;
];
%}
% Rows are the run before, and columns are zeros left
% rows start with index zero because there may be no non zero coeff 
% columns start with index one because it's not possiple to have no zeros 

runsTable = [
"1"       "1"       "11"      "11"      "11"      "11"      "111"
"0"       "01"      "10"      "10"      "10"      "000"     "110"
""        "00"      "01"      "01"      "011"     "001"     "101"
""        ""        "00"      "001"     "010"     "011"     "100"
""        ""        ""        "000"     "001"     "010"     "011"
""        ""        ""        ""        "000"     "101"     "010"
""        ""        ""        ""        ""        "100"     "001"
""        ""        ""        ""        ""        ""        "0001"
""        ""        ""        ""        ""        ""        "00001"
""        ""        ""        ""        ""        ""        "000001"
""        ""        ""        ""        ""        ""        "0000001"
""        ""        ""        ""        ""        ""        "00000001"
""        ""        ""        ""        ""        ""        "000000001"
""        ""        ""        ""        ""        ""        "0000000001"
""        ""        ""        ""        ""        ""        "00000000001"

];
% Display the Runsleft table
%disp(runsTable);
%%
% The Logic 
runZeros = 0;
% if you will give him a variable youhave to give it in the input 
zerosN = sum(~MB_Ready_Reverse(:)) ;
zerosLeft  = zerosN ;
QLength = length(MB_Ready_Reverse);
stream = [];
bitstream = [];
%%
% continue Pass control to next iteration of for or while loop
% I added this condition because if the zeros left is zero we will not use
% the loop and to improve the timing in case of No Zeros
  if zerosLeft>=1
      for i = 1:QLength
           % make sure that you will use it 
        % this is a big mistake because if there run before at hte end the first MB will not added >>> if (i~=0)

        % this only to pass the first NZQ and count after it 
             if (i==1)
              continue;        
             elseif(MB_Ready_Reverse(i)==0)
                    runZeros = runZeros +1 ;
                    if(i== QLength)
                      break;
                    end
             else
                    % addd = "from vlc";
                    % made error here because it exceed the number six you have to add logic for that.
                    zerosLMax = min (zerosLeft , 7);
                    % Note this is the previous  runBeforeOut = runsTable( runZeros +1 , zerosLMax +1 );
                    if (zerosLMax > 0)
                        runBeforeOut = runsTable( runZeros +1 , zerosLMax );
                        stream = [stream runBeforeOut];
                        zerosLeft = zerosLeft - runZeros ;
                        runZeros = 0;
                    end
                    % NOTE The solution is very simple is to move it down (Rearrange the sequence)
                    
            end
      end       
  end
end
















