defaults
defaultByReference
	^ DefaultByReference ifNil: [ DefaultByReference := SeamlessTransferByReferenceStrategy new ]