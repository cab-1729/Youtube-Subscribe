#!/bin/perl
use warnings;
use strict;
use threads;
use Term::ReadKey qw(ReadMode ReadKey);
use lib "$ENV{HOME}/.config/youtube";#load configurations
use LWP::Simple 'get';
use JSON::Parse 'parse_json';
use Switch;
use Subscribed;
my $subscribed=new Subscribed();#import subscriptions
use Done;
my $done=new Done();#import last downloads
my $API_KEY=$subscribed->api_key();
my @videos=();
foreach my $topic (keys %{$subscribed}){
	my $dash="-"x(4+length($topic));
	print "$dash\n| $topic |\n$dash\n";
	foreach my $playlist (@{$subscribed->{$topic}}){
		my $latest_vid;
		print "\t$playlist->[0]\n";
		my $playlistId=$playlist->[1];
		my $directory=$playlist->[2];
		my $items=(parse_json get "https://youtube.googleapis.com/youtube/v3/playlistItems?key=$API_KEY&part=snippet&maxResults=50&playlistId=$playlistId")->{'items'};#assuming less than 50 videos have been missed
		my $last_vid=$done->{$playlistId};#get id of previously downloaded video
		$latest_vid=$items->[0]->{'snippet'}{'resourceId'}{'videoId'};#get id of previously downloaded video
		foreach my $video (@{$items}){#loop over videos
			my $snippet=$video->{'snippet'};
			my $videoId=$snippet->{'resourceId'}{'videoId'};
			if($videoId eq $last_vid){last;}#videos not new anymore
			my $prompt=1;
			ReadMode 'cbreak';
			print "\t\t$snippet->{'title'} : ";
			do{#wait for correct input
				switch(ReadKey 0){
					case "y" {
						print "y\n";
						push @videos,[$videoId,defined($directory)?$directory:"$ENV{HOME}/Downloads"];
						$prompt=0;
					}
					case "n" {
						print "n\n";
						$prompt=0;
					}
					case "d" {#video description asked
						print "d\n\n\t\t\tDescription\n\n$snippet->{'description'}\n\n\n";
						print "\n\t\t$snippet->{'title'} : ";
					}
				}
			}while($prompt);
			ReadMode 'normal';
		}
	$done->{$playlistId}=$latest_vid;#remember last videoId
	}
}
print "\n\nPress ENTER to start downloading ...";
<STDIN>;
map{$_->join()}(map{threads->create(\&Subscribed::download,@{$_})}(@videos));#start downloading
#update Done module
open(doneFile,'>',"$ENV{HOME}/.config/youtube/Done.pm") or die $!;
print doneFile <<EOF;
package Done;
#This file may change when code is run
use strict;
use warnings;
our sub new{
	my \$class=shift;
	our \$self={
EOF
foreach my $playlist (keys %{$done}){
	print doneFile "\t\t\'$playlist\'=>\'$done->{$playlist}\',\n";
}
print doneFile <<EOF;
	};
	bless \$self,\$class;
	return \$self;
}
1;
EOF
close doneFile;
