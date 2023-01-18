/******************************************************************************* 
 * Contributors: 
 *        pawaca(pawaca@mess-up.com) - initial API and implementation 
 * Last modified:
 *        2005-1-14
 ******************************************************************************/

import fcadmin.utils.LicenseUtil;


/**
 * Specific information about each license.
 */
class fcadmin.data.LicenseInfo
{

	/**
	 * License key as set in Server.xml.
	 */	
	var key:String;
 
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
	 */
	var edition:String;
 

	/**
	 * Maximum socket connections allowed for this license.
	 */
	var maxConnections:Number;


	/**
	 * Maximum adaptors (network cards) allowed for this license. 
	 * If the license family is Adaptor, this value is 1.
	 */
	var maxAdaptors:Number; 
	
	/**
	 * Maximum number of virtual hosts for each adaptor, for this 
	 * license. If the license family is Personal, this value is 1.
	 */
	var maxVHosts:Number;

	/**
	 * Maximum number of CPUs allowed. If this number is greater
	 * than 1, you can run the server on multiprocessor computers.
	 */
	var maxCPU:Number;

	/**
	 * Maximum bandwidth, in megabits per second.
	 */
	var maxBandwidth:Number; 

	/**
	 * Determined by license family.
	 */
	var productCode:String;

	
	var expires:Date;
	var valid:Boolean;	
	var used:Boolean;


	private function LicenseInfo()
	{
	}

	/**
	 * @exclude
	 */
	static function fromRawData(rawInfo:Object):LicenseInfo
	{
		
		//trace("LicenseInfo.fromRawData:\r"+fcadmin.utils.ObjectUtil.getProperties(rawInfo,true).join("\r"));

		var licenseInfo:LicenseInfo=new LicenseInfo();

		licenseInfo.key=rawInfo.key;

		licenseInfo.type=LicenseUtil.typeString(rawInfo);
		licenseInfo.family=LicenseUtil.familyString(rawInfo);
		licenseInfo.edition=LicenseUtil.editionString(rawInfo);		
		licenseInfo.productCode=LicenseUtil.productCodeString(rawInfo);
		licenseInfo.expires=LicenseUtil.hasExpire(rawInfo)?rawInfo.expires:-1;
		licenseInfo.maxConnections=LicenseUtil.isCapacityUpgrade(rawInfo)?-1:rawInfo.max_connections;
		licenseInfo.maxBandwidth=LicenseUtil.isCapacityUpgrade(rawInfo)?-1:rawInfo.max_bandwidth;


		

		licenseInfo.maxAdaptors=rawInfo.max_adaptors;
		licenseInfo.maxVHosts=rawInfo.max_vhosts;
		licenseInfo.maxCPU=rawInfo.max_cpu;

		licenseInfo.used=rawInfo.used;
		licenseInfo.valid=rawInfo.valid==0?false:true;


		return licenseInfo;
	}

}
