Class {
	#name : #SeamlessGetEnvironmentRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessGetEnvironmentRequestTests >> requestClass [
	^SeamlessGetEnvironmentRequest
]

{ #category : #tests }
SeamlessGetEnvironmentRequestTests >> testExecution [

	[
		[request executeFor: #senderPeer]
			should strictly satisfy: 
		[context returnValue: Smalltalk to: #senderPeer]
	] runWithMocks 
]
