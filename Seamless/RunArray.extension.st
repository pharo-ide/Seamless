Extension { #name : #RunArray }

{ #category : #'*Seamless' }
RunArray >> prepareValueTransferBy: aSeamlessTransporter [
	
	aSeamlessTransporter transferByValue: runs.
	aSeamlessTransporter transferByValue: values
]
