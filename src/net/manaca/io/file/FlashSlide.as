import mx.utils.Delegate;
import mx.transitions.Tween;
import net.manaca.ui.UIObject;
import net.manaca.io.file.EnhancedMovieClipLoader;
import net.manaca.controls.PicZoom;
import net.manaca.util.ArrayUtil;
/**
 * 图片播放器
 * @see 事件 onSlideClick 当用户点击内容时 返回参数：target {@param Object，模块本身}，url {@param String，文件路径}
 * @see 方法 SetSlidePath 设置播放文件列表 {@param path_arr 文件列表Array}
 * @see 方法 getCurrentPath 获取当前播放的文件路径 {@return String 文件路径}
 * @see 属性 Index 当前播放的文件列表索引
 * @see 属性 OutTime 播放时间
 * @see 属性 IsFade 是否使用渐变效果
 * @author Jiagao
 * @version 1.0, 2005-10-19
 */
class net.manaca.io.file.FlashSlide extends UIObject
{
	private static var className : String = "net.manaca.io.file.FlashSlide";
	/** 幻灯片mc */
	private var flashslide_mc:MovieClip;
	/** 切换时间间隔，单位秒 */
	private var intervalNum:Number;
	/** true播放false暂停 */
	private var _status:Boolean;
	/** 当前显示的内容 */
	private var currentSlideNum:Number;
	/** 内容总数 */
	private var totalSlideNum:Number;
	private var _intervalID:Number;
	/** 播放内容列表 */
	private var slideUrl_arr:Array;
	/** MovieClipLoader */
	private var _EMC:EnhancedMovieClipLoader;
	/** 是否使用渐变效果 */
	private var _isFade:Boolean;
	/** 渐变效果控制 */
	private var _FadeIn_Tween:Tween;
	private var _FadeIn_listener:Object;
	/** 图片加载缩放 */
	private var pz:PicZoom;
	/**
	 * 构造函数
	 * @param 无
	 */
	public function FlashSlide()
	{
		slideUrl_arr = new Array();
		intervalNum = 5;
		_status = false;
		_isFade = true;
		_FadeIn_listener = new Object();
		_FadeIn_listener.onMotionFinished = Delegate.create(this,onFadeInFinished);
		//_FadeIn_Tween = new Tween(flashslide_mc,"_alpha",null,0,100,1,true);
		//_FadeIn_Tween.stop();
		currentSlideNum = 0;
		flashslide_mc = this.createEmptyMovieClip("flashslide_mc",1);
		//_EMC = new EnhancedMovieClipLoader();
		//_EMC.addEventListener("onLoadPic",Delegate.create(this,onLoadSlideComplete));
		///_EMC.addEventListener("onLoadError",Delegate.create(this,onLoadSlideError));
		pz = new PicZoom(flashslide_mc,this._width,this._height);
		pz.addEventListener("onLoadPic",Delegate.create(this,onLoadSlideComplete));
		pz.addEventListener("onLoadPicError",Delegate.create(this,onLoadSlideError));
		//pz.loadPic(Ezingy.DefaultPhoto);
	}
	/**
	 * 播放一个图片
	 */
	public function PlayAFile(filepath:String):Void
	{		
		SetSlidePath([filepath]);
	}
	/**
	 * 设置播放内容列表
	 * @param  path_arr  参数类型：Array 
	 */
	public function SetSlidePath(path_arr:Array) :Void
	{
		slideUrl_arr = path_arr;
		InitCurrentSlide(0);
	}
	/**
	 * 获取当前播放的文件路径
	 * @return String
	 */
	public function getCurrentPath():String
	{
		return slideUrl_arr[Index];
	}	
	/**
	 * @param value 参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set Index(value:Number) :Void
	{
		SetSlideNum( value);
	}
	public function get Index() :Number
	{
		return currentSlideNum;
	}
	/**
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set OutTime(value:Number) :Void
	{
		intervalNum = value;
	}
	public function get OutTime() :Number
	{
		return intervalNum;
	}
	/**
	 * @param value 参数类型：Boolean
	 * @return 返回值类型：Boolean
	 */
	public function set IsFade(value:Boolean):Void
	{
		_isFade = value;
	}
	public function get IsFade() :Boolean
	{
		return _isFade;
	}
	/**
	 * 播放当前Slide
	 * @param n 指定Slide的索引，如果n为空，自动播放下一个，n为-1播放前一个。
	 */
	private function InitCurrentSlide(n:Number):Void
	{
		_FadeIn_Tween.removeListener(_FadeIn_listener);
		clearInterval(_intervalID);
		if(SetSlideNum(n)) pz.loadPic(slideUrl_arr[currentSlideNum]);
		//_EMC.loadClip(slideUrl_arr[currentSlideNum],flashslide_mc);
	}
	/** _MCL加载完成，执行该剪辑的第一帧中的动作 */
	private function onLoadSlideComplete():Void
	{
		if(_isFade) {
			if(isSwf(currentSlideNum)) flashslide_mc.gotoAndStop(1);
			//Fade In
			_FadeIn_Tween = new Tween(flashslide_mc,"_alpha",null,0,100,1,true);
			_FadeIn_Tween.addListener(_FadeIn_listener);
		} else {
			onFadeInFinished();
		}
	}
	/**	加载文件出错 */
	private function onLoadSlideError():Void
	{
		Tracer.warn("加载文件："+slideUrl_arr[currentSlideNum]+"出错","onLoadSlideError",className);
		//去除错误的图片
		ArrayUtil.RemoveIndex(slideUrl_arr,currentSlideNum);
		InitCurrentSlide();
	}
	/** 内容切换动画完成 */
	private function onFadeInFinished():Void 
	{
		//渐变结束
		_FadeIn_Tween.removeListener(_FadeIn_listener);
		flashslide_mc.onRelease = Delegate.create(this,onSlideRelease);
		flashslide_mc.useHandCursor = false;
		if(isSwf(currentSlideNum)) {
			flashslide_mc.play();
		}
		if(_status) {
			_intervalID = setInterval(this,"checkSlideIsShowComplete",intervalNum*1000);
		}
	}
	/**
	 * 检查当前Slide是否已超时
	 * @param nowTime 当前系统时间
	 * @param delay 播放该Slide需要的时间
	 */
	private function checkSlideIsShowComplete():Void
	{
		clearInterval(this._intervalID);
		SlideShowComplete();
	}
	/**
	 * 当前Slide播放完毕
	 */
	private function SlideShowComplete(n:Number):Void
	{
		if(_isFade) {
			//Fade Out
			var owner:FlashSlide = this;
			var _FadeOut_listener:Object = new Object();
			_FadeOut_listener.onMotionFinished = function() {
				//渐变效果结束
				_FadeOut_Tween.removeListener(_FadeOut_listener);
				owner.InitCurrentSlide();
				delete _FadeOut_listener;
				delete _FadeOut_Tween;
			};
			var _FadeOut_Tween:Tween = new Tween(flashslide_mc,"_alpha",null,100,0,1,true);
			_FadeOut_Tween.addListener(_FadeOut_listener);
		} else {
			InitCurrentSlide();
		}		
	}	
	/**
	 * 响应用户点击事件
	 */
	private function onSlideRelease():Void
	{
		this.dispatchEvent({type:"onSlideClick",target:this,url:slideUrl_arr[currentSlideNum]});
	}
	
	/**
	 * 获取Slide类型，swf或者图片
	 * @param i Url列表索引
	 */
	private function isSwf(i:Number):Boolean
	{
		var extName:String = String(slideUrl_arr[i]).toLowerCase().substr(-3, 3);
		var isSwf:Boolean;
		if (extName == "swf") {
			isSwf = true;
		} else {
			isSwf = false;
		}
		return isSwf;
	}
	
	/** 设置当前播放位置，设置成功返回true，否则返回false */
	private function SetSlideNum(n:Number):Boolean
	{	
		totalSlideNum = slideUrl_arr.length - 1;	
		if(totalSlideNum < 0) {
			//_isFade = false;
			pz.loadPic("");			
			return false;
		}
		if(totalSlideNum == 0) {
			_status = false;
		} else {
			_status = true;
		}
		if(n == -1) {
			currentSlideNum--;
		} else if(n == undefined) {
			currentSlideNum++;
		} else {
			currentSlideNum = n;
		}
		if(currentSlideNum > totalSlideNum) currentSlideNum = 0;
		if(currentSlideNum < 0) currentSlideNum = totalSlideNum;
		return true;
	}
}