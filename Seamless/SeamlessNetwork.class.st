"
I implement transparent network of objects.

To create new instance of me just send #new message 	
	network := SeamlessNetwork new.
	
On server side you should start server to accept connections: 
	network startServerOn: 40422. ""it is part of Basys network API""

On client side you should retrieve remote environment to start interaction with remote peer:
	remoteSmalltalk := network environmentAt: (TCPAddress ip: #[127 0 0 1] port: 40422). ""short version: TCPAddress localAt: 40422""

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
				

"
Class {
	#name : #SeamlessNetwork,
	#superclass : #BasysNetwork,
	#instVars : [
		'distributedObjects',
		'transferStrategies',
		'transport',
		'requestProcessingTimeout'
	],
	#classInstVars : [
		'defaultRequestProcessingTimeout'
	],
	#category : #'Seamless-Core'
}

{ #category : #accessing }
SeamlessNetwork class >> defaultRequestProcessingTimeout [
	^defaultRequestProcessingTimeout
]

{ #category : #accessing }
SeamlessNetwork class >> defaultRequestProcessingTimeout: aDuration [
	defaultRequestProcessingTimeout := aDuration
]

{ #category : #settings }
SeamlessNetwork class >> defaultRequestProcessingTimeoutSecs [
	^self defaultRequestProcessingTimeout ifNil: [ 0 ] ifNotNil: [:timeout | timeout asSeconds]
]

{ #category : #settings }
SeamlessNetwork class >> defaultRequestProcessingTimeoutSecs: aNumber [

	| timeout |
	timeout := (aNumber isNil or: [aNumber isZero]) 
					ifTrue: [ nil ] ifFalse: [ aNumber seconds].
	self defaultRequestProcessingTimeout: timeout
]

{ #category : #settings }
SeamlessNetwork class >> settingOn: aBuilder [
	<systemsettings>
	(aBuilder group: #seamless)
		label: 'Seamless';
		parent: #tools;
		description: 'Seamless network settings';
		with: [ (aBuilder setting: #defaultRequestProcessingTimeoutSecs)
				target: self; 
				label: 'Default request processing timeout (secs)';
				default: 0
				] 
]

{ #category : #accessing }
SeamlessNetwork >> addTransferStrategy: aTransferStrategy [

	transferStrategies add: aTransferStrategy 
]

{ #category : #accessing }
SeamlessNetwork >> addTransferStrategy: aTransferStrategy priority: anInteger [ 
	aTransferStrategy priority: anInteger.
	self addTransferStrategy: aTransferStrategy
]

{ #category : #accessing }
SeamlessNetwork >> createDeliveryForResultFrom: aRemotePeer [
	^ self requestProcessingTimeout
			ifNil: [SeamlessRequestResultDelivery from: aRemotePeer]
			ifNotNil: [:timeout |	SeamlessRequestResultTimelyDelivery from: aRemotePeer maxTime: timeout]
]

{ #category : #controlling }
SeamlessNetwork >> destroy [
	"This methods supposed to be used when you really want to destroy local peer network and release all resources without thinking that they can be in use on remote peers.
	Special request will be send to all connected peers to notify them. Then all connections and distributed objects will be cleaned.
	Maybe it should be general #close method. But for now it is separate method (network #close only close peers with existing connections).
	When peer is destroying it removes itself from network. That's why we need to enumeration on copy"
	peerRegistry remotePeers copy do: [ :each |	each destroy]
]

{ #category : #accessing }
SeamlessNetwork >> distributedObjects [
	^ distributedObjects
]

{ #category : #accessing }
SeamlessNetwork >> distributedObjects: anObject [
	distributedObjects := anObject
]

{ #category : #requests }
SeamlessNetwork >> environmentAt: anAddress [ 

	| remotePeer |
	remotePeer := self remotePeerAt: anAddress.
	^remotePeer remoteEnvironment
]

{ #category : #operations }
SeamlessNetwork >> identifyLocalPeerOn: aConnection [

	| context |
	context := aConnection createIdentificationContext.

	^context sendRequest: (SeamlessPeerIdentificationRequest peerId: self localPeerId).
	
]

{ #category : #initialization }
SeamlessNetwork >> initialize [
	super initialize.
	
	distributedObjects := SeamlessDistributedObjects over: self.
	transferStrategies := SortedCollection sortBlock: [:a :b | a priority >= b priority].
	transport := SeamlessObjectTransporter default
]

{ #category : #factory }
SeamlessNetwork >> newRemotePeer [ 
	^SeamlessRemotePeer inside: self
]

{ #category : #accessing }
SeamlessNetwork >> objectFor: aSeamlessObjectReference [

	^distributedObjects 
		at: aSeamlessObjectReference
		ifAbsentUseProxy: [ aSeamlessObjectReference createProxy]
]

{ #category : #accessing }
SeamlessNetwork >> objectFor: aSeamlessObjectReference ifNotNew: presentBlock [

	^distributedObjects 
		at: aSeamlessObjectReference
		ifPresent: presentBlock
		ifAbsentUseProxy: [ aSeamlessObjectReference createProxy]
]

{ #category : #operations }
SeamlessNetwork >> process: aSeamlessRequest receivedFrom: aRemotePeer [
	aSeamlessRequest executeFor: aRemotePeer
]

{ #category : #operations }
SeamlessNetwork >> receiveIncomingDataPacketFrom: aRemotePeer by: aBasysConnection [

	| transporter |
	transporter := transport newTransporterFor: self toTransferBy: aRemotePeer.
	
	^transporter receiveObjectBy: aBasysConnection
]

{ #category : #accessing }
SeamlessNetwork >> referenceFor: anObject [

	^self referenceFor: anObject ifNewUse: [ anObject createSeamlessReference]
]

{ #category : #accessing }
SeamlessNetwork >> referenceFor: anObject ifNewUse: refCreationBlock [

	^distributedObjects referenceFor: anObject ifNewUse: refCreationBlock
]

{ #category : #accessing }
SeamlessNetwork >> removeDistributedObject: anObject [

	distributedObjects remove: anObject
]

{ #category : #accessing }
SeamlessNetwork >> removeRemotePeer: aRemotePeer [
	super removeRemotePeer: aRemotePeer.
	
	distributedObjects removeObjectsDistributedBy: aRemotePeer.
	peerRegistry isEmpty ifTrue: [ distributedObjects clear ]
]

{ #category : #accessing }
SeamlessNetwork >> requestProcessingTimeout [
	^ requestProcessingTimeout ifNil: [self class defaultRequestProcessingTimeout]
]

{ #category : #accessing }
SeamlessNetwork >> requestProcessingTimeout: aDuration [
	requestProcessingTimeout := aDuration
]

{ #category : #operations }
SeamlessNetwork >> sendDataPacket: aSeamlessRequest by: aBasysConnection [

	| transporter |
	transporter := transport newTransporterFor: self toTransferBy: aBasysConnection remotePeer.
	
	transporter sendObject: aSeamlessRequest by: aBasysConnection
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByDeepCopy: objectsCriteria [

	self addTransferStrategy: (SeamlessTransferByDeepCopyStrategy for: objectsCriteria)
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByDefaultStrategy: objectsCriteria [

	self addTransferStrategy: (SeamlessDefaultTransferStrategy for: objectsCriteria)
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByDefaultStrategy: objectsCriteria priority: anInteger [

	self
		addTransferStrategy: (SeamlessDefaultTransferStrategy for: objectsCriteria)
		priority: anInteger
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByReference: objectsCriteria [

	self addTransferStrategy: (SeamlessTransferByReferenceStrategy for: objectsCriteria)
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByReference: objectsCriteria withCacheFor: selectors [

	self addTransferStrategy: (
		SeamlessTransferByReferenceStrategy for: objectsCriteria withCacheFor: selectors)
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByReferencedCopy: objectsCriteria [

	self addTransferStrategy: (SeamlessTransferByReferencedCopyStrategy for: objectsCriteria)
]

{ #category : #'transfer strategies' }
SeamlessNetwork >> transferByValue: objectsCriteria [

	self addTransferStrategy: (SeamlessTransferByValueStrategy for: objectsCriteria)
]

{ #category : #accessing }
SeamlessNetwork >> transferStrategies [
	^ transferStrategies
]

{ #category : #accessing }
SeamlessNetwork >> transferStrategies: anObject [
	transferStrategies := anObject
]

{ #category : #accessing }
SeamlessNetwork >> transferStrategyFor: anObject [

	anObject isOnlyDefaultTransferStrategyAllowed ifTrue: [ ^anObject seamlessDefaultTransferStrategy ].
	
	^transferStrategies detect: [ :each | each isAppliedTo: anObject ] ifNone: [ anObject seamlessDefaultTransferStrategy ]
]

{ #category : #accessing }
SeamlessNetwork >> transport [
	^ transport
]

{ #category : #accessing }
SeamlessNetwork >> transport: anObject [
	transport := anObject
]
