/**
 * 文件类型表
 * @author Wersling
 * @version 1.0, 2006-3-31
 */
interface net.manaca.io.file.upload.FileTypes {
	/**
	 * 返回文件列表
	 */
	public function getTypes():Array;
	
	/**
	 * 添加一组类型
	 * @param extension 需要定义的扩展名，如："*.jpg; *.jpeg; *.gif; *.png";
	 * @param description 类型说明，如："Images (*.jpg, *.jpeg, *.gif, *.png)";
	 */
	public function addType(extension:String,description:String):Void;
}