execution
executeFor: senderPeer
	| result |	 
	[
		[result := SeamlessReturnValueResult with: valuable value.
		self returnResult: result to: senderPeer]	
			on: PrimitiveFailed do: [:primitiveFailure | self processPrimitiveFailure: primitiveFailure ]
	
	] on: Exception do: [ :err | 
		err handleSeamlessRequest: self receivedFrom: senderPeer ]