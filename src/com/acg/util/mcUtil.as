
import mx.transitions.OnEnterFrameBeacon;
import mx.transitions.Tween;
import mx.transitions.easing.*;
import com.acg.color.getColorTrans;
import flash.geom.ColorTransform;
import flash.geom.Transform;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix; 


/**
* 무비클립 제어 클래스2
* @author 홍준수
* @date 2007.03.15
* @update 2007.06.18
*/

class com.acg.util.mcUtil {
	
	/**
	* 지정한 무비클립을 타겟프레임으로 이동시켜줍니다. 프레임으로 이동후 콜백함수 실행이 가능합니다.
	* @param mc 지정할 무비클립
	* @param targetNum 이동시켜줄 프레임
	* @param exeFunc 콜백함수
	* @param exeArray 콜백함수의 인수(Array로 지정)
	*/

	public static function moveToFrame(mc			:MovieClip	,
									   targetNum	:Number		,
									   exeFunc		:Function	,
									   exeArray		:Array		) 
	{
		var frameMc = mc.createEmptyMovieClip("dummy_________", 9876);
		
		frameMc.onEnterFrame = function() 
		{
			var owner = this._parent;
			owner._currentframe == targetNum ? ( this.onEnterFrame = null , removeMovieClip(this) , exeFunc.apply(null,exeArray) ) : owner._currentframe>targetNum ? owner.prevFrame() : owner.nextFrame()
		}
	}

	/**
	* 지정한 무비클립을 타겟프레임으로 트위닝 함수를 이용해서 이동시켜줍니다. 프레임으로 이동후 콜백함수 실행이 가능합니다.
	* @param mc 지정할 무비클립
	* @param targetNum 이동시켜줄 프레임
	* @param duration 트위닝을 지속할 프레임
	* @param easingFunc easing클래스(내장 easing클래스나 로버트 플래너 easing클래스도 가능)
	* @param exeFunc 콜백함수
	* @param exeArray 콜백함수의 인수(Array로 지정)
	*/
	
	public static function frameTween(mc			:MovieClip	,
									  targetNum 	:Number		,
									  duration		:Number		,
									  easingFunc	:Function	,
									  exeFunc		:Function	,
									  exeArray		:Array		)
	{
		mc.tm1 ? mc.tm1.stop() : null;
		mc.tm1 = new Tween(mc,"frame_____",easingFunc, mc._currentframe, targetNum, duration, false)
		mc.tm1.onMotionChanged = function() 
		{
			mc.gotoAndStop(int(this.position));
		}
		mc.tm1.onMotionFinished = function() 
		{
			exeFunc.apply(null,exeArray);
			delete this;
		}
	}

	/**
	* 함수를 지정한 딜레이 후에 실행합니다.
	* @param mc 컨테이너 무비클립
	* @param delayFrame 딜레이
	* @param callbackFunc 콜백함수
	*/

	
   public static function delayFunc(mc				:MovieClip	,
									delayFrame		:Number		,
									callbackFunc	:Function 	) 
   {
      var args = arguments;
      var argsLength = args.length;
      var tempArray = new Array();
	  var tempDepth = mc.getNextHighestDepth();
	  
      var ddk = mc.createEmptyMovieClip("delayFuncFrame" + tempDepth, tempDepth);
      ddk.dFN = delayFrame;
      ddk.cFN = 0;
	  
      ddk.onEnterFrame = function () {
         if (this.dFN == this.cFN) {
            if (argsLength > 2) {
               for (var i = 3; i < argsLength; i++) {
                  tempArray.push(args[i]);
               }
               callbackFunc.apply(this._parent, tempArray);
            }
            else {
               callbackFunc.apply(this._parent);
            }
            this.onEnterFrame = null;
            this.removeMovieClip();
         }
         this.cFN++;
      }
   }
   
