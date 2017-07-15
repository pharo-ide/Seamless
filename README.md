# Seamless. Distributed object network.

For details look at [release post](http://dionisiydk.blogspot.fr/2016/07/major-seamless-update.html) or full [documentation](https://ci.inria.fr/pharo-contribution/view/Books/job/PharoBookWorkInProgress/lastBuild/artifact/book-result/Seamless/Seamless.pdf).
```Smalltalk
serverSideNetwork := SeamlessNetwork new.
server := serverSideNetwork startServerOn: 40423
	
clientSideNetwork := SeamlessNetwork new.
remoteEnv := clientSideNetwork environmentAt: (TCPAddress localAt: 40423).
remoteTranscript := remoteEnv at: #Transcript.
remoteTranscript show: 'hello from remote side'.

remotePeer := clientSideNetwork remotePeerAt: (TCPAddress localAt: 40423).
remotePeer evaluate: [Object inform: 'message from remote side']
```
## Installation
```Smalltalk
Metacello new
  baseline: 'Seamless';
  repository: 'github://dionisiydk/Seamless';
  load
```
