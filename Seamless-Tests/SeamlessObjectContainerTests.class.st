Class {
	#name : #SeamlessObjectContainerTests,
	#superclass : #TestCase,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessObjectContainerTests >> testShouldAllowOnlyDefaultTransferStrategy [
	
	| container |
	container := SeamlessObjectValueContainer with: Any.
		
	container should be isOnlyDefaultTransferStrategyAllowed 
]

{ #category : #tests }
SeamlessObjectContainerTests >> testValueTransferPreparation [
	| container transporter |
	
	transporter := Mock new. 
	container := SeamlessObjectValueContainer with: #object.
		
	container prepareValueTransferBy: transporter.

	transporter should receive transferByValue: #object 
]
