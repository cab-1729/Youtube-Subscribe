#!/bin/perl
use warnings;
use strict;
use threads;
use File::Basename 'dirname';
my $scriptFolder;
BEGIN{ $scriptFolder=dirname __FILE__;}#https://stackoverflow.com/a/13950813
use lib "$scriptFolder";#module from same directory
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
			do{#continuous prompt
				print "\t\t$snippet->{'title'} : ";
				switch(<STDIN>){
					case "y\n" {
						push @videos,[$videoId,defined($directory)?$directory:"$ENV{HOME}/Desktop/youtube"];
						$prompt=0;
					}
					case "n\n" {
						$prompt=0;
					}
					case "d\n" {#video description asked
						print "\n\n\t\t\tDescription\n\n$snippet->{'description'}\n\n\n";
					}
				}
			}while($prompt);
		}
	$done->{$playlistId}=$latest_vid;#remember last videoId
	}
}
print "\n\nPress ENTER to start downloading ...";
<STDIN>;
my @downloads=();
foreach my $video (@videos){#start downloading
	push @downloads,threads->create(\&Subscribed::download,@{$video});
}
foreach my $downloader (@downloads){#wait for downloads to complete
	$downloader->join();
}
#update Done module
open(doneFile,'>',"$scriptFolder/Done.pm") or die $!;
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
