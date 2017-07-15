*Seamless
tryWriteTransferObjectFor: anObject format: formatId

	| transferObject |
	transferObject := transporter prepareTransferObjectFor: anObject with: self.
	transferObject == anObject ifTrue: [ ^false ].
	
	self writeSubstitution: transferObject for: anObject format: formatId.
	^true