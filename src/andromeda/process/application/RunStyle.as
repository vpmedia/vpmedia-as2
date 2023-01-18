
import andromeda.process.abstract.AbstractActionLoader;
import andromeda.text.StyleModel;

import asgard.events.LoaderEvent;
import asgard.net.StyleSheetLoader;
import asgard.net.URLRequest;

import vegas.events.Delegate;

/**
 * Launch the loading of the external stylesheet of this application.
 * @author eKameleon
 */
class andromeda.process.application.RunStyle extends AbstractActionLoader 
{
	
	/**
	 * Creates a new RunStyle instance.
	 * @param model the StyleModel to use in this process.
	 * @param url the url of the external css to load.
	 */
	public function RunStyle( model:StyleModel , url:String ) 
	{
		this.model = model ;
		this.url   = url ;
	}
	
	/**
	 * The StyleModel reference of this process.
	 */
	public var model:StyleModel ;

	/**
	 * The default url of this process.
	 */
	public var url:String ;

	/**
	 * Invoqued when the style is loaded.
	 */ 
 	public function initialize(e:LoaderEvent):Void 
 	{
		
		if (e != null)
		{
			getLogger().debug( this + " initialize : " + e.getData() ) ;
		}
		else
		{
			getLogger().warn( this + " initialize but no CSS found." ) ;
		}
		
		notifyFinished() ;
		
	}

	/**
	 * Run the process.
	 */
	public function run() 
	{

		getLogger().debug( this + " run." ) ;

		notifyStarted() ;

		var uri:String = getConfig().style || url ;
		
		if (uri)
		{
			
			var request:URLRequest = new URLRequest( uri ) ;
			
			var loader:StyleSheetLoader = new StyleSheetLoader() ;
			loader.setStyleSheet( model.getStyleSheet() ) ;
			
			loader.addEventListener(LoaderEvent.INIT, new Delegate(this, initialize)) ;
			
			registerLoader( loader ) ;
		
			loader.load( request ) ;
			
		}
		else
		{
			getLogger().warn(this + " run failed with an empty external css url.") ;
			notifyFinished() ;	
		}
		
	}


	
}