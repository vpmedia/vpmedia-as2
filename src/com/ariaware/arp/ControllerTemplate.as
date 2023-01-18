////////////////////////////////////////////////////////////////////////////////
//
// Ariaware RIA Platform (ARP)
// Copyright © 2004 Aral Balkan.
// Copyright © 2004 Ariaware Limited
// http://www.ariaware.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// Project: Ariaware RIA Platform.
// File: ControllerTemplate (Singleton)
// Purpose: Template for application controller.
// Created by: Aral Balkan
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

// Note: Interfaces are Flash Player 7 only. If you need Flash Player 6
// compatibility, use ControllerTemplateForFlashPlayer6 instead
import com.ariaware.arp.ICommand;

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: Controller
//
//
////////////////////////////////////////////////////////////////////////////////
class com.ariaware.arp.ControllerTemplate
{
	//
	// Properties
	//
	private var app = null; // reference to the application instance
	private var commands:Object = null; 	// holds named list of commands
	
	private var commandLog:Array = null;	// log of commands

	////////////////////////////////////////////////////////////////////////////
	//
	// Constructor
	//
	////////////////////////////////////////////////////////////////////////////
	function ControllerTemplate ()
	{
		// initialize properties
		commands = new Object();
		commandLog = new Array();
	}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods 
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// registerApp() (Concrete)
	////////////////////////////////////////////////////////////////////////////
	function registerApp ( app )
	{
		trace ("INFO ControllerTemplate::registerApp()");
		
		// store application reference
		this.app = app;
		
		// add view event listeners manually
		// (hook operation)
		addEventListeners();
		
		// add commands manually
		// (hook operation)
		addCommands();
	}

	////////////////////////////////////////////////////////////////////////////
	//
	// Public Event Handlers
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// handleEvent() (Concrete)
	////////////////////////////////////////////////////////////////////////////
	function handleEvent ( eventObj )
	{
		//
		// handleEvent() is a generic event handler that gets called whenever
		// an event is heard. 
		//
		trace ("INFO ControllerTemplate::handleEvent - " + eventObj.type );
		
		var eventName:String = eventObj.type;
		var commandNameToCheck:String = eventName + "Command";
		
		// Reference to the object that generated the event
		var viewRef = eventObj.target;
		
		if ( commands [ commandNameToCheck ] == undefined )
		{
			throw new Error ("ERROR ControllerTemplate::handleEvent - Unknown command called: "+commandNameToCheck+" from "+viewRef+". Please add this command to the Controller in its addCommands() method.");
		}
		else
		{
			trace ("INFO ControllerTemplate::handleEvent - Creating and executing new "+commandNameToCheck);
			
			// Create a new command
			var theCommand:ICommand = new commands [ commandNameToCheck ] ();
			
			// Execute the command 
			theCommand.execute( viewRef );
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// getInstance() primitive operation
	////////////////////////////////////////////////////////////////////////////
	public static function getInstance ()
	{
		//
		// The class that subclasses ControllerTemplate must be a singleton
		// and must thus override the getInstance method.
		//
		throw new Error (
			"ERROR ControllerTemplate - getInstance primitive operation has not been implemented."
			+ "\nThe Application Controller must be a singleton and provide a concrete implementation of getInstance."
		);
	}


	////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	//
	////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
	// addCommand() (Concrete)
	////////////////////////////////////////////////////////////////////////////
	private function addCommand ( commandName:String, commandRef:Function)
	{
		trace ("INFO Controller - Command added:"+commandName+".");
		
		if ( commands [ commandName ] != undefined ) 
		{
			throw new Error ("ERROR The command "+commandName+" has already been added to the Controller.");
		}
		else
		{
			commands [ commandName ] = commandRef;
		}
	}	

	
	////////////////////////////////////////////////////////////////////////////
	// addListeners() - primitive operation for manual addition of listeners
	////////////////////////////////////////////////////////////////////////////
	private function addEventListeners ()
	{
		//
		// Listen for events from the view. To separate screens may dispatch
		// the same event and these will be handled by the same event handler.
		// No two screens should use the same event for different purposes.
		//
		// The general format should be:
		//
		// var queryScreen:QueryScreen = QueryScreen ( app.getScreen( app.QUERY_SCREEN ) );
		// queryScreen.addEventListener( "getPersonList", this );
		
		throw new Error ( 
			"ERROR ControllerTemplate - addEventListeners() primitive operation not implemented."
			+ "\nEvents have not been added to controller" 
		);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// addCommands() - primitive operation for manual addition of commands
	////////////////////////////////////////////////////////////////////////////
	private function addCommands ()
	{
		//
		// Note: Commands are added as references to the classes. Dispatching 
		// a command includes creating an instance of it, which is then kept
		// in a history log on the controller. The command is automatically 
		// removed after the service has returned (so we don't have a memory leak).
		// This is superior to how a single command was reused in the previous
		// framework and allows a single command to be called from multiple views.
		//
		// The general format should be:
		//
		// addCommand ( "getPersonListCommand", GetPersonListCommand );
		
		throw new Error ( 
			"ERROR ControllerTemplate - addCommands() primitive operation not implemented."
			+ "\nCommands not added to controller" 
		);
	}
}
