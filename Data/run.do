
clear
est clear


****************
* GLOBAL VARIABLES:
*
*  These variables can be used if you wish to re-organize the data,
* programs, and output into various directories.  Just change the
* variables below
*
****************

global PATH "N:\Thesis\Data\"

set more off
set mem 300m
set matsize 3000

use ${PATH}pga_data

do ${PATH}table1

**
* De-means data and creates other variables used in analysis
**
do ${PATH}make_derived_variables

do ${PATH}tables_2_and_3
do ${PATH}tables_4_and_5
do ${PATH}table6
do ${PATH}table7
do ${PATH}table8
do ${PATH}table4_me
