I am root of request contexts which are used to send requests over network to receiver peer.

My subclasses should implement method #sendRequest: which will send given request to receiver remote peer.
Also they should implement return method without interaction with sender peer because sender in that case will be always remote peer which returned result by proxy request on their side. 

Public API and Key Messages

- sendRequest: aSeamlessRequest
- return: anObject
	should return anObject in context of local sender process.

    Instance Variables
	receiverPeer:		<BasysRemotePeer>