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
## How to use
To use Seamless SeamlessNetwork instance should be created on client and server:
```Smalltalk
network := SeamlessNetwork new.
```
To accept connections server should be started:
```Smalltalk
network startServerOn: 40422.
```
Clients could connect to server and retrieve remote environment:
```Smalltalk
remotePeer := network remotePeerAt: (TCPAddress ip: #[127 0 0 1] port: 40422).
remoteSmalltalk := remotePeer remoteEnvironment.
```
Or use short version:
```Smalltalk
remoteSmalltalk := network environmentAt: (TCPAddress localAt: 40422)
```
remoteSmalltalk here is a proxy which delegates any received message to remote object. Remote messages are executed on server which return result back to client. Result can be returned as another proxy or as copy which contains another proxies.

In example result is reference to remote Smalltalk instance. It can access globals from remote environment:
```Smalltalk
remoteTranscript := remoteSmalltalk at: #Transcript.
remoteTranscript open; show: 'remote message'; cr
```
It will open transcript on server and print text on it.

Arguments of remote message are transferred to server with same logic as message result transferred to client. On server arguments can include proxies and server can send messages to them:
```Smalltalk
remoteTranscript print: #(1 2 3 4 5)
```
Here array will be passed to server as reference. Then on server transcript will interact with it to print it. And as result client will receive messages from server.

Concrete transfer strategy is depends on transferred object. It is specified in method #seamlessDefaultTransferStrategy:
```Smalltalk
Object>>seamlessDefaultTransferStrategy
      ^SeamlessTransferStrategy defaultByReference

Number>>seamlessDefaultTransferStrategy
      ^SeamlessTransferStrategy defaultByValue
```
Default strategy could be overridden on network level:
```Smalltalk
network transferByValue: (Instance of: Point).
network transferByReference: (Identical to: #specificSymbol)
```
It allows to tune network for specific application to optimize communication between distributed objects. There are few other transfer strategies which allow minimize remote communication. Most interesting allows properties caching. It will transfer object reference together with specified properties. Following example will configure network to transfer class reference together with name:
```Smalltalk
network transferByReference: (Kind to: Class) withCacheFor: #(name)
```
And then proxy for remote class will return #name from local cache instead of real remote call.

### Remote block execution
Seamless allows evaluate block of code on remote peers:
```Smalltalk
remotePeer evaluate: [1 + 2]. "==>3"
```
Given block is transferred to remote side and evaluated. Result is returned to client. As in other cases it could be proxy or normal object.

Block can use globals. On remote side they will be local globals of this remote environment. Following example will show notification on remote image:
```Smalltalk
remotePeer evaluate: [Object inform: 'message from remote image'].
```
Temps and workspace variables can be used too. They will be transferred according to own strategies:
```Smalltalk
| result |
result := OrderedCollection new.
remotePeer evaluate: [100 to: 500 do: [:i | result add: i factorial ]].
```
Non local return is also supported in regular Smalltalk semantics:
```Smalltalk
remotePeer evaluate: [1 to: 10 do: [:i | i>5 ifTrue: [^i] ] ]. "==>6"
```
Also block can be evaluated asynchronously without waiting any result:
```Smalltalk
| result |
result := OrderedCollection new.
remotePeer evaluateAsync: [result add: 1000 factorial]. "it will not wait result"
```
## Tools
Seamless provides integration with GT tools. Remote proxies can be inspected to explore remote objects state with ability to execute remote scripts (doIt, printIt). It is shown in [the demo about remote debugging](https://youtu.be/SgFjgQpo_nU) which is built with Seamless transport.

To analyze remote communication Seamless implements special tool SeamlessLogger. It is explained in [doc](https://ci.inria.fr/pharo-contribution/view/Books/job/PharoBookWorkInProgress/lastSuccessfulBuild/artifact/book-result/Seamless/Seamless.pdf). To activate logging evaluate:
```Smalltalk
SeamlessLogger startAFresh
```
To disable:
```Smalltalk
SeamlessLogger stop
```
Logger prints all remote messages into Transcript. Also it provides profiler of remote communication. You can inspect request statistics using:
```Smalltalk
SeamlessLogger collectStatistics "inspect it"
```
Statistics shows number of messages, receivers and bytes which was transferred over network in dimension of receiver class or message selector.

## TODO
In current version there are two missing features which will be supported in future:

1) No garbage collection

SeamlessNetwork keeps all objects which was transferred by reference. They will never be cleaned while network is live. 
Now cleanup can be performed manually by evaluating "network destroy". It will clean all object caches and close all connections. It could be not safe because remote peers could still use these objects. Seamless tries to handle it properly with clear errors in such cases. 

In future unused distributed objects will be cleaned automatically.

2) No security: no authorization and encryption. Now for security purpose you need external tools like VPN or SSH tunnel.
