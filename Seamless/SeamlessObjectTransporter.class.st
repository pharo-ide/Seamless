"
I am responsible for transfer objects between Seamless peers.

I extend TostTransporter by defining appropriate format for data exchange. Particulary I use SeamlessSubstitutionTostFormat  which implements object substitution according to their transfer strategies.

I have default instance on class side with prepared formats which describe well known objects and classes.
SeamlessNetwork uses my default instance as transprot to instantiate concrete transporter instances for particular remote peer. 

	transporter newTransporterFor: aSeamlessNetwork toTransferBy: aRemotePeer

SeamlessNetwork uses me to send and receive objects from connections:

	transporter sendObject: anObject by: aBasysConnection
	transporter receiveObjectBy: aBasicConnection
	
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
	#name : #SeamlessObjectTransporter,
	#superclass : #TostTransporter,
	#instVars : [
		'network',
		'remotePeer',
		'objectSubstitutions',
		'objectsByDeepCopy'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Seamless-Transport'
}

{ #category : #default }
SeamlessObjectTransporter class >> collectWellKnownClasses [

	| wellKnownClasses |
	wellKnownClasses := (SortedCollection new: 255) sortBlock: [:a :b | a name < b name].
	Object allSubclassesDo: [:each |
		each isWellKnownSeamlessClass ifTrue: [ wellKnownClasses add: each ]].

	^wellKnownClasses asArray
]

{ #category : #default }
SeamlessObjectTransporter class >> collectWellKnownObjects [

	^TostWellKnownObjectFormat default objects, 
		#(name printString asString class printOn: at: at:put: size do: select: collect: reject:
		instVarAt: instVarAt:put: value value: valueWithArguments: 
		selector methodClass isTestMethod argumentNames
		receiver method methodClass methodSelector isBlockContext home tempNames isDead sender debuggerMap outerContext outerMostContext closure
		allInstVarNames allSlots) asSet asArray
]

{ #category : #default }
SeamlessObjectTransporter class >> createDefault [

	^default := self new 
		formats: { 
			TostWellKnownObjectFormat on: self collectWellKnownObjects.
			TostDuplicatedObjectFormat new. 
			SeamlessSubstitutionTostFormat new.
			TostNewObjectOfWellKnownClassFormat on: self collectWellKnownClasses.	
			TostNewObjectOfDuplicatedClassFormat new. 
			TostNewObjectOfNewClassFormat new }
]

{ #category : #default }
SeamlessObjectTransporter class >> default [
	^default ifNil: [self createDefault]
]

{ #category : #'instance creation' }
SeamlessObjectTransporter class >> forTransferOver: aSeamlessNetwork by: aRemotePeer [
	^self new
		network: aSeamlessNetwork;
		remotePeer: aRemotePeer
]

{ #category : #default }
SeamlessObjectTransporter class >> resetDefault [

	^default := nil
]

{ #category : #'sending-private' }
SeamlessObjectTransporter >> activateSubstitutionFor: anObject by: aBlock [

	| substitution |
	substitution := objectSubstitutions removeKey: anObject ifAbsent: [ ^self ].
	aBlock value: substitution
]

{ #category : #'sending-deep copy' }
SeamlessObjectTransporter >> deepCopyTransferFinishedFor: anObject [

	objectsByDeepCopy removeKey: anObject.
	objectsByDeepCopy ifEmpty: [ objectsByDeepCopy := nil ]
]

{ #category : #'sending-deep copy' }
SeamlessObjectTransporter >> deepCopyTransferStartedFor: anObject at: pathIndex [

	objectsByDeepCopy at: anObject put: pathIndex
]

{ #category : #'sending-deep copy' }
SeamlessObjectTransporter >> findActiveDeepCopyNodeAndIndex [
	
	objectsByDeepCopy associationsDo: [ :objectAndIndex |
		objectAndIndex value > 0 ifTrue: [ ^objectAndIndex  ]].
	
	^nil
]

{ #category : #'sending-deep copy' }
SeamlessObjectTransporter >> isDeepCopyTransferRequiredFor: anObject [

	^objectsByDeepCopy includesKey: anObject
]

{ #category : #accessing }
SeamlessObjectTransporter >> network [
	^ network
]

{ #category : #accessing }
SeamlessObjectTransporter >> network: anObject [
	network := anObject
]

{ #category : #factory }
SeamlessObjectTransporter >> newTransporterFor: aSeamlessNetwork toTransferBy: aRemotePeer [

	| transporter |
	transporter := self class forTransferOver: aSeamlessNetwork by: aRemotePeer.
	transporter preparedFormats: formats.
	^transporter
]

{ #category : #receiving }
SeamlessObjectTransporter >> prepareLocalSubstitutionOf: aLoadedObject with: aTostMaterialization [

	^aLoadedObject prepareLocalSubstitutionIn: network with: aTostMaterialization
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> prepareTransferObjectFor: anObject with: aTostSerialization [

	| strategy |
	self activateSubstitutionFor: anObject by: [ :s | ^s ].
	objectsByDeepCopy ifNotNil: [ 
		aTostSerialization activateDeepCopyTransferIfNeeded ifTrue: [
			^anObject prepareValueForTransferBy: self]].
	
	strategy := network transferStrategyFor: anObject.	
	^strategy prepareTransferObjectFor: anObject by: self
]

{ #category : #'serialize/materialize' }
SeamlessObjectTransporter >> readObjectReference: anObjectReference with: aTostMaterialization [
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

{ #category : #api }
SeamlessObjectTransporter >> receiveObjectBy: aBasysConnection [
	| object in sizeSize size buffer compressionType compressionStream |
	in := aBasysConnection inputStream.
	in binary.
	
	compressionType := in next.
	sizeSize := in next.
	size := (in next: sizeSize) asInteger.
	buffer := in next: size.
	
	compressionType = 1 ifTrue: [ 
		compressionStream := GZipReadStream on: buffer readStream.
		buffer := compressionStream contents].
	
	object := self receiveObjectBy: buffer readStream.	
	object ownBytes: size.
	
	^object
]

{ #category : #accessing }
SeamlessObjectTransporter >> referenceFor: anObject [

	^self referenceFor: anObject ifNewUse: [anObject createSeamlessReference]
]

{ #category : #accessing }
SeamlessObjectTransporter >> referenceFor: anObject ifNewUse: refCreationBlock [
	
	^network referenceFor: anObject ifNewUse: refCreationBlock.
]

{ #category : #accessing }
SeamlessObjectTransporter >> remotePeer [
	^ remotePeer
]

{ #category : #accessing }
SeamlessObjectTransporter >> remotePeer: anObject [
	remotePeer := anObject
]

{ #category : #api }
SeamlessObjectTransporter >> sendObject: anObject by: aBasysConnection [

	| bufferStream buffer bufferSizeBytes compressedBytes compressedStream compressionType |
	objectSubstitutions := IdentityDictionary new.
	
	bufferStream := (ByteArray new: 300) writeStream. 			
	self sendObject: anObject to: bufferStream.	
	buffer := bufferStream contents.
	compressionType := 0.
	buffer size > 100 ifTrue: [ 
		compressionType := 1.
		compressedBytes := (ByteArray new: (buffer size min: 100)) writeStream.
		compressedStream := GZipWriteStream on: compressedBytes.
		compressedStream nextPutAll: buffer; close.
		buffer := compressedBytes contents].
	
	anObject ownBytes: buffer size.	
	bufferSizeBytes := buffer size asByteArray.
	bufferSizeBytes size > 255 ifTrue: [ ^self error: 'Cant serialize given object. It is too big' ].
	
	
	aBasysConnection outputStream
		nextPut: compressionType;
		nextPut: bufferSizeBytes size;
		nextPutAll: bufferSizeBytes;
		nextPutAll: buffer;
		flush
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> transfer: anObject byReference: refCreationBlock [

	| reference |
	reference := self referenceFor: anObject ifNewUse: refCreationBlock.
	
	objectSubstitutions at: anObject put: reference.
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> transfer: anObject byReplacement: replacementObject [
	
	objectSubstitutions at: anObject put: replacementObject
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> transfer: anObject byWellKnownObjectNamed: globalName [

	objectSubstitutions at: anObject put: (SeamlessWellKnownObject named: globalName)
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> transferByDeepCopy: anObject [

	self transferByValue: anObject.
	
	objectsByDeepCopy ifNil: [ objectsByDeepCopy := IdentityDictionary new ].
	objectsByDeepCopy at: anObject put: 0
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> transferByReference: anObject [

	self transfer: anObject byReference: [anObject createSeamlessReference ]
]

{ #category : #'sending-controlling' }
SeamlessObjectTransporter >> transferByValue: anObject [

	| transferObject |
		
	transferObject := anObject prepareValueForTransferBy: self.
	
	objectSubstitutions at: anObject put: transferObject
]

{ #category : #'serialize/materialize' }
SeamlessObjectTransporter >> writeObjectReference: anObjectReference with: aTostSerialization [
	| type |
	type := 2 "given reference is alien. It is not belongs to sender or receiver peers".
	
	aTostSerialization isTransferIdentificationRequest ifFalse: [
		anObjectReference ownerPeerId = remotePeer id 
			ifTrue: [ type := 0 ] "reference belongs to receiver"
			ifFalse: [ anObjectReference ownerPeerId = network localPeerId 
							ifTrue: [ type := 1 ]] "reference from this local peer" .
	].
	aTostSerialization writeByte: type.
	aTostSerialization writePositiveInteger: anObjectReference id.
	
	type = 2 ifTrue: [ aTostSerialization writeBytes: anObjectReference ownerPeerId]
]
