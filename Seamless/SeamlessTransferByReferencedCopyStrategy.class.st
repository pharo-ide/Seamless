"
I am strategy which transfer objects by referenced copy which means that remote side will contain copy of original object which will be connected by me to client side object
"
Class {
	#name : #SeamlessTransferByReferencedCopyStrategy,
	#superclass : #SeamlessTransferStrategy,
	#category : 'Seamless-Transport'
}

{ #category : #operations }
SeamlessTransferByReferencedCopyStrategy >> prepareTransferObjectFor: anObject by: anObjectTransporter [
	
	^anObjectTransporter referenceFor: anObject ifNewUse: [SeamlessObjectCopyReference to: anObject]
]
