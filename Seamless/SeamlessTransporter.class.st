"
I am responsible for a transfer of Seamless requests between Seamless peers.

I extend TostTransporter by defining appropriate format for data exchange. Particulary I use SeamlessSubstitutionTostFormat  which implements object substitution according to their transfer strategies.

I have default instance on class side with prepared formats which describe well known objects and classes.
SeamlessNetwork uses my default instance as transprot to instantiate concrete transporter instances for particular remote peer. 

	transporter newTransporterFor: aSeamlessNetwork toTransferBy: aRemotePeer

SeamlessNetwork uses me to send and receive requests to and from connections:

	transporter sendRequest: anObject by: aBasysConnection
	transporter receiveRequestBy: aBasicConnection
	
I maintain objectSubstitutions dictionary to control how specific objects should be transferred. Transport strategies command me for this using following messages:

	 transporter transferByValue: anObject
	 transporter transfer: anObject byReference: creationBlock
	 transporter transfer: anObject byWellKnownObjectNamed:
	 transporter transferByDeepCopy: anObject

Last command activates deep copy transfer strategy for particular object. I keep them in separate dictionary objectsByDeepCopy. 
Idea that any reference from given object subgraph should be transferred by value which means that network strategies will not be used for them.

To read objects from connections substitutions are processed specifically. Loaded from stream objects are asked to create local substitutions which will be injected into materialized object graph instead of them.
 
	transporter prepareLocalSubstitutionOf: aLoadedObject with: aTostMaterialization.  

Alsow I implement optimized encoding for SeamlessObjectReference's to miminize size of objects on stream. When transferred references belongs to sender or receiver peers I encode them without ownerPeerId property.  I extract it value from participating peers. Look at methods:

- writeObjectReference: anObjectReference with: aTostSerialization
- readObjectReference: anObjectReference with: aTostMaterialization

Internal Representation and Key Implementation Points.

    Instance Variables
	network:		<SeamlessNetwork>
	remotePeer:		<BasysRemotePeer>
	objectSubstitutions:		<IdentityDictionary>
	objectsByDeepCopy:		<IdentityDictionary>
"
Class {
	#name : #SeamlessTransporter,
	#superclass : #TostTransporter,
	#instVars : [
		'network',
		'connection',
		'remotePeer',
		'objectSubstitutions',
		'objectsByDeepCopy'
	],
	#classInstVars : [
		'default'
	],
	#category : #'Seamless-Transport'
}

