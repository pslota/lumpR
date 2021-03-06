% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/subbasin.R
\name{calc_subbas}
\alias{calc_subbas}
\title{Calculation of hydrological subbasins using GRASS GIS}
\usage{
calc_subbas(dem = NULL, drain_points = NULL, river = NULL,
  basin_out = NULL, stream = NULL, points_processed = NULL,
  outlet = NULL, thresh_stream = NULL, thresh_sub = NULL,
  snap_dist = NULL, rm_spurious = 0.01, keep_temp = F, overwrite = F,
  silent = F)
}
\arguments{
\item{dem}{Digital elevation model in GRASS location used for delineation of
subbasins. Should be larger than the expected catchment, otherwise artefacts
close to boundaries may occur.}

\item{drain_points}{\code{SpatialPoints} object containing drainage locations in
units of and compliant with the projection of your respective GRASS location.
At least the watershed drainage point has to be given.}

\item{river}{River vector map in GRASS location if available. If set to \code{NULL}
(default value) river network will be calculation by GRASS function \emph{r.watershed}.}

\item{basin_out}{Output: Name of subbasins raster map exported into GRASS location.}

\item{stream}{Output: Prefix of calculated stream segments vector (<stream>_vect) and
raster (<stream>_rast) maps exported into GRASS location. Only generated if
\code{river} is not set. Default: \code{NULL}.}

\item{points_processed}{Output: Prefix of point vector files exported to GRASS location.
\code{<points_processed>_snap} are given \code{drain_points} snapped to river.
\code{<points_processed>_calc} are internally calculated drain points (only if
parameter \code{thresh_sub} is not \code{NULL}, see below).}

\item{outlet}{Integer (row number) defining the catchment outlet in \code{drain_points}.
If there are \code{drain_points} outside the watershed delineated for the
outlet point these will be omitted. If \code{NULL} (default) and \code{drain_points}
contains only one point this will be assumed as catchment outlet.}

\item{thresh_stream}{Integer defining threshold for stream calculation. Raster
cells in accumulation map with values greater than thresh_stream are
considered as streams. Needs to be set only if \code{river} is not set.
Default: \code{NULL}.}

\item{thresh_sub}{Integer defining threshold for subbasin calculation. Parameter for
GRASS function \emph{r.watershed} defining the minimum size of an exterior
watershed basin in number of grid cells. If \code{NULL} (default) only the
given drainage points are used for subbasin delineation.}

\item{snap_dist}{Integer defining maximum distance for snapping of \code{drain_points}
to stream segments in units of your GRASS location.}

\item{rm_spurious}{\code{numeric}. If greater zero, spurious subbasins will
be removed, i.e. those subbasins being smaller than \code{rm_spurious} times \code{thresh_sub}.
Spurious subbasins are 'interior' watersheds created by GRASS function
\emph{r.watershed} around stream segments below multiple tributaries. If they
are very small they induce unnecessary computational burden when used within a
hydrological model. If removed, these areas will be related to the next upstream
subbasins, respectively. If \code{thresh_sub = NULL} (default) \code{rm_spurious}
will be automatically set to \code{0}. Default: 0.01.}

\item{keep_temp}{\code{logical}. Set to \code{TRUE} if temporary files shall be kept
in the GRASS location, e.g. for debugging or further analyses. Default: \code{FALSE}.}

\item{overwrite}{\code{logical}. Shall output of previous calls of this function be
deleted? If \code{FALSE} the function returns an error if output already exists.
Default: \code{FALSE}.}

\item{silent}{\code{logical}. Shall the function be silent (also suppressing warnings
of internally used GRASS functions)? Default: \code{FALSE}.}
}
\description{
Takes DEM from a GRASS location and a file of drainage locations to calculate 
hydrological subbasins for each drainage point using GRASS functions.
}
\note{
Prepare GRASS location and necessary raster files in advance and start
     GRASS session in R using \code{\link[spgrass6]{initGRASS}}. Location
     should not contain any maps ending on *_t as these will be removed by
     calling the function to remove temporary maps.
     
     You should select your DEM sufficiently large. Otherwise the resulting
     catchment might be truncated or boundaries influence the calculation
     of stream segments.
     
     Check the results (subbasins and snapped points). In case points have been snapped
     to the wrong stream segment, adjust point locations manually in GRASS and re-run
     the function with the updated locations (use \code{\link[spgrass6]{readVECT6}}
     to import the updated drainage points). Also check that calculated subbasins and
     those delineated based on given \code{drain_points} do not interfere (e.g.
     resulting in very small spurious subbasins).
     
     Generated raster and vector stream maps might slightly deviate from each other
     as the raster map is thinned (GRASS function \emph{r.thin}) prior to conversion
     to a vector map to ensure strictly linear features.
}
\author{
Tobias Pilz \email{tpilz@uni-potsdam.de}
}
