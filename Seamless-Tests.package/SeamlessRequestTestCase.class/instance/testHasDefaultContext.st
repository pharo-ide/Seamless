tests
testHasDefaultContext

	request := self requestClass new.
	request context should be: SeamlessRequestContext default