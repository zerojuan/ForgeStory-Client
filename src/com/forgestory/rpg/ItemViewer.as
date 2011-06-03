package com.forgestory.rpg
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.resource.ImageResource;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class ItemViewer extends Sprite
	{
		private var _image:Bitmap;
		
		public function ItemViewer(){
			super();
			
			_image = new Bitmap();
			
			addChild(_image);
		}
		
		public function setURL(url:String):void{
			PBE.resourceManager.load("./items/"+url, ImageResource, onImageLoaded);
		}
		
		private function onImageLoaded(img:ImageResource):void{
			_image.bitmapData = img.bitmapData;
		}
	}
}