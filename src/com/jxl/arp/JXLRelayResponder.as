/*
	JXLRelayResponder
    
	Strongly typed version of mx.rpc.Responder.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.rpc.Responder;
import mx.rpc.FaultEvent;
import mx.rpc.ResultEvent;

class com.jxl.arp.JXLRelayResponder extends Object implements Responder
{

   private var __obj:Object;
   private var __onFault:Function;
   private var __onResult:Function;

   function JXLRelayResponder( resp:Object, resultFunc:Function, faultFunc:Function )
   {
      super();
      __obj = resp;
      __onFault = faultFunc;
      __onResult = resultFunc;
   }

   function onFault( fault:FaultEvent ):Void
   {
      __onFault.call(__obj, fault);
   }

   function onResult( result:ResultEvent ):Void
   {
      __onResult.call(__obj, result);
   }
}