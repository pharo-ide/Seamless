"
I am special request to transfer given objectProxy by value back to sender. I return it inside special SeamlessObjectValueContainer which forcibly transfer it content by value.

My senders put proxy inside my objectProxy variable which should be loaded by value from remote side.

On receiver peer my objectProxy will contain real distributed object. If it will contains proxy then real object will be loaded from another remote side.

I can be created by:
	SeamlessLoadObjectRequest proxy: aSeamlessProxy
But I am hidden inside smart proxy message:
	proxy asLocalObject

Internal Representation and Key Implementation Points.

    Instance Variables
	objectProxy:		<SeamlessProxy>
"
Class {
	#name : #SeamlessLoadObjectRequest,
	#superclass : #SeamlessRequest,
	#instVars : [
		'objectProxy'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessLoadObjectRequest class >> proxy: aSeamlessProxy [
	^self new 
		objectProxy: aSeamlessProxy
]

{ #category : #execution }
SeamlessLoadObjectRequest >> executeFor: senderPeer [
"On sender peer my objectProxy is SeamlessProxy which points to requested remote object.
But on receiver peer my objectProxy will contain real distributed object. 
If it will contain proxy then real object should be loaded from another remote side"
	| referenceOrLoadedRemoteObject |
	referenceOrLoadedRemoteObject := objectProxy asLocalObject.
	
	context returnValue: referenceOrLoadedRemoteObject asTransferredByValue to: senderPeer
]

{ #category : #accessing }
SeamlessLoadObjectRequest >> objectProxy [
	^ objectProxy
]

{ #category : #accessing }
SeamlessLoadObjectRequest >> objectProxy: anObject [
	objectProxy := anObject
]
