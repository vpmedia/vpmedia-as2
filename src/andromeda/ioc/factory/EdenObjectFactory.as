import andromeda.ioc.core.ObjectDefinition;
import andromeda.ioc.factory.ObjectFactory;

import vegas.core.IFactory;
import vegas.data.map.HashMap;

/**
 * This builder use a eden object to creates all Objects with the IObjectDefinitionContainer.
 * <p><b>Example :</b></p>
 * 1 - The eden application file : <b>"application.eden"</b>
 * {@code 
 *   {
 *        objects : 
 *        [
 *            {   
 *                id            : "address"  ,
 *                type          : "test.Address" ,
 *                properties    : 
 *                [ 
 *                    { name : "city"   , value : "Marseille" } ,
 *                    { name : "street" , value : "xx xxx xxxxxxxxxxx" } ,
 *                    { name : "zip"    , value : 13004 } 
 *                ]
 *            }
 *            ,
 *            {   
 *                id         : "job_dev"  ,
 *                type       : "test.Job" ,
 *                properties : [ { name:"name" , value:"AS Developper" } ]
 *            }
 *            ,
 *            {   
 *                id            : "user" , 
 *                type          : "test.User" , 
 *                arguments     : 
 *                [ 
 *                    { value :"eKameleon" } , 
 *                    { value :"ALCARAZ"   } , 
 *                    { ref   :"address"   } 
 *                ] ,
 *                singleton     : true ,
 *                assemblyName  : "" , // not implemented yet
 *                destroy       : "destroy" ,  // not fully implemented yet
 *                init          : "initialize" ,
 *                properties : 
 *                [
 *                    { name:"age"       , value : 30          } ,
 *                    { name:"firstName" , value : "Marc"      } , 
 *                    { name:"job"       , ref   : "job_dev"      } , 
 *                    { name:"setMail"   , arguments  :  [ { value :"vegas@ekameleon.net" } ] } , // method
 *                    { name:"url"       , value : "http://www.ekameleon.net/blog" }
 *                ]
 *             }
 *         ]
 *    }
 * }
 * 2 - The ActionScript test code :
 * {@code
 *  import test.User ;
 * 
 *  import andromeda.ioc.factory.EdenObjectFactory ;
 * 
 *  var loader:LoadVars = new LoadVars() ;
 *  loader.onData = function ( source:String ):Void
 *  {
 *     app = buRRRn.eden.Application.deserialize(source) ;
 *     
 *     var factory:EdenObjectFactory = new EdenObjectFactory() ;
 *     factory.create( app.objects ) ;
 *     
 *     trace("--- User") ;
 *     
 *     var user:User = factory.getObject("user") ;
 *     
 *     trace("User : " + user) ;
 *     trace("User pseudo : " + user.pseudo ) ; // ekameleon
 *     trace("User firstName : " + user.firstName ) ; // Marc
 *     trace("User name : " + user.name ) ; // ALCARAZ
 *     trace("User age : " + user.age ) ; // 30
 *     trace("User mail : " + user.mail ) ; // vegas@ekameleon.net
 *     trace("User url : " + user.url  ) ; // http://www.ekameleon.net/blog
 *     trace("User job : " + user.job ) ; // [Job AS Developper]
 *     trace("User address : " + user.address) ; // [Address]
 *     trace("User address city : " + user.address.city) ; // Marseille
 *     trace("User address street : " + user.address.street) ; // xx xxx xxxxxxxxxxx
 *     trace("User address zip : " + user.address.zip) ; // 13004
 *  }
 * 
 *  loader.load("application.eden") ;
 * }
 * 
 * 3 - The <b>test.User</b> class.
 * {@code
 * import test.Address ;
 * import test.Job ;
 * import vegas.core.CoreObject ;
 *
 * class test.User extends CoreObject
 * {
 * 
 *     public function User( pseudo:String, name:String, address:Address )
 *     {
 *         this.pseudo  = pseudo ;
 *         this.name = name ;
 *         this.address = address ;
 *     }
 *     
 *     public var address:Address ;
 *     public var age:Number ;
 *     public var firstName:String ;
 *     public var job:Job ;
 *     public var mail:String ;
 *     public var name:String ;
 *     public var pseudo:String ;
 *     public var url:String ;
 *     
 *     public function destroy():Void
 *     {
 *         trace( this + " destroy.") ;
 *     }
 *     
 *     public function initialize():Void
 *     {
 *         trace( this + " initialize.") ;
 *     }
 *     
 *     public function setMail( sMail:String ):Void
 *     {
 *         mail = sMail ;
 *     }
 * }
 * }
 * 4 - The <b>test.Address</b> class.
 * {@code
 * import vegas.core.CoreObject ;
 * 
 * class test.Address extends CoreObject
 * {
 * 
 *     public function Address() {}
 *     
 *     public var city:String ;
 *     public var street:String
 *     public var zip:Number ;
 * }
 * }
 * 5 - The <b>test.Job</b> class.
 * {@code
 * import vegas.core.CoreObject ;
 * import vegas.util.ConstructorUtil;
 * 
 * class test.Job extends CoreObject
 * {
 *
 *     public function Job() {}
 *     
 *     public var name:String ;
 *     
 *     public function toString():String
 *     {
 *         return "[" + ConstructorUtil.getName(this) + " " + name + "]" ;
 *     }
 * }
 * }
 * @author eKameleon
 */
