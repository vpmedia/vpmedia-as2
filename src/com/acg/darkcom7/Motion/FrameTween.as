 /**************************************************************
* 1. 파일명 : FrameTween.as
* 2. 제작목적 : 무비클럽 프레임 트윈 제어
* 3. 제작자 : 유주상(Hiddenid)
* 4. 제작일 : Thu Jun 29 20:28:46 2006
* 5. 최종수정일 : Thu Jun 29 20:28:50 2006
* 6. 부가설명 : 무비클럽 프레임 트윈 제어
* 7. 주요매소드  : 
* 							@ FrameTween
* 							@ yoyo
* 9. 리턴값 : void
* 10. 사용법 :
*
* 
* 1. 
				import Lib.Cloud9.Hiddenid.Movieclip.*;
				import Lib.com.robertpenner.easing.*;

				var tween = new FrameTween(this.mc, Bounce.easeInOut, 10, this.mc._totalframes, 40);
				
	2. 		this._parent.tween.yoyo();

**************************************************************/

/*****************************************************************
펑션타입정의 

      Linear
      Quad
      Cubic
      Quart
      Quint
      Sine
      Expo
      Circ  -==> Strong타입
      Elastic
      Back
      Bounce


******************************************************************/

import Ease.*;
class Motion.FrameTween{
	var t_mov:MovieClip;//트윈제어 타켓 무비클럽
	var func:Function;//트윈펑션 타입
	var begin:Number;//초기값
	var _finish:Number;//최종값
	var _duration:Number;//트윈시간
	var _time:Number = 0;//현재 경과시간
	var _pos:Number = 0 ;//현재위치
	var _cfinish:Number = 0;//변경되어야 할 변화값
	var Func:Function
	var Refer:MovieClip
	var para:Array
	
/************************************************************************
* 1. 메소드명 : FrameTween
* 2. 메소드기능 : 트윈 대상과 시작,마지막값, 총진행시간등의 파라미터를 받아서 맴버속성으로 돌린다.
*  3. 파라미터 : 
* 		@mc : 타켓무비클럽
* 		@f_name : 트윈펑션네입
* 		@start : 초기시작값
* 		@end : 최종값
* 		@d_time :  플래이시간
* 4. 리턴값 : void
* 5. 참고사항 : 
* ***********************************************************************/	

	//생성자
	function FrameTween(mc:MovieClip, f_name:Function, start:Number, end:Number, d_time:Number,refer:MovieClip,func:Function,para:Array){
		this.t_mov = mc;
		this.func = f_name;
		this.begin = start;
		this._finish = end;
		this._duration = d_time;
		this._cfinish = end- start;
		this.init();
		this.Func = func
		this.para = para
		this.Refer = refer
	}
	
	
	private function init(){
		this.t_mov.gotoAndStop(this.begin);
		this.moveframe();
	}
	
	private function moveframe(){
		var temp_mov:MovieClip = t_mov.createEmptyMovieClip("frame_util_1", 1);
		var temp = this;
		
		temp_mov.onEnterFrame = function(){

			temp._pos = Math.floor(temp.getPosition ());
			temp.t_mov.gotoAndStop(temp._pos);
			
						
			if(temp._time >= temp._duration){
				delete this.onEnterFrame;
				temp.t_mov.gotoAndStop(temp._finish);
				this.removeMovieClip();
				if(temp.t_mov._currentframe!=1){
				mx.utils.Delegate.create (temp.Refer, temp.Func).apply (temp.Refer, temp.para)
			}
			}else{
				temp._time++;
			}

		}
		
	}

/************************************************************************
* 1. 메소드명 : yoyo
* 2. 메소드기능 : 트윈된 프레임을 다시 원상복구(리와인드) 시킨다.
* 3. 파라미터 : 
* 4. 리턴값 : void
* 5. 참고사항 : 
* ***********************************************************************/	
	public function yoyo(){
		var t_begin  = this.begin;
		this.begin = this._finish;
		this._finish = t_begin
		this._cfinish = this._finish - this.begin;
		this._time = 0;
		this.moveframe();
	}
	
	private function getPosition (t:Number):Number {	

		if (t == undefined) t = this._time;
		return this.func (t, this.begin, this._cfinish, this._duration);
	}
	
	function set finish (f:Number):Void {
		this._pos = f - this.begin;
	};

	function get finish ():Number {
		return this.begin + this._pos;
	};
	
}