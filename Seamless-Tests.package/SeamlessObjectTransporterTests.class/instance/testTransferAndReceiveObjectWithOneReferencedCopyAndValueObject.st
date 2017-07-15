tests
testTransferAndReceiveObjectWithOneReferencedCopyAndValueObject

	| transferedObject |
	
	network transferByReferencedCopy: (Identical to: #value).
	network transferByValue: (Instance of: Point).
	network transferByValue: (Instance of: Array).
	transporter sendObject: (SeamlessRequestStub with: {#value. 10@20}) by: connection.
	transferedObject := transporter receiveObjectBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should equal: { #value. 10@20 }