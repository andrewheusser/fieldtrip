function s1 = appendstruct(varargin)

% APPENDSTRUCT appends a structure to a structure or struct-array.
% It also works if the initial structure is an empty structure or
% an empty double array. It also works if the input structures have 
% different fields.
%
% Use as
%   ab = appendstruct(a, b)
%
% See also PRINTSTRUCT, COPYFIELDS, KEEPFIELDS, REMOVEFIELDS

% Copyright (C) 2015-2017, Robert Oostenveld
%
% This file is part of FieldTrip, see http://www.fieldtriptoolbox.org
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id$

narginchk(2,inf);

if nargin>2
  % use recursion to append a whole list of structures
  s1 = varargin{1};
  for i=2:nargin
    s2 = varargin{i};
    s1 = appendstruct(s1, s2);
  end
  return
else
  s1 = varargin{1};
  s2 = varargin{2};
end

assert(isstruct(s1) || isempty(s1), 'input argument 1 should be empty or a structure');
assert(isstruct(s2), 'input argument 2 should be a structure');

if isempty(s1)
  s1 = s2;
elseif isstruct(s1)
  fn1 = fieldnames(s1);
  fn2 = fieldnames(s2);
  % find the fields that are missing in either one
  missing1 = setdiff(union(fn1, fn2), fn1);
  missing2 = setdiff(union(fn1, fn2), fn2);
  % add the missing fields
  for i=1:numel(missing1)
    s1(1).(missing1{i}) = [];
  end
  for i=1:numel(missing2)
    s2(1).(missing2{i}) = [];
  end
  % concatenate the second structure to the first
  s1 = cat(1,s1(:), s2(:));
end
