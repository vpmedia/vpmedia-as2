
import mx.transitions.Tween;
import mx.transitions.easing.*;
import com.acg.darkcom7._Color.getColorTrans
import flash.geom.ColorTransform;
import flash.geom.Transform;

/**
* 무비클립 제어 클래스
* @author 홍준수
* @date 2007.3.15
*/

class com.acg.darkcom7._Color.TweenColor {
   
	/**
	* 지정한 무비클립의 컬러를 지정한 컬러로 바꿔줍니다.
	* @param mc 무비클립
	* @param targetRGB 바꿔줄 컬러값 
	* @param easeFunc easing클래스
	* @param duration 트위닝을 지속할 프레임값    
	*/


   public static function colorTo(mc:MovieClip, targetRGB:Number, easeFunc:Function,duration:Number)
	{
		var trans:Transform = new Transform(mc);
		
		var colorTrans:ColorTransform = new ColorTransform();
		
		mc.r = trans.colorTransform.redOffset;
		mc.g = trans.colorTransform.greenOffset;
		mc.b = trans.colorTransform.blueOffset;
		
		var target = TweenColor .hexToRgb(targetRGB);
		
		mc.cm1.stop() , mc.cm2.stop() , mc.cm3.stop() ,mc.cm4.stop();
		
		mc.cm1 = new Tween(mc, "r" , easeFunc, mc.r , target.r , duration , false);
		mc.cm2 = new Tween(mc, "g" , easeFunc, mc.g , target.g , duration , false);
		mc.cm3 = new Tween(mc, "b" , easeFunc, mc.b , target.b , duration , false);
		
		mc.cm1.trans = trans;
		mc.cm1.colorTrans = colorTrans;
		
		mc.cm1.onMotionChanged = function() {
			var obj = this.obj;
			var tempRGB = TweenColor .rgbToHex(obj.r , obj.g , obj.b);
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
	
	public static function tintTo(mc:MovieClip ,rgb:Number,amt:Number, duration:Number, easeFunc:Function ,Refer:MovieClip, exeFunc:Function , exeArray:Array )
	{
		if(!mc.$tintTween){mc.$tintTween=0}
		mc.$tween.stop()
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
			mx.utils.Delegate.create (Refer, exeFunc).apply(null , exeArray);
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
	
	
	
	/**
	* 스파클
	* @param	mc 대상 오브젝트 
	*/
	public static function advanceColor (mc:MovieClip , easeFunc:Function , duration:Number  )
	{
		var trans:Transform = new Transform(mc);

		mc.advance =255 
		
		mc.DummyTween.stop() 
		
		mc.DummyTween = new Tween(mc, "advance" , easeFunc, 255 , 0 , duration , false);
		
		mc.DummyTween.trans = trans;
		
		
		mc.DummyTween.onMotionChanged = function() {
			var obj = this.obj;
			var value = obj.advance
			var colorTrans:ColorTransform = new ColorTransform(1,1,1,1,value,value,value,0);
			this.trans.colorTransform = colorTrans;
			
		}
		
		mc.DummyTween.onMotionFinished = function() {
			var obj = this.obj;
			obj.DummyTween.stop() 
			var colorTrans:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
			this.trans.colorTransform = colorTrans;
		}
	}   
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
