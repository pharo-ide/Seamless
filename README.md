# Seamless. Distributed object network.
[![Build Status](https://travis-ci.org/dionisiydk/Seamless.svg?branch=master)](https://travis-ci.org/dionisiydk/Seamless)

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
## Installation on server
On server only Core group of project is needed:
```Smalltalk
Metacello new
  baseline: 'Seamless';
  repository: 'github://dionisiydk/Seamless';
  load: #(Core)
```
It will not include any tools to work with remote objects. And it will not install tests. If you want tests then add Tests group into script.

Use following snippet for stable dependency in your project server baseline:
```Smalltalk
spec
    baseline: 'Seamless'
    with: [ spec 
        repository: 'github://dionisiydk/Seamless:v0.9.x';
	loads: #(Core)]
```
## Installation on client
On client you can load default project group: 
```Smalltalk
Metacello new
  baseline: 'Seamless';
  repository: 'github://dionisiydk/Seamless';
  load
```
It will include tests and tools to inspect remote objects.

And use following snippet for stable dependency in your client project baseline:
```Smalltalk
spec
    baseline: 'Seamless'
    with: [ spec repository: 'github://dionisiydk/Seamless:v0.9.x' ]
```
