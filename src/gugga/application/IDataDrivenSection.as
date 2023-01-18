/**
 * @author todor
 */

import gugga.application.ISection;
import gugga.common.EventDescriptor;

interface gugga.application.IDataDrivenSection extends ISection 
{
	private function getLoadDataFinishedEventInfo():EventDescriptor;
	private function getLayOutFinishedEventInfo():EventDescriptor;	
	
	private function loadData();
	private function layOut();
}