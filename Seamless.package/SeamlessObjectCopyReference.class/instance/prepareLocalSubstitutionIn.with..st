transfer
prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization
	| representation |
	objectCopy := aTostMaterialization readNextObject.
	
	self == objectCopy ifFalse: [ 
		"It happens when Tost serialization substitutes object with another object 
		which reference original object itself. In this case on remote side materialized object 
		will reference itself. 
		Here it is ObjectCopyReference which references itself in objectCopy variable. 
		So we dont need to visit objectCopy because we already here and it will broke protocol.
		In future we need to support correct serialization of such substitutions. 
		So inside substitution subgraph original object will be serialized without substitution. 
		It also will allow automatic synchronization of object state on client 
		when same object will be received from server few times".
		aTostMaterialization atNextStepProcess: objectCopy].		
	
	representation := aSeamlessNetwork objectFor: self.	
			
	^representation