import mx.utils.Delegate;
import net.manaca.lang.BObject;
import net.manaca.io.file.EnhancedMovieClipLoader;
/**
 * 图片缩放类
 * @exception var pz:PicZoom = new PicZoom(_PicCell);
			  pz.loadPic(item.PicPath);
 * @author Wersling
 * @version 1.0, 2005-11-10
 */
class net.manaca.controls.PicZoom extends BObject {
	private var className : String = "net.manaca.controls.PicZoom";
	private var _PicCell:MovieClip;
	//默认图片大小
	private var size:Object;
	//外部文件加载类
	private var _emcl : EnhancedMovieClipLoader;
	/**
	 * 构造函数
	 * @param mc 加载图片的MC
	 * @param w 图片最大宽度，不设置则为MC宽度
	 * @param h 图片最大高度，不设置则为MC高度
	 */
	public function PicZoom(mc:MovieClip,w:Number,h:Number)
	{
		super();
		_PicCell = mc;
		size = new Object();
		size.x = _PicCell._x;
		size.y = _PicCell._y;
		if(w){
			size.w = w;
		}else{
			size.w = _PicCell._width;
		}
		if(h){
			size.h = h;
		}else{
			size.h = _PicCell._height;
		}
		_emcl = new EnhancedMovieClipLoader();
		_emcl.init(this._PicCell,"");
		_emcl.addEventListener("onLoadInit",Delegate.create(this,Adjust));
		_emcl.addEventListener("onLoadError",Delegate.create(this,onLoadPicError));
		_emcl.addEventListener("onLoadProgress",Delegate.create(this,LoadProgress));
	}
	/**
	 * 加载图片
	 * @param path 图片路径
	 */
	public function loadPic(path:String):Void
	{
		_PicCell._x = size.x;
		_PicCell._y = size.y;
		_PicCell._xscale = 100;
		_PicCell._yscale = 100;
		//_PicCell._width = size._w;
		//_PicCell._height = size._h;
		if(path) {
			_emcl.load(path);
		}
	}
	/* 调整大小 */
	private function Adjust():Void
	{
		var w = size.w/_PicCell._width;
		var h = size.h/_PicCell._height;
		var s = w<h ? w : h;
		_PicCell._xscale = _PicCell._yscale = s*100;
		if (w < h)
		{
			_PicCell._y = (size.h-_PicCell._height)/2+size.y;
		}else
		{
			_PicCell._x = (size.w-_PicCell._width)/2+size.x;
		}
		this.dispatchEvent({type:"onLoadPic",value:_PicCell});
	}
	/** 加载图片出错 */
	private function onLoadPicError():Void
	{
		this.dispatchEvent({type:"onLoadPicError"});
	}
	private function LoadProgress(obj:Object):Void{
		this.dispatchEvent({type:"onLoadProgress",value:obj.scale});
	}
}