#!/usr/bin/perl
##!/usr/local/bin/perl
#
# A script for quick histogram of data
# 
# The format of the script follows those by Didier Gonze.
#
# Usage histogram.pl [-i infile] [-col column_number] [-n title_lines] 
#                    ... [-o output_selection] 
#                    ... [-l lower_limit] [-u upper_limit] [-bin bin_number]
#                    ... [-help] [-h] [-v]
#                  
# default: infilename:       no default 
#          column_number:    1
#          title_lines:      0
#          output_selection: 0 
# 
# Hai Lin
# 10/27/2012

############################################
#               Main                       #
############################################

&ReadArguments;

&ReadData;

&OutputData;

###########################################
#   Read arguments from the command line  #
###########################################

sub ReadArguments {

    $verbo = 0;
    $infile = "";
    $col = 1;
    $n = 0;
    $o = 0;
    $ll = 0;
    $ul = 0;
    $nbin = 1;

    $numdata = 0;
    $sum  = 0;
    $rmsd = 0;
    $mad  = 0;
    $ave  = 0;
    $max  = 0;
    $min  = 0;
    $absmax = 0;
    $absmin = 0;

    foreach my $a (0..$#ARGV) {

    ### help
    if ($ARGV[0] eq "-h") {
    	die "Syntax: rmsd.pl -i infile -col # -o # \n";
    }
    elsif ($ARGV[0] eq "-help") {
    	&PrintHelp;
    }
            
    ### input file
    elsif ($ARGV[$a] eq "-i") {
	$inok=1;
    	$infile  = $ARGV[$a+1];
    }

    ### column
    elsif ($ARGV[$a] eq "-col") {
    	$col = $ARGV[$a+1];
    }

    ### title lines
    elsif ($ARGV[$a] eq "-n") {
        $n = $ARGV[$a+1];
    }

    ### output
    elsif ($ARGV[$a] eq "-o") {
        $o = $ARGV[$a+1];
    }

    ### lower limit for binning
    elsif ($ARGV[$a] eq "-l") {
        $ll = 1;
        $llimit = $ARGV[$a+1];
    }

    ### lower limit for binning
    elsif ($ARGV[$a] eq "-u") {
        $ul = 1;
        $ulimit = $ARGV[$a+1];
    }

    ### number of bins
    elsif ($ARGV[$a] eq "-bin") {
        $nbin = $ARGV[$a+1];
    }

    ### verbosity 
    elsif ($ARGV[$a] eq "-v") {
	$verbo=1;
    }

    }
	
    if ($infile eq "") {
    	die "STOP! You have to give the name of the input file!\n";
    }

    if ($col <= 0) {
        die "STOP! Impossible column!\n";
    }  

    if ($n < 0) {
        die "STOP! Impossible number of lines for title!\n";
    }

    if (($ll == 0) || ($ul == 0)) {
        die "STOP! Please set the limits for bins!\n";
    }

    if (($o < 0) || ($o > 1)) {
        die "STOP! 0 = histogram, 1 = histogram and others\n";
    }
	
}  #  End of ReadArguments

############################################
#           Print Help                     #
############################################

sub PrintHelp {
  open HELP, "| more";
  print <<EndHelp;
NAME
        histogram.pl

DESCRIPTION
	Quick histogram of data

AUTHOR
	Hai Lin  
        
OPTIONS
	-i file_name
		Specify the input file containing the data. 
		This argument is obligatory (except if using option -h).

	-col #
		Specify the column of the input file (default: 1st).
	
        -n #
                Specify how many lines are title lines to be skip 
                (default: 0 = no title lines).
         -l #
                Specify the lower limit for binning 
                (default: no such limit).

         -u #
                Specify the upper limit for binning 
                (default: no such limit).

        -bin #
                Specify the number of bins
                (default: 1)

        -o #
                Specific the output selection (default: 0)
                 0 = histogram
                 1 = histogram and others 
 
	-v 
		Verbosity: print detailed informations during the 
		process.
	       
	-h 
		Give syntax. This argument must be the first.

	-help 
		Give detailed help (print this message). This argument 
		must be the first.

EXAMPLE
        perl histogram.pl -i my.dat -col 2 -n 1 -l 0 -u 10 -bin 5 -o 1   

EndHelp

close HELP;
die "\n";

}  #  End of PrintHelp

###################################################
#      Read the data and fill the data vector     # 
###################################################

