Extension { #name : #GlobalVariable }

{ #category : #'*Seamless' }
GlobalVariable class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
GlobalVariable >> prepareMethodTransferBy: anObjectTransporter [
	super prepareMethodTransferBy: anObjectTransporter.
	
	anObjectTransporter transfer: self value byWellKnownObjectNamed: self key
]
