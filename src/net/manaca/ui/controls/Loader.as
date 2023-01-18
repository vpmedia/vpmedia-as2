import net.manaca.ui.controls.UIComponent;
import net.manaca.ui.controls.skin.ILoaderSkin;
import net.manaca.ui.controls.skin.SkinFactory;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.controls.Panel;
import net.manaca.ui.controls.ProgressBar;
import net.manaca.io.file.EnhancedMovieClipLoader;
import net.manaca.util.Delegate;
import net.manaca.lang.event.Event;
import net.manaca.util.MovieClipUtil;
import net.manaca.ui.controls.skin.mnc.LoaderSkin;
/**
 * 当图片加载完成时
 */
[Event("complete")]
/**
 * 当图片正在加载时
 */
[Event("progress")]
/**
 * 图片加载器，指定图片路径，则可以加载图片，可以设置是否自适应图片大小
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
class net.manaca.ui.controls.Loader extends UIComponent {
	private var className : String = "net.manaca.ui.controls.Loader";
	private var _componentName = "Loader";
	private var _skin:ILoaderSkin;
	
	private var _panel : Panel;
	private var _progressBar:ProgressBar;
	private var _emcl : EnhancedMovieClipLoader;
	private var _picHoder:MovieClip;
	private var _autoLoad : Boolean = true;
	private var _contentPath : String;
	private var _scaleContent : Boolean = true;
	private var _percentLoaded : Number;
	public function Loader(target : MovieClip, new_name : String) {
		super(target, new_name);
//		_skin = SkinFactory.getInstance().getDefault().createLoaderSkin();
		_skin = new LoaderSkin();
		_preferredSize = new Dimension(120,90);
		
		this.paintAll();
		init();
	}
	private function init() : Void {
		_panel = _skin.getPanel();
		_progressBar = _skin.getProgressBar();
		_progressBar.conversion = 1024;
		//_progressBar.label ="{1}KB/{2}KB {3}%";
		_emcl = new EnhancedMovieClipLoader();
		_emcl.addEventListener("onLoadProgress",Delegate.create(this,onLoadProgress));
		_emcl.addEventListener("onLoadInit",Delegate.create(this,onLoadComplete));
		
		_progressBar.setVisible(false);
		
	}
	//加载前初始化
	private function initPicHoder(){
		if(_picHoder != undefined ) MovieClipUtil.remove(_picHoder);
		_progressBar.setProgress(0,0);
		_picHoder = _panel.getBoard().createEmptyMovieClip("_picHoder",1);
		_emcl.init(_picHoder);
	}
	/**
	 * 指示 loader 开始加载其内容
	 */
	public function load(path:String):Void{
		if(path != undefined) this._contentPath = path;
		if(contentPath != undefined && contentPath != ""){
			initPicHoder();
			_emcl.load(contentPath);
			_progressBar.setVisible(true);
		}
	}
	
	//加载进度
	private function onLoadProgress(e:Event) : Void {
		_percentLoaded = Number(e.value);
		_progressBar.setProgress(this.bytesLoaded,this.bytesTotal);
		this.dispatchEvent(new Event("progress",_percentLoaded,this));
	}
	
	//加载完成
	private function onLoadComplete(e:Event) : Void {
		_percentLoaded = 100;
		_progressBar.setVisible(false);
		if(scaleContent){
			adjust();
		}else{
			this.setSize(_picHoder._width,_picHoder._height);
		}
		this.dispatchEvent(new Event(Event.COMPLETE,100,this));
		
	}
	
	/**
	 * 获取和设置是自动加载内容 (true)，还是等到调用 Loader.load() 时才加载内容 (false)。默认值为 true。
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set autoLoad(value:Boolean) :Void{
		_autoLoad = value;
	}
	public function get autoLoad() :Boolean{
		return _autoLoad;
	}
	
	/**
	 * 获取已经加载的字节数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get bytesLoaded() :Number{
		return _emcl.bytesLoaded;
	}
	
	/**
	 * 获取总字节数
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get bytesTotal() :Number{
		return _emcl.bytesTotal;
	}
	
	/**
	 * 获取已加载内容的百分比
	 * @param  value:Number - 
	 * @return Number 
	 */
	public function get percentLoaded() :Number{
		return _percentLoaded;
	}
	
	/**
	 * 获取和设置对包含所加载文件的内容的影片剪辑实例的引用
	 * @param  value:String - 
	 * @return String 
	 */
	public function get content() :MovieClip{
		return _panel.getBoard();
	}
	
	/**
	 * 获取和设置要加载的内容的 URL
	 * @param  value:String - 
	 * @return String 
	 */
	public function set contentPath(value:String) :Void{
		_contentPath = value;
		if(autoLoad){
			this.load();
		}
	}
	public function get contentPath() :String{
		return _contentPath;
	}
	
	/**
	 * 获取和设置是内容进行缩放以适合加载器 (true)，还是加载器进行缩放以适合内容 (false)。默认值为 true。
	 * @param  value:Boolean - 
	 * @return Boolean 
	 */
	public function set scaleContent(value:Boolean) :Void{
		_scaleContent = value;
	}
	public function get scaleContent() :Boolean{
		return _scaleContent;
	}

	/* 调整大小 */
	private function adjust():Void{
		var size:Object = new Object();
		size.w = this.getSize().getWidth();
		size.h = this.getSize().getHeight();
		size.x = 0;
		size.y = 0;
		var w = size.w/_picHoder._width;
		var h = size.h/_picHoder._height;
		var s = w<h ? w : h;
		if(_picHoder._width > size.w || _picHoder._height > size.h){
			_picHoder._xscale = _picHoder._yscale = s*100;
		}else{
			_picHoder._xscale = 100;
		}
		_picHoder._y = int((size.h-_picHoder._height)/2+size.y);
		_picHoder._x = int((size.w-_picHoder._width)/2+size.x);
		
		if( _picHoder._width > size.w || _picHoder._height > size.h) adjust();
	}
}