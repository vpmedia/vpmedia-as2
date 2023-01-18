/**
 * Klasa stworzona z myślą o początkowym wczytywaniu głównych klipów, XMLów, itp.
 * zanim zostanie wczytany SWF z AS. Czyli jest to zupełnie samodzielna klasa.
 * 
 * Zajmuje się obserwacją postępu wczytywania kilku obiektów jednocześnie
 * wczytywane obiekty są podawane na samy początku poprzez konstruktor.
 * 
 * Zanim nastąpi utworzenie instancji musi zostać uruchomione wczytywanie obiektów.
 * Obiekty te muszą posiadać dwie metody:
 *  - getBytesLoaded()
 *  - getBytesTotal()
 * 
 * Nie uwzględnia sytuacji w której nie udało się wczytać pliku.
 * 
 *  - ONETIME
 *  - MAUALSTART
 * 
 * @author Marek Brun 'minim'
 */
/*EX

//events
onEventLoadingsObserverInit=function(){}
onEventLoadingsObserverBytesTotalAchieved=function(){}
onEventLoadingsObserverProgress=function(){}
onEventLoadingsObserverEnd=function(){}
EX*/
class pl.milib.tools.LoadingsObserver {
	
	private var loadedObjects : Array;
	private var objectsWithNoTotalBytes : Array;
	private var phaseNow : Object;
	private var phase_0_Init : Object = {name:'Init'};
	private var phase_1_GetObjectsBytesTotal : Object = {name:'GetObjectsBytesTotal'};
	private var phase_2_GetObjectsBytesLoaded : Object = {name:'GetObjectsBytesLoaded'};
	private var phase_3_WaitAfterEnd : Object = {name:'WaitAfterEnd'};
	private var phase_4_End : Object = {name:'End'};
	private var bytesTotal : Number;
	private var lastBytesLoaded : Number;
	private var mcOEF : MovieClip;
	
	public function LoadingsObserver(loadedObjects : Array){
		this.loadedObjects=loadedObjects;
		phaseNow=phase_0_Init;
		mcOEF=_root.createEmptyMovieClip('mcFromLoadingsObserver', _root.getNextHighestDepth());
	}//<>
	
	public function start(Void):Void {
		mcOEF.boss=this;
		mcOEF.onEnterFrame=function(){ this.boss.onMCEnterFrame(); };
		delete start;
	}//<<
	
	public function getProgressN01(Void) : Number{
		switch(phaseNow){
			case phase_0_Init:
				return 0;
				break;
			case phase_1_GetObjectsBytesTotal:
				return 0;
				break;
			case phase_2_GetObjectsBytesLoaded:
				return lastBytesLoaded/bytesTotal;
				break;
			case phase_3_WaitAfterEnd:
				return 1;
				break;
			case phase_4_End:
				return 1;
				break;
		}
	}//<<
	
//****************************************************************************
// EVENTS for LoadingsObserver
//****************************************************************************
	public function onMCEnterFrame(Void) : Void {
		switch(phaseNow){
			case phase_0_Init:
				objectsWithNoTotalBytes=loadedObjects.concat();
				phaseNow=phase_1_GetObjectsBytesTotal;
				onEventLoadingsObserverInit();
			break;
			case phase_1_GetObjectsBytesTotal:
				for(var i = 0;i<objectsWithNoTotalBytes.length;i++){
					if(objectsWithNoTotalBytes[i].getBytesTotal()>0){
						objectsWithNoTotalBytes.splice(i, 1);
						i--;
					}
				}
				if(!objectsWithNoTotalBytes.length){
					bytesTotal=0;
					for(var i = 0;i<loadedObjects.length;i++){
						bytesTotal+=loadedObjects[i].getBytesTotal();
					}
					var bytesLoaded = 0;
					for(var i = 0,obj;obj=loadedObjects[i];i++){
						bytesLoaded+=obj.getBytesLoaded();
					}
					lastBytesLoaded=bytesLoaded;
					phaseNow=phase_2_GetObjectsBytesLoaded;
					onEventLoadingsObserverBytesTotalAchieved();
				}
			break;
			case phase_2_GetObjectsBytesLoaded:
				var bytesLoaded = 0;
				for(var i = 0,obj;obj=loadedObjects[i];i++){
					bytesLoaded+=obj.getBytesLoaded();
				}
				if(lastBytesLoaded!=bytesLoaded){
					lastBytesLoaded=bytesLoaded;
					onEventLoadingsObserverProgress();
				}
				if(bytesLoaded>=bytesTotal){
					if(onEventLoadingsObserverTryStart()===false || onEventLoadingsObserverTryStart()===true){
						phaseNow=phase_3_WaitAfterEnd;
					}else{
						phaseNow=phase_4_End;
					}
				}
			break;
			case phase_3_WaitAfterEnd:
				if(onEventLoadingsObserverTryStart()){
					phaseNow=phase_4_End;
				}
			break;
			case phase_4_End:
				delete mcOEF.onEnterFrame;
				onEventLoadingsObserverEnd();
			break;
		}
	}//< E<
	
	public function onEventLoadingsObserverInit(Void) : Void {}//< E>
	public function onEventLoadingsObserverBytesTotalAchieved(Void) : Void {}//< E>	public function onEventLoadingsObserverProgress(Void) : Void {}//< E>	public function onEventLoadingsObserverTryStart(Void) : Boolean { return null; }//< E>	public function onEventLoadingsObserverEnd(Void) : Void {}//<< E>
	
}