   public static function delayFunc2(mc				:MovieClip	,
									delayFrame		:Number		,
									callbackFunc	:Function 	) 
   {
      var args = arguments;
      var argsLength = args.length;
      var tempArray = new Array();
	  var tempDepth = mc.getNextHighestDepth();
	  
      var ddk = mc.createEmptyMovieClip("delayFuncFrame", 9999);
      ddk.dFN = delayFrame;
      ddk.cFN = 0;
	  
      ddk.onEnterFrame = function () {
         if (this.dFN == this.cFN) {
            if (argsLength > 2) {
               for (var i = 3; i < argsLength; i++) {
                  tempArray.push(args[i]);
               }
               callbackFunc.apply(this._parent, tempArray);
            }
            else {
               callbackFunc.apply(this._parent);
            }
            this.onEnterFrame = null;
            this.removeMovieClip();
         }
         this.cFN++;
      }
   }   
   
   
	/**
	* 지정한 무비클립의 컬러를 지정한 컬러로 바꿔줍니다.
	* @param mc 무비클립
	* @param targetRGB 바꿔줄 컬러값 
	* @param easeFunc easing클래스
	* @param duration 트위닝을 지속할 프레임값    
	*/


   public static function colorTween(mc			:MovieClip	,
									 targetRGB	:Number		,
									 easeFunc	:Function	,
									 duration	:Number		)
	{
		var trans:Transform = new Transform(mc);
		
		var colorTrans:ColorTransform = new ColorTransform();
		
		mc.r = trans.colorTransform.redOffset;
		mc.g = trans.colorTransform.greenOffset;
		mc.b = trans.colorTransform.blueOffset;
		
		var target = mcUtil.hexToRgb(targetRGB);
		
		mc.cm1.stop() , mc.cm2.stop() , mc.cm3.stop() ,mc.cm4.stop();
		
		mc.cm1 = new Tween(mc, "r" , easeFunc, mc.r , target.r , duration , false);
		mc.cm2 = new Tween(mc, "g" , easeFunc, mc.g , target.g , duration , false);
		mc.cm3 = new Tween(mc, "b" , easeFunc, mc.b , target.b , duration , false);
		
		mc.cm1.trans = trans;
		mc.cm1.colorTrans = colorTrans;
		
		mc.cm1.onMotionChanged = function() {
			var obj = this.obj;
			var tempRGB = mcUtil.rgbToHex(obj.r , obj.g , obj.b);
			this.colorTrans.rgb = tempRGB;
			this.trans.colorTransform = colorTrans;
		}
		
		mc.cm1.onMotionFinished = function() {
			var obj = this.obj;
			obj.cm1.stop() , obj.cm2.stop() , obj.cm3.stop();
		}
	}   
	
	/**
	* 지정한 무비클립을 지정한 값만큼 tint시켜줍니다.
	* @param mc 타겟 무비클립
	* @param rgb 타겟컬러
	* @param amt tint수치(0~100)
	*/
	
	public static function tintTo(mc:MovieClip , easeFunc:Function , rgb:Number , amt:Number , duration:Number , exeFunc:Function , exeArray:Array )
	{
		if (!mc.$tintTween) { mc.$tintTween=0 }
		mc.$tween.stop();
		mc.my_color = new Color(mc);
		mc.targetRGBColor = rgb;
		mc.$tween = new Tween(mc , "$tintTween" , easeFunc , mc.$tintTween , amt , duration , false);
		mc.$tween.onMotionChanged = function() 
		{
			var myColor = this.obj.my_color;
			myColor.setTransform(getColorTrans.tint( this.obj.targetRGBColor , this.position ) );
		}
		mc.$tween.onMotionFinished = function() 
		{
			exeFunc.apply(null , exeArray);
		}
	}
	
	public static function tintTo2(mc:MovieClip , easeFunc:Function , rgb:Number , startAmt:Number , amt:Number , duration:Number , exeFunc:Function , exeArray:Array )
	{
		mc.$tintTween = startAmt;
		mc.$tween.stop();
		mc.my_color = new Color(mc);
		mc.targetRGBColor = rgb;
		mc.$tween = new Tween(mc , "$tintTween" , easeFunc , mc.$tintTween , amt , duration , false);
		mc.$tween.onMotionChanged = function() 
		{
			var myColor = this.obj.my_color;
			myColor.setTransform(getColorTrans.tint( this.obj.targetRGBColor , this.position ) );
		}
		mc.$tween.onMotionFinished = function() 
		{
			exeFunc.apply(null , exeArray);
		}
	}
	
	
	
	/** 
	* 무비클립을 지정한 값만큼 blur처리 해줍니다. 퀄리티는 1로 고정됩니다.
	* @param mc 타겟 무비클립
	* @param blurX 블러값을 적용할 수치(가로값)
	* @param blurY 블럭값을 적용할 수치(세로값)
	* @param easeFunc easing클래스
	* @param duration 트위닝을 지속할 프레임값	
	*/
	
