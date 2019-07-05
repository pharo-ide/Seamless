"
I execute given valuable object (block or message sends) and return result to sender.
There are four cases:
	- evaluation completes successfully. I return SeamlessReturnValueResult with message answer.
	- evaluation signals exception. I return it as SeamlessThrowExceptionResult with SeamlessRemoteException which includes signalled exception info. 
	- evaluation attempts to execute non local return.  I return SeamlessNonLocalReturnResult with target home context and returned value. 
	- evaluation signals  Halt or Nortification. I pass it locally. They will not returned to sender.

Look it comments.

    Instance Variables
	evaluable:		<MessageSend or: BlockClosure>
"
Class {
	#name : #SeamlessEvaluationRequest,
	#superclass : #SeamlessRequest,
	#instVars : [
		'valuable'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessEvaluationRequest class >> with: aBlockOrMessageSend [
	^self new 
		valuable: aBlockOrMessageSend
]

{ #category : #execution }
SeamlessEvaluationRequest >> executeFor: senderPeer [
	| result |	 
	[
		[result := SeamlessReturnValueResult with: valuable value.
		self returnResult: result to: senderPeer]	
			on: PrimitiveFailed do: [:primitiveFailure | self processPrimitiveFailure: primitiveFailure ]
	
	] on: Exception do: [ :err | 
		err handleSeamlessRequest: self receivedFrom: senderPeer ]
]

{ #category : #accessing }
SeamlessEvaluationRequest >> prepareValueTransferBy: aSeamlessObjectTransporter [

	aSeamlessObjectTransporter transferByValue: valuable
]

{ #category : #execution }
SeamlessEvaluationRequest >> processMethodExecutePrimitiveFailure: aPrimitiveFailed [

	| args failedContext primitiveArguments result method |
	
	failedContext := aPrimitiveFailed signalerContext.
	[ failedContext selector == #withArgs:executeMethod: ] whileFalse: [ failedContext := failedContext sender ].

	args := failedContext tempAt: 1.
	method := failedContext tempAt: 2.
	args isSeamlessProxy | method isSeamlessProxy ifFalse: [ ^aPrimitiveFailed pass  ].

	primitiveArguments := failedContext arguments.
	primitiveArguments at: 1 put: args asLocalObject. 
	primitiveArguments at: 2 put: method asLocalObject. 
	
	result := failedContext receiver 
		perform: failedContext selector 
		withArguments: primitiveArguments.
	failedContext return: result
]

{ #category : #execution }
SeamlessEvaluationRequest >> processPerformPrimitiveFailure: aPrimitiveFailed [

	| args failedContext primitiveArguments result |

	failedContext := aPrimitiveFailed signalerContext.
	[ failedContext selector == #perform:withArguments:inSuperclass: ] whileFalse: [ failedContext := failedContext sender ].

	args := failedContext tempAt: 2.
	args isSeamlessProxy ifFalse: [ ^aPrimitiveFailed pass  ].

	primitiveArguments := failedContext arguments.
	primitiveArguments at: 2 put: args asLocalObject. 

	result := failedContext receiver 
		perform: failedContext selector 
		withArguments: primitiveArguments.
	failedContext return: result
]

{ #category : #execution }
SeamlessEvaluationRequest >> processPrimitiveFailure: aPrimitiveFailed [

	aPrimitiveFailed selector == #perform:withArguments:inSuperclass: 
		ifTrue: [ ^self processPerformPrimitiveFailure: aPrimitiveFailed].
	
	aPrimitiveFailed selector == #withArgs:executeMethod:
		ifTrue: [ ^self processMethodExecutePrimitiveFailure: aPrimitiveFailed].
	
	aPrimitiveFailed pass 
]

{ #category : #execution }
SeamlessEvaluationRequest >> returnResult: aSeamlessRequestResult to: senderPeer [

	context return: aSeamlessRequestResult to: senderPeer.
	
	resultBytes := aSeamlessRequestResult transferredBytes
]

{ #category : #accessing }
SeamlessEvaluationRequest >> valuable [
	^valuable
]

{ #category : #accessing }
SeamlessEvaluationRequest >> valuable: anObject [
	valuable := anObject
]
