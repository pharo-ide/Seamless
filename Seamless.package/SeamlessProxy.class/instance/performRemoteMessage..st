remote reflection
performRemoteMessage: aMessage
	| messageSend |
	messageSend := 	MessageSend 
		receiver: self selector: aMessage selector arguments: aMessage arguments.
	
	^reference performRemoteMessage: messageSend