	public static function blurTo(mc:MovieClip , blurX:Number , blurY:Number , easeFunc:Function , duration:Number , exeFunc:Function , exeArray:Array )
	{
		if (!mc.$blurTweenX) { mc.$blurTweenX =0 }
		if (!mc.$blurTweenY) { mc.$blurTweenY =0 }
		
		mc.$blurTween1.stop() , mc.$blurTween2.stop();
		mc.$blurTween1 = new Tween(mc , "$blurTweenX" , easeFunc , mc.$blurTweenX , Math.min(blurX,99) , duration , false);
		mc.$blurTween2 = new Tween(mc , "$blurTweenY" , easeFunc , mc.$blurTweenY , Math.min(blurY,99) , duration , false);
		
		mc.$blurTween1.onMotionChanged = function()
		{
			var obj = this.obj;
			obj.filters = [ new BlurFilter(obj.$blurTweenX , obj.$blurTweenY , 1) ];
		}
		
		mc.$blurTween1.onMotionFinished = function()
		{
			var obj = this.obj;
			obj.$blurTween1.stop();
			obj.$blurTween2.stop();
			delete obj.$blurTween1
			delete obj.$blurTween2;
			exeFunc.apply(null , exeArray);
		}
	}
	
	/**
	* 무비클립을 지정한 값만큼 dropshadow처리를 해줍니다. 퀄리티는 1로 고정됩니다.
	* @param	mc 타겟 무비클립 
	* @param distance 쉐도우의 거리
	* @param	shadowX 쉐도우를 적용할 수치(x)
	* @param	shadowY 쉐도우를 적용할 수치(y)
	* @param	easeFunc easing클래스
	* @param shadowColor 쉐도우 컬러
	* @param shadowAngle  쉐도우의 각도
	* @param shadowAlpha 쉐도우 알파값
	* @param	duration 트위닝을 지속할 프레임값 
	* @param	exeFunc 콜백함수
	* @param	exeArray 콜백함수의 인수(Array로 지정)
	*/
	
	public static function shadowTo(mc:MovieClip , distance:Number , shadowX:Number , shadowY:Number , easeFunc:Function , shadowColor:Number , shadowAngle:Number ,  shadowAlpha:Number , duration:Number , exeFunc:Function , exeArray:Array , strengh:Number , quality:Number )
	{
		
		if ( !strengh ) strengh = 1;
		if ( !quality ) quality = 1;
		
		if (!mc.$shadowTweenX) { mc.$shadowTweenX = 0 }
		if (!mc.$shadowTweenY) { mc.$shadowTweenY = 0 }
		if (!mc.$shadowDistance) { mc.$shadowDistance = 0 }
		if (!mc.$shadowAngle) { mc.$shadowAngle = 0 }
		if (!mc.$shadowColor) { mc.$shadowColor = 0 }
		if (!mc.$shadowAlpha) { mc.$shadowAlpha = 0 }
		
		mc.$shadowTween1.stop() , mc.$shadowTween2.stop() , mc.$shadowTween3.stop();
		mc.$shadowTween4.stop() , mc.$shadowTween5.stop() , mc.$shadowTween6.stop();
		
		mc.$shadowTween1 = new Tween(mc , "$shadowTweenX" , easeFunc , mc.$shadowTweenX , Math.min(shadowX , 99) , duration , false);
		mc.$shadowTween2 = new Tween(mc , "$shadowTweenY" , easeFunc , mc.$shadowTweenY , Math.min(shadowY , 99) , duration , false);
		mc.$shadowTween3 = new Tween(mc , "$shadowDistance" , easeFunc , mc.$shadowDistance , distance , duration , false);
		mc.$shadowTween4 = new Tween(mc , "$shadowAngle" , easeFunc , mc.$shadowAngle , shadowAngle , duration , false);
		mc.$shadowTween5 = new Tween(mc , "$shadowColor" , easeFunc , mc.$shadowColor , shadowColor , duration , false);
		mc.$shadowTween6 = new Tween(mc , "$shadowAlpha" , easeFunc , mc.$shadowAlpha , shadowAlpha , duration , false);
		
		mc.$shadowTween1.onMotionChanged = function()
		{
			var obj = this.obj;
//			obj.filters = [ new DropShadowFilter( obj.$shadowDistance , obj.$shadowAngle , obj.$shadowColor , obj.$shadowAlpha , obj.$shadowTweenX , obj.$shadowTweenY ) ] ;
			obj.filters = [ new DropShadowFilter( obj.$shadowDistance , obj.$shadowAngle , shadowColor , obj.$shadowAlpha , obj.$shadowTweenX , obj.$shadowTweenY , strengh , quality ) ] ;
		}
		
		mc.$shadowTween1.onMotionFinished = function()
		{
			var obj = this.obj;
			obj.$shadowTween1.stop();
			obj.$shadowTween2.stop();
			obj.$shadowTween3.stop();
			obj.$shadowTween4.stop();
			obj.$shadowTween5.stop();
			obj.$shadowTween6.stop();
			
			delete obj.$shadowTween1
			delete obj.$shadowTween2;
			delete obj.$shadowTween3
			delete obj.$shadowTween4;
			delete obj.$shadowTween5
			delete obj.$shadowTween6;
			
			exeFunc.apply(null , exeArray);
		}
	}	
	
	
	/**
	* r,g,b값을 16진수 hex값으로 변환시켜줍니다.
	* @param r red값
	* @param g green값
	* @param b blue값
	*/

