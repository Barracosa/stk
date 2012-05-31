% RUN_ALL_EXAMPLES runs all examples to check for errors

%          STK : a Small (Matlab/Octave) Toolbox for Kriging
%
% Copyright Notice
%
%    Copyright (C) 2011, 2012 SUPELEC
%    Version:   1.1
%    Authors:   Julien Bect        <julien.bect@supelec.fr>
%               Emmanuel Vazquez   <emmanuel.vazquez@supelec.fr>
%    URL:       http://sourceforge.net/projects/kriging
%
% Copying Permission Statement
%
%    This  file is  part  of  STK: a  Small  (Matlab/Octave) Toolbox  for
%    Kriging.
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
%

%% Run all the examples

clear all; close all;

NB_EXAMPLES = 7;
script_name = cell(1, NB_EXAMPLES);
err = cell(1, NB_EXAMPLES);

for example_num = 1:NB_EXAMPLES,
    try
        script_name{example_num} = sprintf('example%02d', example_num);
        run(script_name{example_num});
        drawnow; pause(1.0); close all;
    catch %#ok<CTCH>
        err{example_num} = lasterror(); %#ok<LERR>
    end
end


%% Display a summary

disp('                                ');
disp('#==============================#');
disp('#   run_all_examples summary   #');
disp('#==============================#');
disp('                                ');

for example_num = 1:NB_EXAMPLES,
    fprintf('%s : ', script_name{example_num});
    if isempty(err{example_num})
        fprintf('OK\n');
    else
		id = err{example_num}.identifier;
		if isempty(id),
			fprintf('ERROR (no identifier provided)\n');
		else
			fprintf('%s\n', id);
		end        
    end
end

fprintf('\n\n');