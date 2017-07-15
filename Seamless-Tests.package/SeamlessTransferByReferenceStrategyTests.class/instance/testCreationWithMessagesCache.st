tests
testCreationWithMessagesCache

	| selectors |
	selectors := #(someMessage).	
	strategy := SeamlessTransferByReferenceStrategy for: #criteria withCacheFor: selectors.
	
	strategy where criteria should be: #criteria.
	strategy where cachedMessages should be: selectors