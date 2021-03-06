function [d_norm, scalefactor, cap_value ] = SHAPE_normalize( d_for_scalefactor );
% [d_norm, scalefactor, cap_value ] = SHAPE_normalize( d_for_scalefactor );
%
%  'box-plot' normalize:
%  -- remove outliers, i.e., any values above 1.5 * interquartile range 
%  -- Find maximum value after filtering. If its smaller than the 95th percentile value, then 
%      take that instead.
%  -- scalefactor is mean of top 10th percentile of values, but removing values above that filter.
%

if nargin == 0;  help( mfilename ); return; end;

FLIPPED = 0;
if size( d_for_scalefactor, 1) == 1
  FLIPPED = 1;
  d_for_scalefactor = d_for_scalefactor';
end

cap_value = 999;
for k = 1:size( d_for_scalefactor, 2 )
  d_OK = d_for_scalefactor( find( ~isnan( d_for_scalefactor(:,k)) ), k );

  dsort = sort( d_OK );
  
  % this attempts to recover the normalization scheme in ShapeFinder, as reported by Deigan et al., 2008.
  q1 = dsort( round( 0.25*length(dsort) ) );
  q3 = dsort( round( 0.75*length(dsort) ) );
  interquartile_range = abs( q3 - q1 );

  % old
  % outlier_cutoff = min( find( dsort > 1.5 ) );

  % original -- fixed
  outlier_cutoff = min( find( dsort > 1.5*interquartile_range ) );
  
  % test -- based on definition of matlab box().
  %outlier_cutoff = min( find( dsort > (q3 + 1.5*interquartile_range ) ) );

  %[outlier_cutoff length( dsort ) ]
  if ~isempty( outlier_cutoff )
    actual_cutoff = outlier_cutoff - 1;
    %if length( dsort ) < 100; actual_cutoff = max( actual_cutoff, round(0.95*length(dsort) ) - 1 ); end;
    actual_cutoff = max( actual_cutoff, round(0.95*length(dsort) ) - 1 );
    %[actual_cutoff length( dsort) ]
    cap_value = dsort( actual_cutoff+1 );
    dsort = dsort(1: actual_cutoff );
  end

  scalefactor(k) = mean(dsort(  round( 0.9 * length(dsort)):end ) );

  d_norm(:,k) = d_for_scalefactor(:,k) / scalefactor(k);
end

if FLIPPED
  d_norm = d_norm';
end