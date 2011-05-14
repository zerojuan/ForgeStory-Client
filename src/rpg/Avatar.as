package rpg
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.resource.ImageResource;
	import com.pblabs.engine.resource.Resource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Avatar extends Sprite{
		
		private var _body:Bitmap;
		private var _head:Bitmap;
		
		public function Avatar(){
			super();
			
			_body = new Bitmap();
			_body.y = 44;
			_head = new Bitmap();
			
			addChild(_body);
			addChild(_head);
		}
		
		public function setBody(url:String):void{
			PBE.resourceManager.load("./items/"+url, ImageResource, onBodyLoaded);
		}
		
		public function setHead(url:String):void{
			PBE.resourceManager.load("./items/"+url, ImageResource, onHeadLoaded);
		}
		
		private function onBodyLoaded(img:ImageResource):void{
			_body.bitmapData = img.bitmapData;
		}
		
		private function onHeadLoaded(img:ImageResource):void{
			_head.bitmapData = img.bitmapData;
		}
	}
}