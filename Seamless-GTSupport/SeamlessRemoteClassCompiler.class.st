Class {
	#name : #SeamlessRemoteClassCompiler,
	#superclass : #OpalCompiler,
	#category : #'Seamless-GTSupport'
}

{ #category : #evaluation }
SeamlessRemoteClassCompiler >> evaluate [
	"Compiles the sourceStream into a parse tree, then generates code into
	 a method. If aContext is not nil, the text can refer to temporaries in that
	 context (the Debugger uses this). If aRequestor is not nil, then it will receive
	 a notify:at: message before the attempt to evaluate is aborted. Finally, the 
	 compiled method is invoked from here via withArgs:executeMethod:, hence
	 the system no longer creates Doit method litter on errors."

	| value |
	self noPattern: true.
	self getSourceFromRequestorSelection.
	
	self class: (context 
				ifNil: [ receiver remoteClass ]
				ifNotNil: [ context compiledCode methodClass ]).
	
	compilationContext productionEnvironment: self class environment.
	value := [ receiver withArgs: (context ifNil: [ #() ] ifNotNil: [ {context} ]) executeMethod: self compileDoit]
		on: SyntaxErrorNotification 
		do: [ :exception | 
			self compilationContext requestor
                ifNotNil: [
						self compilationContext requestor 
							notify: exception errorMessage , ' ->'
							at: exception location
							in: exception errorCode.
                    self compilationContext failBlock value ]
                ifNil: [ exception pass ]].
	self logDoIt.
	^ value
]
