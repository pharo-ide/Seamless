sending-controlling
transferByValue: anObject

	| transferObject |
		
	transferObject := anObject prepareValueForTransferBy: self.
	
	objectSubstitutions at: anObject put: transferObject