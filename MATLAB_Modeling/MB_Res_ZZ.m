
function ind = MB_Res_ZZ(matrix)
ind = reshape(1:numel(matrix), size(matrix));         %# indices of elements /// The reshape function is used to reshape the array of linear indices to the size of MB_Res
ind = fliplr( spdiags( fliplr(ind) ) );               %# get the anti-diagonals
ind(:,1:2:end) = flipud( ind(:,1:2:end) );            %# reverse order of odd columns
ind(ind==0) = [];                                     %# keep non-zero indices

ind = matrix(ind)  ;                                        %This line rearranges the elements of the original matrix MB_Res based on the calculated indices in the modified ind matrix. It effectively creates a modified version of MB_Res where the elements are reordered according to the specified patterns.

end