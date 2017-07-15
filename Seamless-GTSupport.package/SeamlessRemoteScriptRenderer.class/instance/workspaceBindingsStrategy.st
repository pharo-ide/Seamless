private
workspaceBindingsStrategy
	^ [ :currentBindings :aString :aTextModel | 
		self findCustomBindingFor: aString in: aTextModel doItReceiver existing: currentBindings ]