#!/usr/bin/perl
# grab_lines_code.pl
#
# grab lines of code in different versions of R/qtl

$ifile = "../Data/versions.txt";
open(IN, $ifile) or die("Cannot read from $ifile");
$ofile = "../Data/lines_code_by_version.csv";
open(OUT, ">$ofile") or die("Cannot write to $ofile");
print OUT "file,date,R,C,man\n";
while($line = <IN>) {
    chomp($line);
    @v = split(/\s+/, $line);
    $file = $v[0];
    $file =~ /^qtl_(.+).tar.gz$/;
    $version = $1;
    $date = join(" ", @v[1..(@v-1)]);
    $date =~ s/[\(\)]//g;
    system("tar xzf ~/Code/Rqtl/Backup/$file");
    print "$file\n";
    system("wc -l qtl/R/*.R > rlines.txt");
    system("wc -l qtl/src/*.c qtl/src/*.cpp qtl/ > clines.txt");
    system("wc -l qtl/man/*Rd qtl/ > Rdlines.txt");
    system("\\rm -r qtl");

    @files = ("rlines.txt", "clines.txt", "Rdlines.txt");
    print OUT "$version,$date";
    foreach $ifile (@files) {
        open(IN2, $ifile) or die("Cannot read from $file");
        while($line = <IN2>) {
            chomp($line);
            if($line =~ /total/) {
                @v = split(/\s+/, $line);
                if($v[0] eq "") { shift @v; }
                print OUT ",$v[0]";
            }
        }
    }
    foreach $ifile (@files) {
        system("\\rm $ifile");
    }
    print OUT "\n";
}

          
           
