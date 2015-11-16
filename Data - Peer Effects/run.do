
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

global PATH "."
global DATA "${PATH}/"
global OUTPUT "${PATH}/"
global SRC "${PATH}/"

set more off
set mem 300m
set matsize 3000

use ${DATA}pga_data

do ${SRC}table1

**
* De-means data and creates other variables used in analysis
**
do ${SRC}make_derived_variables

do ${SRC}tables_2_and_3
do ${SRC}tables_4_and_5
do ${SRC}table6
do ${SRC}table7
do ${SRC}table8
do ${SRC}table4_me





