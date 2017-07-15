sending-deep copy
deepCopyTransferFinishedFor: anObject

	objectsByDeepCopy removeKey: anObject.
	objectsByDeepCopy ifEmpty: [ objectsByDeepCopy := nil ]