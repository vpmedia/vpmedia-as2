/**
* Class: ThreadManager
*
* Version: v1.0
* Released: March 13, 2006
*
* Manages threads (execution strings) running within Flash. Use of this class allows for alternate looping mechanisms not based
* on the 'enter frame' model as well as greater execution control such as throttling, stopping, and so on.
*
* The latest version can be found at:
* http://sourceforge.net/projects/bnm-fc
* -or-
* http://www.baynewmedia.com/
*
* (C)opyright 2006 Bay New Media.
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library (see "lgpl.txt") ; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*
*	Class/Asset Dependencies
* 		Extends: None
*		Requires: com.bnm.fc.ThreadManager.Thread, com.bnm.fc.Extension,import com.bnm.fc.Error
*		Required By: None
*		Required Data Sources: None
*		Required Assets:
*			None
*
*
* History:
*
* v1.0 [04/03/06]
* 	- first public version
* 	- Added centralized error reporting mechanism through Error class
*
*/
import com.bnm.fc.ThreadMgr.Thread;
import com.bnm.fc.Extension;
import com.bnm.fc.Error;
class com.bnm.fc.ThreadManager {

	// __/ STATIC VARIABLES \_

	// __/ PUBLIC VARIABLES \_
	//parentClass (object) - A pointer to the class, movie clip, or object that created this class instance. May be required by
	//			some methods. Should always be set to ensure proper functioning.
	public var parentClass:Object=undefined;

	// __/ PRIVATE VARIABLES \_
	//_threads (array) - An array of currently active instances of the Thread class.
	private var _threads:Array=undefined;
	//_priority (array) - Numbered array of prioritized threads. Each array item represents the associated priority level
	//			so that _priority[0] holds references to all 0 priority threads, _priority[1] holds references to all 1 priority threads,
	//			and so on.
	private var _priority:Array=undefined;
	//_clockSpeed (number) - The clock speed for use in executing the threaded processes. The default is 1 (maximum)
	//			but this may be adjusted prior to issuing a call to 'start'. This value is directly related to the interval value
	//			for the 'setInterval' function.
	private var _clockSpeed:Number=undefined;
	//_interval (number) - Execution interval clock.
	private var _interval:Number=undefined;
	//_model (number) - The execution model to use in executing threads. A value of 0 indicates concurrent execution
	//			(all items execute at the same time), and 1 indicates stepped (one thread is executed on each clock cycle).
	//			For most applications a 0 model is recommended.
	private var _model:Number=undefined;

	// __/ PUBLIC METHODS \__

	/**
	* Method: ThreadManager
	*
	* Constructor method for the class.
	*
	* Parameters:
	* 	iniObj (object, optional) - An object containing reciprocal properties to the class instance. That is, each item in the object
	* 			will be assigned to an existing or new item in the class instance.
	* strict (boolean, optional) - if TRUE, items in initObj must both exist and be of the same type as the reciprocal items in the
	* 			class instance. Any items not matching this criteria is discarded.
	*
	* Returns:
	* 	object - A reference to the newly created class instance.
	*
	* See also:
	* <init>
	* <setDefaults>
	*/
	public function ThreadManager (initObj:Object, strict:Boolean) {
		this.setDefaults();
		if (initObj<>undefined) {
			this.init(initObj, strict);
		}// if
	}// constructor

	/**
	* Method: init
	*
	* Initializes class members by assigning reciprocal items in the parameter object to items in the class instance.
	*
	* Parameters:
	* 	iniObj (object, required) - An object containing reciprocal properties to the class instance. That is, each item in the object
	* 			will be assigned to an existing or new item in the class instance.
	* strict (boolean, optional) - if TRUE, items in initObj must both exist and be of the same type as the reciprocal items in the
	* 			class instance. Any items not matching this criteria are discarded.
	*
	* Returns:
	* 	bolean - FALSE if 'initObj' was not supplied.
	*
	* See also:
	* <ThreadManager>
	*/
	public function init(initObj:Object, strict:Boolean):Boolean {
		if (initObj==undefined) {return (false);};
		for (var item in initObj) {
			if (strict) {
				if (Extension.xtypeof(initObj[item])==Extension.xtypeof(this[item])) {
					this[item]==initObj[item];
				} else {
					this.broadcastError(1, 'ThreadManager.init: initObj.'+item+' is of the wrong type or not reciprocal in class instance. '+Extension.xtypeof(this[item])+' expected.');
				}// else
			} else {
				this[item]=initObj[item];
			}// else
		}// for
	}// init


