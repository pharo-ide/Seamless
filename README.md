# Seamless. Distributed object network.

[![GitHub release](https://img.shields.io/github/release/pharo-ide/Seamless.svg)](https://github.com/pharo-ide/Seamless/releases/latest)
[![Unit Tests](https://github.com/pharo-ide/Seamless/actions/workflows/tests.yml/badge.svg)](https://github.com/pharo-ide/Seamless/actions/workflows/tests.yml)

[![Pharo 7.0](https://img.shields.io/badge/Pharo-7.0-informational)](https://pharo.org)
[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-informational)](https://pharo.org)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-informational)](https://pharo.org)

For details on Seamless design read [full documentation](https://github.com/SquareBracketAssociates/Booklet-Infrastructure).

## Installation on client
On the client you can load default project group: 
```Smalltalk
Metacello new
  baseline: 'Seamless';
  repository: 'github://pharo-ide/Seamless';
  load
```
It will include tests and tools to inspect remote objects.

And use the following snippet for stable dependency in your client project baseline:
```Smalltalk
spec
    baseline: 'Seamless'
    with: [ spec repository: 'github://pharo-ide/Seamless' ]
```
## Installation on server
You can just use client instructions to prepare servers. But in case if you want to prepare really small images without any tools and even without SUnit then follow this section.

On server only Core group of project is needed:
```Smalltalk
Metacello new
  baseline: 'Seamless';
  repository: 'github://pharo-ide/Seamless';
  load: #(Core)
```
It will not include any tools to work with remote objects. And it will not install tests. If you want tests then add Tests group into a script.

Use the following snippet for stable dependency in your project server baseline:
```Smalltalk
spec
    baseline: 'Seamless'
    with: [ spec 
        repository: 'github://pharo-ide/Seamless:v1.0.0';
	loads: #(Core)]
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
remoteSmalltalk here is a proxy which delegates any received message to remote object. Remote messages are executed on the server which returns result back to the client. The result can be returned as another proxy or as a copy which contains other proxies.

In this example, the result is a reference to a remote Smalltalk instance. It can access globals from remote environment:
```Smalltalk
remoteTranscript := remoteSmalltalk at: #Transcript.
remoteTranscript open; show: 'remote message'; cr
```
It will open transcript on the server and print text on it.

Arguments of remote message are transferred to the server with the same logic as message result transferred to client. On server arguments can include proxies and server can send messages to them:
```Smalltalk
remoteTranscript print: #(1 2 3 4 5)
```
Here array will be passed to server as reference. Then on server transcript will interact with it to print it. And as result client will receive messages from the server.

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
It allows us to tune network for specific application to optimize communication between distributed objects. There are few other transfer strategies which allow minimizing remote communication. Most interesting allows properties caching. It will transfer object reference together with specified properties. The following example will configure a network to transfer class reference together with a name:
```Smalltalk
network transferByReference: (Kind to: Class) withCacheFor: #(name)
```
And then the proxy for the remote class will return #name from a local cache instead of real remote call.

### Remote block execution
Seamless allows evaluate a block of code on remote peers:
```Smalltalk
remotePeer evaluate: [1 + 2]. "==>3"
```
Given block is transferred to remote side and evaluated. A result is returned to the client. As in other cases, it could be a proxy or normal object.

Block can use globals. On the remote side, they will be local globals of this remote environment. The following example will show notification on remote image:
```Smalltalk
remotePeer evaluate: [Object inform: 'message from remote image'].
```
Temps and workspace variables can be used too. They will be transferred according to own strategies:
```Smalltalk
| result |
result := OrderedCollection new.
remotePeer evaluate: [100 to: 500 do: [:i | result add: i factorial ]].
```
Non-local return is also supported in regular Smalltalk semantics:
```Smalltalk
remotePeer evaluate: [1 to: 10 do: [:i | i > 5 ifTrue: [ ^i ]]]. "==>6"
```
Also, block can be evaluated asynchronously without waiting any result:
```Smalltalk
| result |
result := OrderedCollection new.
remotePeer evaluateAsync: [result add: 1000 factorial]. "it will not wait result"
```
## Tools
Seamless provides integration with GT tools. Remote proxies can be inspected to explore remote objects state with the ability to execute remote scripts (doIt, printIt). It is shown in [the demo about remote debugging](https://youtu.be/SgFjgQpo_nU) which is built with Seamless transport.

To analyze remote communication Seamless implements special tool SeamlessLogger. It is explained in the [documentation](https://ci.inria.fr/pharo-contribution/view/Books/job/PharoBookWorkInProgress/lastSuccessfulBuild/artifact/book-result/Seamless/Seamless.pdf). To activate logging evaluate:
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
Statistics shows s number of messages, receivers and bytes which was transferred over the network in a dimension of receiver class or message selector.

## TODO
In the current version there are two missing features which will be supported in future:

1) No garbage collection

SeamlessNetwork keeps all objects which were transferred by reference. They will never be cleaned while the network is live. 
Now cleanup can be performed manually by evaluating "network destroy". It will clean all object caches and close all connections. It is not safe operation because removed objects can be still used by remote peers. Seamless tries to handle it properly with clear errors in such cases. 

In future unused distributed objects will be cleaned automatically.

2) No security: no authorization and encryption. Now for security purpose, you need external tools like VPN or SSH tunnel.
