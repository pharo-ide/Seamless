"
I am used as variable binding in remote playground. 
I hold playground variable value on client (at the side of playground).
When doIt/printIt is evaluated I compile store/read operations by delegating writing/reading to my state variable. When method is transferred from client to server my state is sent to server as value. But internally state points to me by proxy. 

1) When remote method performs read from me my state will ask my proxy to read variable value. It will perform remote message to me. If there is no connection with remote side then existing local value is used as result of read. 
Loaded value from client side updates local state on server side. 

2) When remote method performs write to me local value of variable is modified. And if there is connection with remote side then new value is sent to client using asyncronous send of #write: message. On client side write message modifies client value and updates my client state variable. When next doIt will be performed updated state will be transferred to server.

Internal Representation and Key Implementation Points.

    Instance Variables
	state:		<SeamlessLocalVariableState>
"
Class {
	#name : #SeamlessRemoteWorkspaceVariable,
	#superclass : #WorkspaceVariable,
	#instVars : [
		'state'
	],
	#category : #'Seamless-GTSupport'
}

{ #category : #'instance creation' }
SeamlessRemoteWorkspaceVariable class >> key: aKey [ 

	^self new
		 key: aKey
]

{ #category : #'code generation' }
SeamlessRemoteWorkspaceVariable >> emitStore: methodBuilder [

	| tempName |
	tempName := '0slotTempForStackManipulation'. 
	methodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop;
		pushLiteralVariable: #slot -> state;
		pushTemp: tempName;
		send: #write:
]

{ #category : #'code generation' }
SeamlessRemoteWorkspaceVariable >> emitValue: methodBuilder [

	methodBuilder 
		pushLiteralVariable: #slot -> state;
		send: #read
]

{ #category : #'code generation' }
SeamlessRemoteWorkspaceVariable >> initialize [
	super initialize.
	
	state := SeamlessLocalVariableState of: self
]

{ #category : #testing }
SeamlessRemoteWorkspaceVariable >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #accessing }
SeamlessRemoteWorkspaceVariable >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByReference 
]

{ #category : #'code generation' }
SeamlessRemoteWorkspaceVariable >> write: anObject [
	super write: anObject.
	state value: anObject.
	^anObject
]
