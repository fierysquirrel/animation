package fs.animation;

import aze.display.TileLayer;
import aze.display.TileSprite;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.Lib;
import aze.display.SparrowTilesheet;
import flash.display.BitmapData;
import openfl.Assets;

/**
 * ...
 * @author Henry Fernández
 */

class Main extends Sprite 
{
	var inited:Bool;

	var tilesheet : SparrowTilesheet;
	
	var lastTime : Float;
	
	var a : Animation;
	
		var t : TileLayer;
		
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		
		
		
	
		
		var platformsTilesheet : SparrowTilesheet;
		var xml : String;
		var spritesheet : BitmapData;
		var frames : Array<TileSprite>;
		var ani : TileSprite;
		
		ani = new TileSprite(t, "player-drag-2");
		//ani.x = 50;
		frames = [new TileSprite(t, "player-drag-1"), new TileSprite(t, "player-drag-2"), new TileSprite(t, "player-drag-3"), ani];
		spritesheet = Assets.getBitmapData("assets/level-objects.png");
		xml = Assets.getText("assets/level-objects.xml");
		
		tilesheet = new SparrowTilesheet(spritesheet, xml);
		
		t = new TileLayer(tilesheet);
		a = new Animation(t, frames,4);
		
		a.SetPosition(200, 200);
		a.Play();
		a.On();
		//a.
		addChild(t.view);
		
		
		
		//Main loop
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, MainLoop);
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	function MainLoop(event : Event)
	{
		var time : Float = Lib.getTimer();
		var deltaTime : Float = time - lastTime;
		lastTime = time;
		
		a.Update(deltaTime);
		t.render();
	}
	
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
