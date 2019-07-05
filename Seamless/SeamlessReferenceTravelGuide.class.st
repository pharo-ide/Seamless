"
I am special mirror to discover SeamlessObjectReference extended remote properties. I ask them for differnet kind of remote properties to analize existing references.

Seamless references should define following protocol:

- hasRemoteProperties
- remotePropertiesSize
- remotePropertyAt: referenceIndex
- remotePropertyAt: referenceIndex put: anObject

I skip any other native references by inst vars. For example senderPeer variable will not be traversed. To support Tost serialization references encode internal state directly to stream in optimized way
"
Class {
	#name : #SeamlessReferenceTravelGuide,
	#superclass : #ObjectTravelGuide,
	#category : 'Seamless-Core'
}

{ #category : #navigation }
SeamlessReferenceTravelGuide class >> isNode: aSeamlessObjectReference hasLastReferenceAt: referenceIndex [
	^referenceIndex > 0 and: [aSeamlessObjectReference remotePropertiesSize = referenceIndex]
]

{ #category : #navigation }
SeamlessReferenceTravelGuide class >> isNodeEmpty: aSeamlessObjectReference [
	^aSeamlessObjectReference hasRemoteProperties not
]

{ #category : #navigation }
SeamlessReferenceTravelGuide class >> referenceOf: aSeamlessObjectReference atIndex: referenceIndex [
	^aSeamlessObjectReference remotePropertyAt: referenceIndex
]

{ #category : #operations }
SeamlessReferenceTravelGuide class >> replaceReferenceOf: aSeamlessObjectReference at: referenceIndex with: replacementObject [
	^aSeamlessObjectReference remotePropertyAt: referenceIndex put: replacementObject 
]