sub ReadData {

  my $i=0;
  my $j=0;

  $length  = $ulimit - $llimit;
  $binsize = $length / $nbin;
  $allnbin = $nbin + 1;
  for ($i=0; $i<=$allnbin; $i++) { $bin[$i] = 0; }

  open inf, $infile or die "STOP! File $infile not found.\n";
  if ($verbo==1) { 
      print "Open input file: $infile\n";
      print "Work with column $col\n";
      print "Skip title of $n lines\n";
  }

  $i = 0;
  foreach $line (<inf>){
    chomp $line;
    @line=split / +/, $line;
    $i = $i + 1;   

    if ($i < $n+1) { 
       if ($verbo==1) {
            print "Skip: $line\n";
       }
    } else {
       $xx = $line[$col];
       if ($verbo==1) { print "data $xx\n"; }
       if ($xx < $llimit) { 
            $bin[0] ++; 
       } elsif ($xx > $ulimit) { 
            $bin[$allnbin] ++; 
       } else {
            $dbinxx = $xx - $llimit;
            $ibin = int($dbinxx / $binsize) + 1;
            $bin[$ibin] ++;
#            print "data $xx diff $dbinxx binsize $binsize ibin $ibin\n";
       }
# other statistics
       if ($o > 0) {
          $j++;
          $absxx = abs($xx);
          $x[$j] = $xx;
          if ($verbo==1) {
              print "$j, $x[$j]\n";
          }
          $sum = $sum + $xx;
          if ($j == 1) {
              $max = $xx;
              $min = $xx;
              $absmax = $absxx;
              $absmin = $absxx;
          } else {
              if ($max < $xx) { $max = $xx; }
              if ($min > $xx) { $min = $xx; }
              if ($absmax < $absxx) { $absmax = $absxx; }
              if ($absmin > $absxx) { $absmin = $absxx; }
          }
       }
    }
  }
  
  if ($o > 0) {
    $numdata = $j;
    if ($numdata == 0) { die "STOP! No data point can be read in!\n"; }
    if ($numdata == 1) { 
       print "Just one data point: $x[1]\n";
       die "STOP! Statis on just one data point? Funny ...\n";
    }
    $ave = $sum/$numdata;
  }

  close inf;

}  # End of ReadData

##############################
#        OutputData          #
##############################

sub OutputData {

  my $i=0;
  my $j=0;
  $sumabsdd = 0;
  $sumdd2 = 0;

  if ($verbo == 1) {
     print "Bin between $llimit and $ulimit\n"; 
     print "Length of window $length\n";
     print "Number of bins $nbin\n";
     print "Bin size is $binsize\n"; 
  }

  printf " [   infinity , %10.3f ) : %10d\n", $llimit, $bin[0];
  for ($i=1; $i<=$nbin; $i++) {
      $uppervalue = $llimit + $binsize * $i;
      $lowervalue = $uppervalue - $binsize;
      printf " [ %10.3f , %10.3f ) : %10d\n", $lowervalue, $uppervalue, $bin[$i];  
  } 
  $i = $allnbin;
  printf " [ %10.3f ,   infinity ) : %10d\n", $ulimit, $bin[$i];

# additional analysis
  if ($o > 0) {
    for ($j=1; $j<=$numdata; $j++) {
      $dd = $x[$j] - $ave;
      $absdd = abs($dd);
      $dd2 = $dd*$dd;
      $sumabsdd = $sumabsdd + $absdd; 
      $sumdd2 = $sumdd2 + $dd2;      
    }
    $var0 = $sumdd2 / $numdata;
    $var1 = $sumdd2 / ($numdata - 1);
    $rmsd0 = sqrt($var0);
    $rmsd1 = sqrt($var1);
    $mad = $sumabsdd / $numdata;
    $stdevmean = $rmsd1 / sqrt($numdata);
 
    print "Number of data points = $numdata\n"; 
    print "Sum = $sum\n";  
    print "Average = $ave\n"; 
    print "Variance = $var0\n"; 
    print "Population RMSD = $rmsd0\n"; 
    print "Sample RMSD = $rmsd1\n"; 
    print "Std Dev of the Mean = $stdevmean\n"; 
    print "Mean Abs Dev = $mad\n"; 
    print "Max = $max\n"; 
    print "Min = $min\n"; 
    print "Abs Max = $absmax\n"; 
    print "Abs Min = $absmin\n";
  }
}  # End of OutputData