	/**
	 * Method: addThread
	 *
	 *	Adds a thread to the thread stack by creating a new Thread instance and assigning all required values to it. While it is possible to
	 *	add multiple threads pointing to the same function, this practice should be avoided.
	 *
	 *  Parameters:
	 *		threadObj - (object, required) Object containing parameters for the desired thread. Allowable parameters
	 * 				are as follows:
	 * 				func - (function reference, required) A reference to the function to be called on each thread iteration
	 * 				context - (object reference, optional) The context or scope in which to invoke the function
	 * 				priority - (number, optional) The thread priority to assign to the thread. The highest priority is 0 and the lowest is 100. Values
	 * 							exceeding these limits will be capped at these minimum or maximum values. Threads are executed in order
	 * 							of priority so that all priority 0 items are executed first, priority 1 next, and so on. Default priority is 50.
	 * 				iterations - (number, optional) The maximum number of iterations to allow the thread to run before stopping it (1 based).
	 * 							For example, an 'iterations' value of 100 will run the threaded loop exactly 100 times and then stop.  A value of 0 will
	 * 							create an indefinite loop. Once it has reached its iteration limit it is removed from the thread loop. Default is 0.
	 * 				clockDivider - (number, optional) - The clock division value to be used for this thread. See <ThreadMgr.Thread._clockDivision>
	 * 							for more information. Setting this value to 0 effectively turns off the thread. Default is 1.
	 * 				parameters - (object, optional) - An object containing parameters to send to the threaded function. This may also be a single
	 * 							value if desired as no type checking is done.
	 *
	 *  Returns:
	 *    Thread  - An instance of the newly created Thread object, or undefined if an error occured. Errors include missing required parameters
	 * 				or a 'clockDivider' value of 0. A thread may be paused or re-started directly but should not be destroyed directly. Instead,
	 * 				use ThreadManager to remove the thread and be sure to remove an references to it that you may be keeping so that it can
	 * 				be fully removed from memory.
	 * See also:
	 * <removeThread>
	 * <ThreadMgr.Thread._clockDivision>
	 */

	public function addThread(threadObj:Object):Thread {
		if ((threadObj.func==undefined) || (Extension.xtypeof(threadObj.func)<>'function')) {
			this.broadcastError(1, 'ThreadManager.addThread: threadObj.func is either undefined or not a functon type.');
			return (undefined);
		}//if
		if (threadObj.priority==undefined) {threadObj.priority=50;}
		if (threadObj.iterations==undefined) {threadObj.iterations=0;}
		if (threadObj.clockDivider==undefined) {threadObj.clockDivider=1;}
		threadObj.priority=Number(threadObj.priority);
		threadObj.iterations=Number(threadObj.iterations);
		threadObj.clockDivider=Number(threadObj.clockDivider);
		if (threadObj.clockDivider==0) {
			this.broadcastError(5, 'ThreadManager.addThread: threadObj.clockDivider is 0. Thread processing would be blocked so thread not started.');
			return (undefined);
		}//if
		if (threadObj.priority>100) {threadObj.priority=100;}
		if (threadObj.priority<0) {threadObj.priority=0;}
		if (threadObj.priority[threadObj.priority]==undefined) {
			this._priority[threadObj.priority]=new Array();
		}//if
		var initObj:Object=new Object();
		initObj.threadFunction=threadObj.func;
		initObj.context=threadObj.context;
		initObj.priority=threadObj.priority;
		initObj.context=threadObj.context;
		initObj.maxIterations=threadObj.iterations;
		initObj.clockDivision=threadObj.clockDivider;
		initObj.parameters=threadObj.parameters;
		var threadInstance=new Thread(initObj, false);
		this._priority[threadObj.priority].push(threadInstance);
		this._threads.push(threadInstance);
		return (threadInstance);
	}// addThread

	/**
	 * Method: removeThread
	 *
	 * Removes a running thread instance from the stack at any priority levels it is found.
	 *
	 * Parameters:
	 * 	threadInstance (Thread, required) - A reference to the thread instance to remove. This instance
	 * 				reference is retrieved either as the return value from the 'addThread' method or during
	 * 				each thread execution loop as the second parameter for the called method.
	 *
	 * Returns:
	 * 	Nothing
	 *
	 * See also:
	 * 	<addThread>
	 */
	public function removeThread(threadInstance:Thread) {
		for (var priorityCount:Number=0; priorityCount<=100; priorityCount++) {
			if (this._priority[priorityCount]<>undefined) {
				var threadTotal:Number=this._priority[priorityCount].length;
				for (var threadCount:Number=0; threadCount<threadTotal; threadCount++) {
					var foundThread:Thread=this._priority[priorityCount][threadCount];
					if (foundThread==threadInstance) {
						threadInstance.destroy.call(threadInstance);
						this._priority[priorityCount].splice (threadCount,1);
					}//if
				}//if
			}//for
		}// for
	}//removeThread

