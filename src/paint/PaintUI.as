package paint
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.InputText;
	import com.bit101.components.Panel;
	import com.pblabs.engine.debug.Logger;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PaintUI extends Panel{
		private var colorPicker:ColorChooser;
		private var showGridCheck:CheckBox;
		
		private var paletteColor:uint = 0x000000;
		
		private var paintSprite:Sprite;
		private var gridSprite:Sprite;
		private var imageSprite:Sprite;
		
		private var pixelSize:int = 20;
		private var imageSize:int = 16;
		
		private var isMouseDown:Boolean = false;
		
		public function PaintUI(){
			width = 320;
			height = 400;
			
			imageSprite = new Sprite();
			imageSprite.x = 240;
			imageSprite.y = 330;
			imageSprite.graphics.beginFill(0xffffff);
			imageSprite.graphics.drawRect(0,0,64, 64);
			imageSprite.graphics.endFill();
			addChild(imageSprite);
			
			paintSprite = new Sprite();
			paintSprite.graphics.beginFill(0xffffff);
			paintSprite.graphics.drawRect(0,0,320, 320);
			paintSprite.graphics.endFill();
			addChild(paintSprite);
			
			gridSprite = new Sprite();
			
			for(var x1:int = 0; x1 < imageSize; x1++){
				for(var y1:int = 0; y1 < imageSize; y1++){
					with(gridSprite.graphics){
						lineStyle(1, 0x000000, .25);
						drawRect(x1 * pixelSize, y1 * pixelSize, pixelSize, pixelSize);
					}
				}
			}
			
			addChild(gridSprite);
			
			colorPicker = new ColorChooser(this, 20, 350, paletteColor, onColorPicked);
			colorPicker.usePopup = true;
			
			showGridCheck = new CheckBox(this, 100, 350, "Show Grid", onGridClicked);
			showGridCheck.selected = true;
			
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function get image():Sprite{
			return imageSprite;
		}
		
		public function enable(val:Boolean):void{
			if(val){
				colorPicker.enabled = true;
				showGridCheck.enabled = true;
			}else{
				colorPicker.enabled = false;
				showGridCheck.enabled = false;
			}
		}
		
		public function reset():void{
			paintSprite.graphics.beginFill(0xffffff);
			paintSprite.graphics.drawRect(0,0,320, 320);
			paintSprite.graphics.endFill();
			
			imageSprite.graphics.beginFill(0xffffff);
			imageSprite.graphics.drawRect(0,0,64, 64);
			imageSprite.graphics.endFill();
		}
		
		private function onColorPicked(evt:Event):void{
			Logger.print(this, "Color Picked");
			paletteColor = colorPicker.value;
		}
		
		private function onGridClicked(evt:Event):void{
			if(showGridCheck.selected){
				gridSprite.alpha = 1;
			}else{
				gridSprite.alpha = 0;
			}
		}
		
		private function onMouseMove(evt:MouseEvent):void{
			if(isMouseDown && colorPicker.enabled){
				paintOnCanvas();
			}
		}
		
		private function onMouseClick(evt:MouseEvent):void{
			if(colorPicker.enabled)
				paintOnCanvas();
		}
		
		private function onMouseDown(evt:MouseEvent):void{
			isMouseDown = true;
		}
		
		private function onMouseUp(evt:MouseEvent):void{
			isMouseDown = false;
		}
		
		private function paintOnCanvas():void{
			var x:int = mouseX / pixelSize;
			var y:int = mouseY / pixelSize;
			
			if(y > imageSize - 1){
				return;
			}
			
			with(paintSprite.graphics){
				beginFill(paletteColor, 1);
				drawRect(x * pixelSize, y * pixelSize, pixelSize, pixelSize);
				endFill();
			}
			
			with(imageSprite.graphics){
				beginFill(paletteColor, 1);
				drawRect(x * (pixelSize/5), y * (pixelSize/5), (pixelSize/5), (pixelSize/5));
				endFill();
			}
		}
	}
}