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
 * {@code CommandMS} allows to store Command objects and to loop 
 * their execution at a specified speed in milliseconds.
 * 
 * <p>I encourage in most of cases to use singleton implementation : {@link com.bourre.commands.CommandManagerMS}
 * 
 * <p>In the Example below, the specified command will be runned each second :
 * 
 * @example
 * <code>
 * import com.bourre.commands.*;
 * 
 * var t:CommandMS = new CommandMS();
 * 
 * function test(s:String) : Void
 * {
 * 	trace("hello world");
 * }
 * 
 * t.push( new Delegate(this, test), 1000 );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.Command;
import com.bourre.log.PixlibStringifier;

class com.bourre.commands.CommandMS
{
	private var _oT:Object;
	private var _nID:Number;
	private var _nL;
		
	private static var _EXT:String = '_C_';
	
	/**
	 * Constructs a new {@code CommandMS} instance.
	 *
	 * <p>That allows to store Command objects and to loop 
	 * their execution at a specified speed in milliseconds.
	 * @see com.bourre.commands.Command
	 * @see com.bourre.commands.CommandFPS
	 */
	public function CommandMS()
	{
		_oT = new Object();
		_nID = 0;
		_nL = 0;
	}
	
	/**
	 * Add Command object.
	 * The passed command added will be executed in a loop until 
	 * you stop it temporarily or remove it definitely.
	 * You must specify time loop duration in milliseconds.
	 * 
	 * <p>This method returns a String, you can use it later as a hashcode 
	 * to stop, restart or remove your command.
	 * Check {@link CommandMS#pushWithName} documentation to get more details on this topic.
	 * 
	 * @param oC Command instance to add.
	 * @param nMs Time loop duration in milliseconds.
	 * @return String Key name.
	 */
	public function push(oC:Command, nMs:Number) : String
	{
		var sN:String = _getNameID();
		if (_oT[sN] != undefined) _remove(sN);
		
		return _push( oC, nMs, sN );
	}
	
	/**
	 * Add Command object.
	 * The passed command added will be executed in a loop until 
	 * you stop it temporarily or remove it definitely.
	 * You must specify time loop duration in milliseconds.
	 * 
	 * <p>It works exactly the same as {@link CommandMS#push} excepts it takes String as parameter.
	 * This String will work as a hashcode for further stop ({@link CommandMS#removeWithName}), 
	 * removal ({@link CommandMS#stopWithName}) or restart ({@link CommandMS#resumeWithName}).
	 * 
	 * @usageNote
	 * <p>If you provide an existing key, it will remove the associated command without any warning.
	 * 
	 * <p>Another note, try to use this feature only when its absolutely required.
	 * Generally, be careful about your design and objects encapsulation.
	 * Don't make global references when it's not needed.
	 * 
	 * @example
	 * import com.bourre.commands.*;
	 * 
	 * var t:CommandMS = new CommandMS();
	 * var d:Delegate = new Delegate(this, test);
	 * 
	 * function test() : Void
	 * {	
	 * 	trace("hello world");
	 * 	if (getTimer()>3000) t.removeWithName("key")
	 * }
	 * 
	 * t.pushWithName(d, 500, "key");
	 * d.execute();
	 * </code>
	 * 
	 * @param oC Command instance to add.
	 * @param nMs Time loop duration in milliseconds.
	 * @param sN (optional parameter) You can specify your own String key name.
	 * @return String Key name.
	 */
	public function pushWithName(oC:Command, nMs:Number, sN:String) : String
	{
		if (sN == undefined) 
		{
			sN =_getNameID();
		} else if (_oT[sN] != undefined) 
		{
			_remove(sN);
		}
		
		return _push( oC, nMs, sN );
	}
	
	/**
	 * Wait specified amount of time before executing the passed command.
	 * The command will be executed once.
	 * 
	 * <p>In this example, the method execution is 3 seconds delayed :
	 * 
	 * @example
	 * <code>
	 * import com.bourre.commands.*;
	 * 
	 * var t:CommandMS = new CommandMS();
	 * 
	 * function test() : Void
	 * {
	 * 	trace('hello world');
	 * }
	 * 
	 * t.delay( new Delegate(this, test), 3000 );
	 * </code>
	 * 
	 * @param oC targeted Command Object to execute.
	 * @param nMs Time delay before execution
	 */
	public function delay(oC:Command, nMs:Number) : Void
	{
		var sN:String = _getNameID();
		var o:Object = _oT[sN] = new Object();
		o.cmd = oC;
		o.ID = setInterval(this, '_delay', nMs, sN);
	}
	
