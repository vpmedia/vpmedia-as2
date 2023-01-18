/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-14
 ******************************************************************************/

import fcadmin.data.LicenseInfo;
import fcadmin.utils.LicenseUtil;

/**
 * License information including information on the maximum bandwidth 
 * and maximum number of connections, adaptors, virtual hosts, and 
 * CPUs that are allowed by the license. License information for all 
 * your licenses is first summarized, followed by specific information 
 * about each license.
 */
class fcadmin.data.LicenseSummary
{

	/**
	 * Product name.
	 */	
	var name:String;
	

	/**
	 * Version number.
	 */
	var version:String;


	/**
	 * Build number.
	 */
	var build:String;

	/**
	 * Copyright information.
	 */
	var copyright:String;

 
 	/**
	 * 'Developer', 'Commercial' or 'Educational'.
	 */
	var type:String;
 
	/**
	 * 'Personal' or 'Professional'.
	 */
	var family:String;


	/**
	 * Edition, for example, single, trial, beta, unlimited, and so on. 
	 * If you have multiple licenses, they must have the same edition number.
	 */
	var edition:String;
 

	/**
	 * Maximum number of socket connections allowed, which is determined by 
	 * license family.
	 * If you have more than one license, this number is the sum of the 
	 * maxConnections values of all your licenses.
	 */
	var maxConnections:Number;


	/**
	 * Maximum number of adaptors (network cards) that you can configure for 
	 * the server, which is determined by license family. 
	 * If the license family is Personal, the value of maxAdaptors is 1. 
	 */
	var maxAdaptors:Number; 
	
	/**
	 * Maximum number of virtual hosts for each adaptor, for this 
	 * license. If the license family is Personal, this value is 1.
	 */
	var maxVHosts:Number;

	/**
	 * Maximum number of CPUs allowed, which is determined by license family.
	 * If this number is greater than 1, you can run the server on 
	 * multiprocessor computers.
	 */
	var maxCPU:Number;

	/**
	 * Maximum bandwidth, in megabits per second. If you have multiple licenses,
	 * this number is the sum of the maxBandwidth values of all your licenses.
	 */
	var maxBandwidth:Number; 
	
	
	/**
	 * Contains the information for each license key. If you have more than one 
	 * license key, there is one array element for each license key. 
	 *
	 * @see fcadmin.data.LicenseInfo
	 */
	var keyDetails:Array;



	private function LicenseSummary()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawInfo:Object):LicenseSummary
	{
		//trace("LicenseSummary.fromRawData:\r"+fcadmin.utils.ObjectUtil.getProperties(rawInfo,true).join("\r"));

		
		var licenseSummary:LicenseSummary=new LicenseSummary();

		licenseSummary.name=rawInfo.name;
		licenseSummary.version=rawInfo.version;
		licenseSummary.build=rawInfo.build;
		licenseSummary.copyright=rawInfo.copyright;
		licenseSummary.type=LicenseUtil.typeString(rawInfo);
		licenseSummary.family=LicenseUtil.familyString(rawInfo);
		licenseSummary.edition=LicenseUtil.editionString(rawInfo);
		licenseSummary.maxConnections=rawInfo.max_connections;
		licenseSummary.maxAdaptors=rawInfo.max_adaptors;
		licenseSummary.maxVHosts=rawInfo.max_vhosts;
		licenseSummary.maxCPU=rawInfo.max_cpu;
		licenseSummary.maxBandwidth=rawInfo.max_bandwidth;
		licenseSummary.keyDetails=new Array();

		for(var i:Number=0;i<rawInfo.key_details.length;i++)
		{
			licenseSummary.keyDetails.push(LicenseInfo.fromRawData(rawInfo.key_details[i]))
		}

		return licenseSummary;
	}

}
