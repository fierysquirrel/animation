package;

import openfl.display.Tile;
import openfl.display.Tilemap;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.text.TextField;

/**
 * Represents an animation in 2 dimensions. 
 * Made from a Sprite Sheet.
 * 
 * @author Fiery Squirrel
 * @link http://www.fierysquirrel.com
 * @version 1.0
 */

 //TODO: Review Flip
/*
 * Flip: Horizontal, Vertical, None.
 * */
/*enum FlipState
{
	Horizontal;
	Vertical;
	None;
}*/

 /*
  * Animation State: Play, Pause, Stop.
  * */
enum AnimationState
{
	Play;
	Pause;
	Stop;
}

/*
  * Animation Direction: It plays forward or backward.
  * Depends on the initial configuration.
  * */
enum AnimationDirection
{
	Forward;
	Backward;
}

/*
  * Animation Direction: It plays forward or backward.
  * Depends on the initial configuration.
  * */
enum AnimationType
{
	Loop;
	OneWay;
	GoReturn;
}

class Animation implements IAnimation
{
	/*
	 * 
	 * */
	static public var MILLISECONDS : Int = 1000;
	
	/*
	 * Animation ended event.
	 * */
	static public var EVENT_ANIMATION_ENDED : String = "ANIMATION_ENDED";
	
	static public var NAME : String = "ANIMATION_2D";
	
	/*
	 * Constant to represent the initial time.
	 * */
	static private var INIT_TIME : Int = 0;
	
	/*
	 * Center circle color.
	 * */
	static private var CENTER_COLOR :Int = 0xFF0000;
	
	/*
	 * Center circle size.
	 * */
	static private var CENTER_SIZE : Int = 5;
	
	/*
	 * Frame color.
	 * */
	static private var FRAME_COLOR : Int = 0xFF0000;
	
	/*
	 * Debugging information.
	 */
	private var debuggingText : TextField;
	
	/*
	 * Is debugging?.
	 */
	private var isDebugging : Bool;
	
	/*
	 * Occurs when the animation ends.
	 * */
	private var endedEvent : EventDispatcher;
        
	/*
	 * Animation id used to identify the animation among others.
	 */
	private var id : String;
	
	private var x : Float;
	
	private var y : Float;
	
	/*
	 * Has the animation ended?.
	 */
	private var hasEnded : Bool;
	
	/*
	 * Direction: forward, backward.
	 */
	private var direction : AnimationDirection;

	/*
	 * Current state: Playing, Paused, Stopped.
	 */
	private var state : AnimationState;
	
	/*
	 * Is the animation a loop or it could be played only once.
	 */
	private var type : AnimationType;
	
	/*
	 * Animation pivot. Used to scale, rotate and translate.
	 */
	private var pivot : Point;
	
	/*
	 * Duration of the animation
	 */
	private var duration : Float;
	
	/*
	 * Frames Per Second.
	 * */
	private var fps : Int;
	
	/*
	 * Set of frames that represent the animation.
	 * */
	private var frames : Array<Tile>;
	
	/*
	 * Current frame index.
	 * */
	private var currentFrame : Int;
	
	/*
	 * Number of the first frame, counting all frames.
	 * It's used to play only a segment of the animation.
	 * */
	private var initialFrame : Int;
	
	/*
	 * Number of the last frame, counting all frames.
	 * It's used to play only a segment of the animation.
	 * */
	private var finalFrame : Int;
	
	/*
	 * Elapsed time.
	 * */
	private var elapsedTime : Float;
	
	
	private var layer : Tilemap;
	
	//TODO: replace this (for debugging)
	/*
	 * Sprite circle to draw the center of the frame.
	 * */
	//private var center : Sprite;
	
	/*
	 * A rectangle to draw the animation frame.
	 * */
	//private var frame : Sprite;
	
	/*
	 * Red color.
	 * */
	private var colorR : Float;
	
	/*
	 * Green color.
	 * */
	private var colorG : Float;
	
	/*
	 * Blue color.
	 * */
	private var colorB : Float;
	
	/*
	 * Alpha.
	 * */
	private var colorA : Float;
	
	/*
	 * Current flip.
	 * */
	//private var flip : FlipState;
	
	
	private var visible : Bool;
	
	private var name : String;
	
