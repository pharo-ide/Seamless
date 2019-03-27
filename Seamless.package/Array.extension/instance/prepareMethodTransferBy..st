*Seamless
prepareMethodTransferBy: anObjectTransporter
	super prepareMethodTransferBy: anObjectTransporter.
	
	"Literal array can be complex structure. So we should forcibly transfer it as a whole thing"
	anObjectTransporter transferByDeepCopy: self 