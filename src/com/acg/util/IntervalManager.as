/**
 * @usage:
   setting intervals
   
   var id1:Number = IntervalManager.setInterval(2, myFunction, 100, "myArg");
   var id2:Number = IntervalManager.setInterval(2, _root, "myFunction", 100, "myArg");
   var id3:Number = IntervalManager.setInterval(myFunction, 100, "myArg");

   var id4:Number = IntervalManager.setInterval(_root, "myFunction", 100, "myArg");

   clearing intervals
   IntervalManager.clearInterval(id1);
   IntervalManager.clearAllIntervals();
 */
 
class com.acg.util.IntervalManager
{
	private static var  intervals:Object = {};
	
    /**
     * @constructor IntervalManager
    */
    private function IntervalManager(Void)
    {
    }
    
    /**
     * @method createInterval
   	 * @return (Number) 
    */
    private static function createInterval():Number
    {
    	var id:Number = _global.setInterval.apply(_global.setInterval, arguments);
        intervals[id] = id;
		return id;
    }
    
    /**
     * @method setInterval
     * @return (Number)
    */
    public static function setInterval(iCt, a, b, c, args):Number
    {
        var func:Function;
        var id;
        if(typeof iCt == "number"){
            if (typeof arguments[1] == "function"){
                args = arguments.slice(3);
                func = function(){
            		//myFunction.apply(thisObject, argumentsObject)
                    a.apply(null, args);
                    iCt--;
                    if (iCt == 0){
                        clearInterval(id);
                    }
                }
                id = createInterval(func, b, args);
            } else{
            	trace(typeof(a));
                args = arguments.slice(4);
                func = function(){
                    a[b].apply(a, args);
                    iCt--;
                    if (iCt == 0){
                        clearInterval(id);
                    }
                }
                id =  createInterval(func, c, args);
            }
        } else {
            id = createInterval.apply(IntervalManager, arguments);
        }
        return id;
    }
    
    /**
     * @method (PUBLIC STATIC): clearInterval
     * @param iId(Number)
     * @return (Void)
    */
    public static function clearInterval(iId:Number):Void
    {
        _global.clearInterval(iId);
        delete(intervals[iId]);
    }
    
    /**
     * @method clearAllIntervals
     * @param (Void)
     * @return (Void)
    */
    public static function clearAllIntervals():Void
    {
        var each;
        for (each in intervals){
                clearInterval(each);
        }
    }
}