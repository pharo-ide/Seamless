*Seamless
evaluateAsync: aBlock

	self sendDataPacket: (SeamlessBlockEvaluationRequest with: aBlock)