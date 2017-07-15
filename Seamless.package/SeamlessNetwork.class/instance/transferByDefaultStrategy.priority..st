transfer strategies
transferByDefaultStrategy: objectsCriteria priority: anInteger

	self
		addTransferStrategy: (SeamlessDefaultTransferStrategy for: objectsCriteria)
		priority: anInteger