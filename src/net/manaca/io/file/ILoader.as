/**
 * 基本的文件加载类的接口，如加载SWF、PNG、JPG、GIF、TXT等
 * @author Wersling
 * @version 1.0, 2005-12-2
 */
interface net.manaca.io.file.ILoader {
	/**
	 * 加载路径
	 * @param url 文件路径
	 * @return Boolean 如果没有以外则为true
	 */
	public function load(url:String):Boolean;
	/**
	 * 卸载加载，也就是反加载
	 */
	public function unload():Boolean;
}