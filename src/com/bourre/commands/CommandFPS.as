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
 * {@code CommandFPS} allows to store Command objects and to execute each one
 * at each frame displayed by the player.
 * 
 * <p>If your animation framerate is 31 fps, each added command
 * will have its {@code execute} method triggered 31 times per second.
 * 
 * <p>I encourage in most of cases to use singleton implementation : {@link com.bourre.commands.CommandManagerFPS}
 * 
 * <p>See below a basical example to understand the mechanism :
 * @example
 * <code>
 * import com.bourre.commands.*;
 * 
 * var t:CommandFPS = new CommandFPS();
 * var d:Delegate = new Delegate(this, test);
 * var i:Number = 0;
 * 
 * function test(s:String) : Void
 * {
 * 	trace("hello world");
 * 	i++;
 * 	if (i >= 10) t.remove(d);
 * }
 * 
 * t.push( d );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.Command;
import com.bourre.commands.Delegate;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IFrameListener;

class com.bourre.commands.CommandFPS
	implements IFrameListener
{
	private var _oT:Object;
	private var _oS:Object;
	private var _nID:Number;
	private var _nL;
	
	/**
	 * Constructs a new {@code CommandFPS} instance.
	 *
	 * <p>That allows to store Command objects and to execute each one
	 * at each frame displayed by the player.
	 * @see com.bourre.commands.Command
	 * @see com.bourre.commands.CommandMS
	 */
	public function CommandFPS()
	{
		_oT = new Object();
		_oS = new Object();
		_nID = 0;
		_nL = 0;
		FPSBeacon.getInstance().addFrameListener(this);
	}
	
	/**
	 * Don't use, overwrite or override this method.
	 * That's the public callback of {@link com.bourre.transitions.FBeacon} used internally to run stored commands on each frame.
	 */
	public function onEnterFrame() : Void
	{
		for (var s:String in _oT) _oT[s].execute();
	}
	
	/**
	 * Add Command object.
	 * The passed command added will be executed each frame until you stop it temporarily 
	 * or remove it definitely.
	 * 
	 * This method returns a String, you can use it later as a hashcode 
	 * to stop, resume or remove your command.
	 * Check {@link CommandFPS#pushWithName} documentation to get more details on this topic.
	 * 
	 * @param oC Command instance to add.
	 * @return String Key name.
	 */
	public function push(oC:Command) : String
	{
		return _push( oC, _getNameID() );
	}
	
	/**
	 * Add Command object.
	 * The passed command added will be executed each frame until you stop it temporarily 
	 * or remove it definitely from CommandFPS instance.
	 * 
	 * <p>It works exactly the same as {@link CommandFPS#push} excepts it takes String as parameter.
	 * This String will work as a hashcode for further stop ({@link CommandFPS#pushWithName}), 
	 * removal ({@link CommandFPS#stop}) or resume ({@link CommandFPS#resumeWithName}).
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
	 * var t:CommandFPS = new CommandFPS();
	 * var d:Delegate = new Delegate(this, test);
	 * 
	 * function test() : Void
	 * {	
	 * 	trace("hello world");
	 * 	if (getTimer()>3000) t.removeWithName("key")
	 * }
	 * 
	 * t.pushWithName(d, "key");
	 * d.execute();
	 * </code>
	 * 
	 * @param oC Command instance to add.
	 * @param sN (optional parameter) You can specify your own String key name.
	 * @return String Key name.
	 */
	public function pushWithName(oC:Command, sN:String) : String
	{
		sN = (sN == undefined) ? _getNameID() : sN;
		return _push(oC, sN);
	}
	
	/**
	 * Delay command execution to the next frame.
	 * The passed command will be executed once.
	 * 
	 * @example
	 * <code>
	 * import com.bourre.commands.*;
	 * 
	 * var t:CommandFPS = new CommandFPS();
	 *
	 * function test() : Void
	 * {
	 * 	trace("hello world");
	 * }
	 * 
	 * t.delay( new Delegate(this, test) );
	 * </code>
	 * 
	 * @param oC Command instance to execute.
	 */
	public function delay(oC:Command) : Void
	{
		var sN:String = _getNameID();
		var d:Delegate = new Delegate(this, _delay, oC, sN);
		_oT[sN] = d;
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
		for (var s:String in _oT) if (_oT[s] == oC) return _remove(s);
		return false;
  	}
	
	/**
	 * Remove command. 
	 * The passed command won't be executed anymore.
	 * 
	 * <p>It works exactly the same as {@link CommandFPS#remove} excepts it takes String as parameter.
	 * You must pass a valid key to ensure it works.
	 * The expected key is the String returned by {@link CommandFPS#push} method while command addition.
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
	 * The targeted command won't be executed anymore until you resume it 
	 * with {@link CommandFPS#resume} or {@link CommandFPS#resumeWithName} methods.
	 * Usage : <em>t.stop(myCommand);</em>
	 * @param oC Command instance to stop.
	 * @return Boolean that indicates stop success.
	 */
	public function stop(oC:Command) : Boolean
	{
		for (var s:String in _oT) if (_oT[s] == oC) return _stop(s);
		return false;
	}
	
	/**
	 * Stops command execution.
	 * The targeted command won't be executed anymore until you resume it 
	 * with {@link CommandFPS#resume} or {@link CommandFPS#resumeWithName} methods.
	 * 
	 * <p>It works exactly the same as stop excepts it takes String as parameter.
	 * You must pass a valid key to ensure that works.
	 * The expected key is the String returned by {@link CommandFPS#push} method while command addition.
	 * Usage : <em>t.stopWithName( "key" );</em>
	 * @param sN Command name (given key) to stop.
	 * @return Boolean that indicates stop success.
	 */
	public function stopWithName(sN:String) : Boolean
	{
		return (_oT[sN] != undefined) ? _stop(sN) : false;
	}

	/**
	 * Resume command previously stopped with {@link CommandFPS#stop} or {@link CommandFPS#stopWithName} methods.
	 * Usage : <em>t.resume( myCommand );</em>
	 * @param oC Command instance to resume.
	 * @return Boolean that indicates resume success.
	 */
	public function resume(oC:Command) : Boolean
	{
		for (var s:String in _oS) if (_oS[s] == oC) return _resume(s);
		return false;
	}
	
	/**
	 * Resume command previously stopped with {@link CommandFPS#stop} or {@link CommandFPS#stopWithName} methods.
	 * 
	 * <p>It works exactly the same as {@link CommandFPS#resume} excepts it takes String as parameter.
	 * You must pass a valid key to ensure that works.
	 * The expected key is the String returned by push method while command addition.
	 * Usage : <em>t.resume( "key" );</em>
	 * @param sN Command name (given key) to resume.
	 * @return Boolean that indicates resume success.
	 */
	public function resumeWithName(sN:String) : Boolean
	{
		return (_oS[sN] != undefined) ? _resume(sN) : false;
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
		_oT = new Object();
		_oS = new Object();
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
	private function _push(oC:Command, sN:String) : String
	{
		_oT[sN] = oC;
		_nL++;
		oC.execute();
		return sN;
	}
	
	private function _getNameID() : String
	{
		while (_oT['_C_' + _nID] != undefined) _nID++;
		return '_C_' + _nID;
	}
	
	private function _remove(s:String) : Boolean
	{
		delete _oT[s];
		_nL--;
		return true;
	}
	
	private function _stop(s:String) : Boolean
	{
		_oS[s] = _oT[s];
		delete _oT[s];
		return true;
	}
	
	private function _resume(s:String) : Boolean
	{
		var oC:Command = _oS[s];
		delete _oS[s];
		oC.execute();
		_oT[s] = oC;
		return true;
	}
	
	private function _delay(oC:Command, sN:String) : Void
	{
		removeWithName(sN);
		oC.execute();
	}
}