> _This work is no longer maintained, I don't write code in ABAP any longer. From what I can see, some inspiration was taken from this work which has superceded this [at this repo over here](https://github.com/xinitrc86/zthread) (though some credit might be missing :disappointed_relieved::wink:, however, at least their work is maintained and usable by the community which is great)_

# ABAP Parallel Objects
See documentation currently at SCN  
http://scn.sap.com/community/abap/blog/2013/07/16/parallel-abap-objects

Unfortunately dont have time yet to update the documentation here

# Install
Download the **PRC_Objects.nugg** and install using **ZSAPLINK**. If unsure how to do this please search for the info.

- Make sure you put install / create the objects into their own package then check that all the objects are activated else activate manually
- Ensure you read carefully and create the shared memory objects per the documentation above
- If you find the following functions are not copied in for some reason you can use the text files that are also located here:  
**ZPRC_RUN_ISOLATED_TASK**  
**ZPRC_RUN_MANAGED_TASK**  
**ZPRC_RUN_FUTURE_TASK**  

