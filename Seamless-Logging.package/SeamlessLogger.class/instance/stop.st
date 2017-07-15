controlling
stop

	incomingLink ifNotNil: [ incomingLink uninstall ].
	outgoingLink ifNotNil: [ outgoingLink uninstall ].
	isRunning := false