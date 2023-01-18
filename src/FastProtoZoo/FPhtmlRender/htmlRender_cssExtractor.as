//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
class FastProtoZoo.FPhtmlRender.htmlRender_cssExtractor {
	//
	private var motherCss:Object;
	//
	public function htmlRender_cssExtractor(motherCss:Object) {
		this.motherCss=motherCss;
	}
	//get precise class
	public function getCSSItem(currentclass:String, reference:Object):Object{
		//
		if (!reference){
			var reference=new Object();
		}
		var extracted=new Object();
		//extract border attributes
		var border=new Object();
		border=this.extractBorder(this.motherCss._css[currentclass].border);
		//
		extracted.style=border.style;
		if (extracted.style!=undefined){
			reference.attributes.style=extracted.style;
		}
		//
		extracted.border=Number(border.px);
		if (extracted.border>0){
			reference.attributes.border=extracted.border;
		}
		//
		extracted.bordercolor=border.color;
		if (extracted.bordercolor!=undefined){
			reference.attributes.bordercolor=extracted.bordercolor;
		}
		//
		extracted.bgcolor=this.motherCss._css[currentclass].backgroundColor;
		if (extracted.bgcolor!=undefined){
			reference.attributes.bgcolor=extracted.bgcolor;
		}
		//split where px is found
		var temp=(this.motherCss._css[currentclass].margin).split("p");
		extracted.margin=Number(temp[0]);
		if (extracted.margin>0){
			reference.attributes.margin=extracted.margin;
		}
		//
		var temp=(this.motherCss._css[currentclass].padding).split("p");
		extracted.padding=Number(temp[0]);
		if (extracted.padding>0){
			reference.attributes.padding=extracted.padding;
		}
		//
		var temp=(this.motherCss._css[currentclass].width).split("p");
		extracted.width=Number(temp[0]);
		if (extracted.width>0){
			reference.attributes.width=extracted.width;
		}
		//
		var temp=(this.motherCss._css[currentclass].height).split("p");
		extracted.height=Number(temp[0]);
		if (extracted.height>0){
			reference.attributes.height=extracted.height;
		}
		//assign
		/*for (var i in extracted){
			trace (">>>"+i+"____"+extracted[i]);
		}*/
		//return
		return(extracted);
	}
	//border attributes extractor
	private function extractBorder(attribute:String):Object{
		var temp=attribute.split(" ");
		var border=new Object();
		//
		var tempborder=temp[0].split("p");
		border.px=Number(tempborder[0]);
		border.color=temp[2];
		border.style=temp[1];
		return(border);
	}

}
