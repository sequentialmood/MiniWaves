package {
	import flash.display.Sprite;
	import flash.events.SampleDataEvent;
	import com.bit101.components.Panel;
	import com.bit101.components.VSlider;
	import com.bit101.components.PushButton;
	import com.bit101.components.Label;
	import flash.media.Sound;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * @author PROG
	 */
	[SWF(backgroundColor='#000000', frameRate='80')]
	public class Main extends Sprite {
		private var _sineBtn:PushButton;
		private var _squareBtn:PushButton;
		private var _sawtoothBtn:PushButton;
		private var _triangleBtn:PushButton;
		private var _PlayBtn:PushButton;	
		private var _VibratoSlider:VSlider;
		private var _ToneSlider:VSlider;
		private var _DelaySlider:VSlider;
		private var _ReleaseSlider:VSlider;
		private var _arpSlider:VSlider;
		private var _panel:Panel;
		private var _position:int = 0;
		private var _n:Number = 0;
		private var _timer:Timer;
		private var _amp:Number = 0.5;
		private var _y:Number;
		private var _waveFormType:int = 0;
		
		private var _phase:Number;
		private var _freq:Number;
		private var _t:Number;
		private var _sample:Number;
		
		private var _baseArpegiatorTune:Number;
		private var _arpegiatorCount:Number = 0.0;
		
		private var _display:Boolean = true;
		private var _play:Boolean = true;
		
		private var _sound:Sound;
		
		public function  Main()
		{
			initView();

			reset();
		
			
			_y = stage.stageHeight/2.0;
			

			
		}
		
		private function reset():void
		{
			_sound = new Sound();
			_sound.addEventListener("sampleData",sineWavGenerator);
			_sound.play();
			
			_timer = new Timer(300);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function del():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
			_timer = null;
			//_sound.stop();
			_sound.removeEventListener("sampleData",sineWavGenerator);
			_sound = null;
		}
		
		private function sineWavGenerator(event:SampleDataEvent):void {
			if(_play){
				

			if(_display){
				graphics.clear();
				graphics.lineStyle(0.0, 0xFF0000);
				graphics.moveTo(0.0, _y);				
			}

			

			
			 for(var i:int = 0; i < 2048; i++)
			    {	
					++_position;
				
					if(_VibratoSlider.value > 0.0){
						_amp = 0.5 + Math.cos(_position * 0.001) * _VibratoSlider.value;
					}
					
					computeWaveForm(_waveFormType);
					
					event.data.writeFloat(_sample); // left
					event.data.writeFloat(_sample); // right
					
					if(_display){
						graphics.lineTo(i / 1024.0 * stage.stageWidth, _y - _sample * _y / 2);
					}
			    }

				_amp *= Math.floor(_ReleaseSlider.value) /10;
			}
		}
		
		private function computeWaveForm(type:int):void
		{
			_phase = _position / 44100.0 ;
			_freq = 440.0 * Math.pow(2.0, _n / 12.0);
			
			switch(type){
				//SINUS
				case 0:
					_t = _phase * _freq * Math.PI * 2.0;
					_sample = Math.sin(_t) * _amp;
				break;
				//SQUARE
				case 1:
					_t = _phase * _freq * Math.PI * 2.0;
					_sample = (Math.sin(_t) > 0.0 ? _amp : -_amp);
				break;
				//DENT DE SCIE
				case 2:
					_t = _phase * _freq;
					_sample = (2.0 * (_t - Math.floor(_t + 1.0)) )* _amp + _amp;
				break;
				//TRIANGLE
				case 3:
					_t = _phase * _freq;
					_sample = (2.0 * Math.abs(2.0 * _t - 2.0 * Math.floor(_t) - 1.0 ) - 1.0) * _amp;
				break;
			}
		}
		
		private function initView():void
		{
			
			_panel = new Panel(this, stage.stageWidth / 2 - (stage.stageWidth / 3)/2, 20);
			_panel.setSize(stage.stageWidth / 3, stage.stageHeight /3);
			
			//SLIDERS
			_VibratoSlider = new VSlider(_panel, 140, 20);
			_VibratoSlider.maximum = 0.5;
			_VibratoSlider.minimum = 0;
			_VibratoSlider.height = 200;
			new Label(_panel, 136, 0, "Vib");
			
			_ReleaseSlider = new VSlider(_panel, 160, 20);
			_ReleaseSlider.maximum = 10.0;
			_ReleaseSlider.minimum = 0;
			_ReleaseSlider.height = 200;
			new Label(_panel, 156, 0, "Rel");
			
			_ToneSlider = new VSlider(_panel, 180, 20);
			_ToneSlider.maximum = 20.0;
			_ToneSlider.height = 200;
			_ToneSlider.minimum = -30.0;
			new Label(_panel, 176, 0, "Tun");
			
			_DelaySlider = new VSlider(_panel, 200, 20);
			_DelaySlider.maximum = 800.0;
			_DelaySlider.height = 200;
			_DelaySlider.minimum = 1.0;
			_DelaySlider.value = 105.0;
			new Label(_panel, 196, 0, "ArpT");
			
			_arpSlider = new VSlider(_panel, 220, 20);
			_arpSlider.maximum = 12.0;
			_arpSlider.height = 200;
			_arpSlider.minimum = 1.0;
			_arpSlider.value = 5.0;
			new Label(_panel, 223, 0, "ArpInt");
			
			//BUTTONS
			_sineBtn = new PushButton(_panel, 20, 20, "SINE", _setWaveformType);
			_squareBtn = new PushButton(_panel, 20, 50, "SQUARE", _setWaveformType);
			_sawtoothBtn = new PushButton(_panel, 20, 80, "SAWTOOTH", _setWaveformType);
			_triangleBtn = new PushButton(_panel, 20, 110, "TRIANGLE", _setWaveformType);
			
			_showWaveBtn = new PushButton(_panel, 20, 140, "DISPLAY WAVEFORM", _displayWaveOrNot);
			_PlayBtn = new PushButton(_panel, 20, 170, "PLAY/STOP", _togglePlay);
		}
		
		private function _togglePlay(ev:MouseEvent):void
		{
			_play = (_play ? false : true);
			if(!_play){
				del();
			}else{
				reset();
			}
			
		}
		
		private function _displayWaveOrNot(ev:MouseEvent):void
		{
			if(_display){
				graphics.clear();
			}
			_display = (_display ? false : true);
		}
		
		private function _setWaveformType(ev:MouseEvent):void
		{
			switch(ev.currentTarget){
				case _sineBtn:
					_waveFormType = 0;
				break;
				
				case _squareBtn:
					_waveFormType = 1;
				break;
				
				case _sawtoothBtn:
					_waveFormType = 2;
				break;
				
				case _triangleBtn:
					_waveFormType = 3;
				break;
			}
			
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_amp = 0.5;
			if(_arpegiatorCount == 0){
				_baseArpegiatorTune = Math.floor(_ToneSlider.value);
				_n = _baseArpegiatorTune;
				
			}else if(_arpegiatorCount >2){	
				_arpegiatorCount = -1;
				_n = _n + _arpSlider.value;	
			}else{
				_n = _n + _arpSlider.value;
			}
			
			
			
			//_n = Math.floor(_ToneSlider.value);
			_timer.delay = Math.floor(_DelaySlider.value);
			trace(_timer.delay)
			_arpegiatorCount++;
		}
		
	}
}