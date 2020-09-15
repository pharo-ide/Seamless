Extension { #name : #Array }

{ #category : #'*Seamless' }
Array >> prepareMethodTransferBy: aSeamlessTransporter [
	super prepareMethodTransferBy: aSeamlessTransporter.
	
	"Literal array can be complex structure. So we should forcibly transfer it as a whole thing"
	aSeamlessTransporter transferByDeepCopy: self 
]
