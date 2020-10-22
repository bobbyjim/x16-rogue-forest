use strict;
use warnings;

# -----------------------------------------------------------
#
#  Labels are used as GOTO and GOSUB proxies.
#
# -----------------------------------------------------------
my %label   = ();

# -----------------------------------------------------------
#
#  Long variable names are declared like so:
#
#  longvar \mylongvariable ml
#
#  'longvar' is the keyword for declaring a long variable.
#  The long variable name comes next, prepended with a /.
#  Finally, its BASIC 2.0 mapping comes last.  This is the 
#  value that the long variable will be reduced to when
#  the converter runs.
#
# -----------------------------------------------------------
my %long  = ();
my %short = ();

my $file = shift || synopsis();               #
open IN, $file or die "Cannot open $file\n";  # Read our file.
my @lines = <IN>;                             #
close IN;                                     #

my $lineNumber = 0;
my $step = 5;

# -----------------------------------------------------------
#
#   Analysis Phase
#
# -----------------------------------------------------------
my @newlines = ();
my $errors = 0;
my $parseLine = 0;
for my $line (@lines)
{
   # remove in-house comments
   $line =~ s/^;.*$//;

   # remove REMs?
   #$line =~ s/REM.*$//i;

   # macro
   $line =~ s/pad\((.+?),(\d+)\)/left\$($1+"                    ",$2)/g;

   # handle printing a banked string
=pod
   if ($line =~ /print\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)/)
   {
      print "Found ]print $1 $2 $3\n";
      my $bank    = $1;
      my $address = $2;
      my $counter = $3;
      my $construct = "$counter = 0\n"
                    . "poke \$9f61,$bank\n"
                    . "{:loop-$counter}\n"
                    . "? chr$(peek($address+$counter));\n"
                    . "$counter = $counter + 1\n"
                    . "if peek($address+$counter) > 0 goto {:loop-$counter}\n";
      $line =~ s#\]print\s*$1\s*,\s*$2\s*,\s*$3#$construct#; 
   }
=cut

   # handle longvar declaration
   if ($line =~ /longvar\s+\\([\w\.]+)[\$\%]?\s+(\w+)[\$\%]?/)
   {
      my $longvarname = $1;
      my $basicvarname = $2;

      if ($long{$longvarname})
      {
         print STDERR "Line $parseLine: Long varname '$longvarname' already declared!\n";
         $errors++;
      }
      if ($short{$basicvarname})
      {
         print STDERR "Line $parseLine: Short varname '$basicvarname' already mapped to $short{$basicvarname}!\n";
         $errors++;
      }
      $long{$1} = $2;
      $short{$2} = $1;
      $line = "";
   }

   foreach my $lv (keys %long)
   {
      if ($line =~ /\\$lv/i)   # handle longvar 
      {
         my $basic = $long{ $lv };

#        printf STDERR "BEFORE: %20s", $line;
         $line =~ s/\\$lv/$basic/g;
#        printf STDERR "AFTER : %20s", $line;
      }
#      else
#      {
#         print STDERR "Line $parseLine: UNDECLARED LONG VAR ($1)\n";
#         print STDERR "Line: $line\n";
#         $errors++;
#      }
   }

#   $line =~ s/\$\$//g;

   $lineNumber += $step;
   if ( $line =~ /^\s*(\{:[-\w\s.]+\})/ )        # Find a label:
   {
      $label{ $1 } = $lineNumber;             # Map label to line number
      $line =~ s/$1\s*//;                     # Remove label decl
   }
   $lineNumber -= $step unless $line =~ /\S/;
   $parseLine++;

   push @newlines, $line if $line =~ /\S/;    # Remove empty lines
}
@lines = @newlines;

print STDERR "Longvar Dump:\n";
foreach (sort keys %long)
{
   print STDERR sprintf "   %-4s: $long{$_}\n", $_;
}


die if $errors;
print STDERR "Parse OK\n";

# -----------------------------------------------------------
#
#   Output Phase
#
# -----------------------------------------------------------
$lineNumber = 0;

#if ($lines[0] =~ /version ([\d\.]*)/i)  # first line have a version?
#{
#   my $oldver = $1;
#   my $newver = $oldver++;
#   $lines[0] =~ s/version $oldver/version: $newver/i;
#}

for my $line (@lines)
{
   $lineNumber += $step;
   my @captures = $line =~ /(\{:[.\s\w-]+\})/g;

   foreach my $lbl (@captures)
   { 
      $line =~ s/$lbl/$label{$lbl}/g            # Replace label with line number
         if $label{$lbl};
   } 
   print uc "$lineNumber $line";              # Print our prepared line
}


sub synopsis
{
   print<<EOUSAGE;
USAGE: $0 basic-file

This program manipulates BASIC text in these ways:

1. It removes all REM statements.
2. It treats the semicolon (;) at column 1 ONLY as a REM shorthand.
3. It removes all blank lines.
4. It processes labels like so:

{:mylabel} print "hello, world"
goto {:mylabel}

   Note that labels can contain dots and dashes.  So this works:

   goto {:BankUtil.parseString}

   ...but I don't handle parameters :(

5. It creates line numbers magically.
6. It manages declaration of STATES like so:

   my \$\$fu
   my \$\$fu = 12

7. It ENFORCES clear use of DECLARED STATES.
8. If managed long variables like so:
   longvar \\mylongvariablename  ml

   - the second ID is the two-character BASIC variable the longvar maps to.
   - it is type agnostic.  It only registers a string mapping.


EOUSAGE
}

