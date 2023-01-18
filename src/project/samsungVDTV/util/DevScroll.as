/**
 * 삼성 VDTV 스크롤 컨텐츠
 * @author 이정득
 */

import mx.transitions.Tween;
import mx.transitions.easing.*;
import com.acg.util.Delegate;
import mx.events.EventDispatcher;
	
class project.samsungVDTV.util.DevScroll extends EventDispatcher
{
	public static var CHANGE:String = "onChanged";
	private var target:MovieClip;					//타겟 무비 클립
	private var maskMc:MovieClip;					//마스크 무비클립;
	
	private var tween:Tween;
	private var num:Number = 0;
	private var oldNum:Number;
	private var wNum:Number;
	private var devNum:Number
	private var mouseListener:Object = new Object();

	public function DevScroll( target:MovieClip , maskMc:MovieClip , devNum:Number )
	{
		this.target = target;
		this.maskMc = maskMc;
		this.wNum = target._parent._width - target._width
		this.devNum = devNum;
		
		eventHandler()
	};
	
	public function stop()
	{
		tween.stop();
	}
	
	private function eventHandler()
	{
		target.onPress = Delegate.create ( this , onDownFn ) 
		target.onRelease = target.onReleaseOutside = Delegate.create( this , onUpFn ); 
		maskMc.onRollOver = Delegate.create ( this , maskOver  )
		maskMc.onRollOut = maskMc.onReleaseOutside = Delegate.create ( this , maskOut );
		maskMc.useHandCursor = false;
		Mouse.addListener(mouseListener);	
	};

	private function onDownFn( )
	{
		//trace("down");
		tween.stop();
		target.startDrag( false , 0 , 0 , wNum , 0 );
		target.onMouseMove = Delegate.create ( this , moveFn )
	};

	private function onUpFn( )
	{
		//trace("over");
		target.stopDrag();
		num = Math.round( ( (devNum-1) / wNum ) * target._x );
		var totalNum = ( ( wNum / (devNum-1) )* num );
		tween = new Tween( target , "_x" , Strong.easeOut , target._x , totalNum , 30 , false );
		
		if ( num != oldNum )dispatchEvent( { type:DevScroll.CHANGE , num:num } );
		oldNum = num;
	};
	
	private function moveFn()
	{
		updateAfterEvent();
		num = Math.round( ( (devNum - 1) / wNum ) * target._x );
		//dispatchEvent({ type:DevScroll.CHANGE , num:num });
	};

	private function maskOver( )
	{
		this.mouseListener.onMouseWheel = Delegate.create ( this , wheelOver );
	};
	
	private function maskOut( )
	{
		delete this.mouseListener.onMouseWheel
	};
	
	private function wheelOver( delta:Number )
	{
		if( delta < 0 )
		{
			tween.stop();
			this.num--
			if( num < 0 )num = 0	
			var totalNum = ( ( wNum / (devNum-1) )* num )
			tween = new Tween( target , "_x" , Strong.easeOut , target._x , totalNum , 50 , false );	
		}
		else
		{
			tween.stop();
			num++
			if( num > devNum-1 )num = devNum	-1
			var totalNum = ( ( wNum / (devNum-1) )* num )
			tween = new Tween( target , "_x" , Strong.easeOut , target._x , totalNum , 50 , false );	
		};
		
		if ( num != oldNum ) dispatchEvent( { type:DevScroll.CHANGE , num:num } );
		oldNum = num;
	};
};