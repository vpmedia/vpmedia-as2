import com.jxl.shuriken.core.UIComponent;

class com.jxl.shuriken.utils.LoopUtils
{
	
	private var __loop_mc:MovieClip;
	private var __isIUI:Boolean;
	
	private var __currentIndex:Number;
	private var __startIndex:Number;
	private var __endIndex:Number;
	private var __increment:Number;
	
	private var __startRow:Number;
	private var __startCol:Number;
	private var __endRow:Number;
	private var __endCol:Number;
	private var __currentRow:Number;
	private var __currentCol:Number;
	private var __rowIncrement:Number;
	private var __colIncrement:Number;
	
	private var __o:Object;
	private var __props:Array;
	
	private var __scope:Object;
	private var __callback:Function;
	private var __callbackDone:Function;
	
	
	
	public function LoopUtils(p_mc:MovieClip)
	{
		__loop_mc = p_mc;
		if(__loop_mc instanceof UIComponent)
		{
			__isIUI = true;
		}
		else
		{
			__isIUI = false;
		}
	}
	
	public function forLoop(p_from:Number, 
							p_to:Number, 
							p_increment:Number, 
							p_scope:Object, 
							p_func:Function, 
							p_doneFunc:Function):Void
	{
		__startIndex		= p_from;
		__endIndex			= p_to;
		__increment			= p_increment;
		__scope				= p_scope;
		__callback			= p_func;
		__callbackDone		= p_doneFunc;
		
		__currentIndex 		= __startIndex;
		
		startProcessing(processNextForLoop);
	}
	
	public function gridLoop(p_startIndex:Number,
							 p_increment:Number,
							 p_startRow:Number,
							 p_startCol:Number,
							 p_endRow:Number,
							 p_endCol:Number,
							 p_rowIncrement:Number,
							 p_colIncrement:Number,
							 p_scope:Object,
							 p_func:Function,
							 p_doneFunc:Function):Void
	{
		
		__currentIndex		= p_startIndex;
		__increment			= p_increment;
		__startRow			= p_startRow;
		__startCol			= p_startCol;
		__endRow			= p_endRow;
		__endCol			= p_endCol;
		__rowIncrement		= p_rowIncrement;
		__colIncrement		= p_colIncrement;
		__scope				= p_scope;
		__callback			= p_func;
		__callbackDone		= p_doneFunc;
		
		__currentRow 		= __startRow;
		__currentCol		= __startCol;
		
		startProcessing(processNextGridLoop);
	}
	
	public function forInLoop(p_obj:Object,
							  p_scope:Object,
							  p_func:Function,
							  p_done:Function):Void
	{
		__o 				= p_obj;
		__scope				= p_scope;
		__callback			= p_func;
		__callbackDone		= p_done;
		
		startProcessing(processNextForIn);
	}
	
	
	private function startProcessing(p_targetLoopFunc:Function):Void
	{
		if(__isIUI == true)
		{
			__loop_mc.callLater(this, p_targetLoopFunc);
		}
		else
		{
			__loop_mc.scope = this;
			__loop_mc.func = p_targetLoopFunc;
			__loop_mc.onEnterFrame = function()
			{
				this.func.call(this.scope);
			};
		}
		
		p_targetLoopFunc.call(this);
	}
	
	public function stopProcessing():Void
	{
		if(__isIUI == false) deleteVars();
	}
	
	private function processNextForLoop():Void
	{
		if(__currentIndex < __endIndex)
		{
			runCallback();
			if(__currentIndex + __increment < __endIndex)
			{
				__currentIndex += __increment;
				if(__isIUI == true) __loop_mc.callLater(this, processNextForLoop);
			}
			else
			{
				stopProcessing();
				runDoneCallback();
			}
		}
		else
		{
			stopProcessing();
			runDoneCallback();
		}
	}
	
	private function processNextGridLoop():Void
	{
		if(__currentRow < __endRow)
		{
			if(__currentCol < __endCol)
			{
				runCallback();
				__currentIndex += __increment;				
				__currentCol++;
				if(__isIUI == true) __loop_mc.callLater(this, processNextGridLoop);
			}
			else
			{
				if(__currentRow < __endRow)
				{
					__currentCol = 0;
					__currentRow++;
					processNextGridLoop();
				}
				else
				{
					stopProcessing();
					runDoneCallback();
				}
				
			}
		}
		else
		{
			stopProcessing();
			runDoneCallback();
		}
	}
	
	private function processNextForIn():Void
	{
		if(__props != null)
		{
			if(__props.length > 0)
			{
				var nextProp:String = String(__props.shift());
				__callback.call(__scope, nextProp, __o[nextProp]);
			}
			else
			{
				// we're done
				stopProcessing();
				runDoneCallback();
			}
		}
		else
		{
			// first time
			__props = [];
			for(var p:String in __o)
			{
				__props.push(p);
			}
			
			if(__props.length < 1)
			{
				// nothing to iterate
				stopProcessing();
				runDoneCallback();
			}
		}
	}
	
	private function runCallback():Void
	{
		__callback.call(__scope, __currentIndex, __currentRow, __currentCol);
	}
	
	private function runDoneCallback():Void
	{
		__callbackDone.call(__scope);
		delete __scope;
		delete __callback;
		delete __callbackDone;
	}
	
	private function deleteVars():Void
	{
		delete __loop_mc.scope;
		delete __loop_mc.func;
		delete __loop_mc.onEnterFrame;
		
		delete __currentIndex;
		delete __startIndex;
		delete __endIndex;
		delete __increment;
		
		delete __startRow;
		delete __startCol;
		delete __endRow;
		delete __endCol;
		delete __currentRow;
		delete __currentCol;
		delete __rowIncrement;
		delete __colIncrement;
		
		delete __o;
		delete __props;
	}
	
	public function destroy(p_destroyClip:Boolean):Void
	{
		deleteVars();
		
		if(p_destroyClip != true) return;
		
		__loop_mc.removeMovieClip();
		delete __loop_mc;
		delete __isIUI;
	}
	
	
}