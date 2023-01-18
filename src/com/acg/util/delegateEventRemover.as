/**
* 
* delegate한 이벤트 삭제하는 클래스 
* @author 홍준수
* @version 1.0
*/

class com.acg.util.delegateEventRemover
{ 
	
	/**
	* 이벤트를 삭제합니다.
	* 
	* @param	dispatcher delegate 타겟 
	* @param	evt 지울 이벤트 
	* @param	scop 타겟 스콥
	* @param	handler 지울 이벤트 핸들러
	*/
	
   public static function removeListener(dispatcher:Object, evt:String, scop:Object, handler:Function)
   { 
	trace("지움****************************************************************");
      var queueName:String = "__q_" + evt; 
      var leng:Number = dispatcher[queueName].length; 

      if (dispatcher[queueName] == undefined) 
	  { 
         return; 
      } 
	  else 
	  { 
         for (var i = 0; i < leng; i ++) 
		 { 
            if (dispatcher[queueName][i].target == scop && dispatcher[queueName][i].handler == handler) 
			{ 
               dispatcher[queueName].splice(i, 1); 
            } 
         } 
      } 
   } 

   public static function removeAllListener(dispatcher:Object, evt:String)
   { 
      var queueName:String = "__q_" + evt; 
      var leng:Number = dispatcher[queueName].length;       
      if (dispatcher[queueName] != undefined) { 
         delete dispatcher[queueName]; 
      } 
   } 

} 