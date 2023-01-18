/*
Class	Delegate
Package	ch.util
Project	Aminona Snowpark

Created by :	Tabin Cedric - thecaptain
Created at :	11 nov. 2005
*/

/**
 * Create delegate functions.
 * <p><strong>Using :</strong><br><code><br>
 * var tp:Function = function(okay:Boolean):Void<br>
 * {<br>
 * 		trace(okay);<br>
 * }<br>
 * <br>
 * myButton.onRelease = Delegate.getRedirect(this, "tp", true);
 * </code></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		11 nov. 2005
 * @version		1.0
 */
class ch.util.Delegate
{
	//---------//
	//Variables//
	//---------//
	private var		_target:Object; //target object
	private var		_method:String; //the method
	private var		_parameters:Array; //the parameters
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new Delegate.
	 * 
	 * @param	target	The target object.
	 * @param	method	The method name to call.
	 * @throws	Error	If {@code method} does not exist in {@code target}.
	 */
	private function Delegate(target:Object, method:String)
	{
		if (target[method] == null)
		{
			throw new Error(this+".<init> : '"+method+"' does not exist in "+target);
		}
		
		_target = target;
		_method = method;
		_parameters = [];
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Create a new {@code Delegate} instance.
	 * <p>After the {@code target} and {@code method} parameters, other
	 * parameters can be added. They will be considerated as parameters
	 * for the function to call.</p>
	 * 
	 * @param	target	The target object.
	 * @param	method	The method to execute into {@code target}.
	 * @param	...		The parameters to add or {@code nothing}.
	 * @return	The {@code Delegate} instance created.
	 * @throws	Error	If {@code method} does not exist in {@code target}.
	 */
	public static function create(target:Object, method:String /* other params */):Delegate
	{
		var dg:Delegate = new Delegate(target, method);
		var ag:Array = arguments;
		var ln:Number = ag.length;
		
		for (var i:Number=2 ; i<ln ; i++)
		{
			dg.addParameter(ag[i]);
		}
		
		return dg;
	}
	
	/**
	 * Create a new {@code Delegate} instance and return the
	 * function to be called.
	 * <p>After the {@code target} and {@code method} parameters, other
	 * parameters can be added. They will be considerated as parameters
	 * for the function to call.</p>
	 * 
	 * @param	target	The target object.
	 * @param	method	The method to execute into {@code target}.
	 * @param	...		The parameters to add or {@code nothing}.
	 * @return	The function of the {@code Delegate} instance created.
	 * @throws	Error	If {@code method} does not exist in {@code target}.
	 */
	public static function getRedirect(target:Object, method:String /* other params */):Function
	{
		var dg:Delegate = Delegate.create.apply(null, arguments);
		
		return dg.getStaticFunction();
	}
	
	/**
	 * Create a new {@code Delegate} instance and return the
	 * function to be called.
	 * <p>The paramters of the function will be the same as the
	 * replaced function.</p>
	 * 
	 * @param	target	The target object.
	 * @param	method	The method to execute into {@code target}.
	 * @return	The function of the {@code Delegate} instance created.
	 * @throws	Error	If {@code method} does not exist in {@code target}.
	 */
	public static function getDynamicRedirect(target:Object, method:String):Function
	{
		var dg:Delegate = Delegate.create.apply(null, arguments);
		
		return dg.getDynamicFunction();
	}
	
	/**
	 * Get the target object.
	 * 
	 * @return	The target.
	 */
	public function getTarget(Void):Object
	{
		return _target;
	}
	
	/**
	 * Get the method name.
	 * 
	 * @return	The method.
	 */
	public function getMethod(Void):String
	{
		return _method;
	}
	
	/**
	 * Get the parameters.
	 * 
	 * @return	The parameters.
	 */
	public function getParameters(Void):Array
	{
		return _parameters;
	}
	
	/**
	 * Add a parameter.
	 * 
	 * @param	value	The parameter to add.
	 */
	public function addParameter(value:Object):Void
	{
		_parameters.push(value);
	}
	
	/**
	 * Remove all the parameters.
	 */
	public function clearParameters(Void):Void
	{
		_parameters = [];
	}
	
	/**
	 * Get a function with no parameters and no return type.
	 * <p>When this function is executed, the method of the
	 * target will be executed with the specified parameters.</p>
	 * 
	 * @return	A {@code Function}.
	 */
	public function getStaticFunction(Void):Function
	{
		var me:Delegate = this;
		var fu:Function = function(Void):Void
		{
			me._target[me._method].apply(me._target, me._parameters);
		};
		
		return fu;
	}
	
	/**
	 * Get a function with no specified parameters and no return type.
	 * <p>When this function is executed, the method of the
	 * target will be executed with the parameters passed by the calling.</p>
	 * 
	 * @return	A {@code Function}.
	 */
	public function getDynamicFunction(Void):Function
	{
		var me:Delegate = this;
		var fu:Function = function():Void //arguments !
		{
			me._target[me._method].apply(me._target, arguments);
		};
		
		return fu;
	}
	
	/**
	 * Execute the {@code Delegate}.
	 */
	public function execute(Void):Void
	{
		_target[_method].apply(_target, _parameters);
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the Delegate instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.Delegate";
	}
}