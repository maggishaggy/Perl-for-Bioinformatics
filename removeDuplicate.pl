#! /usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Bio::AlignIO;
my %unique;

 die "Usage: $0 inputdir outputdir" unless (@ARGV == 2); 
  my $dir1 = "./"."$ARGV[0]";
  my $dir2 = "./"."$ARGV[1]";
  system("mkdir $dir2");	
  opendir(DIR, $dir1) || die "Can't open directory $dir1\n";
my @store_array = ();
@store_array = readdir(DIR);
my $name = '';
my @array = ();
foreach my $file (@store_array) {
	@array = ();
 		next unless ($file =~ /^(\S+)\.gblock.codon.aln/);
 	if ($file =~ /^(.*?)\./){
		$name = $1;
	} 
	
my $seqio  = Bio::SeqIO->new(-file => "$dir1/$file", -format => "fasta");
my $outseq = Bio::SeqIO->new(-file => ">$dir2/$name.aln.fa", -format => "fasta");

while(my $seqs = $seqio->next_seq) {
  my $id  = $seqs->display_id;
  my $seq = $seqs->seq;
  unless(exists($unique{$seq})) {
    $outseq->write_seq($seqs);
    $unique{$seq} +=1;
  }
}


my $in = Bio::AlignIO->new(-format => 'fasta', -file   => "$dir2/$name.aln.fa");
my $aln = $in->next_aln;
my $seqno = $aln->no_sequences;
if($seqno < 5){
 system("rm $dir2/$name.aln.fa");
 }

 }