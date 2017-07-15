I implement transparent network of objects.

To create new instance of me just send #new message 	
	network := SeamlessNetwork new.
	
On server side you should start server to accept connections: 
	network startServerOn: 40422. "it is part of Basys network API"

On client side you should retrieve remote environment to start interaction with remote peer:
	remoteSmalltalk := network environmentAt: (TCPAddress ip: #[127 0 0 1] port: 40422). "short version: TCPAddress localAt: 40422"

Returned value is proxy which delegates any received message to remote object. Remote object executes it and returns result to sender. On client side result can be returned as another proxy or as copy which contains another proxies.
In example result is reference to remote Smalltalk instance. You can get remote globals from it and send messages to it: 
	remoteTranscript := remoteSmalltalk at: #Transcript.
	remoteTranscript open; show: 'remote message'; cr
It will opens transcript on server and print text on it.

Arguments of remote message are transferred to server with same logic as result transferred to client. If argument will be transferred by reference server can send messages to it: 
	remoteTranscript print: #(1 2 3 4 5)
Here array will be passed to server as reference. Then on server transcript will interact with it to print it. And as result client will receive messages from server.

By default objects transferred by reference. But some objects like numbers and strings are transferred by value. You can override this behaviour by implementing #seamlessDefaultTransferStrategy on you classes.
For example Object returnes SeamlessTransferByReferenceStrategy. But numbers and strings return SeamlessTransferByValueStrategy.
This default strategies are defined as singletons and can be used by:
	SeamlessTransferStrategy defaultByValue 
	SeamlessTransferStrategy defaultByReference

I allows overriding default strategies. You can add strategy explicitly to me for specific set of objects. For detailes look at SeamlessTransferStrategy comments.

When object should be transferred by reference I create SeamlesObjectReference for it and transmit it over network instead of real object. On server side I create proxy objects for received references. 
By default proxy is SeamlessProxy which delegates all messages to remote side. But it is possible to use specific proxy classes for specific objects. 
For this you should implement subclass of SeamlessObjectReference which will return new kind of proxy. And you should override method #createSeamlessReference on your class to return new reference instance. For more details look at SeamlessObjectReference comments. 

I contain transporterClass which defines actual protocol for sending and receiving data. It is implemented by SeamlessObjectTransforter subclasses. Look at it comments for details. Now there is only Fuel based protocol.

Network peers communicate with each others by sending request objects. It is subclasses of SeamlessRequest. Remote message send is just one type of it (SeamlessMessageSendRequest). 
Requests are sent by contexts which represent logical sender. And requests return result to contexts.
	context sendRequest: SeamlessRequest
	context return: result to: senderPeer.
Result of requests is subclasses of SeamlessRequestResult.
Look at comments of this classes for details

Public API and Key Messages

- environmentAt: aTCPAddress
- addTransferStrategy: aSeamlessTransferStrategy
- look at BasysNetwork API for detailes
 
Internal Representation and Key Implementation Points.

    Instance Variables
	distributedObjects:		<SeamlessDistributedObjects>
	transferStrategies:		<Colection of <SeamlessTransferStrategy>>
	transporterClass:		<SeamlessObjectTransporter class>
				
