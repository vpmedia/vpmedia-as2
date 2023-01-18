/**
 * 为客户端定义基本的方法
 * @author Wersling
 * @version 1.0, 2006-3-24
 */
interface net.manaca.io.conn.client.Client {
	public function close() : Void;
	public function connect(connectionName:String) : Boolean;
	public function send():Boolean;
}