{ #category : #'instance creation' }
SeamlessTransporter class >> using: aSeamlessTransport onConnection: aBasysConnection [
	^self new
		transport: aSeamlessTransport;
		connection: aBasysConnection
]

{ #category : #sending }
SeamlessTransporter >> activateDeepCopyTransferIfNeeded [
	| activeNode |
	activeNode := self findActiveDeepCopyNodeAndIndex.
	activeNode ifNil: [  
		(self isDeepCopyTransferRequiredFor: traveler currentNode) ifFalse: [^false].
		self deepCopyTransferStartedFor: traveler currentNode at: traveler currentNodeIndex.
		^true ].
	
	(self processesObject: activeNode key asNodeAt: activeNode value)	ifTrue: [ ^true ].
	
	self deepCopyTransferFinishedFor: activeNode key.
	^false
]

{ #category : #sending }
SeamlessTransporter >> activateSubstitutionFor: anObject by: aBlock [

	| substitution |
	substitution := objectSubstitutions removeKey: anObject ifAbsent: [ ^self ].
	aBlock value: substitution
]

{ #category : #accessing }
SeamlessTransporter >> connection [
	^ connection
]

{ #category : #accessing }
SeamlessTransporter >> connection: aBasysConnection [
	connection := aBasysConnection.
	network := connection network.
	remotePeer := connection remotePeer
]

{ #category : #sending }
SeamlessTransporter >> deepCopyTransferFinishedFor: anObject [

	objectsByDeepCopy removeKey: anObject.
	objectsByDeepCopy ifEmpty: [ objectsByDeepCopy := nil ]
]

{ #category : #sending }
SeamlessTransporter >> deepCopyTransferStartedFor: anObject at: pathIndex [

	objectsByDeepCopy at: anObject put: pathIndex
]

{ #category : #sending }
SeamlessTransporter >> findActiveDeepCopyNodeAndIndex [
	
	objectsByDeepCopy associationsDo: [ :objectAndIndex |
		objectAndIndex value > 0 ifTrue: [ ^objectAndIndex  ]].
	
	^nil
]

{ #category : #testing }
SeamlessTransporter >> isDeepCopyTransferRequiredFor: anObject [

	^objectsByDeepCopy includesKey: anObject
]

{ #category : #api }
SeamlessTransporter >> materializeObject [
	| request in sizeSize size buffer compressionType compressionStream |
	in := connection inputStream.
	in binary.	
	compressionType := in next.
	sizeSize := in next.
	size := (in next: sizeSize) asInteger.
	buffer := in next: size.
	
	compressionType = 1 ifTrue: [ 
		compressionStream := GZipReadStream on: buffer readStream.
		buffer := compressionStream contents].
	
	transportStream := buffer readStream.
	request := super materializeObject.
	request ownBytes: size.	
	^request
]

{ #category : #accessing }
SeamlessTransporter >> network [
	^ network
]

{ #category : #accessing }
SeamlessTransporter >> network: anObject [
	network := anObject
]

{ #category : #receiving }
SeamlessTransporter >> prepareLocalSubstitutionOf: aLoadedObject with: aTostMaterialization [

	^aLoadedObject prepareLocalSubstitutionIn: network with: aTostMaterialization
]

{ #category : #controlling }
SeamlessTransporter >> prepareTransferObjectFor: anObject with: aTostSerialization [

	| strategy |
	self activateSubstitutionFor: anObject by: [ :s | ^s ].
	objectsByDeepCopy ifNotNil: [ 
		aTostSerialization activateDeepCopyTransferIfNeeded ifTrue: [
			^anObject prepareValueForTransferBy: self]].
	
	strategy := network transferStrategyFor: anObject.	
	^strategy prepareTransferObjectFor: anObject by: self
]

{ #category : #receiving }
SeamlessTransporter >> readObjectReference: anObjectReference with: aTostMaterialization [
	| type uuid |
	type := aTostMaterialization readByte.
	anObjectReference id: aTostMaterialization readPositiveInteger.
	anObjectReference senderPeer: remotePeer.	
	type = 0 ifTrue: [ "it is reference to my local object"
		^anObjectReference ownerPeerId: network localPeerId].
	type = 1 ifTrue: [ "it is reference owned by sender remote peer"
		remotePeer id ifNil: [self error: 'it should not happen: we receive reference with type 1 from sender which is not identifyed yet'].
		 ^anObjectReference ownerPeerId: remotePeer id].
	
	uuid := aTostMaterialization readBytes: 16 as: UUID.
	anObjectReference ownerPeerId: uuid
]

{ #category : #receiving }
SeamlessTransporter >> readSeamlessReference: anObjectReference [
	| type uuid |
	type := self readByte.
	anObjectReference id: self readPositiveInteger.
	anObjectReference senderPeer: remotePeer.	
	type = 0 ifTrue: [ "it is reference to my local object"
		^anObjectReference ownerPeerId: network localPeerId].
	type = 1 ifTrue: [ "it is reference owned by sender remote peer"
		remotePeer id ifNil: [self error: 'it should not happen: we receive reference with type 1 from sender which is not identifyed yet'].
		 ^anObjectReference ownerPeerId: remotePeer id].
	
	uuid := self readBytes: 16 as: UUID.
	^anObjectReference ownerPeerId: uuid
	
]

{ #category : #receiving }
SeamlessTransporter >> readSeamlessSubstitution [

	| loadedObjectIndex loadedObject localRepresentation |
	loadedObjectIndex := objectIndex.
	loadedObject := self readObject.

	localRepresentation := self prepareLocalSubstitutionOf: loadedObject with: self.
	localRepresentation == loadedObject ifTrue: [ ^loadedObject  ].
	
	processedObjects at: loadedObjectIndex put: localRepresentation.
	
	^localRepresentation
]

{ #category : #accessing }
SeamlessTransporter >> referenceFor: anObject [

	^self referenceFor: anObject ifNewUse: [anObject createSeamlessReference]
]

{ #category : #accessing }
SeamlessTransporter >> referenceFor: anObject ifNewUse: refCreationBlock [
	
	^network referenceFor: anObject ifNewUse: refCreationBlock.
]

{ #category : #accessing }
SeamlessTransporter >> remotePeer [
	^ remotePeer
]

{ #category : #accessing }
SeamlessTransporter >> remotePeer: anObject [
	remotePeer := anObject
]

{ #category : #api }
SeamlessTransporter >> serialize: aSeamlessRequest [
	| buffer bufferSizeBytes compressedBytes compressedStream compressionType |
	objectSubstitutions := IdentityDictionary new.	
	transportStream := (ByteArray new: 300) writeStream. 			
	super serialize: aSeamlessRequest.	
		
	buffer := transportStream contents.
	compressionType := 0.
	buffer size > 100 ifTrue: [ 
		compressionType := 1.
		compressedBytes := (ByteArray new: (buffer size min: 100)) writeStream.
		compressedStream := GZipWriteStream on: compressedBytes.
		compressedStream nextPutAll: buffer; close.
		buffer := compressedBytes contents].
	
	aSeamlessRequest ownBytes: buffer size.	
	bufferSizeBytes := buffer size asByteArray.
	bufferSizeBytes size > 255 ifTrue: [ ^self error: 'Cant serialize given object. It is too big' ].
	
	connection outputStream
		nextPut: compressionType;
		nextPut: bufferSizeBytes size;
		nextPutAll: bufferSizeBytes;
		nextPutAll: buffer;
		flush
]

{ #category : #controlling }
SeamlessTransporter >> transfer: anObject byReference: refCreationBlock [

	| reference |
	reference := self referenceFor: anObject ifNewUse: refCreationBlock.
	
	objectSubstitutions at: anObject put: reference.
]

{ #category : #controlling }
SeamlessTransporter >> transfer: anObject byReplacement: replacementObject [
	
	objectSubstitutions at: anObject put: replacementObject
]

{ #category : #controlling }
SeamlessTransporter >> transfer: anObject byWellKnownObjectNamed: globalName [

	objectSubstitutions at: anObject put: (SeamlessWellKnownObject named: globalName)
]

{ #category : #controlling }
SeamlessTransporter >> transferByDeepCopy: anObject [

	self transferByValue: anObject.
	
	objectsByDeepCopy ifNil: [ objectsByDeepCopy := IdentityDictionary new ].
	objectsByDeepCopy at: anObject put: 0
]

{ #category : #controlling }
SeamlessTransporter >> transferByReference: anObject [

	self transfer: anObject byReference: [anObject createSeamlessReference ]
]

{ #category : #controlling }
SeamlessTransporter >> transferByValue: anObject [

	| transferObject |
		
	transferObject := anObject prepareValueForTransferBy: self.
	
	objectSubstitutions at: anObject put: transferObject
]

{ #category : #testing }
SeamlessTransporter >> transfersIdentificationRequest [

	^traveler startNode class = SeamlessPeerIdentificationRequest 
]

{ #category : #sending }
SeamlessTransporter >> tryWriteTransferObjectFor: anObject format: formatId [

	| transferObject |
	transferObject := self prepareTransferObjectFor: anObject with: self.
	transferObject == anObject ifTrue: [ ^false ].
	
	self writeSubstitution: transferObject for: anObject format: formatId.
	^true
]

{ #category : #sending }
SeamlessTransporter >> writeObjectReference: anObjectReference with: aTostTransporter [
	| type |
	type := 2 "given reference is alien. It is not belongs to sender or receiver peers".
	
	aTostTransporter transfersIdentificationRequest ifFalse: [
		anObjectReference ownerPeerId = remotePeer id 
			ifTrue: [ type := 0 ] "reference belongs to receiver"
			ifFalse: [ anObjectReference ownerPeerId = network localPeerId 
							ifTrue: [ type := 1 ]] "reference from this local peer" .
	].
	aTostTransporter writeByte: type.
	aTostTransporter writePositiveInteger: anObjectReference id.
	
	type = 2 ifTrue: [ aTostTransporter writeBytes: anObjectReference ownerPeerId]
]

{ #category : #sending }
SeamlessTransporter >> writeSeamlessReference: anObjectReference [
	| type |
	type := 2 "given reference is alien. It is not belongs to sender or receiver peers".
	
	self transfersIdentificationRequest ifFalse: [
		anObjectReference ownerPeerId = remotePeer id 
			ifTrue: [ type := 0 ] "reference belongs to receiver"
			ifFalse: [ anObjectReference ownerPeerId = network localPeerId 
							ifTrue: [ type := 1 ]] "reference from this local peer" .
	].
	self writeByte: type.
	self writePositiveInteger: anObjectReference id.
	
	type = 2 ifTrue: [ self writeBytes: anObjectReference ownerPeerId]
]
