import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.components.ImageLoader;
import gugga.utils.DebugUtils;
import gugga.utils.Listener;
/**
 * @author Barni
 * 
 * TODO: Could be renamed in more abstract way. And also implemented in that way.
 * Especially in triggerLoad method.
 */
class gugga.components.ImageLoaderScheduler 
{
	private static var MAX_SIMULTANEOUS_LOADERS : Number = 3;
	
	private static var mInstance : ImageLoaderScheduler = new ImageLoaderScheduler();
	public static function get Instance() : ImageLoaderScheduler
	{	
		return mInstance;
	}	
	
	private var mPendingLoaders : Array;
	/**
	 * TODO: Items should sealed classes.
	 */
	private var mCurrentlyRunningLoaders : Array; // {loader : ImageLoader, listener : Listener}
	
	private function ImageLoaderScheduler()
	{
		mPendingLoaders = new Array();
		mCurrentlyRunningLoaders = new Array(MAX_SIMULTANEOUS_LOADERS);	
	}
	 
	public function addLoader(aLoader : ImageLoader) : Void 
	{
		//DebugUtils.traceContext("", this, arguments);
		mPendingLoaders.push(aLoader);
		refreshCurrentlyRunningLoaders();
	}
	
	/**
	 * TODO: To be implemented
	 */
	public function removeLoader(aLoader : ImageLoader) : Void 
	{
		//DebugUtils.traceContext("", this, arguments);
		var wasCurrentlyRunning : Boolean = removeCurrentlyRunningLoader(aLoader);
		if(!wasCurrentlyRunning)
		{
			removePendingLoader(aLoader);
		}
	}
	
	private function removeCurrentlyRunningLoader(aLoader : ImageLoader) : Boolean
	{
		var	result : Boolean = false;
		
		for (var i : Number = 0; i < mCurrentlyRunningLoaders.length; i++)
		{
			if(mCurrentlyRunningLoaders[i].loader == aLoader)
			{
				Listener(mCurrentlyRunningLoaders[i].listener).stop();
				mCurrentlyRunningLoaders.splice(i, 1);
				result = true;
				break;
			}
		}
		
		return result;
	}
	
	private function removePendingLoader(aLoader : ImageLoader) : Boolean
	{
		var	result : Boolean = false;
		
		for (var i : Number = 0; i < mPendingLoaders.length; i++)
		{
			if(mPendingLoaders[i] == aLoader)
			{
				mPendingLoaders.splice(i, 1);
				result = true;
				break;
			}
		}
		
		return result;
	}

	public function canLoad(aLoader : ImageLoader) : Boolean 
	{
		var result : Boolean = false;
		for (var i : Number = 0; i < mCurrentlyRunningLoaders.length; i++)
		{
			if(mCurrentlyRunningLoaders[i].loader == aLoader)
			{
				result = true;
				break;
			}
		}
		return result;	
	}
	
	private function refreshCurrentlyRunningLoaders() : Void
	{
		while(mCurrentlyRunningLoaders.length <= MAX_SIMULTANEOUS_LOADERS)
		{
			var loader : ImageLoader = ImageLoader(mPendingLoaders.shift());
			if(loader)
			{
				var listener : Listener = Listener.createSingleTimeMergingListener(new EventDescriptor(loader, "completed"),
					Delegate.create(this, onLoaderCompleted), {loader : loader});
					
				mCurrentlyRunningLoaders.push({loader : loader, listener : listener});
				loader["triggerLoad"]();
			}
			else
			{
				break;
			}
		}
	}
	
	private function onLoaderCompleted(ev) : Void
	{
		removeCurrentlyRunningLoader(ev.loader);
		refreshCurrentlyRunningLoaders();
	}
}