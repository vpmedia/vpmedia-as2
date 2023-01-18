/**
 * 处理客户的服务要求，并作出一定的反映
 * @author Wersling
 * @version 1.0, 2006-3-24
 */
interface net.manaca.io.conn.server.ServerServiceProxy {
	
	/**
	 * 	运行这个服务并监听客户端请求
	 */
	public function run(host:String):Void;
	
	/**
	 * 停止服务
	 */
	public function stop(Void):Void;
}