	/*
	 * Global scale
	 * */
	private var scale : Float;
	

	
	/*
	 * Initializes a 2D sprite animation.
	 * 
	 * @param id An identifier to distinguish the animation in a collection.
	 * @param spriteSheet a bitmap loaded spritesheet.
	 * @param frames an array of TileSprite that represent each frame of the animation.
	 * @param direction should the animation run Forward or Backward?.
	 * @param isLoop is it a loop animation?.
	 * @param fps frames per second, determine the speed of the animation.
	 * */
	public function new(layer : Tilemap,frames : Array<Tile>,fps : Int,scale : Float = 1, rotation : Float = 0,type : AnimationType = null, direction : AnimationDirection = null) 
	{
		if (fps <= 0)
			throw "Error: fps should be a possitive value";
			
		if (frames.length <= 0)
			throw "Error: frames cannot be empty";
		
		
		this.layer = layer;
		this.direction = direction == null ? AnimationDirection.Forward : direction;
		this.type = type == null ? AnimationType.Loop : type;
		this.duration = MILLISECONDS / fps;
		this.state = AnimationState.Stop;
		this.hasEnded = false;
		this.initialFrame = 0;
		this.finalFrame = frames.length - 1;
		this.fps = fps;
		this.state = AnimationState.Play;
		this.frames = frames;
		this.scale = scale;
		
		//container = new TileGroup(layer);
		currentFrame = initialFrame;
		elapsedTime = INIT_TIME;
		endedEvent = new EventDispatcher();
		
		//Frames
		for (f in frames)
		{
			f.scaleX = scale;
			f.scaleY = scale;
			f.rotation = rotation;
			f.visible = false;
			//f.r = 1;
			//f.g = 1;
			//f.b = 1;
			
			//TODO: Check this structure, think about making it better
			//Adding frames to container
			layer.addTile(f);
			
			//container.addChild(f);
		}
		
		colorR = 1;
		colorG = 1;
		colorB = 1;
		colorA = 1;
		//flip = FlipState.None;
		
		visible = false;
		
		//TODO: Check this structure, think about making it better
		//Adding container to the layer
		//layer.addChild(container);
	}
	
	/*public function GetContainer() : TileGroup
	{
		return container;
	}*/
	
	public function SetPosition(x : Float, y : Float) : Void
	{
		//container.x = x;
		//container.y = y;
		this.x = x;
		this.y = y;
	}
	
	public function SetName(name : String) : Void
	{
		this.name = name;
	}
	
	public function GetName() : String
	{
		return name;
	}
	
	public function GetFrames() : Array<Tile>
	{
		return frames;
	}
	
	/*
	 * Is the animation a loop or it could be played only once.
	 */
	public function GetAnimationType() : AnimationType
	{
		return type;
	}
	
	/*
	 * Has the animation ended?.
	 */
	public function HasEnded() : Bool
	{
		return this.hasEnded;
	}
	
	/*
	 * Duration of the animation.
	 */
	public function GetDuration() : Float
	{
		return this.duration;
	}

	/*
	 * Gets the animation direction: Forward, Backward
	 * */
	public function GetCurrentFrame() : Tile
	{
		return frames[currentFrame];
	}
	
	/*
	 * Gets the animation direction: Forward, Backward
	 * */
	public function GetDirection() : AnimationDirection 
	{
		return this.direction;
	}

	//TODO: This has to be fixed. This is not an event, this is an EventDispatcher, not the same.
	/*
	 * Event fired when the animation ends.
	 * */
	public function GetEndedEvent() : EventDispatcher
	{
		return endedEvent;
	}
	
	/*
	 * Event fired when the animation ends.
	 * */
	public function GetCurrentFrameNumber() : Int
	{
		return currentFrame;
	}

	/*
	 * Gets the current state: Play, Pause, Stop and Resume.
	 * */
	public function GetState() : AnimationState
	{
		return this.state;
	}
	
	/*
	 * Get the pivot.
	 */
	public function GetPivot() : Point
	{
		return this.pivot;
	}
	
	public function IsVisible() : Bool
	{
		return visible;
	}
	
	/*
	 * Set the pivot.
	 */
	public function SetPivot(pivot : Point)
	{
		this.pivot = pivot;
	}
	
	/*
	 * Play the animation if it's stopped.
	 * */
	public function Play()
	{
		state = AnimationState.Play;
	}

	/*
	 * Pauses the animation if it's playing.
	 * */
	public function Pause()
	{
		if(state == AnimationState.Play)
			state = AnimationState.Pause;
	}

	/*
	 * Resumes the animation if it's paused.
	 * */
	public function Resume()
	{
		if(state == AnimationState.Pause)
			state = AnimationState.Play;
	}

	/*
	 * Stops the animation if it's playing.
	 * */
	public function Stop()
	{
		state = AnimationState.Stop;
		Restart();
	}
	
	public function Off() : Void
	{
		frames[currentFrame].visible = false;	
		visible = false;
	}
	
	public function On() : Void
	{
		frames[currentFrame].visible = true;
		visible = true;
	}
	
	/*
	 * Updates the logic to reproduce the animation.
	 *
	 * @param gameTime Current game time.
	 * */
	public function Update(gameTime:Float)
	{
		if (state == AnimationState.Play)
		{
			//This is here in case the fps change at runtime
			duration = MILLISECONDS / fps;

			elapsedTime += gameTime;
			
			//Check for animation ending
			switch (direction)
			{
				case AnimationDirection.Forward:
					hasEnded = currentFrame >= frames.length - 1;
				case AnimationDirection.Backward:
					hasEnded = currentFrame == initialFrame;
			}
			
			//transform.update();

			frames[currentFrame].visible = false;
			if (elapsedTime > duration)
			{
				//Reset animation
				if (hasEnded)
				{
					endedEvent.dispatchEvent(new Event(EVENT_ANIMATION_ENDED));
					if(type == AnimationType.Loop || type == AnimationType.GoReturn)
						Restart();
				}
				else
				{
					
					//Update frames
					switch (direction)
					{
						case AnimationDirection.Forward:
												
							//Update horizontal frame
							currentFrame++;

							if (currentFrame > finalFrame)
								Restart();
							
						case AnimationDirection.Backward:
							//Update horizontal frame
							currentFrame--;

							if (currentFrame < initialFrame)
								Restart();
					}
				}

				elapsedTime = INIT_TIME;
			}
			frames[currentFrame].x = x;
			frames[currentFrame].y = y;
			frames[currentFrame].visible = true && visible;	
		}
	}

