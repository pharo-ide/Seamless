"
I am request to execute block on remote side (my valuable instance is one args block closure)
"
Class {
	#name : #SeamlessBlockEvaluationRequest,
	#superclass : #SeamlessEvaluationRequest,
	#category : #'Seamless-Requests'
}

{ #category : #accessing }
SeamlessBlockEvaluationRequest >> block [
	^ valuable
]

{ #category : #printing }
SeamlessBlockEvaluationRequest >> printBlock [
	^self block sourceNode formattedCode
]

{ #category : #printing }
SeamlessBlockEvaluationRequest >> printMessageForLog [
	"Do not use #printBlock as it could lead to many message sends back to remote side"
	^'Remote block request' 
]

{ #category : #printing }
SeamlessBlockEvaluationRequest >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		print: self printBlock;
		nextPut: $)
]
