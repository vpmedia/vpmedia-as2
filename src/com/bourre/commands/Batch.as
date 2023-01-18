/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code Batch} is a concrete implementation of MacroCommand interface.
 * 
 * <p>It handles several commands as one command.
 * 
 * <p>Basical example :
 * 
 * @example
 * <code>
 * import com.bourre.commands.*;
 * 
 * function test(s)
 * {
 * 	trace(s);
 * }
 * 
 * function sum(x, y)
 * {
 * 	var n = x+y;
 * 	trace("sum result : " + n);
 * }
 * 
 * var d0:Delegate = new Delegate(this, test, 'hello world');
 * var d1:Delegate = new Delegate(this, sum, 3, 4);
 * 
 * var b:Batch = new Batch();
 * b.addCommand(d0);
 * b.addCommand(d1);
 * b.execute();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.Command;
import com.bourre.commands.MacroCommand;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;

class com.bourre.commands.Batch
	implements MacroCommand
{
 	private var _aC:Array;
	
	/**
	 * Creates batch instance and returns method reference that runs the whole commands stack.
	 * @example <code>myButton.onPress = Batch.create(myCommand0, myCommand1, myCommand2);</code>
	 * @return Function.
	 * @see com.bourre.commands.MacroCommand
	 */
	public static function create() : Function
	{
		var b:Batch = new Batch();
		var l:Number = arguments.length;
		for (var i:Number = 0; i < l; i++) 
		{
			var f:Function = arguments[i];
			if ( typeof (f['execute']) == 'function' ) b['addCommand'](f);
		}
		return b.getFunction();
	}
 	
	/**
	 * MacroCommand implementation.
	 * @see com.bourre.commands.MacroCommand
	 */
 	public function Batch()
 	{
  		_aC = new Array();
  	}
	
	/**
	 * Takes all elements of an Array and pass them one by one as arguments 
	 * to a method of an object. 
	 * It's exactly the same concept as batch processing in audio or video
	 * software, when you choose to run the same actions on a group of files.
	 * 
	 * <p>Basical example which sets _alpha value to 10 and scale to 50
	 * on all MovieClips nested in the Array :
	 * 
	 * @example
	 * <code>
	 * import com.bourre.commands.*;
	 * 
	 * function changeAlpha(mc, a, s)
	 * {
	 * 	mc._alpha = a;
	 * 	mc._xscale = mc._yscale = s;
	 * }
	 * 
	 * Batch.process(this, changeAlpha, [mc0, mc1, mc2], 10, 50);
	 * </code>
	 * 
	 * @param o Context in which to run the function.
	 * @param f Function to run.
	 * @param a Array of parameters.
	 */
  	public static function process(o, f:Function, a:Array) : Void
  	{
  		var l:Number = a.length;
		var aArgs:Array = arguments.splice(3);
		while( --l > -1 ) f.apply(o, (aArgs.length > 0) ? [a[l]].concat(aArgs) : [a[l]]);
  	}
 	
	/**
	 * Add command to Batch instance.
	 * @param oC Command instance to add.
	 * @see com.bourre.commands.MacroCommand
	 */
 	public function addCommand(oC:Command) : Void
 	{
  		_aC.push(oC);
  	}
  	
	/**
	 * Remove command to Batch instance.
	 * @param oC Command instance to remove.
	 * @see com.bourre.commands.MacroCommand
	 */
  	public function removeCommand(oC:Command) : Void
  	{
  		var l:Number = _aC.length;
		while( --l > -1 ) if (_aC[l] == oC) _aC.splice(l, 1);
  	}
 
 	/**
	 * Execute all commands stored in Batch instance.
	 * Command polymorphism.
	 * @see com.bourre.commands.command
	 */
 	public function execute( e : IEvent) : Void
 	{
  		var l:Number = _aC.length;
  		for (var i:Number = 0; i<l; i++) _aC[i].execute(e);
  	}
  	
	/**
	 * Get amount of stored commands.
	 * @return Number.
	 */
  	public function getLength() : Number
  	{
  		return _aC.length;
  	}
	
	/**
	 * Get method reference that runs the whole commands stack.
	 * @return Function that delegates its call to a different scope, method and arguments.
	 */
	public function getFunction() : Function
	{
		var _f:Function = function()
		{	
			return arguments.callee.t.execute.call( arguments.callee.t );
		};
		_f.t = this;
		return _f;
	}
	
	/**
	 * Remove all commands.
	 * Each command added will be removed, it means that they won't be executed anymore.
	 * Warning, because you can't undo this method's behaviour.
	 */
	public function removeAll() : Void
	{
		_aC = new Array();
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}