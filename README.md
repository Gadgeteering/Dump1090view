Dump1090view
============

This application is for Graphical Display of Dump1090 data

The program runs in Processing available from www.processing.org

Before starting the software you will first need to run Dump1090 using
the command line 'dump1090 --net --interactive'

After this a table will be displayed in the Command window, then start Dump1090view and a chart will 
be displayed with the aircraft present.

Setup
=====


You may need to edit the following lines to setup for correct operation if not using a Mode-S decoder connected directly to your computer. 

 'myClient = new Client(this, "localhost", 30003);' this line is used to setup port where information is coming from, if using a remote computer for data you may need to edit it with correct address.
 
 Also the chart is currently only setup for the London UK area at the moment and will need to be change 'String file = "atc_lon-tma";' this line is used to setup chart in use, choose a chart from http://www.mantma.co.uk/
for your location, you will need to make sure the files (.jpg .clb) are the same as the directory and named as the filename without extension(.clb,.jpg) and that directory is in the same directory as the Dump1090viewer


With these two items setup the software should operate correctly


