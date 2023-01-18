import net.manaca.lang.BObject;
import net.manaca.io.file.upload.FileTypes;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-3-31
 */
class net.manaca.io.file.upload.SimpleFileType extends BObject implements FileTypes{
	private var className : String = "net.manaca.io.file.upload.SimpleFileType";
	private var _arrTypes:Array;
	public function SimpleFileType() {
		super();
		_arrTypes = new Array();
	}

	/**
	 * 返回文件列表
	 * @param Array 符合FileUp的文件列表
	 */
	public function getTypes():Array{
		return _arrTypes;
	}
	
	/**
	 * 添加一组类型
	 * @param _extension 需要定义的扩展名，如："*.jpg; *.jpeg; *.gif; *.png";
	 * @param _description 类型说明，如："Images (*.jpg, *.jpeg, *.gif, *.png)";
	 */
	public function addType(_extension:String,_description:String):Void{
		if(_extension != undefined && _description != undefined){
			_arrTypes.push({extension:_extension,description:_description});
		}
	}

}