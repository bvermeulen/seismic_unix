/* Copyright (c) Colorado School of Mines, 2011.*/
/* All rights reserved.                       */
/* correction made for generating the cmp line, bruno.vermeulen@hotmail.com */

#include "su.h"
#include "segy.h"

/*********************** self documentation **********************/
char *sdoc[] = {
" 									",
" SUCDPBIN - Compute CDP bin number					",
" 									",
" sucdpbin <stdin >stdout xline= yline= dcdp=				",
" 									",
" Required parameters:							",
" xline=		array of X defining the CDP line		",
" yline=		array of Y defining the CDP line		",
" dcdp=			distance between bin centers			",
"									",
" Optional parameters							",
" verbose=0		<>0 output informations				",
" cdpmin=1001		min cdp bin number				",
" distmax=dcdp		search radius					",
" 									",
" xline,yline defines the CDP line made of continuous straight lines. 	",
" If a smoother line is required, use unisam to interpolate.		",
" Bin centers are located at dcdp constant interval on this line. 	",
" Each trace will be numbered with the number of the closest bin. If no  ",
" bin center is found within the search radius. cdp is set to 0		",
"									",
NULL};

/* Credits:
 * 2009 Dominique Rousset - Mohamed Hamza
 *      Université de Pau et des Pays de l'Adour (France)
 */

/**************** end self doc ***********************************/

segy tr;

int
main(int argc, char **argv)
{
	float *xline=NULL;	/* array of key mute curve values	*/
	float *yline=NULL;	/* ...		mute curve time values 	*/
	float dcdp;	/* distance between bin centers */
	float *xbin=NULL, *ybin=NULL;
	float sl, ord, x2, a, b, c, d, delta, dx;
	float xmp, ymp, dist, distmin, distmax;
	int nxline, nyline, nbin;
	int verbose;
	int ipoint;
	int cdpmin;
	float scale;
	float length;
	int maxbin, ibin,iseg ;

	/* Initialize */
	initargs(argc, argv);
	requestdoc(1);

	/* Get parameters */
	if (!(nxline = countparval("xline"))) {
		err("must give xline= vector");
	}
	if (!(nyline = countparval("yline"))) {
		err("must give yline= vector");
	}
	if (nxline != nyline) {
		err("lengths of xline, yline must be the same");
	}
	/* allocate space */
	xline = ealloc1float(nxline);
	yline = ealloc1float(nyline);
	getparfloat("xline", xline);
	getparfloat("yline", yline);
	for (ipoint = 1; ipoint < nxline; ++ipoint) {
		if (xline[ipoint] <= xline[ipoint - 1]) {
			err("xline values must increase monotonically");
		}
	}

	if (!getparfloat("dcdp", &dcdp)) {
		err("must give dcdp");
	}
	if (!getparint("cdpmin", &cdpmin)) {
		cdpmin = 1001;
	}
	if (!getparfloat("distmax", &distmax)) {
		distmax = dcdp;
	}
	if (!getparint("verbose", &verbose)) {
		verbose = 0;
	}
	checkpars();

	if (verbose) {
		warn ("%d points on the line", nxline);
		ipoint=0 ;
		do  {
			warn ("point # %d x= %f y= %f", ipoint, xline[ipoint], yline[ipoint]);
			++ipoint;
		} while (ipoint < nxline);
	}

	/* maximum length of the line */
	length=0;
	for (ipoint=1; ipoint<nxline; ++ipoint) {
		length=length+sqrt(pow((xline[ipoint]-xline[ipoint-1]),2)+pow((yline[ipoint]-yline[ipoint-1]),2));
	}
	maxbin=length/dcdp+1;
	xbin = ealloc1float(maxbin+1);
	ybin = ealloc1float(maxbin+1);

	ibin=0;
	xbin[ibin] = xline[0];
	ybin[ibin] = yline[0];
	if (verbose)
	{
		warn("ibin=%d x=%f y=%f ", ibin, xbin[ibin], ybin[ibin]);
	}

	iseg = 0;
	sl = (yline[1]-yline[0])/(xline[1]-xline[0]);
	ord = (yline[0]*xline[1]-yline[1]*xline[0])/
	 	  (xline[1]-xline[0]);

	if (verbose) {
		warn("slope: %f, ord: %f", sl, ord);
	}

	dx = dcdp * sqrt(1/(1 + sl*sl));

	/* loop over segments */
	do {
		if (verbose) {
			warn("iseg=%d",iseg);
		}

		/* 1 segment binning */
		do {
			++ibin;
			xbin[ibin] = xbin[ibin-1] + dx;
			ybin[ibin] = sl*xbin[ibin] + ord;

			if (verbose) {
				warn("ibin=%d x=%f y=%f ",ibin, xbin[ibin], ybin[ibin]);
			}

		} while (xbin[ibin]<= xline[iseg+1]);

		++iseg;

		/* parameters of the next segment */
		sl = (yline[iseg+1] - yline[iseg]) / (xline[iseg+1] - xline[iseg]);
		dx = dcdp * sqrt(1 / (1 + sl*sl));
		ord= (yline[iseg] * xline[iseg+1] - yline[iseg+1] * xline[iseg]) /
		     (xline[iseg+1]-xline[iseg]);

		a = (ord - ybin[ibin - 1]);
		b = 1 + sl*sl;
		c = -2*xbin[ibin - 1] + 2*sl*a;
		d = xbin[ibin - 1]*xbin[ibin - 1] + a*a - dcdp*dcdp;
		delta = c*c - 4*b*d;
		x2 = 0.5 * (-c + sqrt(delta)) / b;

		xbin[ibin - 1] = x2;
		ybin[ibin - 1] = sl * xbin[ibin] + ord;

		if (verbose) {
			warn("slope=%f dx=%f ord=%f delta=%f", sl, dx, ord, delta);
			warn("ibin=%d x=%f y=%f", ibin, xbin[ibin], ybin[ibin]);
		}

	} while (xbin[ibin] <= xline[nxline-1]);
	nbin=ibin;

	if (verbose) {
		warn ("length of the line :%f ",length);
		warn ("maximum number of bin:%d",maxbin);
		warn ("actual number of bin:%d",nbin);
	}

	/* Get info from first trace */
	if (!gettr(&tr)) err("can't read first trace");

	/* Loop over traces */
	do {
		if (tr.scalco < 0 )
			scale=1./abs(tr.scalco);
		else if (tr.scalco > 0)
			scale=tr.scalco;
		else {
			warn ("scalco = 0 ; 1 assumed") ;
			scale=1;
		}
		xmp=(tr.gx+tr.sx)/2.*scale;
		ymp=(tr.gy+tr.sy)/2.*scale;
		tr.cdp=cdpmin;
		distmin=sqrt(pow(xmp-xbin[0],2)+pow(ymp-ybin[0],2));

		for (ibin=1 ; ibin < nbin ; ++ibin) {
			dist=sqrt(pow(xmp-xbin[ibin],2)+pow(ymp-ybin[ibin],2));
		   	/* warn ("ibin= %d dist= %f distmin= %f xmp= %f ymp= %f scale=%f", ibin, dist,distmin,xmp,ymp,scale); */
			if (dist < distmin) {
				distmin=dist;
				tr.cdp=ibin+cdpmin;
			}
		}
		if (distmin > distmax) tr.cdp=0;
		puttr(&tr);
	} while (gettr(&tr));

	return(CWP_Exit());
}
