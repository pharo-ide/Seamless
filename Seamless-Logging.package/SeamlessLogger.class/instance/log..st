logging
log: aSeamlessRequest
	aSeamlessRequest class = SeamlessDeliverResultRequest ifTrue: [ ^self ].
	
	requests add: aSeamlessRequest.
	Transcript crShow: aSeamlessRequest printMessageForLog; flush.