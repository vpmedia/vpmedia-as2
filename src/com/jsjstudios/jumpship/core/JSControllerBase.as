﻿//////////////////////////////////////////////////////////////////////////////////// JumpShip Framework// Copyright 2006 Jamie Scanlon//// Permission is hereby granted, free of charge, to any person obtaining a copy // of this software and associated documentation files (the "Software"), to deal // in the Software without restriction, including without limitation the rights // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell // copies of the Software, and to permit persons to whom the Software is // furnished to do so, subject to the following conditions://// The above copyright notice and this permission notice shall be included in all // copies or substantial portions of the Software.//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS // IN THE SOFTWARE.//// Project: JumpShip Framework// File: JSControllerBase.as// Created by: Jamie Scanlon//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Imports////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Class: JSControllerBase/////////////////////////////////////////////////////////////////////////////////////*** Controller Base Class.*/class com.jsjstudios.jumpship.core.JSControllerBase{	//	// Assets	//		private var eventBroadcasters:Array;	// references to all objects that will be											// Broadcasting events to this controller												private var commands:Object;				// holds named list of commands		private var commandLog:Array;			// log of commands	private var commandHistory:Array;		// history of commands		private var viewLookupTable:Array;		// An associative array of commands and their corresponding views		//	// Functions	//	public var addListener:Function;		// Used by AsBroadcaster	public var removeListener:Function;		// Used by AsBRoadcaster	public var broadcastMessage:Function;	// Used by AsBroadcaster to broadcast message		//	// Constants	//	/** 	* Constant: Determines the maximum number of commands the controller will remember	* in it's history.	*/	private var MAXHISTORY:Number = 100;	// maximum number of history entries		////////////////////////////////////////////////////////////////////////////	//	// Constructor	//	////////////////////////////////////////////////////////////////////////////		function JSControllerBase () 	{				// Initialize AsBroadcaster to enable event broadcasting		AsBroadcaster.initialize(this);				// initialize properties		eventBroadcasters = new Array();		commands = new Object();		commandLog = new Array();		commandHistory = new Array();				viewLookupTable = new Array();				// Hook Operation		preCommandInit();				// Hook Operation		addCommands();				// Hook Operation		init();			}		////////////////////////////////////////////////////////////////////////////	//	// Public Methods 	//	////////////////////////////////////////////////////////////////////////////		////////////////////////////////////////////////////////////////////////////	//	// Concrete Methods	//	////////////////////////////////////////////////////////////////////////////	/** 	* Registers an event broadcaster with this controller. This method differs from registerEventDispatcher in that the object being registerd is expected to issue an event by calling the AsBroadcaster.broadcastMessage method.	* @param theEventBroadcaster A reference to the event issuer.	* @param reciprocate A Boolean value that determines if theEventBroadcaster should also be added as a listener to this object.	* @see public function registerEventDispatcher ( theEvent:String, theEventDispatcher:Object, reciprocate:Boolean )	*/	public function registerEventBroadcaster ( theEventBroadcaster:Object, reciprocate:Boolean ) 	{				// store application reference		this.eventBroadcasters.push({type:"broadcaster", broadcaster:theEventBroadcaster});				// register this controller as a listener		theEventBroadcaster.addListener(this);				if (reciprocate) {						this.addListener(theEventBroadcaster);					}			}		/** 	* Registers an event dispatcher with this controller. This method differs from registerEventBroadcaster in that the object being registerd is expected to issue an event by calling the EventDispatcher.dispatchEvent method.	* @param theEvent A string with the name of the event to listen for.	* @param theEventDispatcher A reference to the event issuer.	* @param reciprocate A Boolean value that determines if theEventDispatcher should also be added as a listener to this object.	* @see public function registerEventBroadcaster ( theEventBroadcaster:Object, reciprocate:Boolean )	*/	public function registerEventDispatcher ( theEvent:String, theEventDispatcher:Object, reciprocate:Boolean ) 	{				// store application reference		this.eventBroadcasters.push({type:"dispatcher", broadcaster:theEventDispatcher, event:theEvent});				// register this controller as a listener		theEventDispatcher.addEventListener(theEvent, this);				if (reciprocate) {						this.addListener(theEventDispatcher);					}			}		/** 	* Returns the result of a command. This method calls the afterFilter() hook 	* method and removes command object. This method then calls the processCommandResult 	* primitive method with the result.	* @param theResultObject An object containing the result information from the command.	* @param theID A String with the ID of the command returning the result.	*/	public function returnCommandResult(theResultObject:Object, theID:String) 	{				afterFilter(theResultObject.type);				// Free up memory		delete commandLog[theID];		commandLog[theID] = undefined;				processCommandResult(theResultObject); 			}		/** 	* Returns a reference to the View that is associated with a given command.	* @param theCommandName A string with the name of the class requesting a reference.	* @throws Error If the command name has not been registered with this controller	* @return A reference to the view associated with this command. 	*/	public function requestView ( theCommandName:String ) 	{				//		// this method returns the proper view accociated with a given command.		//				if ( commands [ theCommandName ] != undefined ) {			return viewLookupTable[ theCommandName ];		} else {			throw new Error ("ERROR The command "+theCommandName+" is trying to perform an command but is not registered with the Controller.");		}			}		////////////////////////////////////////////////////////////////////////////	//	// Primitive methods (*must* be overriden)	//	////////////////////////////////////////////////////////////////////////////		/** 	* In most cases, this controller will be a Singleton. This is a primitive method to return the Singleton instance of this controller. If the extending controller is not a Singleton, the extending class should still overwrite this method to throw a new error.	* @throws Error If this method has not been implemented in the extending class.	* @return A reference to this controller.	*/	public static function getInstance () 	{		//		// The class that subclasses ATControllerTemplate must be a singleton		// and must thus override the getInstance method.		//		throw new Error (			"ERROR JSControllerBase - getInstance primitive operation has not been implemented."			+ "\nThe Application Controller must be a singleton and provide a concrete implementation of getInstance."		);				//		// sample imlementation...		//		/*		if ( inst == null )		{			// create a single instance of the singleton			inst = new JSControllerBase();					}				return inst;		*/	}	////////////////////////////////////////////////////////////////////////////	//	// Public Event Handlers	//	////////////////////////////////////////////////////////////////////////////	//	// A sample implementation...	//	/*	function handleEvent ( eventObj ) 	{				var eventName:String = eventObj.type;				// Step 1 - Evaluate the current state:		var currentState = _myCurrentState;				// Step 2 - Choose an command to take based on the current state:		if (currentState == "menu") {						var parameters:Object = new Object();						parameters.newMode = "image";						//			createCommand("doTransitionCommand", parameters);					} else if (currentState == "image") {						var parameters:Object = new Object();						parameters.scaleSize = 50;			parameters.scalePositonX = 100;			parameters.scalePositonY = 100;						//			createCommand("doCommand1", parameters);			createCommand("doCommand2", parameters);			createCommand("doCommand3", parameters);					}			}	*/		////////////////////////////////////////////////////////////////////////////	//	// Hook Functions	//	////////////////////////////////////////////////////////////////////////////		private function preCommandInit(){}		private function init(){}		private function beforeFilter(theCommandName:String){}		private function afterFilter(theCommandName:String){}		////////////////////////////////////////////////////////////////////////////	//	// Concrete functions	//	////////////////////////////////////////////////////////////////////////////		private function addCommand ( commandName:String, commandRef:Function) 	{				if ( commands [ commandName ] != undefined ) {			throw new Error ("ERROR The command "+commandName+" has already been added to the Controller.");		} else {			commands [ commandName ] = commandRef;		}	}		private function createCommand(theCommandName:String, theParams:Object) 	{				// Create a unique id for this command		var tempDate:Date = new Date();		var idNum:Number = Date.UTC(tempDate.getFullYear(),tempDate.getMonth(), tempDate.getDate(), tempDate.getHours(), tempDate.getMinutes(), tempDate.getSeconds(), tempDate.getMilliseconds());		var idString:String = String(idNum);				// Check to see if this id already exists		while (commandLog[idString] != undefined) {						// if so increment the id number			idNum++;			idString = String(idNum);					}				beforeFilter(theCommandName);				commandLog[idString] = new commands [ theCommandName ]();		commandHistory.push({name:theCommandName, params:theParams});				// to prevent a memory leak, limit the size of the array to MAXHISTORY		while (commandHistory.length > MAXHISTORY) {						commandHistory.splice(0,1);					}				commandLog[idString].execute(this, idString, theParams);				}		////////////////////////////////////////////////////////////////////////////	//	// Primitive functions (*must* be overriden)	//	////////////////////////////////////////////////////////////////////////////		private function addCommands () 	{		//		// Note: Commands are added as references to the classes. Dispatching 		// a command includes creating an instance of it, which is then kept		// in a history log on the controller. The command is automatically 		// removed after the service has returned (so we don't have a memory leak).		//		// The general format should be:		//		// addCommand ( "getPersonListCommand", GetPersonListCommand );				throw new Error ( 			"ERROR JSControllerBase - addCommands() primitive operation not implemented."			+ "\nCommands not added to controller" 		);	}		private function processCommandResult(theResultObject:Object) 	{				throw new Error ( "ERROR JSControllerBase - processCommandResult() primitive operation not implemented.");				// theResultObject will be in the form:		// theResultObject.type : String - the name of the command returning the result		// theResultObject.result : Object - the actual result				// Step 1 - Evaluate result.				// Step 2  - Update the current State (If needed).				// Step 3  - Broadcast Message based on what took place.		// Example:		// this.broadcastMessage("stateChangeEvent", this);			}	}