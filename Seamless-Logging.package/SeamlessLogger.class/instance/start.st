controlling
start

	(SeamlessNetwork>>#sendDataPacket:by:) ast link: outgoingLink.		
	(SeamlessEvaluationRequest>>#executeFor:) ast link: incomingLink.
	
	isRunning := true