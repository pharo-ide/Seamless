tests
testSettingResultTransferredBytes

	request result: SeamlessRequestResult new.
			
	request ownBytes: #bytes.
	
	request result transferredBytes should be: #bytes