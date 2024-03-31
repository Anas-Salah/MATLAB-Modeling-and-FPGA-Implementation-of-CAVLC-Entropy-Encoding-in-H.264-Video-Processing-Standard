clc; clear;
% Input the matrix
%
%{
%  tested correctly//  Iain R. example one 
MB_Res = [0  3 -1 0
          0 -1 1 0
          1  0 0 0
          0  0 0 0];
%the expected output 0000100011  10010111101101
%the  output         0000100011  01001111101101
%}


%{
%
% the corner case 
 MB_Res = [-5 2 0 0
           -1 1 0 0
            2 0 0 0
            0 0 0 0];
%}


%{ 
%} 
%{
%  tested correctly// Iain R. example two
 MB_Res = [-2 4 0 -1
            3 0 0 0
           -3 0 0 0
            0 0 0 0];
%the expected output 000000011010001001000010111001100
%the  output         000000011010001001000010111001100
%}

% 
 % tested correctly// Iain R. example three
  MB_Res = [0 0 1 0 ; 
            0 0 0 0 ; 
            1 0 0 0 ; 
           -1 0 0 0 ]; 
%the expected output 0001110001110010
%the  output         0001110001110010
%}

%{
% Some corner cases added by me 
% 1- if all the MB are NZQs
%
MB_Res = [2 3 -1 1
          3 -1 1 6
          1 8 7 5
          9 6 6 7];
%}

% for this one I modified the MB_Ready to consider this case and also
% consider if there is no ones.
%
%{
% Note that the all zero block isn't recognized in the CAVLC it's handled
% using CPB
MB_Res = [0 0 0 0
          0 0 0 0
          0 0 0 0
          0 0 0 0];
%}
%{
% if there is only one MB
MB_Res = [0 0 0 0
          0 0 0 0
          0 0 0 0
          0 0 0 0];
%}
%{
% test if there is no trailng ones
% test passed and only the output for the first and the third stage
MB_Res = [2 3 8 5
          2 3 8 5
          2 3 8 5
          2 3 8 5];
%}
nU = 0;
nL = 0;

test_1 = CAVLC(MB_Res, nU,nL  )
