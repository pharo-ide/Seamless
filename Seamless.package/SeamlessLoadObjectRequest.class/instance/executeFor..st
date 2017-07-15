execution
executeFor: senderPeer
"On sender peer my objectProxy is SeamlessProxy which points to requested remote object.
But on receiver peer my objectProxy will contain real distributed object. 
If it will contain proxy then real object should be loaded from another remote side"
	| referenceOrLoadedRemoteObject |
	referenceOrLoadedRemoteObject := objectProxy asLocalObject.
	
	context returnValue: referenceOrLoadedRemoteObject asTransferredByValue to: senderPeer