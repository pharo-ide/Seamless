Extension { #name : #BlockClosure }

{ #category : #'*Seamless' }
BlockClosure class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
BlockClosure >> prepareValueTransferBy: aSeamlessTransporter [
	"For me transfer by values means that I could be evaluated directly on remote side"
	| mostOuterContext |
	
	mostOuterContext := self outerContext.
	[mostOuterContext closure notNil ] whileTrue: [ 
		aSeamlessTransporter transferByValue: mostOuterContext. 
		aSeamlessTransporter transferByValue: mostOuterContext closure.
		aSeamlessTransporter transferByValue: mostOuterContext method.
		mostOuterContext := mostOuterContext outerContext].
 
	mostOuterContext == self home ifFalse: [ self error: [ 'It should not happen' ] ].
	
	self hasMethodReturn 
		ifTrue: [ 
			aSeamlessTransporter transfer: mostOuterContext byReference: [ 
				SeamlessObjectCopyReference to: mostOuterContext ]] 
		ifFalse: [ aSeamlessTransporter transferByValue: mostOuterContext ].

	aSeamlessTransporter transferByValue: mostOuterContext method.
	"following commented line is required to evaluate blocks which are referenced inst vars of home receiver"
	"anObjectTransporter transferAsValue: mostOuterContext receiver"
]
