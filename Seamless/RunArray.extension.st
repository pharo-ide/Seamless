Extension { #name : #RunArray }

{ #category : #'*Seamless' }
RunArray >> prepareValueTransferBy: anObjectTransporter [
	
	anObjectTransporter transferByValue: runs.
	anObjectTransporter transferByValue: values
]
