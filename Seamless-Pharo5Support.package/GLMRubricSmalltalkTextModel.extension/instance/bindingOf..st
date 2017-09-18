*Seamless-Pharo5Support
bindingOf: aSymbol

	^ self bindingsStrategy cull: self variableBindings cull: aSymbol cull: self