*Seamless-GTSupport
gtDebuggerRawIn: composite
	<gtDebuggerPresentationOrder: 15>
	
	((SeamlessObjectVariablesBrowser from: self remotePeer) variablesIn: composite)
		title: 'Raw';
		send: #value.
			
	(GTProtoObjectVariablesBrowser new variablesIn: composite)
		title: 'Proxy';
		send: #value