	public static function rgbToHex(r:Number, g:Number, b:Number):Number
	{ 
		return (r<<16 | g<<8 | b); 
	} 

	/**
	* 16진수 hex값을 r,g,b값으로 변환시켜줍니다.
	* @param hex 16진수 hex값
	*/

	public static function hexToRgb(hex:Number):Object
	{
		var tr:Number = (hex >> 16);
		var tg:Number = (hex >> 8 ^ tr << 8);
		var tb:Number = (hex ^ (tr << 16 | tg << 8));
		return {r:tr, g:tg, b:tb};
	}	
	
	/**
	* 무비클립에 덧붙인 경로를 알아내서 리턴합니다.
	* @param mc 무비클립
	* @param path 덧붙힐 경로 (ex:"cc.dd");
	* @return MovieClip
	*/
	
	public static function mcName(mc:MovieClip , path:String):MovieClip
	{
		var path = path.split(".");
		var tempMc:MovieClip = mc

		for (var i=0;i<path.length;i++) {
			tempMc = tempMc[path[i]];
		}
		return tempMc;
	}
	
	/**
	* 현재 작업경로가 로컬인지 아닌지 판정합니다.
	* @param mc 타겟 무비클립
	* @return Boolean
	*/
	
	public static function isLocal(mc:MovieClip)
	{
		var tempTxt:String = mc._url.substr(0,4);
		if (tempTxt=="file") 
		{
			return true;
		} 
		else
		{
			return false;
		}
	}
	
	public static function clear( mc:MovieClip )
	{
		mc.dummy_________.removeMovieClip();
		mc.frame_____.removeMovieClip();
		mc.$gradientBox.removeMovieClip();
		delete mc.$tintTween;
	}
	
	public static function delayFuncClear( mc:MovieClip )
	{
		mc.delayFuncFrame.removeMovieClip();		
	}
	
	public static function createGradientBoxMovieClip( targetMc:MovieClip ):MovieClip 
	{
		var tWidth:Number = targetMc._width * 4;
		var tHeight:Number = targetMc._height * 4;
		
		
		var gradientBox:MovieClip = targetMc.createEmptyMovieClip ( "$gradientBox" , targetMc.getNextHighestDepth() );
		
		var fillType:String = "radial"
		var colors:Array = [ 0xFFFFFF , 0xFFFFFF ];
		var alphas:Array = [ 100 , 0 ];
		var ratios:Array = [ 0 , 127 ];
		var matrix:Matrix = new Matrix();

		matrix.createGradientBox( tWidth , tHeight , 0 , -tWidth/2 , -tHeight/2 );
		var spreadMethod:String = "pad";

		gradientBox.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod); 

		gradientBox.moveTo( 0 - tWidth/2, 0 - tHeight/2 );
		gradientBox.lineTo( 0 - tWidth/2 , tHeight - tHeight/2 );
		gradientBox.lineTo( tWidth - tWidth/2 , tHeight - tHeight/2);
		gradientBox.lineTo( tWidth - tWidth/2 , 0 - tHeight/2 );
		gradientBox.lineTo( 0 - tWidth/2 , 0 - tHeight/2 ) ;
		
		gradientBox.endFill();		
		//gradientBox._rotation = -45;
		
		return gradientBox;
	}
	
	
}
