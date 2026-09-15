Class {
	#name : 'SeamlessRemoteClassCompiler',
	#superclass : 'OpalCompiler',
	#category : 'Seamless-NewToolsSupport',
	#package : 'Seamless-NewToolsSupport'
}

{ #category : 'evaluation' }
SeamlessRemoteClassCompiler >> evaluate [
	"Compiles the sourceStream into a parse tree, then generates code into
	 a method. If aContext is not nil, the text can refer to temporaries in that
	 context (the Debugger uses this). If aRequestor is not nil, then it will receive
	 a notify:at: message before the attempt to evaluate is aborted. Finally, the 
	 compiled method is invoked from here via withArgs:executeMethod:, hence
	 the system no longer creates Doit method litter on errors."

	| value doItContext |
	self isScripting: true.
	doItContext := self requestor doItContext.
	
	compilationContext productionEnvironment: self class environment.
	value := [ self receiver withArgs: (doItContext ifNil: [ #() ] ifNotNil: [ {doItContext} ]) executeMethod: self compile]
		on: OCSyntaxErrorNotice 
		do: [ :exception | 
			self requestor
                ifNotNil: [
						self requestor 
							notify: exception errorMessage , ' ->'
							at: exception location
							in: exception errorCode.
                    self failBlock value ]
                ifNil: [ exception pass ]].
	self logged == true ifTrue: [
		self semanticScope announceDoItEvaluation: source by: self class codeSupportAnnouncer ].
	^ value
]
