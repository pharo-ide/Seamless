tests
testReturningValueToLocalContext

	[:homeContext |	
		result := SeamlessNonLocalReturnResult with: #returnedValue homeContext: homeContext.
		[result returnValue] 
			should strictly satisfy: 
		[homeContext isSeamlessProxy willReturn: false. 
		homeContext return: #returnedValue ]
	] runWithMocks 