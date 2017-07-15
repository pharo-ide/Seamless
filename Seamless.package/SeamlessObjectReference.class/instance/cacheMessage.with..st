accessing
cacheMessage: selector with: resultObject

	messagesCache ifNil: [ messagesCache := SmallIdentityDictionary new].
	
	messagesCache at: selector put: resultObject	