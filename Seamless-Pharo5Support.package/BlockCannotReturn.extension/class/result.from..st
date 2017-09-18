*Seamless-Pharo5Support
result: anObject from: homeContext
 	^ self new
		result: anObject;
		deadHome: homeContext;
		signal