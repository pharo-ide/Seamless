"
I am request to execute remote message send (my valuable variable is MessageSend instance)
"
Class {
	#name : #SeamlessMessageSendRequest,
	#superclass : #SeamlessEvaluationRequest,
	#category : #'Seamless-Requests'
}

{ #category : #accessing }
SeamlessMessageSendRequest >> messageSend [
	^ valuable
]

{ #category : #printing }
SeamlessMessageSendRequest >> printMessageForLog [

	^String streamContents: [ :s | 
		s 
			nextPutAll: self receiver printForSeamlessLog;
			nextPutAll: '>>';
			nextPutAll: self selector
	]
]

{ #category : #printing }
SeamlessMessageSendRequest >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		print: valuable receiver;
		nextPutAll: '>>';
		print: valuable selector;		
		nextPut: $)
]

{ #category : #accessing }
SeamlessMessageSendRequest >> receiver [
	^self messageSend receiver
]

{ #category : #accessing }
SeamlessMessageSendRequest >> selector [
	^self messageSend selector
]
