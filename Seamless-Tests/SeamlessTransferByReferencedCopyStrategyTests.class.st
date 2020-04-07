Class {
	#name : #SeamlessTransferByReferencedCopyStrategyTests,
	#superclass : #SeamlessTransferStrategyTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessTransferByReferencedCopyStrategyTests >> setUp [
	super setUp.
	
	strategy := SeamlessTransferByReferencedCopyStrategy new
]

{ #category : #tests }
SeamlessTransferByReferencedCopyStrategyTests >> testTransferPreparation [

	| object transferObject |
	object := 'object' copy.
	(transporter stub referenceFor: 'object' ifNewUse: Arg block) willReturn: #reference.
	
	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should be: #reference. 
	Arg block where value should beInstanceOf: SeamlessObjectCopyReference.
	Arg block where value objectCopy should equal: object.
	Arg block where value objectCopy should not be: object.
]
