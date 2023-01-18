
import pegas.transitions.ITransition;

import vegas.data.Map;
import vegas.data.map.HashMap;
import vegas.errors.IllegalArgumentError;
import vegas.events.AbstractCoreEventDispatcher;
import vegas.util.TypeUtil;

/**
 * The TransitionController register all the ITransition of the application.
 * @author eKameleon
 */
class pegas.transitions.TransitionController extends AbstractCoreEventDispatcher
{

	/**
	 * Creates a new TransitionController instance.
	 * <p><b>Example :</b> 
	 * {@code 
	 * var controller:TransitionController = new TransitionController() ;
	 * }
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function TransitionController( bGlobal:Boolean , sChannel:String  ) 
	{
		super( bGlobal , sChannel ) ;	
		_map = new HashMap() ;
	}
	
	/**
	 * Returns {@code true} if the {@code id} passed in argument is registered in the TransitionController.
	 * @param id the {@code id} of the ITransition object mapped in the TransitionController.
	 * @return {@code true} if the {@code id} passed in argument is registered in the TransitionController.
	 */
	public function contains( id:String ):Boolean 
	{
		return _map.containsKey( id ) ;	
	}
	
	/**
	 * Returns {@code true} if the {@code Transition} passed in argument is registered in the TransitionController.
	 * @param transition the {@code Transition} reference to search in the TransitionController.
	 * @return {@code true} if the {@code Transition} passed in argument is registered in the TransitionController.
	 */
	public function containsTransition( transition:ITransition ):Boolean 
	{
		return _map.containsValue( transition ) ;	
	}

	/**
	 * Returns the singleton instance of TransitionController class.
	 * @return singleton instance of TransitionController class.
	 */
	public static function getInstance():TransitionController
	{
		if ( _instance == null )
		{
			_instance = new TransitionController() ;
		}
		return _instance ;
	}

	/**
	 * Returns a ITransition reference register in the TransitionController with the specified {@code id} passed in argument.
	 * @param  id the {@code id} of the ITransition object mapped in the TransitionController.
	 * @return the ITransition object mapped in the TransitionController.  
	 */
	public function getTransition( id ):ITransition 
	{
		return _map.get( id ) ;
	}
	
	/**
	 * Adds a new entry into the TransitionController.
	 * @param transition the ITransition to register in the TransitionController.
	 * @throws IllegalArgumentError if the argument is 'null' or 'undefined'.
	 * @throws IllegalArgumentError if the ITransition object ID is empty.
	 */
	public function insert( transition:ITransition ):Void 
	{
		if (transition == null)
		{
			throw new IllegalArgumentError( this + " insert failed, the transition argument not must be 'null' or 'undefined'") ;
		}
		if ( transition.getID() != null )
		{
			_map.put( transition.getID(), transition ) ;
		}
		else
		{
			throw new IllegalArgumentError( this + " insert failed if the passed-in ITransition object don't contains an empty ID.") ;	
		}
	}
	
	/**
	 * Removes an entry into the TransitionController.
	 * @param transition the id of the ITransition object mapped in the TransitionController or a ITransition object to remove.
	 * @return The removed ITransition object or null if the ITransition don't exist in the controller. 
	 */
	public function remove( transition ) 
	{
		if (transition instanceof ITransition)
		{
			return _map.remove( ITransition(transition).getID() ) ;
		}
		else if ( TypeUtil.typesMatch( transition, String ) )
		{
			return _map.remove( transition ) ;
		}
		else
		{
			getLogger().warn( this + " remove failed with an unknow ITransition or ID passed-in argument." ) ;
			return null ;	
		}
	}

	/**
	 * Run the specified Transition.
	 * @param id the id of the Transition to be run.
	 * @throws ContainsError if the {@param id} passed in argument isn't register in this TransitionCntroller
	 * @throws IllegalArgumentError if the {@code id} passed in argument is 'null' or 'undefined'.
	 */
	public function run( id:String ):Void
	{
		if (id == null)
		{
			throw new IllegalArgumentError(this + " run method failed, the 'id' passed in argument not must be 'null' or 'undefined'.") ;	
		}
		if (contains(id))
		{
			getTransition( id ).run() ;	
		}
		else
		{
			throw new IllegalArgumentError(this + " run method failed, the 'id' passed in argument isn't register in this TransitionController : " + id) ;	
		}
	}

	/**
	 * The singleton reference of this class.
	 */
	static private var _instance:TransitionController ;

	/**
	 * Internal HashMap instance.
	 */
	private var _map:Map ;
	
}