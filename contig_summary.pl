#!/usr/bin/perl
#xuzf 2012-3-13
die "Usage:     $0  fastafile > read_statistics \n" if(@ARGV != 1);

use strict;

open(GENO,$ARGV[0])or die "cannot open $ARGV[0]\n";
#open(FILELEN,">$ARGV[1]") or die "cann't open file:$!\n";
#>SRR029701.13 E769IWU01DNQMJ
#TTTTCATCCATATCTTTCGTGGAATACCAACGCACACAATCATCATCGAATTTCACGCCATAATCGGAAAGACACTGGATAAATCCTTTATAGCGCTCAATTCCCTGCATATCATCATATTTA
#AAAATTCCACTGAGACACGCAACAGGGGATAGGCAAGGCACACAGGGGATAGGNN
#>SRR029701.14 E769IWU01CYYKI
#AGGCTGTTTGCTTCAGAGCCGTTTCGAAACGCTGATGTTGGGAATGGATGCCCTTTTAAGCAAACACCCTACACTTCGTTTGAATCGGTGGCTGGATTTTGCCTCAAAAGCTGCCGAAACAAC
#CACAGAAAAAACAGTATGAAACTGAATGCGCGGCGTATTCTGAGACACGCAACAGGGGGATAGGCCAAGGCACCACAGGGGATAGGNNNNNNNNN

local $/ = '>'; 

my $totallen = 0;
my $len = 0;
my $GC = 0;
my $ambiguous = 0;
my $baseA = 0;
my $baseT = 0;
my $baseG = 0;
my $baseC = 0;
my $count = 0;
my $totalN = 0;
my $totalA = 0;
my $totalT = 0;
my $totalG = 0;
my $totalC = 0;
my %hash = ();
my $readno = 0;

while(<GENO>){
        chomp;
        my ($head,$sequence) = split(/\n/,$_,2);
        #my $name = ($head =~ /^(\S+)\s+/);
        #>contig00001 length=6152   numreads=71
        if($head =~ /^(\S+)\s+(\S+)\s+numreads=(\d+)/){
        	$readno += $3;
        }
        $sequence =~ s/\n//g;
        $sequence = uc($sequence);
        $len = length($sequence);
        if (length($sequence) >= 1){                  #this script can set length limitation for each read
        	$count++;
        	$hash{$len} = $len;
        	#print FILELEN "$len\n";
        	#warn "$count\t", length($sequence);
        
        #my $gc = ($sequence =~ tr/GC/GC/);
        $totallen += $len;
        $ambiguous = ($sequence =~ tr/N/N/);
        $baseA = ($sequence =~ tr/A/A/);
        $baseT = ($sequence =~ tr/T/T/);
        $baseG = ($sequence =~ tr/G/G/);
        $baseC = ($sequence =~ tr/C/C/);
        
        #$genomicGC +=  $gc;
        $totalN += $ambiguous;
        $totalA += $baseA;
        $totalT += $baseT;
        $totalG += $baseG;
        $totalC += $baseC;
      }
}
#my $percent = sprintf("%.2f",$genomicGC*100/$genomiclength);       
#print "genomic GC (%):\t$percent\n\n";           

print "Total no. of contigs:\t $count\n\n";
print "Total size of all contigs \(bp\):\t\t $totallen\n\n";

my $avelen = $totallen/$count;
print "Average length of contigs\(bp\):\t\t $avelen\n\n";
print "Total ambiguous bases:\t\t\t $totalN\n\n";

my $sum = $totalA + $totalT + $totalG + $totalC + $totalN;
print "The total number of four bases and ambiguous bases:\n  A -> $totalA; T -> $totalT; G -> $totalG; C -> $totalC; ambiguous bases -> $totalN; Sum -> $sum\n\n";

my $gc = 100*($totalG+$totalC)/$sum;
print "The contigs have a percentage of G and C of \%$gc\n\n";

my $min = 0;
my $max = 0;

for my $ele (sort {$a <=> $b} keys %hash){
	#print "$hash{$min}\n";
  #print "$min\n";
  $min = $ele;
  last;
}

for my $tag (sort {$b <=> $a} keys %hash){
	#print "$hash{$min}\n";
  #print "$max\n";
  $max = $tag;
  last;
}

print "Min contig length:      $min bp\n";
print "Max contig length:      $max bp\n\n";
