operations
sendMessage: aMessageSend

	^self sendRequest: (SeamlessMessageSendRequest with: aMessageSend)