instance creation
for: criteria withCacheFor: selectors 
	^(self for: criteria) 
		cachedMessages: selectors