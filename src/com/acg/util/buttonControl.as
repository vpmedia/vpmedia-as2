
import mx.transitions.Tween;
import mx.transitions.easing.*;
import mx.events.EventDispatcher;
import com.acg.util.Delegate;
import com.acg.util.mcUtil;
import com.acg.menu.easing.buttonEasing;

/**
* 버튼 콘트롤 클래스
* @author 홍준수
*/

class com.acg.util.buttonControl extends EventDispatcher
{
	
	public static var CLICK:String = "click"; 
	public static var ROLL_OVER:String = "rollOver";
	public static var ROLL_OUT:String = "rollOut";
	public static var DOUBLE_CLICK:String = "doubleClick";
	
	private var container:MovieClip;
	private var t_num:Number;
	private var over:Number = 0;
	private var mcName:String;
	private var lastNum:Number;
	private var chkFlag:Boolean = true;
	private var Target:String;
	private var type:Function;
	private var num1:Number;
	private var num2:Number;
	private var easeFunc:Function;
	private var duration:Number;
	private var buttonTarget:String;
	private var timer:Number;
	
	/**
	* Method set OVER.오버값을 갱신시키는 setter메소드
	* @param over 갱신시킬 오버값
	*/
	
	public function set OVER(over:Number)
	{
		this.over = over;
		
		buttonSelect ( { num:over } );
		//dispatchEvent({type:buttonControl.ROLL_OVER , num:over});
	}
	
	/**
	* Method get OVER.오버값을 가져오는 getter이벤트
	* @return over 오버값
	*/
	
	public function get OVER()
	{
		return over;
	}
	
	public function set ENABLED(chk:Boolean)
	{
		this.chkFlag = chk;
		trace("버튼상태 변경=="+this.chkFlag);
		buttonFlag();
	}
	
	public function get ENABLED()
	{
		return this.chkFlag;
	}
	
	public function set ENABLE_SINGLE_BUTTON ( num:Number )
	{
		trace("c__________");
		buttonEnableChk ( num );
	}
	
	/**
	* Method buttonControl.생성자 
	* @param container 버튼을 담을 컨테이너
	* @param mcName 무비클립 이름
	* @param t_num 버튼갯수
	* @param type 버튼 오버시 변할 형태 지정(com.acg.menu.easing.buttonEasing package 참조 ( frame , frameTween , Default , alpha , tint ) )
	* @param clickAlive 버튼 클릭시 버튼 활성화 여부 지정(true:활성화됨 , false:활성화 되지 않음)
	*/
	
	public function buttonControl(container:MovieClip , mcName:String , t_num:Number , type:Function , clickAlive:Boolean)
	{
		this.container = container;
		this.mcName = mcName;
		this.t_num = t_num;
		this.type = type;
		if (!type) { this.type=buttonEasing.Default }
		EventDispatcher.initialize(this);
		
		addEventListener(buttonControl.ROLL_OVER , Delegate.create( this , buttonSelect ) );
		addEventListener(buttonControl.ROLL_OUT , Delegate.create( this , buttonSelect ) );
		
		(clickAlive) ? addEventListener(buttonControl.CLICK, Delegate.create(this,clickButton)) : null;
	}
	
	public function init()
	{
		enabledButton();
		dispatchEvent({type:buttonControl.ROLL_OVER , num:over});
	}
	
	/**
	* 버튼오버시 이동수치 지정
	* @param target : 버튼 내 이동시킬 클립 지정(default:this)
	* @param num1 : 롤아웃시
	* @param num2 : 롤오버시
	*/
	
	public function setStyle(easeTarget:String , buttonTarget:String , easeFunc:Function , num1:Number , num2:Number , duration:Number)
	{
		this.Target = easeTarget;
		this.buttonTarget = buttonTarget;
		
		this.easeFunc = easeFunc;
		this.num1 = num1;
		this.num2 = num2;
		this.duration = duration;
	}
	
	private function buttonFlag()
	{
		for (var i=1;i<=t_num;i++) 
		{
			if (buttonTarget) {
				var ddk:MovieClip = mcUtil.mcName(container[mcName+i], buttonTarget);
			} else {
				var ddk:MovieClip = container[mcName+i];
			}
			trace("버튼타겟==="+ddk);
			ddk.enabled = this.chkFlag;
		}
	}
	
	/**
	* Method enabledButton.버튼을 자동으로 활성화시켜 줍니다.
	*/
	
	private function enabledButton()
	{
		var owner:Object = this;
		for (var i=1;i<=t_num;i++) 
		{
			var ddk2:MovieClip = container[mcName+i];
			
			if (buttonTarget) {
				var ddk:MovieClip = mcUtil.mcName(container[mcName+i], buttonTarget);
			} else {
				var ddk:MovieClip = container[mcName+i];
			}

			ddk2.stop();
			ddk.num = i;
			
			ddk.onRollOver = function() 
			{
				owner.dispatchEvent({type:buttonControl.ROLL_OVER , num:this.num , chkNum:this.num , mc:this});
			}
			ddk.onRollOut = ddk.onReleaseOutside = function()
			{
				owner.dispatchEvent({type:buttonControl.ROLL_OUT , num:owner.over , chkNum:this.num , mc:this});
			}
			ddk.onRelease = function()
			{
				if (owner.checkDoubleClick()) {
					owner.dispatchEvent({type:buttonControl.DOUBLE_CLICK , num:this.num , obj:this});
				} else {
					owner.dispatchEvent({type:buttonControl.CLICK , num:this.num , obj:this});
				}
			}
		}
	}
	
	/**
	* Method buttonSelect.버튼 오버시 오버값으로 활성화 비활성화 시켜줍니다.
	* @param num 활성화시킬 버튼넘버
	*/
	
	private function buttonSelect(e:Object)
	{
		var num = e.num;
		
		if (Target) {
			var ddk:MovieClip = mcUtil.mcName(container[mcName+num], Target);
			var ddk2:MovieClip = mcUtil.mcName(container[mcName+lastNum], Target);
		} else {
			var ddk:MovieClip = container[mcName+num];
			var ddk2:MovieClip = container[mcName+lastNum];
		}
		
		type.apply(null , [ddk2 , num1 , num2 , false , easeFunc , duration]);
		type.apply(null , [ddk , num1 , num2 , true , easeFunc , duration]);
			
		lastNum = num;
	}
	
	/**
	* Method clickButton.버튼클릭시 
	* @param e 이벤트 타겟입니다.
	* @param e.num 이벤트로 넘어올 버튼넘버 값입니다.
	*/
	
	private function clickButton(e:Object) {
		OVER = e.num;
	}
	
	/**
	* 더블클릭인지 단순클릭인지 여부를 판정해주는 메소드입니다. 
	* @return Boolean
	*/
	
	private function checkDoubleClick():Boolean
	{
		if (getTimer() - timer<300) {
			return true;
		} else {
			timer = getTimer();
			return false;
		}
	}
	
	private function buttonEnableChk ( num:Number )
	{
		trace("실행?");
		if (buttonTarget) {
			var ddk:MovieClip = mcUtil.mcName( container[ mcName + num ], buttonTarget);
		} else {
			var ddk:MovieClip = container[ mcName + num ];
		}		
		ddk.enabled = !ddk.enabled;
		
		
		trace( ddk.enabled );
	}
}
