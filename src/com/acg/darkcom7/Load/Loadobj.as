 /**************************************************************
* 1. 파일명 : Loadobj.as
* 2. 제작목적 : 객체 로드
* 3. 제작자 : 나민욱(darkcom7)
* 4. 제작일 : 2006. 10. 25
* 5. 최종수정일 : 2006. 10. 25
* 6. 부가설명 :
* 7. 파라미터  :txt:대상 오브젝트(완료후  알파값으로 사라질 겍체)
*                    target: 로드할 대상
*                    x: 대상의 x위치
*                    y :대상의 y위치
*                    w :마스크 의 넓이
*                    h : 마스크의 높이
*                    refer : 로딩후의 함수 경로
*                    fun :로딩후 실행할 함수
*                    para:실행할 함수의 파라미터 값
*
*
*
* 8. 리턴값 : void
* 9. 사용법 :
*
*    import Load.Loadobj;
*    var loadingT = new Loadobj(loadtxt_mc.loading_txt, movie_mc.load_mc, 0, 0, 700, 219.5, this, CompNext);
*    loadingT.loadImage("cf_mv.swf");
*
*
**************************************************************/
class Load.Loadobj extends MovieClip
{
	private var container_mc : MovieClip
	private var mcLoader : MovieClipLoader
	private var txt_mc : Object
	private var Width : Number
	private var Heiht : Number
	private var target_mc : MovieClip
	private var Refer : MovieClip
	private var func : Function
	private var para : Array
	private var loadRefer : MovieClip
	private var loadFunc : Function
	private var Total : Number
	private var LoadInitFunc : Function
	function Loadobj (txt : Object, target : MovieClip, x : Number, y : Number, w : Number, h : Number, refer : MovieClip, fun : Function, para : Array, LoadInitFunc : Function)
	{
		//container_mc.swapDepths(target.getNextHighestDepth()+168000)
		//trace(target)
		this.para = para
		txt_mc = txt
		target_mc = target
		Width = w
		Heiht = h
		Refer = refer
		this.LoadInitFunc = LoadInitFunc
		func = fun
		mcLoader = new MovieClipLoader ();
		mcLoader.addListener (this);
		buildViewer (x, y, w, h);
		txt_mc.text = "00"
		txt_mc._alpha = 0
	}
	private function buildViewer (x : Number, y : Number, w : Number, h : Number) : Void
	{
		createMainContainer (x, y);
		createImageClip ();
		createImageClipMask (w, h);
	}
	private function createMainContainer (x : Number, y : Number) : Void
	{
		container_mc = target_mc.createEmptyMovieClip ("dummy_mc" , target_mc.getNextHighestDepth () + 200);
		container_mc._x = x;
		container_mc._y = y;
	}
	private function createImageClip () : Void
	{
		container_mc.createEmptyMovieClip ("image_mc", 2);
	}
	private function createImageClipMask (w : Number, h : Number) : Void
	{
		if ( ! (w > 0 && h > 0))
		{
			return;
		}
		container_mc.createEmptyMovieClip ("mask_mc", 3);
		container_mc.mask_mc.moveTo (0, 0);
		container_mc.mask_mc.beginFill (0x0000FF);
		container_mc.mask_mc.lineTo (w, 0);
		container_mc.mask_mc.lineTo (w, h);
		container_mc.mask_mc.lineTo (0, h);
		container_mc.mask_mc.lineTo (0, 0);
		container_mc.mask_mc.endFill ();
		container_mc.mask_mc._visible = false;
	}
	public function onLoadStart (target : MovieClip)
	{
		//trace ("실행")
		//txt_mc._visible = true
		var txt_mc = this.txt_mc
		var DummyLoop : MovieClip = target_mc.createEmptyMovieClip ("roop", target_mc.getNextHighestDepth ())
		DummyLoop.onEnterFrame = function ()
		{
			txt_mc._alpha += 3
			if (txt_mc._alpha >= 100)
			{
				txt_mc._alpha = 100
				delete this.onEnterFrame
				removeMovieClip (this)
			}
		}
	};
	public function onLoadProgress (target : MovieClip, bytesLoaded : Number, bytesTotal : Number) : Void
	{
		txt_mc._alpha = 100
		this.Total = bytesTotal
		var loadPercent = int (bytesLoaded / bytesTotal * 100);
		mx.utils.Delegate.create (this.loadRefer, this.loadFunc).call (null, bytesLoaded, bytesTotal)
		if (loadPercent < 10)
		{
			loadPercent = "0" + loadPercent
		}
		txt_mc.text = loadPercent
	};
	/*
	* 이것은 추가 로딩모션을 사용하고 싶을때 ,모션이 있는 펑션을 따로 만들고 아래처럼 메서드의 인자값으로 설정해주면 된다.
	*
	*    public function addLoad (refer :경로 , fun : 펑션네임)
	*
	*
	*    import Lib.Cloud9.darkcom7.Loadobj;
	*    var loadingT = new Loadobj(loadtxt_mc.loading_txt, movie_mc.load_mc, 0, 0, 700, 219.5, this, CompNext);
	*    loadingT.loadImage("cf_mv.swf");
	*    loadingT.addLoad(this, testFunc);
	*    function testFunc(loaded,total) {
	*	  trace(loaded)
	*	  trace("로드되는것   :    "+arguments[0]);
	*	  trace("로드되는것   :    "+arguments[1]);
	*     }
	*/
	public function addLoad (refer : MovieClip, fun : Function)
	{
		this.loadRefer = refer
		this.loadFunc = fun
	}
	public function onLoadInit (target : MovieClip) : Void
	{
		if (LoadInitFunc == null)
		{
			//trace("알파값이 0")
			target._alpha = 0
		}
		//인터메츠에만 컨셉에만 해당하는 부분
		if (_global.NMW.main_mc._currentframe == 2)
		{
			this.txt_mc._parent.gotoAndStop (1)
		}
		//
		target.stop ()
		var txt_mc = this.txt_mc
		var refer = this.Refer
		var fun = this.func
		var para = this.para
		//txt_mc._alpha =100
		if (LoadInitFunc != null)
		{
			//trace("펑션없어~")
			mx.utils.Delegate.create (refer, LoadInitFunc).apply (refer, para)
		}
		var InitFunc = this.LoadInitFunc
		var DummyLoop : MovieClip = target_mc.createEmptyMovieClip ("roop", target_mc.getNextHighestDepth ())
		DummyLoop.onEnterFrame = function ()
		{
			if (InitFunc == null)
			{
				target._alpha += 5
			}
			txt_mc._alpha -= 2
			if (InitFunc == null)
			{
				if (target._alpha >= 100)
				{
					//trace(target._alpha)
					target._alpha = 100
					txt_mc._alpha = 0
					delete this.onEnterFrame
					removeMovieClip (this)
					//txt_mc._visible = false
					//trace("완료")
					mx.utils.Delegate.create (refer, fun).apply (refer, para)
				}
			}else
			{
				if (txt_mc._alpha <= 0)
				{
					//trace(target._alpha)
					target._alpha = 100
					txt_mc._alpha = 0
					delete this.onEnterFrame
					removeMovieClip (this)
					//txt_mc._visible = false
					//trace("완료")
					mx.utils.Delegate.create (refer, fun).apply (refer, para)
				}
			}
		}
		//마스크 씌우기 
		container_mc.image_mc.setMask (container_mc.mask_mc);
		// 
		if ( ! func)
		{
			mx.utils.Delegate.create (Refer, func).apply (null, null)
		}
	};
	public function loadImage (URL : String) : Void
	{
		//trace(URL)
		mcLoader.loadClip (URL, container_mc.image_mc)
	}
	public function destory () : Void
	{
		//trace(container_mc + "   네1 뎁스 ::"+container_mc.getDepth())
		mcLoader.removeListener (this);
		container_mc.removeMovieClip ();
		//mcLoader.unloadClip(this.target_mc)
		this.allclear (this);
		//	trace(container_mc + "   네2 뎁스 ::")
		//container_mc.image_mc.removeMovieClip();
		//trace(container_mc==null?"없다":"있다")
		
	}
	function allclear (obj)
	{
		for (var p in obj)
		{
			//trace(p +  "::지울놈들::" + obj[p])
			delete obj [p];
			obj [p].removeMovieClip ();
			if (obj [p])
			{
				this.allclear (obj [p]);
			}
		}
	}
	//플레이 할땐 꼭 이플레이이 펑션을 실행하십시요
	public function playFunc ()
	{
		container_mc.image_mc.play ()
	}
	public function StopFunc ()
	{
		container_mc.image_mc.gotoAndStop (1)
	}
}
