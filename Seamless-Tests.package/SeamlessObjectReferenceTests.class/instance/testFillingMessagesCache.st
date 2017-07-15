tests
testFillingMessagesCache

	reference cacheMessage: #someMessage with: #result.
	 
	reference messagesCache should include: #result at: #someMessage