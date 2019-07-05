Class {
	#name : #SeamlessTransferByReferenceStrategyTests,
	#superclass : #SeamlessTransferStrategyTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessTransferByReferenceStrategyTests >> setUp [
	super setUp.
	
	strategy := SeamlessTransferByReferenceStrategy new
]

{ #category : #tests }
SeamlessTransferByReferenceStrategyTests >> testCreationWithMessagesCache [

	| selectors |
	selectors := #(someMessage).	
	strategy := SeamlessTransferByReferenceStrategy for: #criteria withCacheFor: selectors.
	
	strategy where criteria should be: #criteria.
	strategy where cachedMessages should be: selectors
]

{ #category : #tests }
SeamlessTransferByReferenceStrategyTests >> testHasEmptyCachedMessagesByDefault [

	strategy where cachedMessages should be isEmpty
]

{ #category : #tests }
SeamlessTransferByReferenceStrategyTests >> testTransferPreparation [

	| transferObject |
	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should beReturnedFrom: [ transporter referenceFor: #object]
]

{ #category : #tests }
SeamlessTransferByReferenceStrategyTests >> testTransferPreparationShouldIgnoreCacheWhenReferenceIsRemote [

	| transferObject reference |
	reference := Mock new.
	(transporter stub referenceFor: #object) willReturn: reference.
	reference stub pointsToRemoteObject willReturn: true.

	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should be: reference
]

{ #category : #tests }
SeamlessTransferByReferenceStrategyTests >> testTransferPreparationWhenThereIsCachedMessages [

	| transferObject |
	strategy cachedMessages: #(#x #y).
	
	transferObject := strategy prepareTransferObjectFor: 10@20 by: transporter.
		
	transferObject should receive cacheMessage: #x with: 10.
	transferObject should receive cacheMessage: #y with: 20.
]
