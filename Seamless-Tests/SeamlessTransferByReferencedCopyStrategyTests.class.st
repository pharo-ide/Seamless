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

	| object transferObject newReference |
	object := 'object' copy.
	(transporter stub referenceFor: 'object' ifNewUse: Arg block) willReturn: #reference.
	
	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should be: #reference. 
	newReference := Arg block fromFirstCall value.
	newReference should beInstanceOf: SeamlessObjectCopyReference.
	newReference objectCopy should equal: object.
	newReference objectCopy should not be: object.
]
