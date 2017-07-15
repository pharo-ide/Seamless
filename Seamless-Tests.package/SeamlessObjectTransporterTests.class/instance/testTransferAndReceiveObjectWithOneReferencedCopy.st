tests
testTransferAndReceiveObjectWithOneReferencedCopy

	| transferedObject |
	
	network transferByReferencedCopy: (Identical to: #value).
	transporter sendObject: (SeamlessRequestStub with: #key -> #value) by: connection.
	transferedObject := transporter receiveObjectBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should beInstanceOf: Association.
	transferedObject content key should equal: #key.
	transferedObject content value should equal: #value