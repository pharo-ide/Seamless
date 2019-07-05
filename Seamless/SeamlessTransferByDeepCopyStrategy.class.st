"
I am strategy which transfer objects as deep copy. 

I have default instance:
	SeamlessTransferStrategy defaultByDeepCopy
"
Class {
	#name : #SeamlessTransferByDeepCopyStrategy,
	#superclass : #SeamlessTransferStrategy,
	#category : 'Seamless-Transport'
}

{ #category : #operations }
SeamlessTransferByDeepCopyStrategy >> prepareTransferObjectFor: anObject by: anObjectTransporter [

	anObjectTransporter transferByDeepCopy: anObject.
	
	^anObject prepareValueForTransferBy: anObjectTransporter
]
