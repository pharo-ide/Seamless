transfer strategies
transferByDeepCopy: objectsCriteria

	self addTransferStrategy: (SeamlessTransferByDeepCopyStrategy for: objectsCriteria)