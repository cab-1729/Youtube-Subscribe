#Disclaimer: This file is made for illustrative purposes only. It is purely fictional and does not represent the preferences or opinions of the author. This project does not endorse any of the Youtube channels mentioned.
package Subscribed;
use warnings;
use strict;
our sub new{
	my $class=shift;
	#Each topic is a data member
	our $self={
		#Each playlist is an array inside the topic
		News=>[
			["Fox News","UUXIJgqnII2ZOINSWNOGFThA"],#channel id with leading UC replaced by UU
			["CNN","UUupvZG-5ko_eiXAupbDfxWw"],
			["MSNBC","UUaXkIU1QidjPwiAYu6GcHjg"],
			["Rebel News","UUGy6uV7yqGWDeUWTZzT3ZEg","$ENV{HOME}/Videos/Rebel News"],#videos will be downloaded to '~/Videos/Rebel News'
		],
		Technology=>[
			["Github Foundation","PL0lo9MOBetEHhfG9vJzVCTiDYcbhAiEqL"],
			["Hey DT!!","PL5--8gKSku16ZCPdQ1RpLW53zXpPlCJ84"],
			["freeCodeCamp","UU8butISFwT-Wl7EV0hUK0BQ"],
			["Linus Tech Tips","UUXuqSBlHAE6Xw-yeJA0Tunw"],
			["Live Overflow","UU7YOGHUfC1Tb6E4pudI9STA"],
		],
		Politics=>[
			["Alexandria Ocasio-Cortez","UUElqfal0wzzpLsHlRuqZjaA"],
			["Senator Rand Paul","UUeM9I-20oWUs8daIIpsNHoQ"],
			["Speaker Nancy Pelosi","UUxPeEcH0xaCK9nBK98EFhDg"],
			["Hold These Truths - Dan Crenshaw","PLO0l2rQLwh0kM34p1jugDSe4b2cy_X2Bv"],
		]
		Music=>[
			["Vevo","UUmC_eIBo4e4KDGJzdi57r9g","$ENV{HOME}/Music"],
		],
		History=>[
			["The Armchair Historian","UUeUJFQ0D9qs6aVNyUt9fkeQ"],
			["Epic History","UUvPXiKxH-eH9xq-80vpgmKQ"],
		],
	};
	bless $self,$class;
	return $self;
}
our sub api_key{
	#This function returns your youtube api key.
	#You are required to write this function
	return "YOUR YOUTUBE API KEY";
}
our sub download{
	#you may rewrite this function to suit your own ways of downloading youtube videos
	my ($id,$directory)=@_;
	chdir "$directory";
	system("yt-dlp --write-thumbnail --embed-chapters https://www.youtube.com/watch?v=$id");
}
1;