	/**
	 * Remove command. 
	 * The passed command won't be executed anymore.
	 * Usage : <em>t.remove(myCommand);</em>
	 * @param oC Command instance to remove.
	 * @return Boolean that indicates remove success.
	 */
	public function remove(oC:Command) : Boolean
  	{
		for (var s:String in _oT) if (_oT[s].cmd == oC) return _remove(s);
		return false;
  	}
	
	/**
	 * Remove command. 
	 * The passed command won't be executed anymore.
	 * 
	 * <p>It works exactly the same as {@link CommandMS#remove} excepts it takes String as parameter.
	 * You must pass a valid key to ensure it works.
	 * The expected key is the String returned by {@link CommandMS#push} method while command addition.
	 * Usage : <em>t.removeWithName( "key" );</em>
	 * @param sN Command name (given key) to remove.
	 * @return Boolean that indicates remove success.
	 */
	public function removeWithName(sN:String) : Boolean
	{
		return (_oT[sN] != undefined) ? _remove(sN) : false;
	}
	
	/**
	 * Stops command execution.
	 * The targeted command won't be executed anymore until you restart it 
	 * with {@link CommandMS#resume} or {@link CommandMS#resumeWithName} methods.
	 * Usage : <em>t.stop(myCommand);</em>
	 * @param oC Command instance to stop.
	 * @return Boolean that indicates stop success.
	 */
	public function stop(oC:Command) : Boolean
	{
		for (var s:String in _oT) if (_oT[s].cmd == oC) return _stop(s);
		return false;
	}
	
	/**
	 * Stops command execution.
	 * The targeted command won't be executed anymore until you restart it 
	 * with {@link CommandMS#resume} or {@link CommandMS#resumeWithName} methods.
	 * 
	 * <p>It works exactly the same as stop excepts it takes String as parameter.
	 * You must pass a valid key to ensure that works.
	 * The expected key is the String returned by {@link CommandMS#push} method while command addition.
	 * Usage : <em>t.stopWithName( "key" );</em>
	 * @param sN Command name (given key) to stop.
	 * @return Boolean that indicates stop success.
	 */
	public function stopWithName(sN:String) : Boolean
	{
		return (_oT[sN] != undefined) ? _stop(sN) : false;
	}
	
	/**
	 * Restarts command previously stopped with {@link CommandMS#stop} or {@link CommandMS#stopWithName} methods.
	 * Usage : <em>t.resume( myCommand );</em>
	 * @param oC Command instance to restart.
	 * @return Boolean that indicates restart success.
	 */
	public function resume(oC:Command) : Boolean
	{
		for (var s:String in _oT) if (_oT[s].cmd == oC) return _notify(s);
		return false;
	}
	
	/**
	 * Restarts command previously stopped with {@link CommandMS#stop} or {@link CommandMS#stopWithName} methods.
	 * 
	 * <p>It works exactly the same as {@link CommandMS#resume} excepts it takes String as parameter.
	 * You must pass a valid key to ensure that works.
	 * The expected key is the String returned by push method while command addition.
	 * Usage : <em>t.resume( "key" );</em>
	 * @param sN Command name (given key) to restart.
	 * @return Boolean that indicates restart success.
	 */
	public function resumeWithName(sN:String) : Boolean
	{
		return (_oT[sN] != undefined) ? _notify(sN) : false;
	}
	
	/**
	 * Get amount of commands stored.
	 * @return Number.
	 */
	public function getLength() : Number
	{
		return _nL;
	}
	
	/**
	 * Remove all commands.
	 * Each command added will be removed, it means that they won't be executed anymore.
	 * Warning, because you can't undo this method's behaviour.
	 */
	public function removeAll() : Void
	{
		for (var s:String in _oT) _remove(s);
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	//
	private function _push(oC:Command, nMs:Number, sN:String) : String
	{
		var o:Object = new Object();
		o.cmd = oC;
		o.ms = nMs;
		o.ID = setInterval(oC, 'execute', nMs);
		_oT[sN] = o;
		_nL++;
		
		oC.execute();
		
		return sN;
	}
	
	private function _getNameID() : String
	{
		while (_oT[CommandMS._EXT + _nID] != undefined) _nID++;
		return CommandMS._EXT + _nID;
	}
	
	private function _remove(s:String) : Boolean
	{
		clearInterval(_oT[s].ID);
		delete _oT[s];
		_nL--;
		return true;
	}
	
	private function _stop(s:String) : Boolean
	{
		clearInterval(_oT[s].ID);
		return true;
	}
	
	private function _notify(s:String) : Boolean
	{
		_oT[s].ID = setInterval(_oT[s].cmd, 'execute', _oT[s].ms);
		return true;
	}
	
	private function _delay(sN:String) : Void
	{
		var o:Object = _oT[sN];
		clearInterval(o.ID);
		o.cmd.execute();
		delete _oT[sN];
	}
}