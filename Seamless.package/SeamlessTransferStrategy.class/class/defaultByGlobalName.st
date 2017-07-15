defaults
defaultByGlobalName
	^ DefaultByGlobalName ifNil: [ DefaultByGlobalName := SeamlessTransferByGlobalNameStrategy new ]