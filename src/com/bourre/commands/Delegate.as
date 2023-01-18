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
 * {@code Delegate} was originally created by Mike Chambers
 * for Macromedia mx.events package.
 * 
 * <p>As he said, this is a reusable class that acts as a proxy for events, 
 * registering itself for specific events, and then proxying 
 * the calls to the event handler and scope you specify. 
 * 
 * <p>This provides the following benefits and advantages :
 * <ul>
 * <li>You can dispatch change events from two different components to two separate methods.</li>
 * <li>You can define the scope in which the event handler would be called (in this case, the containing class).</li>
 * <li>Because it is a separate class, it was modular and you can easily reuse it across projects.</li>
 * </ul>
 * 
 * <p>For more explanations and a complete tutorial,
 * see <a href="http://www.macromedia.com/devnet/flash/articles/eventproxy.html"> there</a>.
 * 
 * <p>This version is also inspired from Peter Hall's EventDelegate. 
 * You can instantiate and keep a reference of a Delegate instance.
 * For more informations, see <a href="http://www.peterjoel.com/blog/index.php?archive=2004_08_01_archive.xml#109320812208031938"> there</a>.
 * 
 * <p>So, what are the new additions ?
 * 
 * <p>- You can pass parameters and add some more further.
 * 		See examples below.
 * 
 * <p>- One of the greatest feature is Command pattern implementation.
 * 		See classes documentation below to figure out benefits :
 * <ul>
 * <li>{@link com.bourre.commands.ThreadManagerFPS}</li>
 * <li>{@link com.bourre.commands.ThreadManagerMS}</li>
 * <li>{@link com.bourre.commands.Batch}</li>
 * </ul>
 * 
 * <p>Here is a basic example with v2 Button component and {@code setArguments} use :
 * @example
 * <code>
 * import com.bourre.commands.*;
 * import mx.controls.*;
 * 
 * function test(event, a) : Void
 * {
 * 	event.target.label = String(++a);
 * 	d.setArguments(a);
 * }
 * 
 * var d:Delegate = new Delegate(this, test);
 * var pb:Button = createClassObject(Button, '__pb', 10, {label:'0'});
 * pb.addEventListener('click', d);
 * d.setArguments(0);
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.Command;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.IFrameListener;

class com.bourre.commands.Delegate
	implements Command, IFrameListener
{
	private var _f:Function;
	private var _o:Object;
	private var _a:Array;
	private var _fProxy:Function;
	
	private function handleEvent(e) : Object
	{
		return _f.apply(_o, [e].concat(_a));
	}

	/**
	 * Wrapper for MM compatibility.
	 * Creates a method that delegates its arguments to a specified scope.
	 * @param o Scope to be used by calling this method.
	 * @param f Method to be executed.
	 * @return Function that delegates its call to a different scope, method and arguments.
	 */
	public static function create(o:Object, f:Function) : Function
	{
		// MM original implementation updated
		var _f:Function = function()
		{	
			var tt = arguments.callee.t;
			var ff = arguments.callee.f;
			var aa = arguments.concat(arguments.callee.a);
			return ff.apply(tt, aa);
		};

		_f.t = o;
		_f.f = f;
		_f.a = arguments.splice(2);
		return _f;
	}
	
	/**
	 * Constructs a new {@code Delegate} instance.
	 * 
	 * @param o Scope to be used by calling this method.
	 * @param f Method to be executed.
	 */
	public function Delegate(o:Object, f:Function)
	{
		_o = o;
		_f = f;
		_a = arguments.splice(2);
		_fProxy = Function(Delegate.create.apply(this, [_o].concat([_f], _a) ));
	}
	
	/**
	 * Get scope reference.
	 * @return Scope to be used for method calling.
	 */
	public function getScope()
	{
		return _o;
	}
	
	/**
	 * Get proxy reference.
	 * @return Function that delegates its call to a different scope, method and arguments.
	 * 
	 * @example
	 * import com.bourre.commands.*;
	 * 
	 * var d:Delegate = new Delegate(this, test, "hello world");
	 * 
	 * function test( s:String ) : Void
	 * {
	 * 	trace( s );
	 * }
	 * 
	 * mc.onPress = d.getFunction();
	 */
	public function getFunction() : Function
	{
		return _fProxy;
	}
	
	/**
	 * Execute proxy method in the provided context. 
	 * No return type is provided for interfaces compatibility.
	 * @return Returns result if there's one.
	 */
	public function callFunction()
	{
		return _fProxy();
	}
	
	/**
	 * Execute proxy method in the provided context. 
	 * Command polymorphism.
	 * @see com.bourre.commands.command
	 */
	public function execute( e: IEvent ) : Void
	{
		_fProxy();
	}
	
	/**
	 * Set or change arguments of proxy method.
	 * See examples above.
	 */
	public function setArguments() : Void
	{
		if (arguments.length > 0)
		{
			_a = arguments;
			_fProxy.a = _a;
		}
	}
	
	/**
	 * Add arguments to proxy method.
	 *
	 * <p>Here is a basical example with {@code Delegate.addArguments} :
	 * 
	 * @example
	 * <code>
	 * import com.bourre.commands.*;
	 * 
	 * function test() : Void
	 * {
	 * 	trace(arguments);
	 * }
	 * function temporisation()
	 * {
	 * 	d.execute();
	 * 	d.addArguments( Math.round(Math.random()*9) );
	 * }
	 * 
	 * var d:Delegate = new Delegate(this, test, 0);
	 * setInterval(temporisation, 100);
	 * </code>
	 */
	public function addArguments() : Void
	{
		if (arguments.length > 0)
		{
			_a = _a.concat(arguments);
			_fProxy.a = _a;
		}
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
	public function onEnterFrame() : Void 
	{
		_fProxy();
	}
}