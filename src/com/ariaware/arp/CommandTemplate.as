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
// Project: Ariaware RIA Platform
// File: CommandTemplate
// Purpose: Template for Commands
// Created by: Aral Balkan
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

// none

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: CommandTemplate
//
//
////////////////////////////////////////////////////////////////////////////////
class com.ariaware.arp.CommandTemplate
{
	//
	// Properties
	//
	
	// If the ConcreteCommand uses a Business Delegate, it should define it
	// as a member property.
	
	// Reference to the view for this command. This is *not* strongly typed on
	// purpose since we don't know the exact type of the view even at runtime
	// (Flash doesn't provide much in the way introspection.)
	var viewRef;	

	////////////////////////////////////////////////////////////////////////////
	//
	// Constructor
	//
	////////////////////////////////////////////////////////////////////////////
	function Command ()
	{
	}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Primitive operations (*must* be overriden)
	//
	////////////////////////////////////////////////////////////////////////////
	
	//
	// ConcreteCommand classes have to override the executeOperation method 
	// with their command behavior. This is called by the concrete execute()
	// method.
	//
	public function executeOperation ()
	{
		throw new Error ("ERROR Command did not implement primitive operation executeOperation(). No behavior defined for command.");
	}

	//
	// The onResultOperation primitive operation must be overriden. Although
	// Commands do not have to call services, it is assumed that a vast majority
	// will and this restriction is in place to aid in debugging and maintainance
	// of the code. Even commands that do not use service calls must define this.
	//
	public function onResultOperation () 
	{
		throw new Error ("ERROR Command did not implement primitive operation onResultOperation().");
	}

	////////////////////////////////////////////////////////////////////////////
	//
	// Hook operations (ConcreteCommands are *not* required to override these
	// but may do so if they wish.)
	//
	////////////////////////////////////////////////////////////////////////////
	
	public function onStatusOperation () {}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Concrete operations
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// execute()
	////////////////////////////////////////////////////////////////////////////

	public function execute ( viewRef )
	{
		trace ("INFO Command::execute");
		
		// save view reference
		this.viewRef = viewRef;
		
		// primitive operation
		executeOperation();
	}

	////////////////////////////////////////////////////////////////////////////
	//
	// Concrete event handlers. (Most Commands will call service functions
    // and we anticipate this behavior by implementing skeleton onStatus and
	// onResult event handlers.)
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// onStatus()
	////////////////////////////////////////////////////////////////////////////
	public function onStatus ( statusObj )
	{
		trace ("STATUS Command::onStatus");
		// print out trace of error, including Java stack trace if applicable
		for ( var i in statusObj )
		{
			trace ( i + " = " + statusObj[i] );
		}

		// hook operation 
		onStatusOperation( statusObj );
	}
	
	////////////////////////////////////////////////////////////////////////////
	// onResult()
	////////////////////////////////////////////////////////////////////////////
	public function onResult ( resultObj )	
	{
		trace ("INFO Command::onResult - "+resultObj);
		
		// primitive operation
		onResultOperation( resultObj );
	}
}
