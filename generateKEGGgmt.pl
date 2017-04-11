#! usr/bin/perl -w
# Zhuofei Xu, 2015 March 19
use strict;
die "Usage: perl $0 mousePathwayName.txt mousePathwayGene.txt" unless (@ARGV == 2);

open(LIST, $ARGV[0]) or die "cannot open $ARGV[0]\n";
open(DATA, $ARGV[1]) or die "cannot open $ARGV[1]\n";

my %hash = ();

# mmu00010 Glycolysis / Gluconeogenesis - Mus musculus (mouse)
while(<LIST>){
	chomp;
	#$_ =~ s/ - Mus musculus \(mouse\)//;
	#- Homo sapiens (human)
	$_ =~ s/ - Homo sapiens \(human\)//;
	if(/^(\S+)\s+(.*)$/){
	  $hash{$1} = $2;
	  #warn "$2\n";
	 }
}
close LIST;

my %vash = ();
# path:mmu00010	mmu:110695
while (<DATA>){
  chomp;
  #if(/^path:(\S+)\s+mmu:(\S+)/){
  if(/^path:(\S+)\s+hsa:(\S+)/){
    push @{$vash{$1}}, $2;
	}
}
close DATA;

for my $ele (sort keys %vash){
  print "$ele $hash{$ele}\t$hash{$ele}\t", join("\t", @{$vash{$ele}}), "\n";
 } 