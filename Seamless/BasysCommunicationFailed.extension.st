Extension { #name : #BasysCommunicationFailed }

{ #category : #'*Seamless' }
BasysCommunicationFailed >> handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer [

	self releaseConnectionAndPassError 
]
