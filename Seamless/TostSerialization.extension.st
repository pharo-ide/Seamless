Extension { #name : #TostSerialization }

{ #category : #'*Seamless' }
TostSerialization >> activateDeepCopyTransferIfNeeded [
	| activeNode |
	activeNode := transporter findActiveDeepCopyNodeAndIndex.
	activeNode ifNil: [  
		(transporter isDeepCopyTransferRequiredFor: traveler currentNode) ifFalse: [^false].
		transporter deepCopyTransferStartedFor: traveler currentNode at: traveler currentNodeIndex.
		^true ].
	
	(self isProcessObject: activeNode key asNodeAt: activeNode value)	ifTrue: [ ^true ].
	
	transporter deepCopyTransferFinishedFor: activeNode key.
	^false
]

{ #category : #'*Seamless' }
TostSerialization >> isTransferIdentificationRequest [

	^traveler startNode class = SeamlessPeerIdentificationRequest 
]

{ #category : #'*Seamless' }
TostSerialization >> tryWriteTransferObjectFor: anObject format: formatId [

	| transferObject |
	transferObject := transporter prepareTransferObjectFor: anObject with: self.
	transferObject == anObject ifTrue: [ ^false ].
	
	self writeSubstitution: transferObject for: anObject format: formatId.
	^true
]

{ #category : #'*Seamless' }
TostSerialization >> writeSeamlessReference: anObjectReference [
	transporter writeObjectReference: anObjectReference with: self
]
