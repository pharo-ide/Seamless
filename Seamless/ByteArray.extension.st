Extension { #name : #ByteArray }

{ #category : #'*Seamless' }
ByteArray class >> definesWellKnownSeamlessClass [ 
	^true
]

{ #category : #'*Seamless' }
ByteArray >> prepareMethodTransferBy: aSeamlessTransporter [
	super prepareMethodTransferBy: aSeamlessTransporter.
	
	aSeamlessTransporter transferByValue: self
]
