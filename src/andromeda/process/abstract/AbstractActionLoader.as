
import andromeda.core.ApplicationCommand;

import asgard.config.Config;
import asgard.events.LoaderEvent;
import asgard.net.ILoader;

import pegas.process.SimpleAction;

import vegas.events.Delegate;
import vegas.events.EventTarget;

/**
 * This skeletal class simplify the implementation of the process with an internal ILoader process in the application.
 * @author eKameleon
 */
class andromeda.process.abstract.AbstractActionLoader extends SimpleAction 
{

	/**
	 * Creates a new AbstractActionLoader instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */	
	function AbstractActionLoader( bGlobal:Boolean, sChannel:String ) 
	{
		super(bGlobal, sChannel);		
	}

	/**
	 * Returns the config object of the application. 
	 * You can overrides this method.
	 * @return the config object of the application.
	 */
	public function getConfig()
	{
		return Config.getInstance() ;
	}	

	/**
	 * Notify an ActionEvent when the process is finished.
	 */
	public function notifyFinished():Void
	{
		_setRunning(false) ;
		ApplicationCommand.hideLoader() ;
		super.notifyFinished() ;	
	}
	
	/**
	 * Notify an ActionEvent when the process is started.
	 */
	public function notifyStarted():Void
	{
		_setRunning(true) ;
		super.notifyStarted() ;	
	}

	/**
	 * Register the process loader object.
	 */
	public function registerLoader( loader:ILoader )
	{
		EventTarget(loader).addEventListener( LoaderEvent.COMPLETE , new Delegate(this, _onLoadComplete) ) ;
 		EventTarget(loader).addEventListener( LoaderEvent.IO_ERROR , new Delegate(this, _onLoadError) ) ;
 		EventTarget(loader).addEventListener( LoaderEvent.PROGRESS , new Delegate(this, _onLoadProgress ) ) ;
 		EventTarget(loader).addEventListener( LoaderEvent.TIMEOUT  , new Delegate(this, _onLoadTimeout ) ) ;
 		return loader ;
	}

	private function _onLoadError(ev:LoaderEvent):Void
	{
	    getLogger().error(  this + " " + ev.getType() + " : " + ev.error ) ;
	   	notifyFinished() ;
	}
	
	private function _onLoadComplete(ev:LoaderEvent):Void
	{
	    getLogger().debug( this + " load complete." ) ;
	}	
	
	private function _onLoadProgress (ev:LoaderEvent):Void
	{
	    getLogger().info(  this + " load progress : " + ev.getPercent() + "%") ;
	   	ApplicationCommand.changeLoader( this + " " + ev.getPercent() + "%", ev.getPercent() ) ;
	}
	
	private function _onLoadTimeout (ev:LoaderEvent):Void
	{
		getLogger().debug(  this + " load timeout." ) ;
	   	notifyFinished() ;
	}

}