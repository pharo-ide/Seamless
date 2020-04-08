Class {
	#name : #SeamlessRemoteClassCompiler,
	#superclass : #OpalCompiler,
	#category : #'Seamless-GTSupport'
}

{ #category : #evaluation }
SeamlessRemoteClassCompiler >> compilationContext [
	receiver isRemoteDoItReceiver ifFalse: [ ^super compilationContext].
	
	^ compilationContext ifNil: [ compilationContext := SeamlessRemoteClassCompilationContext on: receiver remoteClass ] 
]

{ #category : #evaluation }
SeamlessRemoteClassCompiler >> evaluate [

	| value selectedSource itsSelection itsSelectionString doItMethod |
	receiver isRemoteDoItReceiver 
		ifTrue: [compilationContext := SeamlessRemoteClassCompilationContext on: receiver remoteClass requestor: compilationContext requestor.
			compilationContext environment: receiver]
		ifFalse: [ self class: (context 
				ifNil: [ receiver remoteClass ]
				ifNotNil: [ context method methodClass ])].
	(compilationContext respondsTo: #productionEnvironment:) ifTrue: [ 
		"Compatibility with Pharo 8"
		compilationContext productionEnvironment: self class environment].
	
	self noPattern: true.
	selectedSource := ((self compilationContext requestor respondsTo: #selection)
		and: [ 
			(itsSelection := self compilationContext requestor selection) notNil
				and: [ (itsSelectionString := itsSelection asString) isEmptyOrNil not ] ])
		ifTrue: [ itsSelectionString ]
		ifFalse: [ source ].
	self source: selectedSource.
	doItMethod := self translate methodNode generateWithSource.
	
	value := receiver withArgs: (context ifNil: [ #() ] ifNotNil: [ {context} ]) executeMethod:  doItMethod.
	self compilationContext logged
		ifTrue: [ Smalltalk globals 
			at: #SystemAnnouncer 
			ifPresent: [ :sysAnn | 
				sysAnn uniqueInstance evaluated: selectedSource contents context: context ] ].
	^ value
]
