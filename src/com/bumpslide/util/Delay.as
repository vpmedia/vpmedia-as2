import com.bumpslide.util.Delegate;

/**
* Delayed Function call
* 
* Example Usage:
* @code{
*   var dc:Delay;
* 
*   function onRollOver() {
* 	  dc = Delay.call( this, showTooltip, 750, "Testing" );
* 
*     // OR  ... dc = new Delay( Delegate.create( this, showTooltip, "Testing"), 750
*   }
*  
*   function onRollOut() {
*     dc.cancel();
*   }
* }
* 
*/

class com.bumpslide.util.Delay {
	
	private var delayInt:Number = -1;
	private var delegate:Function;		
	
	static function call( scope:Object, func:Function, delayInMs:Number ) {
		var args:Array = [scope, func ].concat( arguments.slice(3) );		
		return new Delay( Delegate.create.apply( null,  args ), delayInMs );
	}
	
	function Delay( func:Function, delayInMs:Number ) {
		delegate = func;
		delayInt = _global.setTimeout( this, 'execute', delayInMs );
	}
	
	private function execute() {
		delegate.call( null );
	}
	
	public function cancel() {
		_global.clearTimeout( delayInt );
	}
}