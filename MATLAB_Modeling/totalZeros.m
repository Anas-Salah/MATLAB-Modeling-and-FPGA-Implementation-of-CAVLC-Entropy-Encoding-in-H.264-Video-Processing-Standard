
function outTotalZeros = totalZeros(NZQS,MB_Ready_Reverse)

ZerosNumber = sum(~MB_Ready_Reverse(:)) ;

% from 0 to 15 row and 15 columbs 
% numCoeff_TotZeros

%{ 
this is a wrong table
numCoeff_TotZeross = [
    "1          " " 111                 "   " 0010  "    "  111101 "       "   01000   "     "     101100  "  "111000"   " 101000    "     " 111000 "  "   10000    "    "  11000  "        "   1000   "   " 100 "  " 00 "  " 0 "     ;
    "011        " " 101                 "   " 1101  "    "  1110 "         "   01010 "       "     101101  "  "111001"   " 101001    "     " 111001 "  "   10001    "    "  11001  "        "   1001   "   " 101 "  " 01 "  " 1 "   ;
    "010        " " 011                 "   " 000  "     "   0110"         "   01011  "      "     1010    "  "11101"   " 10101    "      " 11101 "   "   1001    "     "  1101  "         "   101    "   " 11 "   " 1  "      ""   ;
    "0011       " " 001                 "   " 010  "     "   1010"         "   1110 "        "     001     "  "1001"   " 1011    "       " 1111 "    "   101    "      "  111  "          "   0      "   " 0 "          ""    ""   ;
    "0010       " " 000                 "   " 1011  "    "  000 "          "   011"          "     010     "  "1111"   " 110    "        " 00 "     "    01   "        "  0  "            "   11     "      ""          ""    ""    ;
    "00011      " " 1000                "   " 1111  "    "  100 "          "   100"          "     000     "  "00"   " 00    "         " 01 "    "     11  "         "  10  "           "          "      ""          ""    ""    ;
    "00010      " " 0101                "   " 011  "     "   110"          "   1111"         "     110     "  "01"   " 111    "        " 10 "     "    00   "        "    "             "          "      ""          ""    ""    ;
    "000011     " " 1001                "   " 100  "     "   1011"         "   110 "         "     111     "  "101"   " 01    "         " 110 "    "       "          "    "             "          "      ""          ""    ""    ;
    "000010     " " 1100                "   " 0011  "    "  010 "          "  101"           "     100     "  "110"   " 100    "        "  "     "       "            "    "             "          "      ""          ""    ""    ;
    "0000011    " " 01000               "   " 1110  "    "  001 "          "   001"          "     011     "  "100"   "     "           "  "    "       "             "    "             "          "      ""          ""    ""    ;
    "0000010    " " 11011               "   " 1010  "    "  0111 "         "   000 "         "     10111   "  ""   "      "          "  "    "       "             "    "             "          "      ""          ""    ""    ;
    "00000001   " " 11010               "   " 11000  "   " 1111  "         "   01001"         ""              ""    ""                ""             ""               ""                  ""            ""          ""    ""       ;
    "00000000   " " 010010              "   " 110011  "  " 111100 "        ""                 ""              ""    ""                ""             ""               ""                  ""            ""          ""    ""       ;
    "00000011   " " 0100111             "   " 110010  "  ""               ""                 ""               ""    ""                ""             ""               ""                  ""            ""          ""    ""    ;
    "000000101  " " 0100110             "   ""            ""               ""                 ""              ""    ""                ""             ""               ""                  ""            ""          ""    ""    ;
    "000000100  "  ""                       ""            ""               ""                 ""              ""    ""                ""             ""               ""                  ""            ""          ""    ""      ;
];
%}
numCoeff_TotZeros = [

"1"       "011"     "010"     "0011"    "0010"    "00011"   "00010"   "000011"  "000010"   "0000011"  "0000010"  "00000011"  "00000010"  "000000011" "000000010"   "000000001"  
"111"     "110"     "101"     "100"     "011"     "0101"    "0100"    "0011"    "0010"     "00011"    "00010"    "000011"    "000010"    "000001"    "000000"      ""
"0101"    "111"     "110"     "101"     "0100"    "0011"    "100"     "011"     "0010"     "00011"    "00010"    "000001"    "00001"     "000000"    ""            "" 
"00011"   "111"     "0101"    "0100"    "110"     "101"     "100"     "0011"    "011"      "0010"     "00010"    "00001"     "00000"     ""          ""            ""  
"0101"    "0100"    "0011"    "111"     "110"     "101"     "100"     "011"     "0010"     "00001"    "0001"     "00000"     ""          ""          ""            "" 
"000001"  "00001"   "111"     "110"     "101"     "100"     "011"     "010"     "0001"     "001"      "000000"   ""          ""          ""          ""            "" 
"000001"  "00001"   "101"     "100"     "011"     "11"      "010"     "0001"    "001"      "000000"   ""         ""          ""          ""          ""            ""  
"000001"  "0001"    "00001"   "011"     "11"      "10"      "010"     "001"     "000000"   ""         ""         ""          ""          ""          ""            "" 
"000001"  "000000"  "0001"    "11"      "10"      "001"     "01"      "00001"   ""         ""         ""         ""          ""          ""          ""            ""   
"00001"   "00000"   "001"     "11"      "10"      "01"      "0001"    ""        ""         ""         ""         ""          ""          ""          ""            ""
"0000"    "0001"    "001"     "010"     "1"       "011"     ""        ""        ""         ""         ""         ""          ""          ""          ""            ""
"0000"    "0001"    "01"      "1"       "001"     ""        ""        ""        ""         ""         ""         ""          ""          ""          ""            ""
"000"     "001"     "1"       "01"      ""        ""        ""        ""        ""         ""         ""         ""          ""          ""          ""            ""
"00"      "01"      "1"       ""        ""        ""        ""        ""        ""         ""         ""         ""          ""          ""          ""            ""
"0"       "1"       ""        ""        ""        ""        ""        ""        ""         ""         ""         ""          ""          ""          ""            ""
];       

% Note this was the previous code but modified as the zerosN if 16 (15*16)table  outTotalZeros = numCoeff_TotZeros(NZQS,zerosN );
% Note that the all zero block isn't recognized in the CAVLC it's handled
% using CPB
if ( NZQS < 16 )
    outTotalZeros = numCoeff_TotZeros(NZQS,ZerosNumber +1);
else     
    outTotalZeros = [];
end


% Take this from Hossam 3latool










end