#! /usr/bin/perl -w
use strict;

open(IN,"$ARGV[0]")|| die "can't open file:$!\n";

#chr1	Cufflinks	exon	176810054	176813663	.	+	.	gene_id "XLOC_000004"; transcript_id "TCONS_00000004"; exon_number "1"; oId "CUFF.289.1"; tss_id "TSS4";
#chrY	Cufflinks	exon	83715099	83715782	.	-	.	gene_id "XLOC_037996"; transcript_id "TCONS_00060452"; exon_number "1"; gene_name "ENSMUST00000180018.1"; oId "ENSMUST00000180018.1"; nearest_ref "ENSMUST00000180018.1"; class_code "="; tss_id "TSS49244"; p_id "P33145";

print "Gene_id\tGene_type\tGene_name\tChromosome_lable\tStart\tEnd\tStrand\n";

my %hash = ();

while(<IN>){
  chomp;
  if(/^chr(\S+)\t(.*?)\tgene\t(\d+)\t(\d+)\t(.*?)\t(\S+)\t/){
     my $chrosome = $1;
	 my $start = $3;
	 my $ends = $4;
	 my $strand = $6;
	if(/\sgene_id\s\"(\S+)\";.*?gene_type\s+\"(\S+)\";.*?gene_name\s+\"(\S+)\";/){
     my $id = $1;
	 my $type = $2;
	 my $name = $3;
	 $id =~ s/\.\d+//g;

       print "$id\t$type\t$name\ths$chrosome\t$start\t$ends\t$strand\n";
	 }
	 }
}
close IN;


