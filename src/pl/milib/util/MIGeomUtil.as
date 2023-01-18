/**
 * @author Marek Brun 'minim'
 */
class pl.milib.util.MIGeomUtil {
	
	static public var radian:Number=0.017453;
	static public var PI:Number=Math.PI;
	
	static public function dist(x1:Number, y1:Number, x2:Number, y2:Number):Number {
		var oxp:Number=x2-x1;
		var oyp:Number=y2-y1;
		return Math.sqrt(oxp*oxp+oyp*oyp);
	}//<<
	
	static public function rad(x0:Number, y0:Number, x1:Number, y1:Number):Number {
		return Math.atan2(y1-y0, x1-x0);		
	}//<<
	
}

/*
_global.mt={r:0.017453, PI:Math.PI, ab:{}}

mt.getABbyXYDR=function(x0, y0, dist, rad){
	var ab={x0:x0, y0:y0, dist:dist, rad:rad}
	ab.vx=Math.cos(rad)
	ab.vy=Math.sin(rad)
	ab.x1=x0+ab.vx*ab.dist
	ab.y1=y0+ab.vy*ab.dist
	ab.svx=ab.x1-x0
	ab.svy=ab.y1-y0
	return ab
}//<<

mt.getABbyXYDRBack=function(x1, y1, dist, rad){
	var ab={x1:x1, y1:y1, dist:dist, rad:rad}
	ab.vx=Math.cos(rad)
	ab.vy=Math.sin(rad)
	ab.x0=x1-ab.vx*ab.dist
	ab.y0=y1-ab.vy*ab.dist
	ab.svx=ab.x1-ab.x0
	ab.svy=ab.y1-ab.y0
	return ab
}//<<

mt.setAB_P0=function(ab, rad){
	ab.P0={y:ab.dist*Math.sin(ab.rad-rad),
		   x:ab.dist*Math.cos(ab.rad-rad)}
}//<<

mt.getRD=function(svx,svy){
	return {rad:Math.atan2(svy,svx),
			dist:Math.sqrt(svx*svx+svy*svy)}
}//<<

mt.getRDbyXY=function(x0,y0,x1,y1){
	var svx=x1-x0
	var svy=y1-y0
	return {dist:Math.sqrt(svx*svx+svy*svy),
			rad:Math.atan2(svy,svx)}
}//<<

mt.getVbyRD=function(rd){
	var v={}
	v.vx=Math.cos(rd.rad)
	v.vy=Math.sin(rd.rad)
	v.svx=rd.dist*v.vx
	v.svy=rd.dist*v.vy
	return v
}//<<

mt.setAB=function(ab){
	ab.svx=ab.x1-ab.x0
	ab.svy=ab.y1-ab.y0
	ab.dist=Math.sqrt(ab.svx*ab.svx+ab.svy*ab.svy)
	ab.rad=Math.atan2(ab.svy,ab.svx)
	ab.vx=Math.cos(rad)
	ab.vy=Math.sin(rad)
}//<<
mt.getAB=function(x0,y0,x1,y1,isSinCos){
	var ab={x0:x0, y0:y0, x1:x1, y1:y1}
	ab.svx=x1-x0
	ab.svy=y1-y0
	ab.dist=Math.sqrt(ab.svx*ab.svx+ab.svy*ab.svy)
	ab.rad=Math.atan2(ab.svy,ab.svx)
	if(isSinCos){
		ab.vx=Math.cos(ab.rad)
		ab.vy=Math.sin(ab.rad)
	}
	return ab
}//<<
mt.getRad=function(x0,y0,x1,y1){
	return Math.atan2(y1-y0,x1-x0)
}//<<

mt.dist=function(x1,y1,x2,y2){
	var oxp=x2-x1
	var oyp=y2-y1
	return Math.sqrt(oxp*oxp+oyp*oyp)
}//<<

mt.distR=function(x0,y0,x1,y1,rad){
	var dist=mt.dist(x0,y0,x1,y1)
	var rad2=mt.getRad(x0,y0,x1,y1)
	if(Math.cos(rad-rad2)<0){dist=-dist}
	return dist
}//<<

mt.distLine=function(x0,y0,x1,y1,rad){
	var rd=mt.getRDbyXY(x0,y0,x1,y1)
	return rd.dist*Math.sin(rd.rad-rad)
}//<<

mt.getDistLine=function(x0,y0,x1,y1,rad){
	var rd=mt.getRDbyXY(x0,y0,x1,y1)
	return {y:rd.dist*Math.sin(rd.rad-rad),
			x:rd.dist*Math.cos(rd.rad-rad)}
}//<<
		
mt.isFastBallBam=function(abF, x, y,  width){
	var distL=mt.getDistLine(abF.x0, abF.y0, x, y, abF.rad)
	if(distL.x>0 and distL.x<abF.dist and Math.abs(distL.y)<width){
		return true
	}
	return false
}//<<

mt.isLinesCrossAB=function(ab0, ab1, wnCross){
	return mt.isLinesCross(ab0.x0, ab0.y0, ab0.x1, ab0.y1, ab1.x0, ab1.y0, ab1.x1, ab1.y1, wnCross)
}//<<
mt.linesCrossAB=function(ab0, ab1){
	return mt.linesCross(ab0.x0, ab0.y0, ab0.x1, ab0.y1, ab1.x0, ab1.y0, ab1.x1, ab1.y1)
}//<<
mt.isLinesCross=function(ln11x, ln11y, ln12x,ln12y, ln21x,ln21y, ln22x,ln22y, wnCross){
	if(!wnCross){ var wnCross=mt.linesCross(ln11x, ln11y, ln12x,ln12y, ln21x,ln21y, ln22x,ln22y) }
	wnCross=wnCross.x
	if((wnCross>ln11x and wnCross<ln12x) or (wnCross<ln11x and wnCross>ln12x)){
		if((wnCross>ln21x and wnCross<ln22x) or (wnCross<ln21x and wnCross>ln22x)){
		return true
	}}
	return false
}//<<
mt.linesCross=function(x11, y11, x12, y12, x21, y21, x22, y22) {
	var va0 = x12*y11-x11*y12
	var a1 = (y11-y12)/va0
	var b1 = (x12-x11)/va0
	var va = x22*y21-x21*y22
	var a2 = (y21-y22)/va
	var b2 = (x22-x21)/va
	return {x:(b1-b2)/(a2*b1-a1*b2), y:(a1-a2)/(b2*a1-b1*a2)}
}//<<

mt.zakres=function(n, n0,n1){
	if(n>n1){return n0+(n-n1)%(n1-n0)}
	if(n<n0){return n1-(n0-n)%(n1-n0)}
	return n
}//<<

mt.getBamRD=function(radW, rdFrom){
	var sin=Math.sin(rdFrom.rad-radW)
	if(sin<0){
		radW-=mt.PI
		sin=Math.sin(rdFrom.rad-radW)
	}
	return {rad:radW+mt.PI/2, cos:Math.sin(rdFrom.rad-radW), dist:rdFrom.dist*sin}
}//<<

mt.realBamK=function(k1_x,k1_y,ks_x,ks_y,dist,rad){
	rad+=mt.PI
	var fcos=Math.cos(rad)
	var fsin=Math.sin(rad)
	var wyn=mt.linesCross(k1_x,k1_y,k1_x+fcos,k1_y+fsin,ks_x,ks_y,ks_x+Math.cos(rad+mt.PI/2), ks_y+Math.sin(rad+mt.PI/2))
	var dal=Math.sin(Math.pow(1-mt.dist(wyn.x, wyn.y, ks_x, ks_y)/dist,0.565)*1.57079)*dist
	return {x:wyn.x+fcos*dal, y:wyn.y+fsin*dal}
}//<<

mt.getRealTimeBallsBam=function(ab0, ab1, wid){
	var t01=0, xy0, xy1, x0=ab0.x0, y0=ab0.y0, x1=ab1.x0, y1=ab1.y0, dist, p
	var abF=ab0, abS=ab1
	if(ab1.dist>abF.dist){abF=ab1; abS=ab0}
	var plusDist01=abF.dist/(wid/200)
	var pl={}
	pl.x0=(ab0.dist/plusDist01)*Math.cos(ab0.rad)
	pl.y0=(ab0.dist/plusDist01)*Math.sin(ab0.rad)
	pl.x1=(ab1.dist/plusDist01)*Math.cos(ab1.rad)
	pl.y1=(ab1.dist/plusDist01)*Math.sin(ab1.rad)
	while(true){
		x0+=pl.x0
		y0+=pl.y0
		x1+=pl.x1
		y1+=pl.y1
		dist=mt.dist(x0, y0, x1, y1)
		if(Math.abs(dist-wid)<1){
			return mt.getSroBallsBam(x0, y0, x1, y1, wid)
		}
		p++
		if(p>1000){return false; break;}
	}
}//<<

mt.getSroBallsBam=function(x0, y0, x1, y1, wid){
	var abBam=mt.getAB(x0, y0, x1, y1, true)
	var xSro=(x0+x1)/2
	var ySro=(y0+y1)/2
	wid=wid/2+.5
	x0=xSro-wid*abBam.vx
	y0=ySro-wid*abBam.vy
	x1=xSro+wid*abBam.vx
	y1=ySro+wid*abBam.vy
	return [{x:x0, y:y0}, {x:x1, y:y1}]
}//<<

mt.getAB01xy=function(ab, _01){
	return {x:ab.x0+ab.dist*ab.vx*_01,
			y:ab.y0+ab.dist*ab.vy*_01}
}//<<
*/
