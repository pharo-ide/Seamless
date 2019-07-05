Extension { #name : #BlockClosure }

{ #category : #'*Seamless' }
BlockClosure class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
BlockClosure >> prepareValueTransferBy: anObjectTransporter [
	"For me transfer by values means that I could be evaluated directly on remote side"
	| mostOuterContext |
	
	mostOuterContext := self outerContext.
	[mostOuterContext closure notNil ] whileTrue: [ 
		anObjectTransporter transferByValue: mostOuterContext. 
		anObjectTransporter transferByValue: mostOuterContext closure.
		anObjectTransporter transferByValue: mostOuterContext method.
		mostOuterContext := mostOuterContext outerContext].
 
	mostOuterContext == self home ifFalse: [ self error: [ 'It should not happen' ] ].
	
	self hasMethodReturn 
		ifTrue: [ 
			anObjectTransporter transfer: mostOuterContext byReference: [ 
				SeamlessObjectCopyReference to: mostOuterContext ]] 
		ifFalse: [ anObjectTransporter transferByValue: mostOuterContext ].

	anObjectTransporter transferByValue: mostOuterContext method.
	"following commented line is required to evaluate blocks which are referenced inst vars of home receiver"
	"anObjectTransporter transferAsValue: mostOuterContext receiver"
]
