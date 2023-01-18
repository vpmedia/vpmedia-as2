/**
 * @author tPS
 * @version 1
 * 
 * Abstract Interface for 
 * Iterator-Implementation
 */
 
interface com.tPS.utils.Iterator {
	public function start();
	public function getCurrent():Object;
	public function iterate():Void;
	public function isLast():Boolean;	
}