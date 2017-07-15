remote reflection
remotePrintString

	^self performRemoteMessage: (Message selector: #printString)