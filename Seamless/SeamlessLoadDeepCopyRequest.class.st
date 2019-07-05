"
I am special kind of loading remote object request. 
I force deep copy loading strategy which will transfer full object graph by value to sender
"
Class {
	#name : #SeamlessLoadDeepCopyRequest,
	#superclass : #SeamlessLoadObjectRequest,
	#category : 'Seamless-Requests'
}

{ #category : #execution }
SeamlessLoadDeepCopyRequest >> executeFor: senderPeer [
"On sender peer my objectProxy is SeamlessProxy which points to requested remote object.
But on receiver peer my objectProxy will contain real distributed object. 
If it will contain proxy then real object should be loaded from another remote side"
	| referenceOrLoadedRemoteObject |
	referenceOrLoadedRemoteObject := objectProxy asLocalDeepCopy.
	
	context returnValue: referenceOrLoadedRemoteObject asTransferredByDeepCopy to: senderPeer
]
