Extension { #name : #GlobalVariable }

{ #category : #'*Seamless' }
GlobalVariable class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
GlobalVariable >> prepareMethodTransferBy: aSeamlessTransporter [
	super prepareMethodTransferBy: aSeamlessTransporter.
	
	aSeamlessTransporter transfer: self value byWellKnownObjectNamed: self key
]
