import net.manaca.lang.BObject;
import net.manaca.io.file.upload.UpLoad;
import net.manaca.io.file.upload.FileTypes;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.util.Delegate;
[Event("change")]
/**
 * 用于文件的上传和下载
 * @author Wersling
 * @version 1.0, 2006-3-31
 */
class net.manaca.io.file.upload.FileUpLoad extends BObject implements UpLoad{
	private var className : String = "net.manaca.io.file.upload.FileUpLoad";
	private var _url:String;
	private var _now_fileRef:FileReference;
	private var _fileRef:FileReference;
	private var _fileRefEvent:Object;
	private var _fileRefList:FileReferenceList;
	private var _fileRefListEvent:Object;
	private var _files:Array;
	//用于记录上传成功的文件
	private var _files_complete:Array;
	//上传错误
	private var _files_err:Array;
	public function FileUpLoad() {
		super();
		init();
		
	}
	/**
	 * 初始化
	 */
	private function init():Void{
		_files = new Array();
		_files_complete = new Array();
		_files_err = new Array();
		_fileRef = new FileReference();
		for(var i in _fileRef) trace('key: ' + i + ', value: ' + _fileRef[i]);
		_fileRefList = new FileReferenceList();
		_fileRefEvent = new Object();
		_fileRefListEvent = new Object();
		//关联事件
		_fileRef.addListener(_fileRefEvent);
		_fileRefList.addListener(_fileRefListEvent);
		//监听
		_fileRefEvent.onSelect = Delegate.create(this,onSelect);
		_fileRefEvent.onCancel = Delegate.create(this,onCancel);
		_fileRefListEvent.onSelect = Delegate.create(this,onSelectMore);
		_fileRefListEvent.onCancel = Delegate.create(this,onCancel);
		
		_fileRefEvent.onOpen = Delegate.create(this,onOpen);
		_fileRefEvent.onComplete = Delegate.create(this,onComplete);
		_fileRefEvent.onProgress = Delegate.create(this,onProgress);
		
		_fileRefEvent.onHTTPError = Delegate.create(this,onHTTPError);
		_fileRefEvent.onIOError  = Delegate.create(this,onIOError);
		_fileRefEvent.onSecurityError  = Delegate.create(this,onSecurityError);
	}
	
	/**
	 * 取消文件上传或下载
	 */
	public function cancel() : Void{
		if(_now_fileRef) _now_fileRef.cancel();
		this.dispatchEvent({type:"onCancel",value:_files});
		
	}
	
	/**
	 * 下载远程服务器上的文件。Flash Player 可以下载最多 100 MB 的文件
	 * @param url 下载地址
	 * @param defaultFileName 对话框中显示的要下载的文件的默认文件名
	 */
	public function download(url:String, defaultFileName:String) : Boolean{
		return null;
	}
	
	/**
	 * 开始将用户选择的文件上载到远程服务器
	 * @param url 服务器地址
	 */
	public function upload(url:String) : Boolean{
		if(url) _url = url;
		if(!_url){
			throw new IllegalArgumentException("传入的服务器地址错误！",this,arguments);
			return false;
		}
		var result:Boolean = false;
		if(_files.length >0){
			var item:FileReference = FileReference(_files.shift());//加载一个并从列表删除
			item.addListener(_fileRefEvent);
			result = item.upload(url);
			//上传错误时上传下一个文件
			if(!result && _files.length>0){
				_files_err.push(item);
				upload(_url);
			}
		}
		return result;
	}
	
	/**
	 * 添加一个上传文件
	 * @param fileTypes 文件类型
	 */
	public function add(fileTypes:FileTypes):Void{
		if(fileTypes){
			_fileRef.browse(fileTypes.getTypes());
		}else{
			throw new IllegalArgumentException("缺少文件类型，在浏览文件时",this,arguments);
		}
	}
	
	/**
	 * 添加一个或多个上传文件
	 * @param fileTypes 文件类型
	 */
	public function addAll(fileTypes:FileTypes):Void{
		if(fileTypes){
			_fileRefList.browse(fileTypes.getTypes());
		}else{
			throw new IllegalArgumentException("缺少文件类型，在浏览文件时",this,arguments);
		}
	}
	
	/**
	 * 返回选择文件列表
	 * @return Array 选择的文件列表
	 */
	public function getSelectFileList():Array{
		return _files;
	}
	
	/**
	 * 用户选择单个文件的时候触发事件
	 */
	private function onSelect(file:FileReference):Void{
		if(file){
			 _files.push(file);
			 this.dispatchEvent({type:"onSelect",value:_files});
		}
	}
	
	/**
	 * 用户选择一个或多个文件的时候触发事件
	 */
	private function onSelectMore(fileRefList:FileReferenceList):Void{
		var _list:Array = fileRefList.fileList;
		if(_list.length > 0){
			for (var i : Number = 0; i < _list.length; i++) {
				_files.push(_list[i]);
			}
			this.dispatchEvent({type:"onSelect",value:_files});
		}
	}
	
	/**
	 * 在选择文件时选择取消
	 */
	private function onCancel():Void{
		this.dispatchEvent({type:"onCancel",value:_files});
	}
	
	/**
	 * 开始上传文件
	 */
	private function onOpen(file:FileReference):Void{
		Tracer.debug("开始加载 "+file.name);
		_now_fileRef = file;
		this.dispatchEvent({type:"onOpen",value:file});
	}
	
	/**
	 * 文件上传成功
	 */
	private function onComplete (file:FileReference):Void{
		Tracer.debug("加载 "+file.name+" 完成!");
		_files_complete.push(file);
		if(_files.length > 0){
			this.upload(_url);
			this.dispatchEvent({type:"onComplete",value:file});
		}else{
			Tracer.debug("完成加载所有文件!");
			this.dispatchEvent({type:"onAllComplete",value:{complete:_files_complete,err:_files_err}});
		}
	}
	
	/**
	 * 加载进度
	 */
	private function onProgress(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
		Tracer.debug("加载 "+file.name+"  "+int((bytesLoaded/bytesTotal)*100)+"%");
	}
	
	private function onHTTPError(file:FileReference):Void{
		Tracer.warn("HTTP 错误 at " + file.name);
		this.dispatchEvent({type:"onError",value:file});
	}
	
	private function onIOError(file:FileReference):Void{
		Tracer.warn("输入/输出错误 at " + file.name);
		this.dispatchEvent({type:"onError",value:file});
	}
	
	private function onSecurityError(file:FileReference):Void{
		Tracer.warn("安全错误问题引起错误 at " + file.name);
		this.dispatchEvent({type:"onError",value:file});
	}
	
}