"
I return remote Smalltalk instance to sender
"
Class {
	#name : #SeamlessGetEnvironmentRequest,
	#superclass : #SeamlessRequest,
	#category : 'Seamless-Requests'
}

{ #category : #execution }
SeamlessGetEnvironmentRequest >> executeFor: senderPeer [

	context returnValue: Smalltalk to: senderPeer
]
