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

	request executeFor: #senderPeer.
	
	context should receive returnValue: Smalltalk to: #senderPeer
]
