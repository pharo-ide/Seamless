"
I represent reference to distributed SeamlessRequestContext.
On remote side I represent it by SeamlessRemoteContext
"
Class {
	#name : #SeamlessRequestContextReference,
	#superclass : #SeamlessObjectReference,
	#category : 'Seamless-Core'
}

{ #category : #'proxy creation' }
SeamlessRequestContextReference >> createProxy [
	^SeamlessRemoteContext new
]

{ #category : #'travel guide support' }
SeamlessRequestContextReference >> hasRemoteProperties [ 
	^false
]
