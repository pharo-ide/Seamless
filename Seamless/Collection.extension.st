Extension { #name : #Collection }

{ #category : #'*Seamless' }
Collection class >> definesWellKnownSeamlessClass [ 
	^{Set package. OrderedCollection package} includes: self package
]
