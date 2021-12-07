function out = check_likelihood(l)
delta_l = diff(l) ;
count = nnz(~delta_l) ;
if count > 5
    out = 1 ;
else
    out = 0 ;
end
end