class andromeda.ioc.factory.EdenObjectFactory extends ObjectFactory implements IFactory
{
	
	/**
	 * Creates a new EdenObjectFactory instance.
	 */
	public function EdenObjectFactory() 
	{
		_assemblies = new HashMap() ;
	}
	
	/**
	 * Defines the label of the arguments in a method or a constructor object.
	 */
	static public var ARGUMENTS:String = "arguments" ;  

	/**
	 * Defines the label of the assembly name property of the object.
	 */
	static public var ASSEMBLY_NAME:String = "assemblyName" ;

	/**
	 * Defines the label of the name in a property object.
	 */
	static public var NAME:String = "name" ;  

	/**
	 * The name of the external object property to register the destroy method name.
	 */
	static public var OBJECT_DESTROY_METHOD_NAME:String = "destroy" ;  

	/**
	 * The name of the external object property to define the id of the object.
	 */
	static public var OBJECT_ID:String = "id" ;  

	/**
	 * The name of the external object property to register the init method name.
	 */
	static public var OBJECT_INIT_METHOD_NAME:String = "init" ;  
	
	/**
	 * The name of the external object property to register the properties.
	 */
	static public var OBJECT_PROPERTIES:String = "properties" ;  

	/**
	 * The name of the external object property to define the singleton flag of the object.
	 */
	static public var OBJECT_SINGLETON:String = "singleton" ;  

	/**
	 * Defines the label of the type of the object.
	 */
	static public var TYPE:String = "type" ;  

	/**
	 * Defines the label of the reference in a property object.
	 */
	static public var REFERENCE:String = "ref" ;  

	/**
	 * Defines the label of the value in a property object.
	 */
	static public var VALUE:String = "value" ;  

	/**
	 * Create the objects and fill the IObjectDefinitionContainer.
	 * <p><b>Parameters</b></p>
	 * {@code edenObject} An object who contains all the "objects" settings.
	 */
	public function create( /* ...args */ )
	{
		var arg:Array = arguments[0] ;
		if ( arg instanceof Array && arg.length > 0)
		{
			while ( arg.length > 0)
			{
				_createNewObjectDefinition( arg.shift() ) ;
			}
		}
	}

	private var _assemblies:HashMap ;

	/**
	 * Returns and creates a new IObjectDefinition instance.
	 * @return and creates a new IObjectDefinition instance.
	 */
	private function _createNewObjectDefinition( o:Object ):Void
	{
		if ( o != null )
		{
			
			var args:Array          =  o[ ARGUMENTS ] ;
			var assemblyName:String =  o[ ASSEMBLY_NAME ] ;
			var destroy:String      =  o[ OBJECT_DESTROY_METHOD_NAME ] ;
			var id:String           =  o[ OBJECT_ID ] ;
			var init:String         =  o[ OBJECT_INIT_METHOD_NAME ] ;
			var properties:Array    =  o[ OBJECT_PROPERTIES ] ;
			var singleton:Boolean   =  o[ OBJECT_SINGLETON ] ;
			var type:String         =  o[ TYPE ] ;

			var definition:ObjectDefinition = new ObjectDefinition( type , singleton ) ;
			definition.setConstructorArguments( args ) ;
			definition.setDestroyMethodName( destroy ) ;
			definition.setInitMethodName( init ) ;
			definition.setProperties( _createNewProperties( properties ) ) ;
			
			addObjectDefinition( id , definition ) ;
			
		}
	}

	/**
	 * Returns and creates the Map of all properties.
	 * @return and creates the Map of all properties.
	 */
	private function _createNewProperties( a:Array ):HashMap
	{
		var len:Number = a.length ;
		if ( len > 0 )
		{
			var args:Array  ;
			var prop:Object ;
			var name:String ;
			var properties:HashMap = new HashMap() ;
			var ref:String  ;
			var value ;
			for (var i:Number = 0 ; i<len ; i++)
			{
				prop  = a[i] ;
				args  = prop[ ARGUMENTS ] ;
				ref   = prop[ REFERENCE ]   ;
				name  = prop[ NAME ] ;
				value = prop[ VALUE ] ;
				
				if (args instanceof Array && args.length > 0) 
				{
					properties.put( name , _createArguments( args ) ) ; // methods
				}
				else if (ref != null) 
				{
					properties.put( name , ref ) ; // ref property	
				}
				else 
				{
					properties.put( name, value ) ; // property	
				}
			}
			return (properties.size() > 0) ? properties : null ;
		}
		else
		{
			return null ;	
		}	
	}
	

}