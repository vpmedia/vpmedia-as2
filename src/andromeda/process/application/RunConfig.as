
import andromeda.process.abstract.AbstractActionLoader;

import asgard.config.ConfigEdenLoader;
import asgard.events.LoaderEvent;

import vegas.events.Delegate;

/**
 * This control launch the loading of the configuration.
 * @author eKameleon
 */
class andromeda.process.application.RunConfig extends AbstractActionLoader
{
	
	/**
	 * Creates a new RunConfig instance.
	 */
	public function RunConfig( fileName:String , pathName:String, suffixName:String ) 
	{
		if (fileName != null)
		{
			this.fileName   = fileName ;
		}
		if (pathName != null)
		{
			this.pathName   = pathName ;
		}
		if (suffixName != null)
		{
			this.suffixName = suffixName ;
		}		
	}

	/**
	 * The name of the config file.
	 */
	public var fileName:String = "config" ;
	
	/**
	 * The name of the path of the config file.
	 */
	public var pathName:String = "config/";

	/**
	 * The name of the suffix of the config file.
	 */
	public var suffixName:String = ".eden" ;

	/**
	 * Run the process.
	 */
	public function run() 
	{
		
		notifyStarted() ;
			
		getLogger().debug( this + " run.") ;

		buRRRn.eden.config.security = false ;
		
		var loader:ConfigEdenLoader = new ConfigEdenLoader() ;
		if (fileName)
		{
			loader.fileName = fileName ;
		}
		if ( pathName )
		{
			loader.path = pathName ;
		}
		if ( suffixName )
		{
			loader.suffix = suffixName ;
		}
		loader.addEventListener(LoaderEvent.START , new Delegate(this, notifyStarted), null, 1000, true) ;
		loader.addEventListener(LoaderEvent.INIT  , new Delegate(this, notifyFinished), null, 1000, true) ;
		registerLoader( loader ) ;

		loader.load() ;
		
	}

}