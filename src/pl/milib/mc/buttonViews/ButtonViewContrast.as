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

import com.gskinner.geom.ColorMatrix;

import flash.filters.ColorMatrixFilter;

import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.abstract.AbstractButtonView;
import pl.milib.mc.service.MIMC;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.buttonViews.ButtonViewContrast extends AbstractButtonView {
	
	private var mimc : MIMC;
	private var cMatrix : ColorMatrix;
	private var cMatrixOver : ColorMatrix;
	private var cMatrixPress : ColorMatrix;
	private var cMatrixOut : ColorMatrix;
	
	public function ButtonViewContrast(mc:MovieClip, $outContrast:Number, $overContrast:Number, $pressContrast:Number) {
		mimc=MIMC.forInstance(mc);
		cMatrixOut=new ColorMatrix((new ColorMatrixFilter()).matrix);
		cMatrixOut.adjustContrast($outContrast==null ? 0 : $outContrast);
		cMatrixOver=new ColorMatrix((new ColorMatrixFilter()).matrix);
		cMatrixOver.adjustContrast($overContrast==null ? 20 : $overContrast);
		cMatrixPress=new ColorMatrix((new ColorMatrixFilter()).matrix);
		cMatrixPress.adjustContrast($pressContrast==null ? 40 : $pressContrast);
	}//<>
	
//****************************************************************************
// EVENTS for FourFramesButtonView
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				setStateByActual();
			break;
			case state:
				switch(ev.event){
					case state.event_ValueChanged:
						switch(state.v){
							case state_OUT:
								mimc.mc.filters=[];
							break;
							case state_OVER:
								mimc.mc.filters=[new ColorMatrixFilter(cMatrixOver)];
							break;
							case state_PRESSED:
								mimc.mc.filters=[new ColorMatrixFilter(cMatrix)];
							break;
							case state_DISABLED:
								
							break;
						}
					break;
				}
			break;
		}
	}//<<Events
}