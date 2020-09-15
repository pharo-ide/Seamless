"
I am request to notify remote side that sender peer was destroyed. So remote side could cleanup anything related to sender like distributed objects, remote peer instance and established connections.
"
Class {
	#name : #SeamlessClosePeerRequest,
	#superclass : #SeamlessRequest,
	#category : #'Seamless-Requests'
}

{ #category : #execution }
SeamlessClosePeerRequest >> executeFor: senderPeer [
	
	senderPeer closeByRemoteSide
]
