*Seamless-Tests
testCreationSyncRequestContext

	| context |
	context := peer createSyncRequestContext.

	context should beInstanceOf: SeamlessSyncRequestContext.
	context receiverPeer should be: peer.
	context senderProcess should be: Processor activeProcess