"
I am strategy which transfer objects as globally known name. I use SeamlessWellKnownObject for this purpose. It substitutes original object on transfer stream.

I have default instance:
	SeamlessTransferStrategy defaultByGlobalName
"
Class {
	#name : #SeamlessTransferByGlobalNameStrategy,
	#superclass : #SeamlessTransferStrategy,
	#category : 'Seamless-Transport'
}

{ #category : #operations }
SeamlessTransferByGlobalNameStrategy >> prepareTransferObjectFor: anObject by: anObjectTransporter [
	
	^SeamlessWellKnownObject named: anObject name
]
