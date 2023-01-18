//import janumedia.components.*
import janumedia.application;
//import UI.general.InfoBox;
class janumedia.layout extends MovieClip {
	var curOpenedPods:Array;
	var curTemplate:Array;
	var space:Number = 5;
	var panelmc, tempateCtrl, bwMonitor:MovieClip;
	var defaultWStage:Number = 760;
	//Stage.width;
	var defaultHStage:Number = 600;
	//Stage.height;
	var updateW:Number;
	var updateH:Number;
	var intervalID:Number;
	var im:MovieClip;
	var path:MovieClip;
	function init(t) {
		_global.tt("[Layout] init");
		path = t;
		curOpenedPods = new Array();
		tempateCtrl = path.attachMovie("templateCtrl", "tempateCtrl", 1000);
		//panelmc = path.attachMovie("panel","panelmc",2000);
		_global.stageCover = path.attachMovie("stage_cover", "stage_cover", 3000);
		_global.contentBrowser = path.attachMovie("contentBrowser", "contentBrowser", 3001);
		_global.bwMonitor = path.attachMovie("bandwithMonitor", "bwMonitor", 3002);
		_global.presentationBrowser = path.attachMovie("presentationBrowser", "presentationBrowser", 3003);
		_global.screenSharingWizard = path.attachMovie("screen_sharing_wizard", "screenSharingWizard", 3004);
		_global.screenSharingWizard._visible = false;
		updateW = 1;
		updateH = 1;
		Stage.addListener(this);
		onResize();
	}
	function onResize() {
		_global.tt("[Layout] onResize");
		updateW = Stage.width/defaultWStage;
		updateH = Stage.height/defaultHStage;
	}
	function applyTemplate(tmpt:Array) {
		_global.tt("[Layout] applyTemplate");
		// clear current pods
		removeAllPods();
		/*if (curOpenedPods.length>0) {
		for (var i = 0; i<curOpenedPods.length; i++) {
		curOpenedPods[i].swapDepths(123);
		curOpenedPods[i].removeMovieClip();
		}
		curOpenedPods = new Array();
		}*/
		// generate new pods		                     
		curTemplate = tmpt;
		createPod(1, 0, 0);
	}
	function openPod(o:Object) {
		_global.tt("[Layout] openPod");
		_global.currentTopPod.swapDepths(_global.currentTopPod.getDepth()-100);
		var mc = path.attachMovie(o.podname, "pod_"+o.id, 10+o.id+100);
		mc.bg.setTitle(o.title);
		mc.bg.setSize(300, 300, true);
		mc.setPos((Stage.width-mc.bg.width)/2, (Stage.height-mc.bg.height)/2);
		_global.currentTopPod = mc;
		curOpenedPods.push(mc);
	}
	function createPod(d:Number, n:Number, i:Number) {
		_global.tt("[Layout] createPod", "d: "+d+" ,i: "+i+" ,n: "+n);
		clearInterval(intervalID);
		var depth = d;
		var tmpt = curTemplate;
		var podID = _global.podList[tmpt[n][i].type].id;
		var pastPodID = _global.podList[tmpt[n][i-1].type].id;
		var lastPodID = _global.podList[tmpt[n-1][0].type].id;
		var curMC = path.attachMovie(tmpt[n][i].type, "pod_"+podID, 10+podID);
		var pastMC = path["pod_"+pastPodID];
		var leftMC = path["pod_"+lastPodID];
		//var curMC 	= path.attachMovie(tmpt[n][i].type,"mc"+n+"_"+i,10+depth);
		//var pastMC	= path["mc"+n+"_"+(i-1)];
		//var leftMC	= path["mc"+(n-1)+"_"+0];
		var x = n>0 ? leftMC._x+leftMC.bg._width+space : space;
		var y = n>0 ? pastMC._y+pastMC.bg._height+space : pastMC._y+pastMC.bg._height+space;
		var w = tmpt[n][i].w*updateW;
		var h = tmpt[n][i].h*updateH;
		var isChild = tmpt[n][i].child ? true : false;
		curMC.id = podID;
		curMC.bg.percentage(i>0 ? false : true, n>0 ? false : true, n<tmpt.length-1 ? false : true, pastMC, leftMC, isChild);
		curMC.bg.setTitle(tmpt[n][i].title);
		curMC.bg.setSize(w, h, true);
		//curMC.setPos(isChild ? pastMC._x + pastMC.bg._width + space : x, i > 0 ? isChild ? pastMC._y : y : panelmc._y + panelmc.height + space);
		curMC.setPos(isChild ? pastMC._x+pastMC.bg._width+space : x, i>0 ? isChild ? pastMC._y : y : tempateCtrl._y+space);
		//curMC.swapDepths(10+podID);
		//curMC.swapDepths(10+depth);
		curOpenedPods.push(curMC);
		for (var k in tmpt) {
			for (var j in tmpt[k]) {
				//_global.tt(j+":"+k+":"+tmpt[k][j]);
			}
		}
		//_global.tt(tmpt);
		if (n<=tmpt.length && tmpt[n].length>0) {
			var t = i<=tmpt[n].length ? n : n+1;
			var k = i<=tmpt[n].length ? i+1 : 0;
			//_global.tt("n: "+n+", t: "+t+", k: "+k+", tmpt.length: "+tmpt.length+", tmpt[n].length: "+tmpt[n].length);
			intervalID = setInterval(this, "createPod", 100, d+1, t, k);
		} else {
			clearInterval(intervalID);
		}
	}
	function removeAllPods():Void {
		_global.tt("[Layout] removeAllPods");
		if (curOpenedPods.length>0) {
			for (var i = 0; i<curOpenedPods.length; i++) {
				curOpenedPods[i].swapDepths(123);
				curOpenedPods[i].removeMovieClip();
			}
			curOpenedPods = new Array();
		}
	}
}
