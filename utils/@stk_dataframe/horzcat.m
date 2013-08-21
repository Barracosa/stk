% HORZCAT [overloaded base function]

% Copyright Notice
%
%    Copyright (C) 2013 SUPELEC
%
%    Author: Julien Bect  <julien.bect@supelec.fr>

% Copying Permission Statement
%
%    This file is part of
%
%            STK: a Small (Matlab/Octave) Toolbox for Kriging
%               (http://sourceforge.net/projects/kriging)
%
%    STK is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    STK is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with STK.  If not, see <http://www.gnu.org/licenses/>.

function z = horzcat(x, y, varargin)

if nargin < 2,
    y = [];
end

if isa(x, 'stk_dataframe')
    
    % In this case, [x y] will be an stk_dataframe also.
    
    x_data = double (x);
    y_data = double (y);
        
    if isa(y, 'stk_dataframe')
        y_colnames = get (y, 'colnames');
        y_rownames = get (y, 'rownames');
    else
        y_colnames = {};
        y_rownames = {};
    end
    
    %--- ROW NAMES --------------------------------------------------------

    x_rownames = get (x, 'rownames');
    
    if isempty(x_rownames)
        
        rownames = y_rownames;
        
    elseif ~isempty(y_rownames) && ~all(strcmp(x_rownames, y_rownames))
        
        stk_error(['Cannot concatenate because of incompatible row ' ...
            'names.'], 'IncompatibleRowColNames');
        
    else % ok, we can use x's column names
        
        rownames = x_rownames;
        
    end
    
    %--- COLUMN NAMES -----------------------------------------------------

    x_colnames = get (x, 'colnames');
    
    bx = isempty(x_colnames);
    by = isempty(y_colnames);
    
    if bx && by % none of the argument has row names
        
        colnames = {};
        
    else % at least of one the arguments has column names
       
        if bx
            x_colnames = repmat({''}, 1, size(x_data, 2));
        end
        
        if by
            y_colnames = repmat({''}, 1, size(y_data, 2));
        end
        
        colnames = [x_colnames y_colnames];
        
    end
    
    z = stk_dataframe([x_data y_data], colnames, rownames);
    
else % In this case, z will be a matrix.
    
    z = [double(x) double(y)];

end

if ~isempty(varargin),
    z = horzcat(z, varargin{:});
end

end % function horzcat

%%%%%%%%%%%%%
%%% tests %%%
%%%%%%%%%%%%%

% IMPORTANT NOTE: [x y ...] fails to give the same result as horzcat(x, y, ...)
% in some releases of Octave. As a consequence, all tests must be written using
% horzcat explicitely.

%!shared u v
%! u = rand(3, 2);
%! v = rand(3, 2);

%%
% Horizontal concatenation of two dataframes

%!test
%! x = stk_dataframe(u, {'x1' 'x2'});
%! y = stk_dataframe(v, {'y1' 'y2'});
%! z = horzcat (x, y);
%! assert(isa(z, 'stk_dataframe') && isequal(double(z), [u v]));
%! assert(all(strcmp(z.colnames, {'x1' 'x2' 'y1' 'y2'})));

%!test
%! x = stk_dataframe(u, {'x1' 'x2'}, {'a'; 'b'; 'c'});
%! y = stk_dataframe(v, {'y1' 'y2'});
%! z = horzcat (x, y);
%! assert(isa(z, 'stk_dataframe') && isequal(double(z), [u v]));
%! assert(all(strcmp(z.colnames, {'x1' 'x2' 'y1' 'y2'})));
%! assert(all(strcmp(z.rownames, {'a'; 'b'; 'c'})));

%!test
%! x = stk_dataframe(u, {'x1' 'x2'});
%! y = stk_dataframe(v, {'y1' 'y2'}, {'a'; 'b'; 'c'});
%! z = horzcat (x, y);
%! assert(isa(z, 'stk_dataframe') && isequal(double(z), [u v]));
%! assert(all(strcmp(z.colnames, {'x1' 'x2' 'y1' 'y2'})));
%! assert(all(strcmp(z.rownames, {'a'; 'b'; 'c'})));

%!error % incompatible row names
%! x = stk_dataframe(u, {'x1' 'x2'}, {'a'; 'b'; 'c'});
%! y = stk_dataframe(v, {'y1' 'y2'}, {'a'; 'b'; 'd'});
%! z = horzcat (x, y);

%%
% Horizontal concatenation [dataframe matrix] or [matrix dataframe]

%!test
%! x = stk_dataframe(u);
%! z = horzcat (x, v);
%! assert(isa(z, 'stk_dataframe') && isequal(double(z), [u v]));

%!test
%! y = stk_dataframe(v);
%! z = horzcat (u, y);
%! assert(isa(z, 'double') && isequal(z, [u v]));

%%
% Horizontal concatenation of more than two elements

%!test
%! x = stk_dataframe(u, {'x1' 'x2'});
%! y = stk_dataframe(v, {'y1' 'y2'});
%! z = horzcat (x, y, u, v);
%! assert(isa(z, 'stk_dataframe') && isequal(double(z), [u v u v]));