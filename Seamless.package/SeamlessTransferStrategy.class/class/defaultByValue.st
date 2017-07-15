defaults
defaultByValue
	^ DefaultByValue ifNil: [ DefaultByValue := SeamlessTransferByValueStrategy new ]