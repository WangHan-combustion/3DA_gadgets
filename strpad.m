function [ padded_string ] = strpad( strin,  max_len)
spacing_arg = ['%-', num2str(max_len),'s'];
padded_string = sprintf(spacing_arg, strin);
end

