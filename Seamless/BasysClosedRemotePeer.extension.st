Extension { #name : #BasysClosedRemotePeer }

{ #category : #'*Seamless' }
BasysClosedRemotePeer >> createSyncRequestContext [

	^BasysRemotePeerClosed signal
]

{ #category : #'*Seamless' }
BasysClosedRemotePeer >> destroy [

	network cleanDestroyedPeer: self
]
