import net.manaca.io.file.ILoader;
import net.manaca.lang.BObject;
import mx.utils.Delegate;
import net.manaca.lang.exception.IllegalArgumentException;

/**
 * 增强的影片加载类，实际上还可以加载PNG、JPG、GIF。
 * @author Wersling
 * @version 1.0, 2005-12-2
 */
class net.manaca.io.file.EnhancedMovieClipLoader extends BObject implements ILoader {
	private var className : String = "net.manaca.io.file.EnhancedMovieClipLoader";
	/** MovieClipLoader  */
	private var _mcl:MovieClipLoader;
	/** 事件监听 */
	private var _listenerObj:Object;
	/** 要加载的MC目标 */
	private var target : Object;
	/** 返回参数 */
	private var arg : Object;

	private var _bytesLoaded : Number = 0;

	private var _bytesTotal : Number = 0;
	public function EnhancedMovieClipLoader(){	
		super();
		_mcl = new MovieClipLoader();
		_listenerObj = new Object();
		_listenerObj.onLoadStart = Delegate.create(this,onLoadStart);
		_listenerObj.onLoadProgress = Delegate.create(this,onLoadProgress); 
		_listenerObj.onLoadInit = Delegate.create(this,onLoadInit);
		_listenerObj.onLoadComplete = Delegate.create(this,onLoadComplete);
		_listenerObj.onLoadError = Delegate.create(this,onLoadError);
		//关联
		_mcl.addListener(_listenerObj);
	}
	/**
	 * 初试参数
	 * @param target 目标
	 * @param arg 可返回的参数,可选
	 */
	public function init(target:Object,arg:Object):Void{
		this.target = target;
		this.arg 	= arg;
	}
	/**
	 * 加载路径
	 * @param url 文件路径
	 * @return Boolean 如果没有以外则为true
	 */
	public function load(url : String) : Boolean {
		if (!url)		throw new IllegalArgumentException("下载路径不能为空",this,[url]);
		if (!target)	throw new IllegalArgumentException("加载目标不能为空",this,[target]);
		return loadClip(url,target,arg);
	}
	/**
	 * 卸载加载，也就是反加载
	 */
	public function unload() : Boolean {
		return unloadClip(target);
	}
	/**
	 * 下载MC
	 * @param Path 下载文件路径
	 * @param target 目标
	 * @param 可返回的参数,可选
	 */
	private function loadClip(Path:String,target:Object):Boolean{
		//Tracer.debug("开始加载文件:"+Path);
		return _mcl.loadClip(Path,target);
	}
	/**
	 * 卸载MC
	 */
	private function unloadClip(target:Object):Boolean{
		return _mcl.unloadClip(target);
	}
	
	/** 加载开始 */
	private function onLoadStart(target_mc:MovieClip):Void{
		var loadProgress:Object = _mcl.getProgress(target_mc);
		this.dispatchEvent({type:"onLoadStart",bytesTotal:loadProgress.bytesTotal});
	}
	
	/** 加载进度 */
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void{
		_bytesLoaded = bytesLoaded;
		_bytesTotal = bytesTotal;
		//Tracer.debug("加载进度： " + Math.ceil((bytesLoaded/bytesTotal)*100) + "%");
		this.dispatchEvent({type:"onLoadProgress",scale:Math.ceil((bytesLoaded/bytesTotal)*100)});
	}
	
	/** 执行该剪辑的第一帧中的动作 */
	private function onLoadInit(target_mc:MovieClip):Void{
		//Tracer.debug(target + "已初始化");
		this.dispatchEvent({type:"onLoadInit",target:target_mc,value:arg});
	}
	
	/** 加载完成 */
	private function onLoadComplete(target_mc:MovieClip, httpStatus:Number):Void{
		//Tracer.debug("成功加载文件:"+target_mc);
		this.dispatchEvent({type:"onLoadComplete",target:target_mc,value:arg});
	}
	
	/** 加载错误 */
	private function onLoadError(target_mc:MovieClip, errorCode:String, httpStatus:Number):Void{
		Tracer.warn("加载文件失败:" + errorCode);
		this.dispatchEvent({type:"onLoadError",error:errorCode});
	}
	/**
	 * 获取已经加载的字节数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get bytesLoaded() :Number{
		return _bytesLoaded;
	}
	/**
	 * 获取总字节数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get bytesTotal() :Number{
		return _bytesTotal;
	}

}