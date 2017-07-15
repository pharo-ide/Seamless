private
forkProcessingOf: aSeamlessRequest

	[ 
		[self performRequestSend: aSeamlessRequest] on: Error do: [ :err |
			self return:  (SeamlessThrowExceptionResult with: err) ]
	
	] forkAt: Processor activePriority named: 'Seamless request sending'