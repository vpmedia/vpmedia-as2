// EXTENDED RECT FOR THE SHADOW
import com.pixelficker.drawing.RoundRect;
class com.pixelficker.drawing.BlurredRect extends RoundRect {
	function BlurredRect() {};
	//
	function drawBlurredRect (clip:MovieClip, x:Number, y:Number, width:Number, height:Number, blur:Number, bgColor:Number, alpha:Number, r:Number) {
		var f = [];
		var sum = 0;
		for (var i = 1; i<blur+1; i++) {
			f[i-1] = i*i;
			sum += f[i-1];
		}
		var newfactor= 2;
		var counter = 40;
		var factor;
		do {
			factor=newfactor
			var b = 0;
			for (var i = 0; i<=blur; i++) {
				var ftemp = (f[i]*(factor*alpha)/sum)/100;
				b = b*(1-ftemp)+ftemp;
			}
			counter--;
			newfactor *= alpha/(100*b);
		} while ((counter>0) && (Math.abs(100*b-alpha)>.5));
		for (var i = 0; i<=blur; i++) {
			f[i] *= (factor*alpha)/sum;
		}
		for (var i = 0; i<=blur; i++) {
			clip.beginFill(bgColor, f[i]);
			drawRoundRect(clip, 1+(x+i)-blur/2, 1+(y+i)-blur/2, x+width-i+blur/2-1, y+height-i+blur/2-1, r != undefined ? r : blur-(i*2/3));
			clip.endFill();
		}
	}
}