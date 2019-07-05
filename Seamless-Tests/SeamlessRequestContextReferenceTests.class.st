Class {
	#name : #SeamlessRequestContextReferenceTests,
	#superclass : #SeamlessObjectReferenceTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessRequestContextReferenceTests >> referenceClass [
	^SeamlessRequestContextReference
]

{ #category : #tests }
SeamlessRequestContextReferenceTests >> testProxyCreation [

	| proxy |
	proxy := reference createProxy.
	
	proxy should beInstanceOf: SeamlessRemoteContext
]
