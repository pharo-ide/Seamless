defaults
defaultByReferencedCopy
	^ DefaultByReferencedCopy ifNil: [ 
		DefaultByReferencedCopy := SeamlessTransferByReferencedCopyStrategy new ]