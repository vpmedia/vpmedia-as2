/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.core.IRunnable;
import vegas.errors.IllegalArgumentError;
import vegas.events.BasicEvent;
import vegas.events.EventDispatcher;
import vegas.events.FrontController;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * A command is a easy entry with name and value property to launch a global command in the Commands static tool class.
 * @author eKameleon
 */
dynamic class andromeda.core.Command extends CoreObject implements IRunnable
{

	/**
	 * Creates a new Command instance.
	 * <p><b>Example :</b></p>
	 * {@code
	 * var c1:Command = new Command() ;
	 * var c2:Command = new Command([name:String [, value:*[, channel:String]]]) ;
	 * var c3:Command = new Command([initObject:Object]) ; 
	 * }
	 * @throws IllegalArgumentError if the optional passed-in arguments failed the initialization of the new {@code Command} instance. 
	 */ 
	public function Command( /*args*/ ) 
	{
		
		if (arguments.length == 1)
		{
			
			var arg /*Object*/ = arguments[0] ;
			
			if (TypeUtil.typesMatch(arg, String) )
			{
				this.name = arg ;
			}
			else if (TypeUtil.typesMatch(arg, Object))
			{
				
				if (arg.hasOwnProperty("name") && TypeUtil.typesMatch(arg["name"], String) )
				{
					this.name = arg.name ;	
				}
				else
				{
					throw new IllegalArgumentError( toString() + CONSTRUCTOR_ERROR ) ;	
				}
				
				this.value   = arg.value   || null ;
				this.channel = arg.channel || null ;
				
			}
			else
			{
				throw IllegalArgumentError(this + CONSTRUCTOR_ERROR) ;	
			}
		}
		else if (arguments.length > 2)
		{
			
			if (TypeUtil.typesMatch(arguments[0], String) )
			{
					this.name = arguments[0] ;	
			}
			else
			{
				throw IllegalArgumentError(this + CONSTRUCTOR_ERROR) ;	
			}
			this.value   = arguments[1] || null ;
			this.channel = arguments[2] || null ;
			
		}
		else
		{
			// throw IllegalArgumentError(this + CONSTRUCTOR_ERROR) ;	
		}
	}

	/**
	 * The internal string message used in the constructor if the constructor notify an IllegalArgumentError.
	 */
	static public var CONSTRUCTOR_ERROR:String = ", you can't create this instance without 'name' definition." ;
	
	/**
	 * The channel of this command.
	 */
	public var channel:String ;

	/**
	 * The command's type name.
	 */
	public var name:String ;
	
	/**
	 * The value of this command.
	 */
	public var value ;
	
	/**
	 * Run the process of this command.
	 */
	public function run():Void
	{
		if ( FrontController.getInstance( channel ).contains( name ) )
		{
			getLogger().info(this + " run : " + name + " : " + value ) ;
			EventDispatcher.getInstance( channel ).dispatchEvent( new BasicEvent( name , this, value ) ) ;
		}
		else
		{
			getLogger().warn(this + " run failed with an unknow command '" + name + "' in the Front Controller of this application.") ;
		}
	}

	/**
	 * Returns a simple Object representation of the Commands's instance. 
	 * @return a simple Object representation of the Commands's instance.
	 */
	public function toObject():Object
	{
		return { name:name , value:value , channel:channel } ;	
	}

	/**
	 * Returns the string EDEN representation of this object.
	 * @return the string EDEN representation of this object.
	 */
	public function toSource():String
	{
		var params:Array = [ Serializer.toSource(name) , Serializer.toSource(value) , Serializer.toSource(channel) ] ;
		return Serializer.getSourceOf( this , params ) ;
	}
	
	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String
	{
		var txt:String = "[Command" ;
		if (name != null) 
		{
			txt += " name:" + name ;
		}
		if (channel != null) 
		{
			txt += " channel:" + channel ;
		}
		txt += "]";
		return txt ; 
	}


}