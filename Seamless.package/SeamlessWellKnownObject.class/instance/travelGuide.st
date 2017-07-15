transfer
travelGuide
	"I override normal objects serialization to provide more compact binary format.
	So I implement custom writeTostBodyWith: method instead of walking by my state by travel guide"
	^ EmptyObjectTravelGuide 