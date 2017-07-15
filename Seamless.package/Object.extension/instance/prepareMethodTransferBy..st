*Seamless
prepareMethodTransferBy: anObjectTransporter
	"this method called for each method literal when method is going to be transferred by value.
	GlobalVariable in that case (like class reference) could override this method to manage transporter to transfer class as well known object"