Extension { #name : #BasysRemotePeer }

{ #category : #'*Seamless' }
BasysRemotePeer >> createResultDeliveryForRequests [

	^network createDeliveryForResultFrom: self
]

{ #category : #'*Seamless' }
BasysRemotePeer >> createSyncRequestContext [

	^SeamlessSyncRequestContext receiverPeer: self
]

{ #category : #'*Seamless' }
BasysRemotePeer >> destroy [
	"This methods are supposed to be used when you really want to destroy peer and release all resources without thinking that they can be in use somewhere in network.
	Special request is sent here to remote side to notify it. Then me and remote side will clean all related resources, close connections and clean distributed objects.
	Maybe it should be general #close method. But for now it is separate method (peer #close only close all connections but not cleanup any resources and not send any notification).
	At the end peer will be removed from network"
	[self sendDataPacket: SeamlessPeerDestroyedRequest new]
			on: ConnectionTimedOut, OPTimedOutError, BasysIdentificationFailed do: [ :err | ].
	network cleanDestroyedPeer: self
]

{ #category : #'*Seamless' }
BasysRemotePeer >> destroyedOnRemoteSide [

	network cleanDestroyedPeer: self
]

{ #category : #'*Seamless' }
BasysRemotePeer >> evaluate: aBlock [

	^self createSyncRequestContext sendRequest: (SeamlessBlockEvaluationRequest with: aBlock asLocalObject)
]

{ #category : #'*Seamless' }
BasysRemotePeer >> evaluateAsync: aBlock [

	self sendDataPacket: (SeamlessBlockEvaluationRequest with: aBlock)
]

{ #category : #'*Seamless' }
BasysRemotePeer >> remoteEnvironment [

	^self createSyncRequestContext sendRequest: SeamlessGetEnvironmentRequest new
]
