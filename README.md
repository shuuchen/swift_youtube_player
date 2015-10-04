# swift_youtube_player
An iOS app written in Swift that can search and play videos from Youtube.com
<p>
  <img src="https://github.com/shuuchen/swift_youtube_player/blob/master/swift_youtube_player.gif" height="438" width="250"  />
</p>

## Features
* A light-weight program that can be easily integrated into your own project
* Using auto-layout to display both portrait and landscape on multiple devices
* Using the following Google APIs to search and play videos from Youtube.com
 * https://github.com/youtube/youtube-ios-player-helper
 * You can directly run this program in your own IDE, but it is highly recommended to get your own API key and replace the old one with it in the source code
* Using NSURLSession and GCD to deal with network tasks asynchronously, guaranteeing that the UI interaction will never be blocked

## Requirements
* Xcode 6.4 or above
* iOS 8.0+

## License
swift_youtube_player is released under the MIT license. See LICENSE for details.
