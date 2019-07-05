Class {
	#name : #SeamlessMessageSendTests,
	#superclass : #TestCase,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessMessageSendTests >> testValueTransferPreparation [

	| messageSend transporter |
	
	transporter := Mock new. 
	messageSend := MessageSend receiver: #receiver selector: #selector arguments: #arguments.	
		
	messageSend prepareValueTransferBy: transporter.

	transporter should receive transferByValue: #arguments 
]
