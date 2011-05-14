package
{
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.screens.BaseScreen;
	import com.pblabs.screens.ScreenManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import paint.AcknowledgementPanel;
	import paint.PaintUI;
	
	import rpg.FacebookShower;
	import rpg.PlayerData;
	
	public class ForgeScreen extends BaseScreen{
		private var mainView:SceneView = new SceneView();
		
		private var hBox:HBox;
		private var vBox:VBox;
		
		private var paintUI:PaintUI;
		private var saveButton:PushButton;
		private var clearButton:PushButton;
		private var backButton:PushButton;
		private var successWindow:Window;
		
		private var ackPanel:AcknowledgementPanel;
		
		private var typeCombobox:ComboBox;
		private var priceSlider:HUISlider;
		
		private var nameInput:InputText;
		private var descriptionInput:TextArea;
		
		private var instanceId:String;
		
		public function ForgeScreen(){
			//Style.setStyle(Style.DARK);
			
			mainView.name = "MainView";
			mainView.width = 720;
			mainView.height = 480;
			addChild(mainView);
		
			paintUI = new PaintUI();
			
			paintUI.x = 50;
			paintUI.y = 50;
			addChild(paintUI);
			
			
			hBox = new HBox(this, 400, 360);
			hBox.spacing = 5
			
			saveButton = new PushButton(hBox, 0, 0, "Save", onSaveButton);
			clearButton = new PushButton(hBox, 0, 0, "Clear", onClearButton);
			backButton = new PushButton(hBox, 0, 0, "Home", onBackButton);
			
			vBox = new VBox(this, 400, 60);
			
			nameInput = new InputText(vBox, 0, 0, "Unnamed Item");
			nameInput.width = 200;
			
			descriptionInput = new TextArea(vBox, 0, 0, "<Enter Your Description Here>");
			descriptionInput.width= 250;
			
			typeCombobox = new ComboBox(vBox, 0, 0, "Item Type", ["Head", "Body", "Monster", "Weapon", "Armor"]);
			
			priceSlider = new HUISlider(vBox, 0, 0, "Price");
			priceSlider.minimum = 0;
			priceSlider.maximum = PlayerData.instance.coins;
			priceSlider.tick = 1;
			priceSlider.labelPrecision = 0;
			
			ackPanel = new AcknowledgementPanel();
			ackPanel.cancelCallback = onShareCancelled;
			ackPanel.shareCallback = onSharePressed;
			
			successWindow = new Window(this, 320, 100, "Forging was successful!");
			successWindow.width = 250;
			successWindow.height = 120;
			successWindow.hasCloseButton = true;
			successWindow.visible = false;
			successWindow.addEventListener(Event.CLOSE, onWindowClosed);
			successWindow.content.addChild(ackPanel);
			
		}
		
		override public function onShow():void{
			Logger.print(this, "Loaded ForgeScreen");
			typeCombobox.selectedIndex = 0;
		}
		
		override public function onHide():void{
			Logger.print(this, "Hiding ForgeScreen");
		}
		
		private function onClearButton(evt:Event):void{
			reset();
		}
		
		private function onBackButton(evt:Event):void{
			ScreenManager.instance.goto(DangerItems.WELCOME);
		}
		
		private function onWindowClosed(evt:Event):void{
			updatePlayerData();
		}
		
		private function onSharePressed(evt:Event):void{
			FacebookShower.instance.showUISimple(instanceId, descriptionInput.text, nameInput.text);
			updatePlayerData();
		}
		
		private function onShareCancelled(evt:Event):void{
			updatePlayerData();
		}
		
		private function updatePlayerData():void{
			successWindow.visible = false;
			enable(true);
			PlayerData.instance.coins -= priceSlider.value;
			priceSlider.maximum = PlayerData.instance.coins;
			if(PlayerData.instance.coins <= 0){
				priceSlider.value = 0;
				priceSlider.enabled = false;
			}
		}
		
		private function enable(val:Boolean):void{
			paintUI.enable(val);
			backButton.enabled = val;
			saveButton.enabled = val;
			clearButton.enabled = val;
			typeCombobox.enabled = val;
			priceSlider.enabled = val;
			nameInput.enabled = val;
			descriptionInput.enabled = val;
		}
		
		private function reset():void{
			nameInput.text = "Unnamed Item";
			descriptionInput.text = "<Write awesome description of your item here>";
			paintUI.reset();
		}
		
		private function onSaveButton(evt:Event):void{
			enable(false);
			saveToDatabase();
		}
		
		private function saveToDatabase():void{
			var urlVariables:URLVariables = new URLVariables();
			
			Logger.print(this, "Selected index: " + typeCombobox.selectedIndex);
			
			urlVariables.itemName = nameInput.text;
			urlVariables.itemDesc = descriptionInput.text;
			urlVariables.itemType = typeCombobox.selectedIndex;
			urlVariables.itemPrice = priceSlider.value;
			urlVariables.forgerId = PlayerData.instance.session.uid;
			
			var urlRequest:URLRequest = new URLRequest("saveItem.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onItemSaved);
			urlLoader.load(urlRequest);
		}
		
		private function onItemSaved(evt:Event):void{
			instanceId = evt.target.data;
			saveImage(instanceId);
		}
		
		private function saveImage(imageName:String):void{
			var source:BitmapData = new BitmapData(64,64);
			source.draw(paintUI.image);
			
			var blackAlphaColor:uint = 0xFFFFFFFF;
			var transparentColor:uint = 0x00000000;
			source.threshold( source, source.rect, source.rect.topLeft, "==", blackAlphaColor, transparentColor );
			
			ackPanel.itemImage.bitmapData = source;
			
			var jpgStream:ByteArray= PNGEncoder.encode(source);
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var jpgURLRequest:URLRequest = new URLRequest("itemcreation.php?name="+imageName+".png");
			jpgURLRequest.requestHeaders.push(header);
			jpgURLRequest.method = URLRequestMethod.POST;
			jpgURLRequest.data = jpgStream;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onPictureSaved);
			urlLoader.load(jpgURLRequest);
		}
		
		private function onPictureSaved(evt:Event):void{
			successWindow.visible = true;
			successWindow.move(320, 100);
			ackPanel.itemName = nameInput.text;
		}
	}
}