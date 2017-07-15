*Seamless-GTSupport
gtConstructDebuggerInspectorIn: composite for: aDebugger
	
	^composite custom: ((GTDebuggerInspector new  
		debugger: aDebugger;
		notifyPaneRemoved: true;
		showFirst: [ :a | a custom: (SeamlessDebuggerVariablesBrowser new 
			debugger: aDebugger;
			title: 'Variables';
			startOn: self)];
		yourself) 
			startOn: self)