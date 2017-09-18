*Seamless-Pharo5Support
cannotReturn: result
	closureOrNil ifNotNil: [ ^ self cannotReturn: result to: self home ].
	Processor activeProcess 
		debug: thisContext 
		title: 'computation has been terminated'
	