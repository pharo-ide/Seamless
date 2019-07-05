Extension { #name : #Context }

{ #category : #'*Seamless-Pharo5Support' }
Context >> cannotReturn: result [
	closureOrNil ifNotNil: [ ^ self cannotReturn: result to: self home ].
	Processor activeProcess 
		debug: thisContext 
		title: 'computation has been terminated'
	
]
