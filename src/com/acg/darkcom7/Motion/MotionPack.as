/**
* @author 나민욱
* @version 2.0
*/

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import mx.transitions.Tween;

import com.acg.darkcom7.Ease. *;
import com.acg.util.Delegate

class com.acg.darkcom7.Motion.MotionPack extends MovieClip
{
	/**
	* 생성자
	*/
	public function MotionPack ()
	{
		super ()
	}
	/**
	* 
	* @param	mc             대상무비클립
	* @param	prop          속성 오브젝트
	* @param	duration     이동시간
	* @param	EaseFunc  이징타입
	* @param	callTime     함수 호출 타임 
	* @param	callRefer    호출 함수 this 레퍼런스
	* @param	callFunc    호출 함수 네임 
	* @param	callPara    호출함수 파라메터
	*/
public static function Tween (mc : Object, prop : Object, duration : Number, EaseFunc:Function, callTime : Number, callRefer : Object , callFunc : Function,  callPara : Array)
	{
		if(EaseFunc == null)EaseFunc = Quint.easeOut
		
		var TweenID = 0    //아이디 
		var Count = 0
		
		for (var z in prop)
		{
		   TweenID++
		   
		   mc ["temp" + z].stop()
		   mc ["temp" + z] = new Tween (mc, z, EaseFunc, mc [z] , prop [z] , duration, false );
		   mc ["temp" + z].id = TweenID
		   
		   //모션 
		   mc ["temp" + z].onMotionChanged = function ()
		   {
				if(!callTime)
				{
				Delegate.create (callRefer, callFunc).call (null, mc, mc [z])
				}else
				{
					if(this.id == 1 )
					{
						Count++
						if (Count == callTime)
						{
							Delegate.create (callRefer, callFunc).apply (null, callPara)
						}
					}	
				}
			} 
		}
	}
	/**
	* 
	* @param	mc 트윈을 중지할 오브젝트 
	*/
	public static function TweenStop (mc : Object )
	{
		for( var z in mc )
		{
			if(mc[ z ].toString()== "[Tween]")
			{
				//trace("죽일 트윈   :  "+mc[ z ])
				mc[ z ].stop()
				delete mc[ z ]

			}
		}
	}
	/**
	* 
	* @param	mc        대상 무비클립 
	* @param	s_num  시작 프레임
	* @param	p_num  마지막 프레임
	* @param	term      프레임 단위 (+ ,- 사용 )
	* @param	refer     호출 함수 this 레퍼런스  
	* @param	fun        호출 함수 네임 
	* @param	para     호출함수 파라메터
	*/
	public static function ctr_frame (mc : MovieClip, s_num : Number, p_num : Number, term : Number, refer : Object, fun : Function, para : Array)
	{
		//trace("실행")
		if (s_num == null && p_num == null && term == null)
		{
			s_num = mc._currentframe
			p_num = mc._totalframes
			term = 1
		}
		if (s_num == 0)
		{
			s_num = mc._currentframe
			p_num = 1
			term = - 1
		}
		var tmc = mc;
		tmc.gotoAndStop (s_num);
		if (mc.ctr_frame_1)
		{
			delete mc.ctr_frame_1.onEnterFrame;
			mc.ctr_frame_1.removeMovieClip ();
		}
		var temp_mov : MovieClip = mc.createEmptyMovieClip ("ctr_frame_1", 1);
		temp_mov.onEnterFrame = function ()
		{
			if ((term > 0&&tmc._currentframe < p_num && tmc._currentframe + term <= p_num) || (term < 0&&tmc._currentframe > p_num && tmc._currentframe + term >= p_num))
			{
				tmc.gotoAndStop (tmc._currentframe + term);
			} 
			else
			{
				tmc.gotoAndStop (p_num);
				delete this.onEnterFrame;
				this.removeMovieClip ();
				if (fun)
				{
					mx.utils.Delegate.create (refer, fun).apply (refer, para);
				}
			} // end else if
			
		};
	}
	/**
	* 
	* @param	mc       대상 무비클립 
	* @param	option  비트맵 그리기 부울값 
	* @param	matrix  매트릭스 객체 
	* @param	refer    this 레퍼런스  
	* @param	fun      호출함수 네임 
	* @param	para   호출함수 파라메터 
	*/
	public static function freez_disp (mc : MovieClip, option : Boolean, matrix : Matrix, refer : Object, fun : Function, para : Array)
	{
		if ( ! option)
		{
			if ( ! mc.container_mc)
			{
				var container_mc : MovieClip = mc.createEmptyMovieClip ("container_mc", mc.getNextHighestDepth () + 16000);
				var image_mc : MovieClip = container_mc.createEmptyMovieClip ("image_mc", 1);
			}
			//
			//텍스트 필드의 크기와 같고 투명한 bitmap data를 생성한다.
			if ( ! matrix)
			{
				var tmatrix : Matrix = new Matrix ();
			} else
			{
				tmatrix = matrix;
				container_mc._x = - tmatrix.tx;
				container_mc._y = - tmatrix.ty;
			}
			var Width : Number
			var Height : Number
			if (mc._width > 2880)
			{
				Width = 2880
				Height = mc._height
			} else if (mc._height > 2880)
			{
				Width = mc._width
				Height = 2880
			} else if (mc._height > 2880&&mc._width > 2880)
			{
				Width = 2880
				Height = 2880
			} else
			{
				Width = mc._width
				Height = mc._height
			}
			image_mc.freez_disp_img = new BitmapData (Width, Height, true, 0x00CCCCCC);
			image_mc.freez_disp_img.draw (mc, tmatrix, null, null, null, true);
			//텍스트 필드의 내용을 bitmap data에 쓴다.
			image_mc.attachBitmap (image_mc.freez_disp_img , mc.getNextHighestDepth (),"always",true);
			//만들어진 bitmap을 대상 movieClip에 붙인다.
			for (var p in mc)
			{
				if (mc [p] != container_mc)
				{
					mc [p]._visible = false;
				}
			}
		} else
		{
			//비트맵을 푼다 
			mc.container_mc.image_mc.freez_disp_img.dispose ();
			mc.container_mc.swapDepths (mc.getNextHighestDepth () + 1);
			mc.container_mc.removeMovieClip ();
			for (var p in mc)
			{
				mc [p]._visible = true;
			}
		}
		if (fun)
		{
			mx.utils.Delegate.create (refer, fun).apply (null, para);
		}
	}
	/**
	* 
	* @param	mc:모두 멈추게할 대상 무비클립
	*/
	public static function stopAllMc (mc : MovieClip)
	{
		mc.stop ();
		for (var z in mc)
		{
			if (mc [z] instanceof MovieClip)
			{
				MotionPack.stopAllMc (mc [z])
			}
		}
	}
	/**
	*
	* @param	mc:모두 움직이게할 대상 무비클립
	*/
	public static function PlayAllMc (mc : MovieClip)
	{
		mc.play ();
		for (var z in mc)
		{
			if (mc [z] instanceof MovieClip)
			{
				MotionPack.PlayAllMc (mc [z])
			}
		}
	}
	/**
	* 
	* @param	mc      대상 무비클립 
	* @param	tx        X타겟 스케일 
	* @param	ty        Y타겟 스케일 
	* @param	setVX  X진폭 값 
	* @param	setVY  Y진폿 값 
	*/
	public static function ElasticScale (mc, tx, ty,setVX,setVY)
	{
			if(!setVX||!setVY){
				var vx = 30;
				var vy =  -30;
			}else{
				var vx = setVX
				var vy= setVY
			}
		mc.onEnterFrame = function ()
		{
			vx = (tx - this._xscale) * 0.2 + vx * 0.7;
			this._xscale += vx;
			vy = (ty - this._yscale) * 0.2 + vy * 0.7;
			this._yscale += vy
			//trace ("X 축 반동    :   " + vx)
			//trace ("Y 축 반동    :   " + vy)
			//trace (">>>>>>>>>>>>>>")
			if (Math.abs (vx) < 0.05&&Math.abs (vy) < 0.05)
			{
				delete this.onEnterFrame;
				//trace ("END")
			}
			// end if
			
		}
	}

}
	
	
	
