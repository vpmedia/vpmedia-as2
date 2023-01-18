import mx.utils.Delegate;
import net.manaca.lang.BObject;
import net.manaca.io.cookies.Cookies;
/**
 * 
 * @author Wersling
 * @version 1.0, 2005-10-23
 */
class net.manaca.io.conn.LocalConnectionEnt extends BObject{
	private var className : String = "net.manaca.io.conn.LocalConnectionEnt";
	//建立一个LocalConnection
	private var _LocalConnection : LocalConnection;
	//连接名称
	private var _connectName:String;
	//send
	private var _sendName:String;
	//是否建立连接
	private var _connected:Boolean;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function LocalConnectionEnt(__sendName:String,__connectName:String) {
		_LocalConnection = new LocalConnection();
		if(__sendName) sendName = __sendName;
		if(__connectName) {
			connectName = __connectName;
			//建立连接
			connect(connectName);
		}
	}
	/**
	 * 建立连接，用于接受信息
	 * @param connectionName 连接名称
	 * @return Boolean 如果在同一台客户端计算机上运行的其它进程都没有使用同一 connectionName 参数值发出过此命令，则为 true；否则为 false。
	 */
	public function connect(connectionName:String):Boolean
	{
		connected = attemptConnect(connectionName);
		_LocalConnection.accept = Delegate.create(this,accept);
		return connected;
	}
	/**
	 * 发送信息
	 * @param args 要发送的信息
	 * @exception sendName 发送对象为空
	 * @return Boolean 发送语法正确则true
	 */
	public function send(args):Boolean
	{
		if(sendName){
			return _LocalConnection.send(sendName,"accept",args);
		}else{
			return false;
		}
	}
	/**
	 * 关闭连接，也就是不接受信息
	 */
	public function close():Void{
		if (connected) _LocalConnection.close();
	}
	/**
	 * 接受到的信息
	 */
	private function accept(obj):Void{
		this.dispatchEvent({type:"onAccept",data:obj});
	}
	/**
	 * 建立连接，用于接受信息
	 * @param connectionName 连接名称
	 * @return Boolean 如果在同一台客户端计算机上运行的其它进程都没有使用同一 connectionName 参数值发出过此命令，则为 true；否则为 false。
	 */
	private function attemptConnect(connectionName:String):Boolean
	{
		//如果存在连接
		if (connected) close();
		if(connectionName){
			connectName = connectionName;
			return _LocalConnection.connect(connectName);
		}else if(connectName){
			return _LocalConnection.connect(connectName);
		}else{
			return false;
		}
	}
	/**
	 * 是否建立连接
	 * @param  value 参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set connected ( value:Boolean) :Void
	{
		_connected=  value;
	}
	public function get connected() :Boolean
	{
		return _connected;
	}
	/**
	 * 连接名称
	 * @param  value 参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set connectName ( value:String) :Void
	{
		_connectName=  value;
	}
	public function get connectName() :String
	{
		return _connectName;
	}
	/**
	 * 发送名称
	 * @param  value 参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set sendName ( value:String) :Void
	{
		_sendName=  value;
	}
	public function get sendName() :String
	{
		return _sendName;
	}
}