/* Copyright (c) Colorado School of Mines, 2011.*/
/* All rights reserved.                       */
/* App made to get cdp info bruno.vermeulen@hotmail.com */

#include "su.h"
#include "segy.h"

/*********************** self documentation **********************/
char *sdoc[] = {
    " 									",
    " 									",
    NULL};

/* Credits:
 * 2025 Bruno Vermeulen
*/

/**************** end self doc ***********************************/

segy tr;

int main(int argc, char **argv)
{

    if (!gettr(&tr))
        err("can't read first trace");

    do
    {
        if (tr.scalco < 0)
            scale = 1. / abs(tr.scalco);
        else if (tr.scalco > 0)
            scale = tr.scalco;
        else
        {
            warn("scalco = 0 ; 1 assumed");
            scale = 1;
        }
        xmp = (tr.gx + tr.sx) * 0.5 * scale;
        ymp = (tr.gy + tr.sy) * 0.5 * scale;
        ibin = tr.cdp;
        if (ibin > 0)
            ibin -= cdpmin;
        distmin = sqrt(pow(xmp - xbin[ibin], 2) + pow(ymp - ybin[ibin], 2));
        cbin[ibin] = tr.cdp;
        dbin[ibin] = distmin;
        if (verbose)
            warn("ep=%d cdp=%d distmin=%f", tr.ep, tr.cdp, distmin);
    } while (gettr(&tr));

    return (CWP_Exit());
}