remote reflection
remoteInstVarAt: index

	^self performRemoteMessage: (Message selector: #instVarAt: argument: index)