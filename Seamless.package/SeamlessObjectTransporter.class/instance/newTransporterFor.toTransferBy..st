factory
newTransporterFor: aSeamlessNetwork toTransferBy: aRemotePeer

	| transporter |
	transporter := self class forTransferOver: aSeamlessNetwork by: aRemotePeer.
	transporter preparedFormats: formats.
	^transporter