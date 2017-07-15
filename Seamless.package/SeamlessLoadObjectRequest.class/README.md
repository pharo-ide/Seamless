I am special request to transfer given objectProxy by value back to sender. I return it inside special SeamlessObjectValueContainer which forcibly transfer it content by value.

My senders put proxy inside my objectProxy variable which should be loaded by value from remote side.

On receiver peer my objectProxy will contain real distributed object. If it will contains proxy then real object will be loaded from another remote side.

I can be created by:
	SeamlessLoadObjectRequest proxy: aSeamlessProxy
But I am hidden inside smart proxy message:
	proxy asLocalObject

Internal Representation and Key Implementation Points.

    Instance Variables
	objectProxy:		<SeamlessProxy>