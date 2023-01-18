
import pegas.process.SimpleAction;

/**
 * This Action lauch an initialize process.
 * @author ekameleon
 */
class andromeda.process.abstract.AbstractInitProcess extends SimpleAction 
{

	/**
	 * Creates a new AbstractRunFlashVars instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */	
	function AbstractInitProcess(bGlobal : Boolean, sChannel : String) 
	{
		super(bGlobal, sChannel);
	}
	
	/**
	 * Launch the initialize process in this method.
	 * Overrides this method.
	 */
	public function init():Void
	{
		// override
	}

	/**
	 * Run the process.
	 */
	public function run():Void
	{
		notifyStarted() ;		
		init() ;
		notifyFinished() ;	
	}
	
}