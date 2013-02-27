function [ data_all, filenames_all, data_init, data_length ] = ...
    read_abi_dirs( filepath, dirnames, dye_names_full, PLOT_STUFF );
% READ_ABI_DIRS:  wrapper around plot_abi_runs -- read in .abi data from multiple directories.
%
% [ data_all, filenames_all, data_init, data_length ] = read_abi_dirs( filepath, dirnames, dye_names, PLOT_STUFF );
%
%  dye_names = names of dyes in each color channel.
%
% (C) R. Das 2008-2011


data = {};
data_all = {};
data_init = [];
data_length = [];
filenames_all = {};
count = 0;

if nargin == 0;  help( mfilename ); return; end;

if ~exist( 'dye_names_full' ) dye_names_full = {}; end;

for j = 1:length( dirnames )
  % This script calls read_abi.m which has the actual file format.
  fprintf( 1, 'Reading in:  %s\n',dirnames{j} ); 
  
  [data,filenames] = plot_ABI_runs( [filepath, dirnames{j}], dye_names_full, PLOT_STUFF ); 

  % Count number of capillaries 
  data_init(j) = count + 1;           % acl
  data_length(j) = length(filenames); % acl
  
  for k = 1:length( filenames )
    count = count + 1;
    data_all{ count }  = data{ k };
    filenames_all{ count }  = filenames{ k };
  end
end


clear count;
clear j; clear k;
