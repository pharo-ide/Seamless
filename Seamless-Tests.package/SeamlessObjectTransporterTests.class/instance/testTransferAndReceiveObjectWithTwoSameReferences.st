tests
testTransferAndReceiveObjectWithTwoSameReferences

	| transferedObject |
	
	network transferByReference: (Identical to: #value).
	network transferByValue: (Instance of: Array).
	transporter sendObject: (SeamlessRequestStub with: {#value. #value}) by: connection.
	transferedObject := transporter receiveObjectBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should equal: {#value. #value}