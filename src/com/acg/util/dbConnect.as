
import mx.events.EventDispatcher;
import com.acg.util.Delegate;

class com.acg.util.dbConnect
{
	private var eventSource		:Object;
	private var receiveVar		:LoadVars;
	private var loadVar			:LoadVars;
	private var sendUrl			:String;
	
	public static var LOAD_COMPLETE	:String		=	"onLoadComplete";
	public static var LOAD_ERROR	:String		=	"onLoadError";

	public function addEventListener(Event:String, handler:Function)
	{
		eventSource.addEventListener(Event, handler);
	}
	
	public function dispatchEvent(obj:Object) 
	{
		eventSource.dispatchEvent(obj);
	}
	
	public function dbConnect() 
	{
		eventSource = new Object();
		EventDispatcher.initialize(eventSource);
	}
	
	public function send(sendUrl:String , vars:Object)
	{
		this.sendUrl = sendUrl;
		loadVar = new LoadVars();
		for (var prop in vars) 
		{
			loadVar[prop] = vars[prop];
		}
		
		receiveVar = new LoadVars();
		receiveVar.onLoad = Delegate.create(this , loadOk);
		trace(receiveVar)
		trace(loadVar)
		try {
			loadVar.sendAndLoad(sendUrl , receiveVar , "POST");
		} catch (e:Error) {
			dispatchEvent({type:dbConnect.LOAD_ERROR , error:"에러메시지   :   경로가 없습니다."});
		} 
						_root.test.test.text = loadVar
				_root.test.test2.text = sendUrl
	}
	
	private function loadOk(s)
	{
		
		if (s) 	{
			_root.test.test3.text = "성공 = " + receiveVar
			dispatchEvent({type:dbConnect.LOAD_COMPLETE , dat:receiveVar });
		} else {
			dispatchEvent({type:dbConnect.LOAD_ERROR , error:"에러메시지   :   로딩이 실패했습니다."});
		}
	}
	
	public function del()
	{
		receiveVar.onLoad = null;
		loadVar = null;
		receiveVar = null;
		eventSource = null;
	}
}