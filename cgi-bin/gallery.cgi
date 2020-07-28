#!/usr/bin/perl -w 

# gallery.cgi
#
# display all the files in a directory as images in a page complete with links to the large files
# if a thumbnail directory is available pull the images from there instead of the main directory to speed up page load times
# the links will still point to the larger pics in the main directory specified
#
# usage: gallery.cgi?dir=<directory of pictures>&[thumb=1=on|0=off]&[thumb_dir=<directory of thumbnails>
#
# parameters:
# dir - the directory of images to display
# thumb - use a thumbnail directory to display the pictures on the main table.
# thumb_dir - the directory to pull the thumbnails from.  default is dir/thumbnails
# 
# License stuff:
# This script is copyrighted 2008 by Gordon Rhea.  This Software is being distributed as Freeware. 
# It may be freely used, copied and distributed as long as this message remains and is unchanged.  You may use this
# script for any web site, including professional projects, as long as credit is given to the copyright holder.
#
# DISCLAIMER:
# This Software is is provided "AS-IS" and without any 
# warrenty either express or implied.  There is no 
# liability for any damages including but not limited 
# to loss of data, hardware failure, or any incidental 
# or consequential damages.
#


use CGI qw(:standard escapeHTML); 
use iw_main;

my $q = new CGI;
my $main = new iw_main();

print "Content-type: text/html\n\n";

$main->WriteHeader();

# change this to be the base directory of your galleries.
# most scripts run in a cgi-bin directory so you will have to put ../ in front of your directory to get to the root directory of your web site.
my $base_dir = "../images/";

# the number of columns to display the pictures in.
my $Table_Cols = 3;

# set the height and width of the images.
# change these to 0 to display the image at full size
my $img_width = 240;
my $img_height = 180;

# set up the supported file types
# to add more supported types simply add an extension to the list below
my @types = (".jpg", ".bmp", ".gif");

if($q->param)
{
     my $dir = $base_dir . $q->param('dir');
     my $use_thumb = $q->param('usethumbs');
     my $thumb_dir = $q->param('thumbdir');

     if($use_thumb != 1)
     {
          $use_thumb = 0;
     }
     # check to see if there is a thumbnail directory.  If there is we'll get our display file list from here 
     if($thumb_dir)
     {
          $thumb_dir = "$dir/$thumb_dir";
     }
     else
     {
          $thumb_dir = "$dir/thumbnails";
     }

     # open the directory
     if($use_thumb == 1)
     {
          opendir(DIR, $thumb_dir);
     }
     else
     {
          opendir(DIR, $dir);
     }

     print "<TABLE BORDER=1 RULES=ALL><TR>";

     my $col = 0;  # the count of the columns so we do the specified number
     my $link_file;  # the location for the link file.  If we are using a thumbnail directory we'll want a link to the full sized pic not the thumbnail

     print "Click on any image to display a full sized image<br>";

     # loop through the files in the directory and put them in a table    

     # Sept. 3, 2010
     # Changed to do sort of the files.
     @files = readdir(DIR);
     @file_sorted = sort(@files); 
     #while (my $file = readdir(DIR)) {
     foreach $file (@file_sorted) {
          my $ok = 0;
          # check to make sure the file has a supported extension.  This should filter out any directories as well as unsupported files.
          foreach $tag (@types)
          {
               if($file =~ m/$tag/i)
               {
                    $ok = 1;
                    last;
               }
          }

          if($ok == 1)
          {
               # add the directory path to the file name so it displays correctly
               $link_file = "$dir/$file";
               if($use_thumb == 1)
               {
                    $file = "$thumb_dir/$file";
               }
               else
               {
                    $file = "$dir/$file";
               }

               # print the cell in the table
               print "<td>";
               print "<a href=\"$link_file\"><img border=0 src=\"$file\"";
               if($img_width > 0 && $img_height > 0)
               {
                    print " width=$img_width height=$img_height";
               }
               print "></a>  </td>";
               $col = $col + 1;

               # check to see if we've reached the end of our table row.  If we have then end this row and create a new one.
               if($col >= $Table_Cols)
               {
                    print "</tr><tr>";
                    $col = 0;
               }
          }
     }

     print "</TABLE><BR>";
     closedir(DIR);
}
else
{
     print "No directory specified!<br>";
}

exit;