#!/usr/bin/perl
use strict;
# zhuofei xu, Feb 2nd, 2015

use Bio::SearchIO;
die "Usage:  $0 cog2003-2014.csv cognames2003-2014.tab output.blast > besthit.tab \n" if(@ARGV != 3);

open (LIST, "$ARGV[0]") || die "can't open the list:$!\n";

my %hash = ();

while(<LIST>){
	chomp;
	#158333741,Acaryochloris_marina_MBIC11017_uid58167,158333741,432,1,432,COG0001,0,
  if(/^(\d+),.*?,(COG\d+),/){
  	$hash{$1} = $2;
  }
}
close LIST;

open (DATA, "$ARGV[1]") || die "can't open the data file:$!\n";

my %vash = ();
while(<DATA>){
	chomp;
	if(/^(\S+)\s+(.*)$/){
		$vash{$1} = $2;
	}
}
close DATA;


my $file = $ARGV[2];
my $in = Bio::SearchIO->new(-format => 'blast',
                            -file    => $file);
# SSUSC84_RS00010	15899951	COG0592	L	DNA polymerase III sliding clamp (beta) subunit, PCNA homolog
print "Query\tSubject\tCOG_code\tCOG_class\tCOG_family\n";

my $count = 0;
my $number = 0;

while( my $r = $in->next_result ) {          #read a result
  $count = 0;
  $number++;
  	if ($r->num_hits < 1){
  	 print $r->query_name,"\t","Not in COG\t-\t-\t-\n";
  	 next;
  }
  while( my $h = $r->next_hit ) {            #read a hit

    #warn " Hit is ", $h->name, " Hit raw scores ", $h->raw_score, " Hit Len is ", $h->length, " aa\n";
    #>gb|ADN32826.1| BUN24p41.8 [Bacteroides uniformis]
    my $hitlen = $h->length;
    while( my $hsp = $h->next_hsp ) { 
     my $subject = $h->name;
     if ($subject =~ /^gi\|(\d+)/){
     	my $gi = $1;
     if ($count < 1){
     	my $cogid = $hash{$gi};
      print $r->query_name,"\t", $gi, "\t", $cogid, "\t", $vash{$cogid}, "\n";
     $count++;
     }
    }
    last;
     }    
  }
}
#warn "$number\n";
