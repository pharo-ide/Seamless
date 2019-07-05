"
I am standard local representation of remote objects.
I transparent proxy implemented by Ghost framework.
 
My behaviour delegates all messages to my reference object which resend all them to our remote peer. 

    Instance Variables
	reference:		<SeamlessObjectReference>
"
Class {
	#name : #SeamlessProxy,
	#superclass : #GHObjectGhost,
	#traits : 'GHTNotNilGhost + GHTIdentifiedGhost',
	#classTraits : 'GHTNotNilGhost classTrait + GHTIdentifiedGhost classTrait',
	#instVars : [
		'reference'
	],
	#category : 'Seamless-Proxy'
}

{ #category : #'instance creation' }
SeamlessProxy class >> for: aSeamlessObjectReference [ 

	^self basicNew 
		seamlessReference: aSeamlessObjectReference 
]

{ #category : #operations }
SeamlessProxy >> asLocalDeepCopy [

	^reference loadDeepCopy: self
]

{ #category : #operations }
SeamlessProxy >> asLocalObject [

	^reference loadObject: self
]

{ #category : #transfer }
SeamlessProxy >> asTransferredByDeepCopy [ 
	^self
]

{ #category : #transfer }
SeamlessProxy >> asTransferredByValue [ 
	^self
]

{ #category : #'fuel support' }
SeamlessProxy >> fuelReplacement [
	^ reference
]

{ #category : #accessing }
SeamlessProxy >> ghostBehaviour [
	^SeamlessProxyBehaviour default
]

{ #category : #printing }
SeamlessProxy >> ghostPrintString [

	^(GHMetaMessages printObject: self), '(', reference id asString, ')'
]

{ #category : #testing }
SeamlessProxy >> isConnectedToRemotePeer [

	^reference isConnectedToRemotePeer
]

{ #category : #transfer }
SeamlessProxy >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #testing }
SeamlessProxy >> isSeamlessProxy [
	^true
]

{ #category : #testing }
SeamlessProxy >> isSeamlessReference [
	^false
]

{ #category : #testing }
SeamlessProxy >> isTostValueObject [
	^false
]

{ #category : #'remote reflection' }
SeamlessProxy >> nameForSeamlessStatistics [

	| remoteName |
	remoteName := self performAndCacheRemoteMessage: (Message selector: #nameForSeamlessStatistics).
	
	^'Remote ', remoteName
]

{ #category : #'remote reflection' }
SeamlessProxy >> performAndCacheRemoteMessage: aMessage [
	| messageSend |
	messageSend := 	MessageSend 
		receiver: self selector: aMessage selector arguments: aMessage arguments.
	
	^reference performAndCacheRemoteMessage: messageSend
]

{ #category : #'remote reflection' }
SeamlessProxy >> performRemoteMessage: aMessage [
	| messageSend |
	messageSend := 	MessageSend 
		receiver: self selector: aMessage selector arguments: aMessage arguments.
	
	^reference performRemoteMessage: messageSend
]

{ #category : #transfer }
SeamlessProxy >> prepareValueForTransferBy: anObjectTransporter [
 	"proxies are always transferred as reference"
	
	^reference
]

{ #category : #printing }
SeamlessProxy >> printForSeamlessLog [
	^reference printForSeamlessLog 
]

{ #category : #'remote reflection' }
SeamlessProxy >> remoteClass [

	^self performAndCacheRemoteMessage: (Message selector: #class)
]

{ #category : #'remote reflection' }
SeamlessProxy >> remoteInstVarAt: index [

	^self performRemoteMessage: (Message selector: #instVarAt: argument: index)
]

{ #category : #accessing }
SeamlessProxy >> remotePeer [
	^reference senderPeer
]

{ #category : #'remote reflection' }
SeamlessProxy >> remotePrintString [

	^self performRemoteMessage: (Message selector: #printString)
]

{ #category : #transfer }
SeamlessProxy >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]

{ #category : #accessing }
SeamlessProxy >> seamlessReference [
	^ reference
]

{ #category : #accessing }
SeamlessProxy >> seamlessReference: aSeamlessObjectReference [
	reference := aSeamlessObjectReference
]

{ #category : #accessing }
SeamlessProxy >> travelGuide [
	^EmptyObjectTravelGuide 
]
