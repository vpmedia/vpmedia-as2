/**
* Class: Thread
*
* Version: v1.0
* Released: March 13, 2006
*
* Provides singular thread settings for the ThreadManager class. This class may be extended for sub-threading.
*
* Note that failure to provide a 'context' setting (see public variables below) will result in a limitation of 20 parameters
* on threaded function calls. For most applications this is adequate but if more than 20 parameters are required then
* either the 'context' setting must be provided or the 'run' method must be changed to support more variables.
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
*		Requires: com.bnm.fc.Extension
*		Required By: com.bnm.fc.ThreadManager
*		Required Data Sources: None
*		Required Assets:
*			None
*
*
* History:
*
* v1.0 [03/13/06]
* 	- first public version
* 	- Added Error reporting via Error class.
*
*/
import com.bnm.fc.Extension;
import com.bnm.fc.Error;
class com.bnm.fc.ThreadMgr.Thread {

	// __/ STATIC VARIABLES \_
	//threadCount (Number) - The number of currently active thre
	public static var threadCount:Number=new Number(0);

	// __/ PUBLIC VARIABLES \_
	//parentClass (object) - A pointer to the class, movie clip, or object that created this class instance. May be required by
	//			some methods. Should always be set to ensure proper functioning.
	public var parentClass:Object=undefined;
	//threadFunction (Function) - The function to call on each thread iteration.
	public var threadFunction:Function=undefined;
	//context (object reference) - The context, or scope, in which to run 'threadFunction'
	public var context:Object=undefined;
	//priority (number) - Execution priority used by the thread manager.
	public var priority:Number=undefined;
	//maxIterations (number) - The maximum number of iterations to allow for this thread. A value of 0 indicates no maximum.
	public var maxIterations:Number=undefined;

	// __/ PRIVATE VARIABLES \_
	//parameters (object) - An object containing parameters to send to the target thread function.
	private var _parameters:Object=undefined;
	//_clockDivision (number) - The devision number of the ThreadManager execution clock for this thread. This value essentially
	//			divides the execution clock for this thread and effectively slows it down.  If, for example, this value is set to 2, only
	//			every second tick of the ThreadManager clock will execute this thread. If the ThreadManager clock is set to 10ms,
	//			this thread will execute ever 20ms. Only whole values are currently accepted. A value of 0 effectively halts the thread.
	private var _clockDivision:Number=undefined;
	//_clockCounter (number) - A counter used with '_clockDivision' to skip execution steps.
	private var _clockCounter:Number=undefined;
	//_iteration (number) - The current iteration count for the thread.
	private var _iteration:Number=undefined;

	// __/ PUBLIC METHODS \__

	/**
	* Method: Thread
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
	public function Thread (initObj:Object, strict:Boolean) {
		threadCount++;
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
	* <Thread>
	*/
	public function init(initObj:Object, strict:Boolean):Boolean {
		if (initObj==undefined) {return (false);};
		for (var item in initObj) {
			if (strict) {
				if (Extension.xtypeof(initObj[item])==Extension.xtypeof(this[item])) {
					this[item]==initObj[item];
				} else {
					this.broadcastError(1, 'Thread.init: initObj.'+item+' is of the wrong type or not reciprocal in class instance. "'+Extension.xtypeof(this[item])+'" expected.');
				}// else
			} else {
				this[item]=initObj[item];
			}// else
		}// for
	}// init

	/**
	 * Method: run
	 *
	 * Processes a single iteration of the thread. A secondary parameter pointing to this class instance is sent on each call to give
	 * each threaded function a reference to its own caller.
	 *
	 *	Parameters:
	 * 	None
	 *
	 * Returns:
	 * 	Nothing
	 */
	public function run() {
		if ((this._iteration>=this.maxIterations) && (this.maxIterations>0)) {return;}
		if (this._clockDivision==0) {return;}
		this._clockCounter++;
		if (this._clockCounter<this._clockDivision) {return;}
		if (this._clockCounter>=this._clockDivision) {
			this._clockCounter=0;
		}//if
		if (this.context<>undefined) {
			this.threadFunction.call(this.context, this._parameters, this);
		} else {
			this.threadFunction(this._parameters, this);
		}//else
		if (this.maxIterations>0) {
			this._iteration++;
		}//if
	}//run

	// __/ SETTERS AND GETTERS \__

	/**
	 * Method: set parameters
	 *
	 * Sets the parameters for the threaded method call.
	 *
	 *	Parameters
	 * 	args (object, required) - An object containing the desired parameters. May be a single parameter as well (a string, for example).
	 */
	public function set parameters(args:Object) {
		this._parameters=args;
	}// set parameters

	/**
	 * Method: set clockDivision
	 *
	 * Sets the clock division value for threaded execution.
	 *
	 * Parameters
	 * 	div (number, required) - The clock division to use.
	 *
	 * Returns
	 * 	Nothing
	 *
	 */
	public function set clockDivision(div:Number) {
		if ((div==undefined) || (Extension.xtypeof(div)<>'number')) {return;}
		if (div<0) {return;}
		this._clockDivision=Math.floor(div);
	}//set clockDivision


	/**
	 * Method: get iterations
	 *
	 * Retrieves the current iteration count for this thread.
	 *
	 * Returns:
	 *    number - The current iteration count
	 */

	public function get iterations():Number {
		return (this._iteration);
	}//get iterations

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
		threadCount--;
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
	* <Thread>
	*/
	private function setDefaults() {
		//Default priority 50 (min =100, max =0)
		this.priority=new Number(50);
		this.maxIterations=new Number(0);
		this._parameters=new Array();
		this._clockDivision=new Number(1);
		this._clockCounter=new Number(0);
		this._iteration=new Number(0);
	}// setDefaults

}// Thread class