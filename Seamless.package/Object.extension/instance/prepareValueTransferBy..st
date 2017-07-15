*Seamless
prepareValueTransferBy: aSeamlessObjectTransporter
	"By default transporter will send shallow copy of object to remote side.
	And all internal state will be transferred by their own transfer strategies.
	So we don't need to do anything here if we not have any internal state. 
	But if we have and we think that it is logical part of receiver value
	then we can mark this state to be transferred by value too: 
	
		aSeamlessObjectTransporter transferByValue: internalVariable 
	
	Look for example at OrderedCollection"