	/**
	 * Method: start
	 *
	 * Starts threaded execution.
	 *
	 * Parameters:
	 * 	None
	 *
	 * Returns:
	 * 	boolean - TRUE if threaded execution started correctly, false if there was an error of some sort.
	 *
	 * See also:
	 * <stop>
	 */
	public function start():Boolean {
		if (this._interval>0) {
			this.stop();
		}//if
		this._interval=setInterval (this, 'processThread', this._clockSpeed, this);
		//Store as a global value just in case context is not maintained.
		_global.__Thread_Interval=this._interval;
		if (this._interval>0) {
			return (true);
		} else {
			return (false);
		}// else
	}//start

	/**
	 * Method: stop
	 *
	 * Stops threaded execution.
	 *
	 * Parameters:
	 * 	None
	 *
	 * Returns:
	 * 	Nothing
	 *
	 * See also:
	 * <start>
	 */
	public function stop():Boolean {
		clearInterval(this._interval);
		//Make doubly sure that interval is stopped using global value
		clearInterval(_global.__Thread_Interval);
		return (true);
	}//stop

	/**
	 * Method: processThreads
	 *
	 * The main thread processing loop method. This method should not really be called externally unless
	 * thread execution is stopped and a one-shot execution call is required (step-through, for example).
	 *
	 * Parameters:
	 * 	context (ThreadManager) - A reference to 'this'. This is passed into the method for double
	 * 				redundancy to ensure that proper context (scope) is used for execution.
	 *
	 * Returns:
	 * 	Nothing
	 *
	 * See also:
	 * <start>
	 * <stop>
	 */

	public function processThread(context:ThreadManager) {
		var thisRef:ThreadManager=this;
		if (thisRef<>context) {
			thisRef=context;
		}//if
		if (thisRef._priority.length==0) {return;}
		//Deal with condition in which array is empty but one array item is still left behind and set to undefined. This
		//may be the result of the push/splice operations or perhaps their order. Note that initially pushing a value into
		//the _priority array results in an array length of 2.
		if ((thisRef._priority.toString()=='undefined') && (thisRef._priority.length>0)) {
			delete thisRef._priority;
			thisRef._priority=new Array();
			return;
		}//if
		for (var priorityCount:Number=0; priorityCount<=100; priorityCount++) {
			if (thisRef._priority[priorityCount]<>undefined) {
				var threadTotal:Number=thisRef._priority[priorityCount].length;
				if (threadTotal==0) {
					thisRef._priority.splice(priorityCount,1);
				}//if
				for (var threadCount:Number=0; threadCount<threadTotal; threadCount++) {
					var threadInstance:Thread=thisRef._priority[priorityCount][threadCount];
					threadInstance.run.call(threadInstance);
					if ((threadInstance.iterations>=threadInstance.maxIterations) && (threadInstance.maxIterations>0)) {
						threadInstance.destroy.call(threadInstance);
						thisRef._priority[priorityCount].splice (threadCount,1);
					}//if
				}//if
			}//for
		}// for
		updateAfterEvent();
	}// processThread

	/**
	 * Method: Destroy
	 *
	 * Destroys any objects, class instances, movie clips, and variables that need to be removed before the instance of this class
	 * can be deleted. Be sure to call this method before issuing a 'delete' statement for this class instance otherwise
	 * errant processes and objects may linger in memory.
	 *
	 * Parameters:
	 * 	None
	 *
	 * Returns:
	 * 	Nothing
	 */
	public function destroy() {
		for (var item in this._threads) {
			this._threads[item].destroy.call(this._threads[item]);
		}//for
		delete this._threads;
		clearInterval(this._interval);
	}//destroy

	// __/ PRIVATE METHODS \__

	/**
	 * Method: broadcastError
	 *
	 * Broadcasts an error message via the Error class for all listeners to pick up.
	 *
	 * Parameters:
	 * 	code (number, required) - The numeric error code to broadcast. See the Error class' 'broadcast' method for valid codes.
	 * 	shortMsg (string, optional) - A brief description of the error. See the Error class' 'broadcast' method for preferred format.
	 * 	longMsg (string, optional) - A detailed explanation of the error message. A remedy should be included if possible.
	 *
	 * Returns:
	 * 	Nothing
	 *
	 * See also:
	 * 	<Error>
	 * 	<Error.broadcast>
	 */

	private function broadcastError (code:Number, shortMsg:String, longMsg:String) {
		var errorObj:Object=new Object();
		errorObj.sender=this;
		errorObj.code=code;
		errorObj.msg=shortMsg;
		errorObj.msgLong=longMsg;
		Error.broadcast(errorObj);
	}// broadcastError

	/**
	* Method: setDefaults
	*
	* Creates required class members and assigns default values.
	*
	* Parameters:
	* 	None
	*
	* Returns:
	* 	Nothing
	*
	* See also:
	* <ThreadManager>
	*/
	private function setDefaults() {
		this._threads=new Array();
		this._priority=new Array();
		this._clockSpeed=new Number(1);
		this. _interval=new Number(0);
		this._model=new Number(0);
	}// setDefaults

}// ThreadManager class