"
I represent reference to distributed object inside Seamless network.
I transfered by value between Seamless peers.

""senderPeer"" variable contains BasysPeer instance from which I was received. It can be not peer which originally created me.
When network decides to transfer object by reference it creates me. It asks object #createSeamlessReference and then set up it variables. Objects can override this message to return different types of references. 

On local side my peer will be BasysLocalPeer instance . On remote side my peer will be BasysRemotePeer instance which sent me.
My peerId is always id of my owner peer which created me. So it can be not equal to ""peer id"" because I can be transfered between many network peers and ""peer"" variable will always contain sender peer instance.

My id is unique only inside my owner peer. But pair ""id and peerId"" is globally unique. I use it to implement equality and hash.

I can be asked for proxy representation of remote object which I reference to. By default it is classic transparent proxy (SeamlessProxy) which  delegates all message sends to me. And I resend all them to my remote peer. 
Subclasses can override this behaviour and implement more specific representations of remote objects.

Public API and Key Messages

- createProxy
- isSeamlessReference 
- performRemoteMessage: aMessage

    Instance Variables
	id:		<Object>
	ownerPeerId:		<Object>
	senderPeer:		<BasysPeer>
"
Class {
	#name : #SeamlessObjectReference,
	#superclass : #SeamlessTransferObject,
	#instVars : [
		'id',
		'messagesCache',
		'ownerPeerId',
		'senderPeer'
	],
	#category : 'Seamless-Core'
}

{ #category : #transfer }
SeamlessObjectReference class >> createTostInstanceWith: aSeamlessTransporter [
	| reference |
	reference := super createTostInstanceWith: aSeamlessTransporter.
	aSeamlessTransporter readObjectReference: reference.
	^reference.
]

{ #category : #'instance creation' }
SeamlessObjectReference class >> id: idObject peer: aBasysPeer [

	^(self 	id: idObject peerId: aBasysPeer id)
		senderPeer: aBasysPeer
]

{ #category : #'instance creation' }
SeamlessObjectReference class >> id: objectId peerId: peerId [

	^self new 
		id: objectId;
		ownerPeerId: peerId
]

{ #category : #comparing }
SeamlessObjectReference >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ id = anObject id
		and: [ ownerPeerId = anObject ownerPeerId ]
]

{ #category : #accessing }
SeamlessObjectReference >> cacheMessage: selector with: resultObject [

	messagesCache ifNil: [ messagesCache := SmallIdentityDictionary new].
	
	messagesCache at: selector put: resultObject	
]

{ #category : #'proxy creation' }
SeamlessObjectReference >> createProxy [
	^SeamlessProxy for: self
]

{ #category : #'travel guide support' }
SeamlessObjectReference >> hasRemoteProperties [ 
	^true
]

{ #category : #comparing }
SeamlessObjectReference >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ id hash bitXor: ownerPeerId hash
]

{ #category : #accessing }
SeamlessObjectReference >> id [
	^ id
]

{ #category : #accessing }
SeamlessObjectReference >> id: anObject [
	id := anObject
]

{ #category : #testing }
SeamlessObjectReference >> isConnectedToRemotePeer [

	^senderPeer isConnected
]

{ #category : #operations }
SeamlessObjectReference >> loadDeepCopy: aSeamlessProxy [

	| context |
	context := senderPeer createSyncRequestContext.
	
	^context sendRequest: (SeamlessLoadDeepCopyRequest proxy: aSeamlessProxy)
]

{ #category : #operations }
SeamlessObjectReference >> loadObject: aSeamlessProxy [

	| context |
	context := senderPeer createSyncRequestContext.
	
	^context sendRequest: (SeamlessLoadObjectRequest proxy: aSeamlessProxy)
]

{ #category : #accessing }
SeamlessObjectReference >> messagesCache [
	^ messagesCache
]

{ #category : #accessing }
SeamlessObjectReference >> messagesCache: anObject [
	messagesCache := anObject
]

{ #category : #accessing }
SeamlessObjectReference >> ownerPeerId [
	^ ownerPeerId
]

{ #category : #accessing }
SeamlessObjectReference >> ownerPeerId: anObject [
	ownerPeerId := anObject
]

{ #category : #operations }
SeamlessObjectReference >> performAndCacheRemoteMessage: aMessageSend [

	| result |
	messagesCache ifNotNil: [ 
		messagesCache at: aMessageSend selector ifPresent: [ :v | ^v ] ].
	
	result := self performRemoteMessageWithoutCache: aMessageSend.
	
	self cacheMessage: aMessageSend selector with: result.
	
	^result
]

{ #category : #operations }
SeamlessObjectReference >> performRemoteMessage: aMessageSend [

	messagesCache ifNotNil: [ 
		messagesCache at: aMessageSend selector ifPresent: [ :v | ^v ] ].
	
	^self performRemoteMessageWithoutCache: aMessageSend
]

{ #category : #operations }
SeamlessObjectReference >> performRemoteMessageWithoutCache: aMessageSend [

	|  context |
	
	context := senderPeer createSyncRequestContext.
	
	^context sendMessage: aMessageSend
]

{ #category : #testing }
SeamlessObjectReference >> pointsToRemoteObject [

	^senderPeer class ~~ BasysLocalPeer
]

{ #category : #transfer }
SeamlessObjectReference >> prepareLocalSubstitutionIn: aSeamlessNetwork with: aSeamlessTransporter [
	| localObject |
	super prepareLocalSubstitutionIn: aSeamlessNetwork with: aSeamlessTransporter.
	
	localObject := aSeamlessNetwork objectFor: self.
	aSeamlessTransporter skip: localObject.
	^localObject
]

{ #category : #printing }
SeamlessObjectReference >> printForSeamlessLog [

	^'ObjectReference(', id asString, ')' 
]

{ #category : #printing }
SeamlessObjectReference >> printOn: aStream [

	| referenceName |
	referenceName := 'an ObjectReference'.
	senderPeer ifNotNil: [ 
		referenceName := senderPeer class = BasysLocalPeer ifTrue: [ 'an LocalReference' ] ifFalse: [ 'an RemoteReference' ]].
	
	aStream << referenceName << $( << id asString << ')'.
]

{ #category : #'travel guide support' }
SeamlessObjectReference >> remotePropertiesSize [
	^1
]

{ #category : #'travel guide support' }
SeamlessObjectReference >> remotePropertyAt: propertyIndex [
	^messagesCache
]

{ #category : #'travel guide support' }
SeamlessObjectReference >> remotePropertyAt: propertyIndex put: newObject [
	messagesCache := newObject
]

{ #category : #accessing }
SeamlessObjectReference >> senderPeer [
	^ senderPeer
]

{ #category : #accessing }
SeamlessObjectReference >> senderPeer: anObject [
	senderPeer := anObject
]

{ #category : #'travel guide support' }
SeamlessObjectReference >> travelGuide [
	^SeamlessReferenceTravelGuide
]

{ #category : #transfer }
SeamlessObjectReference >> writeTostBodyWith: aSeamlessTransporter [

	aSeamlessTransporter writeObjectReference: self

]
