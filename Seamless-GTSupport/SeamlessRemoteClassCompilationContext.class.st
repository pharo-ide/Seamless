Class {
	#name : #SeamlessRemoteClassCompilationContext,
	#superclass : #CompilationContext,
	#category : 'Seamless-GTSupport'
}

{ #category : #'instance creation' }
SeamlessRemoteClassCompilationContext class >> on: remoteClass [
	| context |
	context := self new 
		class: remoteClass;		
		yourself.
	(OpalCompiler respondsTo: #defaultOptions) ifTrue: [
		"Compatibility with Pharo 6" 
		context parseOptions: OpalCompiler defaultOptions].
	^context
]

{ #category : #'instance creation' }
SeamlessRemoteClassCompilationContext class >> on: remoteClass requestor: aRequestor [
	
	^(self on: remoteClass) 
		requestor: aRequestor;
		yourself
]

{ #category : #accessing }
SeamlessRemoteClassCompilationContext >> scope [
	| newScope |
	class isSeamlessProxy ifFalse: [ ^super scope ].
	
	newScope := SeamlessRemoteClassScope for: class.
	requestor ifNotNil: [
		"the requestor is allowed to manage variables, the workspace is using it to auto-define vars"  
		newScope := (OCRequestorScope new 
			compilationContext: self;
			requestor: requestor) outerScope: newScope].
	^newScope
]
