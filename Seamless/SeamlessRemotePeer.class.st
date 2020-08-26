"
I represent a remote peer in SeamlessNetwork.

I extend a BasysRemotePeer with Seamless specific functionality:
- evaluate a block on remote side
"
Class {
	#name : #SeamlessRemotePeer,
	#superclass : #BasysRemotePeer,
	#category : #'Seamless-Core'
}

{ #category : #controlling }
SeamlessRemotePeer >> close [
	"This method is supposed to be used when you really want to close (destroy) the peer and release all resources independently if they are used anywhere in the network.
	Special request is sent here to remote side to notify it. Then local and remote sides will clean all related resources, close connections and clean distributed objects.
	At the end peer will be removed from the network. See super implementation for details"
	self isConnected ifFalse: [ ^super close ].
	
	[self sendDataPacket: SeamlessClosePeerRequest new]
			on: ConnectionTimedOut, BasysIdentificationFailed , BasysNoConnection 
			do: [ :err | ].
			
	super close
]

{ #category : #controlling }
SeamlessRemotePeer >> closeByRemoteSide [

	super close
]

{ #category : #controlling }
SeamlessRemotePeer >> createResultDeliveryForRequests [

	^network createDeliveryForResultFrom: self
]

{ #category : #controlling }
SeamlessRemotePeer >> createSyncRequestContext [

	^SeamlessSyncRequestContext receiverPeer: self
]

{ #category : #requests }
SeamlessRemotePeer >> evaluate: aBlock [

	^self createSyncRequestContext sendRequest: (SeamlessBlockEvaluationRequest with: aBlock)
]

{ #category : #requests }
SeamlessRemotePeer >> evaluateAsync: aBlock [

	self sendDataPacket: (SeamlessBlockEvaluationRequest with: aBlock)
]

{ #category : #requests }
SeamlessRemotePeer >> remoteEnvironment [

	^self createSyncRequestContext sendRequest: SeamlessGetEnvironmentRequest new
]
