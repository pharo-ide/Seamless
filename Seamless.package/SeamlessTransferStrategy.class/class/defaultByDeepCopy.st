defaults
defaultByDeepCopy
	^ DefaultByDeepCopy ifNil: [ DefaultByDeepCopy := SeamlessTransferByDeepCopyStrategy new ]