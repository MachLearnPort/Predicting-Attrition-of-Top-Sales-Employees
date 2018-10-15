%CELLWRITE writes a cell array to a CSV file.
%
% The cell array is traversed, the contents of each cell are
% converted to a string, and a CSV file is written using low
% level fprintf statements.
function cellwrite(filename, cellarray)
[rows, cols] = size(cellarray);
fid = fopen(filename, 'w');
for i_row = 1:rows
    file_line = '';
    for i_col = 1:cols
        contents = cellarray{i_row,i_col};
        if isnumeric(contents)
        % num2str is the bottleneck in this function
            contents = num2str(contents);
        elseif isempty(contents)
            contents = '';
        end
        if i_col<cols
            file_line = [file_line, contents, ','];
        else
            file_line = [file_line, contents];
        end
    end
    count = fprintf(fid,'%s\n',file_line);
end
st = fclose(fid);
if st == -1
    error('Bad file write')
end