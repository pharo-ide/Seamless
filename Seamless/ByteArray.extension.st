Extension { #name : #ByteArray }

{ #category : #'*Seamless' }
ByteArray class >> definesWellKnownSeamlessClass [ 
	^true
]

{ #category : #'*Seamless' }
ByteArray >> prepareMethodTransferBy: anObjectTransporter [
	super prepareMethodTransferBy: anObjectTransporter.
	
	anObjectTransporter transferByValue: self
]
