
/**
* 
* 키입력을 관할하는 클래스 
* 싱글턴으로 구현되어있습니다.
* 
* @author 홍준수
* @version 0.1
*/

import com.acg.util.Delegate;
import mx.events.EventDispatcher;

class com.acg.util.keyManager extends Key
{
	
	private static var _instance:keyManager;
	private static var keyObject:Object;
	
	public var addEventListener:Function;
	public var dispatchEvent:Function;
	
	public static var KEY_DOWN:String;
	
	/**
	* 
	* 생성자
	* 
	*/
	
	private function keyManager()
	{
		trace("생성");
		EventDispatcher.initialize(this);
		keyObject = new Object();
		keyObject.onKeyDown = Delegate.create( this , broadCastKeyDown ) 
		
		Key.addListener(keyObject);
	}
	
	/**
	* 
	* 인스턴스를 체크하고 없을시 생성하고 인스턴스를 리턴합니다.
	* 
	*/
	
	public static function getInstance():keyManager
	{
		if (!_instance)
		{
			_instance = new keyManager();
		}
		return _instance;
	}
	
	private function broadCastKeyDown()
	{
		dispatchEvent({type:KEY_DOWN , code:Key.getCode() });
	}
}