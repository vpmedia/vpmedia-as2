import net.manaca.io.conn.server.ServerServiceProxy;
/**
 * 定义服务器端操作的基本方法
 * @author Wersling
 * @version 1.0, 2006-3-24
 */
interface net.manaca.io.conn.server.Server {
	
	/**
	 * 运行此服务器或添加的服务器
	 */
	public function run(Void):Void;
	
	/**
	 * 停止运行此服务器或添加的服务器
	 */
	public function stop(Void):Void;
	
	public function putService(path:String, service):ServerServiceProxy;
}