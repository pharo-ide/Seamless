operations
performAndCacheRemoteMessage: aMessageSend

	| result |
	messagesCache ifNotNil: [ 
		messagesCache at: aMessageSend selector ifPresent: [ :v | ^v ] ].
	
	result := self performRemoteMessageWithoutCache: aMessageSend.
	
	self cacheMessage: aMessageSend selector with: result.
	
	^result