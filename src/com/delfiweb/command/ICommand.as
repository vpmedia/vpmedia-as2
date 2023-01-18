

/**
 * All objects than implement ICommand must have all this method.
 * 
 * @author  Matthieu
 * @version 1.0
 * @usage   
 * @since  01/12/2006 
 */
interface com.delfiweb.command.ICommand
{
	public function execute():Void;
}