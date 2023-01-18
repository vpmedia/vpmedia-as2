import net.manaca.io.file.upload.FileTypes;
/**
 * 提供上传下载的基本方法
 * @author Wersling
 * @version 1.0, 2006-3-31
 */
interface net.manaca.io.file.upload.UpLoad {
	
	/**
	 * 取消文件上传或下载
	 */
	public function cancel() : Void;
	
	/**
	 * 下载远程服务器上的文件。Flash Player 可以下载最多 100 MB 的文件
	 * @param url 下载地址
	 * @param defaultFileName 对话框中显示的要下载的文件的默认文件名
	 */
	public function download(url:String, defaultFileName:String) : Boolean;
	
	/**
	 * 开始将用户选择的文件上载到远程服务器
	 * @param url 服务器地址
	 */
	public function upload(url:String) : Boolean;
	
	/**
	 * 添加一个上传文件
	 * @param fileTypes 文件类型
	 */
	public function add(fileTypes:FileTypes):Void;
	
	/**
	 * 添加一个或多个上传文件
	 * @param fileTypes 文件类型
	 */
	public function addAll(fileTypes:FileTypes):Void;
	
}