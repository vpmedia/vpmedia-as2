
import andromeda.process.abstract.AbstractActionLoader;

import asgard.config.Config;
import asgard.system.EdenLocalizationLoader;
import asgard.system.Lang;
import asgard.system.Localization;

import vegas.events.Delegate;

/**
 * This control launch the loading of the localization of the current Lang.
 * @author eKameleon
 */
class andromeda.process.application.RunLocalization extends AbstractActionLoader
{
	
	/**
	 * Creates a new RunLocalization instance.
	 */
	public function RunLocalization( prefixName:String , pathName:String ) 
	{
		
		if (pathName != null)
		{
			this.pathName = pathName ;
		}

		if (prefixName != null)
		{
			this.prefixName = prefixName ;
		}
		
		var localizer:Localization = Localization.getInstance() ;
		localizer.addEventListener( Localization.CHANGE, new Delegate(this, notifyFinished), false, 1000 ) ;

		buRRRn.eden.Application._trace = Delegate.create(this , _trace ) ;
		buRRRn.eden.config.security = false ;
		
		localizer.setLoader( new EdenLocalizationLoader() ) ;

		loader = EdenLocalizationLoader(localizer.getLoader()) ;

		registerLoader( loader ) ;
		
	}
	
	/**
	 * The default value of the locale path.
	 */
	public var pathName:String = "locale/" ;
	
	/**
	 * The default value of the locale file prefix ;
	 */
	public var prefixName:String = "localize_" ;
	
	/**
	 * The reference of the EdenLicalizationLoader.
	 */
	public var loader:EdenLocalizationLoader ;
	
	/**
	 * Run the process.
	 */
	public function run() 
	{
		
		notifyStarted() ;
		
		var config:Config = getConfig() ;
	
		var currentLang = config.default_lang || Lang.FR ;
		
		getLogger().debug( this + " run process with the current Lang : " + currentLang ) ;

		loader.prefix = config.localePrefix || prefixName ;
		loader.path   = config.localePath   || pathName   ;
		
		Localization.getInstance().setCurrent( currentLang ) ;
	
	}
	
	/**
	 * Invoqued by the Eden tracer.
	 */
	private function _trace( message:String ):Void
	{
		getLogger().warn( this + " : " + message ) ;
	}

}