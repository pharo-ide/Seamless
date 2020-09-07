"
I represent proxy for remote contexts of received requests.
On local side requests contain SeamlessRequestSendingContext. This contexts can be transfered as reference to remote side. And remote side uses me as proxy for such references.
As proxy I can resend my messages to my remote sender peer.  I use it to implement return method. I just send new SeamlessMessageSendRequest with me as receiver of #return: message
"
Class {
	#name : #SeamlessRemoteContext,
	#superclass : #SeamlessRequestContext,
	#category : 'Seamless-Requests'
}

{ #category : #operations }
SeamlessRemoteContext >> return: aSeamlessRequestResult to: senderPeer [
	
	| deliveryRequest |
	deliveryRequest := SeamlessDeliverResultRequest result: aSeamlessRequestResult to: self.
	senderPeer trySendObjectIfConnected: deliveryRequest.		
	senderPeer network removeDistributedObject: self
]
