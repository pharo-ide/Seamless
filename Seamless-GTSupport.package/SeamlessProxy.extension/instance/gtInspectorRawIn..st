*Seamless-GTSupport
gtInspectorRawIn: composite
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: 10>
	<gtInspectorTag: #basic>
	| browsers |
	browsers := {
		SeamlessObjectVariablesBrowser from: self remotePeer.
		GTProtoObjectVariablesBrowser new title: 'Proxy'}.
	self isConnectedToRemotePeer ifFalse: [browsers := browsers reversed].
		
	browsers do: [ :each | composite custom: each ]