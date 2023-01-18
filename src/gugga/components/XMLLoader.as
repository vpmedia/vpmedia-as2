import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.IProgressiveTask;
import gugga.debug.Assertion;
 
[Event("start")]
[Event("progress")]
[Event("interrupted")]
[Event("completed")]

/**
 * @author todor
 */
class gugga.components.XMLLoader extends EventDispatcher implements IProgressiveTask
{
	private var UPDATE_PROGRESS_TIME:Number = 0.2;
	private var mUpdateProgressInterval:Number;		
	
	private var mIsRunning:Boolean;
	private var mInterrupted:Boolean;
	
	private var mPercentsLoaded:Number;
	
	private var mXml:XML;
	private var mContentPath:String;
	
	public function XMLLoader()
	{
		mPercentsLoaded = 0;
		mIsRunning = false;
		mInterrupted = false;
		mXml = new XML();
	}
	
	public function get Xml():XML
	{
		return mXml;
	}
	
	public function get ContentPath():String
	{
		return mContentPath;
	}

	public function set ContentPath(aValue:String)
	{
		mContentPath = aValue;
	}
		
	public function start():Void 
	{
		mPercentsLoaded = 0;
		mIsRunning = true;
		mInterrupted = false;
		load();
	}

	public function isImmediatelyInterruptable() : Boolean
	{
		return false;
	}
	
	public function interrupt() : Void
	{
		mInterrupted = true;
	}
	
	public function load(pContentPath:String):Void
	{
		if(pContentPath)
		{
			mContentPath = pContentPath;
		}
		
		mUpdateProgressInterval = setInterval(this, "onUpdateProgress", UPDATE_PROGRESS_TIME);
		
		mXml.onLoad = Delegate.create(this, onXmlLoaded);  
		
		mXml.load(mContentPath);
		dispatchEvent({type:"start", target:this});	
	}	
	
	private function onUpdateProgress():Void
	{
		var bytesTotal:Number = mXml.getBytesTotal();
		var bytesLoaded:Number = mXml.getBytesLoaded();
		
		if(bytesTotal && bytesLoaded)
		{		
			mPercentsLoaded = (bytesLoaded / bytesTotal) * 100;
		}
		else
		{
			mPercentsLoaded = 0;
		}
	
		dispatchEvent({type:"progress", target:this, xml:mXml, total:bytesTotal, current:bytesLoaded, percents:mPercentsLoaded});
	}
	
	private function onXmlLoaded(success:Boolean):Void
	{	
		mIsRunning = false;	
		clearInterval(mUpdateProgressInterval);
		onUpdateProgress();
				
		if(success)
		{
			if(mInterrupted)
			{
				dispatchEvent({type:"interrupted", target:this});
			}
			else
			{
				dispatchEvent({type:"completed", target:this, xml:mXml});
			}
		}
		else
		{
			Assertion.warning("XML file '" + ContentPath + "' not loaded ", this, arguments);
			dispatchEvent({type:"completed", target:this, xml:mXml, error:true});
		}
	}
	
	public function getProgress() : Number 
	{
		return mPercentsLoaded;
	}

	public function isRunning() : Boolean 
	{
		return mIsRunning;
	}
}