	/*
	 * Restart the animation.
	 * */
	public function Restart()
	{
		switch(type)
		{
			case AnimationType.Loop:
				switch (direction)
				{
					case AnimationDirection.Forward:
						currentFrame = initialFrame;
					case AnimationDirection.Backward:
						currentFrame = finalFrame;
				}
				hasEnded = false;
			case AnimationType.OneWay:
				switch (direction)
				{
					case AnimationDirection.Forward:
						currentFrame = initialFrame;
					case AnimationDirection.Backward:
						currentFrame = finalFrame;
				}
				hasEnded = false;
			case AnimationType.GoReturn:
				Revert();
		}
		
		hasEnded = false;
	}

	/// <summary>
	/// Revert the animation.
	/// </summary>
	public function Revert()
	{
		switch (direction)
		{
			case AnimationDirection.Forward:
				direction = AnimationDirection.Backward;
				currentFrame = frames.length -1;
			case AnimationDirection.Backward:
				direction = AnimationDirection.Forward;
				currentFrame = initialFrame;
		}
	}
	
	/*
	 * Shows / hides debuggin info depending on if it's debugging or not.
	 * 
	 * @param value true to turn on debugging, false to turn it off.
	 * */
	public function SetDebugging(value : Bool)
	{
		/*if (isDebugging)
		{
			if (!value)
			{
				removeChild(frame);
				removeChild(center);
			}
		}
		else
		{
			if (value)
			{
				addChild(frame);
				addChild(center);
			}
		}
		
		isDebugging = value;*/
	}
	
	/*
	 * Rotates the animation sprite.
	 * 
	 * @param rotation value to rotate the sprite in degrees.
	 * */
	public function Rotate(rotation : Float)
	{
		frames[currentFrame].rotation = rotation;
	}
	
	/*
	 * Flips the animation: Horizontal,Vertical,None.
	 * 
	 * */
	/*public function Flip(flip : FlipState)
	{
		this.flip = flip;
	}*/
	
	/*
	 * Scales the animation sprite horizontally and vertically.
	 * 
	 * @param x value X in percentage 0, 0.5, 1... to scale horizontally.
	 * @param y value Y in percentage 0, 0.5, 1... to scale vertically.
	 * */
	public function Scale(scale : Float)
	{
		frames[currentFrame].scaleX = scale * this.scale;
		frames[currentFrame].scaleY = scale * this.scale;
	}
	
	public function ScaleX(scale : Float)
	{
		frames[currentFrame].scaleX = scale * this.scale;
	}
	
	public function ScaleY(scale : Float)
	{
		frames[currentFrame].scaleY = scale * this.scale;
	}
	
	/*
	 * Changes the animation color.
	 * 
	 * @param r quantity of red color 0..1.
	 * @param g quantity of green color 0..1.
	 * @param b quantity of blue color 0..1.
	 * @param a quantity of alpha 0..1.
	 * */
	public function ChangeColor(r : Float,g : Float, b: Float)
	{
		if (r < 0 || r > 1 || g < 0 || g > 1 || b < 0 || b > 1)
			throw "Error: values must be between 0..1";
			
		colorR = r;
		colorG = g;
		colorB = b;
		
		/*frames[currentFrame].r = r;
		frames[currentFrame].g = g;
		frames[currentFrame].b = b;*/
	}
	
	/*
	 * Changes the animation color.
	 * 
	 * @param r quantity of red color 0..1.
	 * @param g quantity of green color 0..1.
	 * @param b quantity of blue color 0..1.
	 * @param a quantity of alpha 0..1.
	 * */
	public function ChangeAlpha(alpha : Float)
	{	
		frames[currentFrame].alpha = alpha;
	}
	
	/*
	 * Set the animation to reproduce a slice of it.
	 * 
	 * @param initialFrame first frame of the slice.
	 * @param finalFrame last frame of the slice.
	 * */
	public function Slice(initialFrame : Int,finalFrame : Int)
	{
		if (initialFrame < 0 || initialFrame >= frames.length || finalFrame < 0 || finalFrame >= frames.length)
			throw "Error: out of bound exception";
			
		if (initialFrame > finalFrame)
			throw "Error: initialFrame < finalFrame";
			
		this.initialFrame = initialFrame;
		this.finalFrame = finalFrame;
		
		Restart();
	}
}