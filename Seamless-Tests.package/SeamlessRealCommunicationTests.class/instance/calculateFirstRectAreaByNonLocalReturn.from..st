helpers
calculateFirstRectAreaByNonLocalReturn: rectanglesArray from: remotePeer 

	| sendingContext |
	sendingContext := remotePeer createSyncRequestContext.
	
	^sendingContext sendMessage: (MessageSend 
			receiver: rectanglesArray selector: #do: arguments: {[ :each | ^each area ]})