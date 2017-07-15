I am strategy to force objects to be transfered with default strategy which is defined by #seamlessDefaultTransferStrategy method. So I am not supposed to be returned from this method.  
I provide simple way how to tune  network level transfer configuration (network addTransferStrategy:). Network could override default strategy for set of objects but for some of them we still need default strategy. 
In that case this such subset of objects we could apply me as strategy.
