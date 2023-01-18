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
// Project: Ariaware RIA Platform (ARP)
// File: ServiceLocatorTemplate.as
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
// Class: ServiceLocatorTemplate
//
//
////////////////////////////////////////////////////////////////////////////////
class com.ariaware.arp.ServiceLocatorTemplate
{
	//
	// Properties
	//
	private var serviceRegistry:Object;	// registry of known services
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Constructor
	//
	////////////////////////////////////////////////////////////////////////////
	function ServiceLocatorTemplate ()
	{
		serviceRegistry = new Object();
	   	addServices();
	}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Public Methods
	//
	////////////////////////////////////////////////////////////////////////////

	
	////////////////////////////////////////////////////////////////////////////
	// getInstance() primitive operation
	////////////////////////////////////////////////////////////////////////////
	public static function getInstance ()
	{
		//
		// The class that subclasses ServiceLocatorTemplate must be a singleton
		// and must thus override the getInstance method.
		//
		throw new Error (
			"ERROR ServiceLocatorTemplate - getInstance primitive operation has not been implemented."
			+ "\nThe Service Locator must be a singleton and provide a concrete implementation of getInstance."
		);
	}

	////////////////////////////////////////////////////////////////////////////
	// getService() concrete operation
	////////////////////////////////////////////////////////////////////////////
	public function getService ( serviceName )
	{
		// Untyped because the Service Locator can handle many different 
		// types of services (eg. mx.remoting.Service for Remoting services
		// that use the Version 2 API.)
		var theService = serviceRegistry [ serviceName ];
		trace ("returning "+theService); 
		return theService;
	}

	////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// addServices() primitive operation
	////////////////////////////////////////////////////////////////////////////
	private function addServices ()
	{
		//
		// Override this method in your Service Locator and add your services
		// to it using the inherited addService() method.
		//

		throw new Error ( 
			"ERROR ServiceLocatorTemplate - addServices() primitive operation not implemented."
			+ "\nServices not added to Service Locator." 
		);
	}

	
	////////////////////////////////////////////////////////////////////////////
	// addService() concrete method
	////////////////////////////////////////////////////////////////////////////
	private function addService ( serviceName:String, serviceRef:Object )
	{
		trace ("adding : "+serviceName+ " = "+ serviceRef);
	
		// Register the passed service instance reference with the
		// Service Locator, using the name (String) passed in serviceName
		// as the lookup index. 
		serviceRegistry [ serviceName ] = serviceRef;
	}

}	
