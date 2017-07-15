transfer strategies
transferByReference: objectsCriteria withCacheFor: selectors

	self addTransferStrategy: (
		SeamlessTransferByReferenceStrategy for: objectsCriteria withCacheFor: selectors)