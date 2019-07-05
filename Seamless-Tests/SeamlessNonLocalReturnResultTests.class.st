Class {
	#name : #SeamlessNonLocalReturnResultTests,
	#superclass : #SeamlessRequestResultTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessNonLocalReturnResultTests >> testReturningValueToLocalContext [

	[:homeContext |	
		result := SeamlessNonLocalReturnResult with: #returnedValue homeContext: homeContext.
		[result returnValue] 
			should strictly satisfy: 
		[homeContext isSeamlessProxy willReturn: false. 
		homeContext return: #returnedValue ]
	] runWithMocks 
]

{ #category : #tests }
SeamlessNonLocalReturnResultTests >> testReturningValueToRemoteContext [

	| homeContext |
	homeContext := Mock new.
	homeContext stub isSeamlessProxy willReturn: true.
	
	result := SeamlessNonLocalReturnResult with: #returnedValue homeContext: homeContext.
	[[result returnValue] on: BlockCannotReturn do: [:err | 
		err result should be: #returnedValue.
		err home should be: homeContext.
		err pass ] 
	] should raise: BlockCannotReturn 
]
