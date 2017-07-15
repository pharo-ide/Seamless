tests
testShouldSaveTransferredResultBytes

	(context stub return: Any to: Any)
			will: [:result :peer | result transferredBytes: #resultBytes].
		
	request executeFor: Any.

	request resultBytes should be: #resultBytes