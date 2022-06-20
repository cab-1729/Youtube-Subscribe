# Youtube-Subscribe
My first Perl program, created for personal use and with the intent to learn Perl.
Allows one to "subscribe" to playlists one youtube. New videos are downloaded every time program is run.
The configuration is done in the _Subscribed.pm_ file.

## Important details:
+ Requires [Youtube Data API](https://developers.google.com/youtube/v3) key.
+ Downloads videos locally.
+ Remembers last videos using the _Done.pm_ file.
+ _Done.pm_ is changed everytime the program is run, so it should be given read and write permissions.
+ Topics are not downloaded in any specific order. (for now)

## About _Subscribed.pm_
+ This file can be thought of as the "_config file_" of the program.
+ Each topic is a data member of the package which is a 2d array.
+ Each playlist is an array belonging to a topic.
+ Playlists have three elements, last one being optional.
+ The first 2 elements of a playlist are the name and the Id respectively, third element is the directory in which the videos are to be downloaded.
+ The name of the playlist can be anything, it does not have to match the actual name.

_Tip: If one wants to subscribe to a channel. Get a hold of the channel id, replace the leading 'UC' with 'UU'. The resulting string is the ID of a playlist containing all of the channels videos._
