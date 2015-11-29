

==============================================
  README FILE
==============================================
Paper: "Peer Effects in the Workplace: Evidence from Random Groupings
in Professional Golf Tournaments"

Authors: Jonathan Guryan, Kory Kroft, and Matthew J. Notowidigdo

Date: 02/18/2009
==============================================





==============================================
INTRODUCTION:
==============================================

This file describes the layout of the golf.AEJ_Final directory, which
contains all of the code and data necessary to reproduce the results
from the paper.

Please e-mail "noto@alum.mit.edu" if you have any questions or
comments related to the code or data included in this ZIP file.



==============================================
QUICK START:
==============================================

To reproduce all of the data tables, simply run the "run.do" file in
Stata ("stata -b do run" from a UNIX terminal).  This will generate
the following text files, which correspond to the data tables
presented in the paper:

- table1.txt
- table2.txt
- table3a.txt
- table3b.txt
- table4.txt
- table5.txt
- table6.txt
- table7.txt
- table8.txt

The columns are ordered to match the paper.  As long as Stata version 10.0
or later is used (see Notes section below for Stata version details),
then the results should match the results in the paper exactly.



==============================================
NOTES:
==============================================

- The data file containing all of the data needed to reproduce the
  data tables is "pga_data.dta".

- Most results report clustered standard errors.  Stata versions 9.2
  or earlier will report slightly different standard errors because
  the formula used by the "areg" command to calculate clustered
  standard errors changed slightly between Stata 9.2 and Stata 10.0.
  The differences in standard errors are always very minimal, but note
  that some standard errors will not match those in the paper exactly
  if Stata version 9.2 or earlier is used.

- The measurement-error-corrected estimator (column (2) in Table 4 of
  the paper) is not included in table4.txt, but rather it is
  calculated by the "table4_me.do" file.  The output from this file
  contains the measurement-error-corrected results.

- To reproduce the Monte Carlo simulation, run "monte_carlo.do".  This
  will generate the following four (4) data files:

   (1) bootstrap10000_0_55.dta 
   (2) bootstrap10000_1_55.dta 
   (3) bootstrap10000_0_550.dta 
   (4) bootstrap10000_1_550.dta 

  These files are used by the "monte_carlo_graphs.do" file to create
  the figures used in the paper.



