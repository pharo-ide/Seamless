"
I represent some missing local object which should be there for received reference but it is not. It could happen when we clear distributed objects collection and then we receive request from remote side with some of removed objects. 
For exampe client has proxy and could send remote messages to it. But server clean all distributed objects. In that case on remote side this proxy will be presented by me.  And remote message send will be resulted as SeamlessReferencedObjectIsLost error.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	reference:		<SeamlessObjectReference>
"
Class {
	#name : #SeamlessMissingObject,
	#superclass : #SeamlessTransferObject,
	#instVars : [
		'reference'
	],
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessMissingObject class >> referencedBy: aSeamlessObjectReference [
	^self new 
		reference: aSeamlessObjectReference 
]

{ #category : #'messages processing' }
SeamlessMissingObject >> perform: aSelector [

	SeamlessReferencedObjectIsLost signal
]

{ #category : #'messages processing' }
SeamlessMissingObject >> perform: selector withArguments: arguments [

	SeamlessReferencedObjectIsLost signal
]

{ #category : #accessing }
SeamlessMissingObject >> reference [
	^ reference
]

{ #category : #accessing }
SeamlessMissingObject >> reference: anObject [
	reference := anObject
]
