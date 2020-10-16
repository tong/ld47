package superposition.renderpath;

class Postprocess {

    public static var colorgrading_global_uniforms = [
        [6500.0, 1.0, 0.0],         //0: Whitebalance, Shadow Max, Highlight Min
        [1.0, 1.0, 1.0],            //1: Tint
        [1.0, 1.0, 1.0],            //2: Saturation
        [1.0, 1.0, 1.0],            //3: Contrast
        [1.0, 1.0, 1.0],            //4: Gamma
        [1.0, 1.0, 1.0],            //5: Gain
        [1.0, 1.0, 1.0],            //6: Offset
		[1.0, 1.0, 1.0]				//7: LUT Strength
    ];

    public static var colorgrading_shadow_uniforms = [
        [1.0, 1.0, 1.0], 			//0: Saturation
        [1.0, 1.0, 1.0], 			//1: Contrast
        [1.0, 1.0, 1.0], 			//2: Gamma
        [1.0, 1.0, 1.0], 			//3: Gain
        [1.0, 1.0, 1.0] 			//4: Offset
    ];

    public static var colorgrading_midtone_uniforms = [
        [1.0, 1.0, 1.0], 			//0: Saturation
        [1.0, 1.0, 1.0], 			//1: Contrast
        [1.0, 1.0, 1.0], 			//2: Gamma
        [1.0, 1.0, 1.0], 			//3: Gain
        [1.0, 1.0, 1.0] 			//4: Offset
    ];

    public static var colorgrading_highlight_uniforms = [
        [1.0, 1.0, 1.0], 			//0: Saturation
        [1.0, 1.0, 1.0], 			//1: Contrast
        [1.0, 1.0, 1.0], 			//2: Gamma
        [1.0, 1.0, 1.0], 			//3: Gain
        [1.0, 1.0, 1.0] 			//4: Offset
    ];

	public static var camera_uniforms = [
		1.0,				//0: Camera: F-Number
		2.8333,				//1: Camera: Shutter time
		100.0, 				//2: Camera: ISO
		0.0,				//3: Camera: Exposure Compensation
		0.01,				//4: Fisheye Distortion
		//1,					//5: DoF AutoFocus §§ If true, it ignores the DoF Distance setting
		0,					//5: DoF AutoFocus §§ If true, it ignores the DoF Distance setting
		10.0,				//6: DoF Distance
		160.0,				//7: DoF Focal Length mm
		128,				//8: DoF F-Stop
		0,					//9: Tonemapping Method
		2.0					//10: Film Grain
	];

	public static var tonemapper_uniforms = [
		1.0, 				//0: Slope
		1.0, 				//1: Toe
		1.0, 				//2: Shoulder
		1.0, 				//3: Black Clip
		1.0 				//4: White Clip
	];

	public static var ssr_uniforms = [
		0.04,				//0: Step
		0.05,				//1: StepMin
		5.0,				//2: Search
		5.0,				//3: Falloff
		0.6					//4: Jitter
	];

	//#if rp_bloom
	public static var bloom_uniforms = [
		1.0,				//0: Threshold
		3.5,				//1: Strength
		3.0					//2: Radius
	];

	public static var ssao_uniforms = [
		1.0,
		1.0,
		8
	];

	public static var lenstexture_uniforms = [
		0.1,				//0: Center Min Clip
		0.5,				//1: Center Max Clip
		0.1,				//2: Luminance Min
		2.5,				//3: Luminance Max
		2.0					//4: Brightness Exponent
	];

	//#if rp_chromatic_aberration
	public static var chromatic_aberration_uniforms = [
		//2.0,				//0: Strength
		0.05,				//0: Strength
		32					//1: Samples
	];

	public static function vec3Link(object:Object, mat:MaterialData, link:String):iron.math.Vec4 {
		var v:Vec4 = null;

		switch link {
		case "_globalWeight":
			final ppm_index = 0;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];
		case "_globalTint":
			final ppm_index = 1;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];
		case "_globalSaturation":
			final ppm_index = 2;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];
		case "_globalContrast":
			final ppm_index = 3;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];
		case "_globalGamma":
			final ppm_index = 4;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];
		case "_globalGain":
			final ppm_index = 5;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];
		case "_globalOffset":
			final ppm_index = 6;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[ppm_index][0];
			v.y = colorgrading_global_uniforms[ppm_index][1];
			v.z = colorgrading_global_uniforms[ppm_index][2];

		//Shadow ppm
		case "_shadowSaturation":
			final ppm_index = 0;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_shadow_uniforms[ppm_index][0];
			v.y = colorgrading_shadow_uniforms[ppm_index][1];
			v.z = colorgrading_shadow_uniforms[ppm_index][2];
		case "_shadowContrast":
			final ppm_index = 1;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_shadow_uniforms[ppm_index][0];
			v.y = colorgrading_shadow_uniforms[ppm_index][1];
			v.z = colorgrading_shadow_uniforms[ppm_index][2];
		case "_shadowGamma":
			final ppm_index = 2;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_shadow_uniforms[ppm_index][0];
			v.y = colorgrading_shadow_uniforms[ppm_index][1];
			v.z = colorgrading_shadow_uniforms[ppm_index][2];
		case "_shadowGain":
			final ppm_index = 3;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_shadow_uniforms[ppm_index][0];
			v.y = colorgrading_shadow_uniforms[ppm_index][1];
			v.z = colorgrading_shadow_uniforms[ppm_index][2];
		case "_shadowOffset":
			final ppm_index = 4;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_shadow_uniforms[ppm_index][0];
			v.y = colorgrading_shadow_uniforms[ppm_index][1];
			v.z = colorgrading_shadow_uniforms[ppm_index][2];

		//Midtone ppm
		case "_midtoneSaturation":
			final ppm_index = 0;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_midtone_uniforms[ppm_index][0];
			v.y = colorgrading_midtone_uniforms[ppm_index][1];
			v.z = colorgrading_midtone_uniforms[ppm_index][2];
		case "_midtoneContrast":
			final ppm_index = 1;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_midtone_uniforms[ppm_index][0];
			v.y = colorgrading_midtone_uniforms[ppm_index][1];
			v.z = colorgrading_midtone_uniforms[ppm_index][2];
		case "_midtoneGamma":
			final ppm_index = 2;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_midtone_uniforms[ppm_index][0];
			v.y = colorgrading_midtone_uniforms[ppm_index][1];
			v.z = colorgrading_midtone_uniforms[ppm_index][2];
		case "_midtoneGain":
			final ppm_index = 3;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_midtone_uniforms[ppm_index][0];
			v.y = colorgrading_midtone_uniforms[ppm_index][1];
			v.z = colorgrading_midtone_uniforms[ppm_index][2];
		case "_midtoneOffset":
			final ppm_index = 4;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_midtone_uniforms[ppm_index][0];
			v.y = colorgrading_midtone_uniforms[ppm_index][1];
			v.z = colorgrading_midtone_uniforms[ppm_index][2];

		//Highlight ppm
		case "_highlightSaturation":
			final ppm_index = 0;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_highlight_uniforms[ppm_index][0];
			v.y = colorgrading_highlight_uniforms[ppm_index][1];
			v.z = colorgrading_highlight_uniforms[ppm_index][2];
		case "_highlightContrast":
			final ppm_index = 1;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_highlight_uniforms[ppm_index][0];
			v.y = colorgrading_highlight_uniforms[ppm_index][1];
			v.z = colorgrading_highlight_uniforms[ppm_index][2];
		case "_highlightGamma":
			final ppm_index = 2;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_highlight_uniforms[ppm_index][0];
			v.y = colorgrading_highlight_uniforms[ppm_index][1];
			v.z = colorgrading_highlight_uniforms[ppm_index][2];
		case "_highlightGain":
			final ppm_index = 3;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_highlight_uniforms[ppm_index][0];
			v.y = colorgrading_highlight_uniforms[ppm_index][1];
			v.z = colorgrading_highlight_uniforms[ppm_index][2];
		case "_highlightOffset":
			final ppm_index = 4;
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_highlight_uniforms[ppm_index][0];
			v.y = colorgrading_highlight_uniforms[ppm_index][1];
			v.z = colorgrading_highlight_uniforms[ppm_index][2];

		//Postprocess Components
		case "_PPComp1":
			v = iron.object.Uniforms.helpVec;
			v.x = camera_uniforms[0]; //F-Number
			v.y = camera_uniforms[1]; //Shutter
			v.z = camera_uniforms[2]; //ISO
		case "_PPComp2":
			v = iron.object.Uniforms.helpVec;
			v.x = camera_uniforms[3]; //EC
			v.y = camera_uniforms[4]; //Lens Distortion
			v.z = camera_uniforms[5]; //DOF Autofocus
		case "_PPComp3":
			v = iron.object.Uniforms.helpVec;
			v.x = camera_uniforms[6]; //Distance
			v.y = camera_uniforms[7]; //Focal Length
			v.z = camera_uniforms[8]; //F-Stop
		case "_PPComp4":
			v = iron.object.Uniforms.helpVec;
			v.x = Std.int(camera_uniforms[9]); //Tonemapping
			v.y = camera_uniforms[10]; //Film Grain
			v.z = tonemapper_uniforms[0]; //Slope
		case "_PPComp5":
			v = iron.object.Uniforms.helpVec;
			v.x = tonemapper_uniforms[1]; //Toe
			v.y = tonemapper_uniforms[2]; //Shoulder
			v.z = tonemapper_uniforms[3]; //Black Clip
		case "_PPComp6":
			v = iron.object.Uniforms.helpVec;
			v.x = tonemapper_uniforms[4]; //White Clip
			v.y = lenstexture_uniforms[0]; //Center Min
			v.z = lenstexture_uniforms[1]; //Center Max
		case "_PPComp7":
			v = iron.object.Uniforms.helpVec;
			v.x = lenstexture_uniforms[2]; //Lum min
			v.y = lenstexture_uniforms[3]; //Lum max
			v.z = lenstexture_uniforms[4]; //Expo
		case "_PPComp8":
			v = iron.object.Uniforms.helpVec;
			v.x = colorgrading_global_uniforms[7][0]; //LUT R
			v.y = colorgrading_global_uniforms[7][1]; //LUT G
			v.z = colorgrading_global_uniforms[7][2]; //LUT B
		case "_PPComp9":
			v = iron.object.Uniforms.helpVec;
			v.x = ssr_uniforms[0]; //Step
			v.y = ssr_uniforms[1]; //StepMin
			v.z = ssr_uniforms[2]; //Search
		case "_PPComp10":
			v = iron.object.Uniforms.helpVec;
			v.x = ssr_uniforms[3]; //Falloff
			v.y = ssr_uniforms[4]; //Jitter
			v.z = bloom_uniforms[0]; //Bloom Threshold
		case "_PPComp11":
			v = iron.object.Uniforms.helpVec;
			v.x = bloom_uniforms[1]; //Bloom Strength
			v.y = bloom_uniforms[2]; //Bloom Radius
			v.z = ssao_uniforms[0]; //SSAO Strength
		case "_PPComp12":
			v = iron.object.Uniforms.helpVec;
			v.x = ssao_uniforms[1]; //SSAO Radius
			v.y = ssao_uniforms[2]; //SSAO Max Steps
			v.z = 0;
		case "_PPComp13":
			v = iron.object.Uniforms.helpVec;
			v.x = chromatic_aberration_uniforms[0]; //CA Strength
			v.y = chromatic_aberration_uniforms[1]; //CA Samples
			v.z = 0;

		default:
			/*
			if( link == "_sunColor" ) {
				if( object != null ) {
					trace(object.name);
					v = new Vec4();
					v.x = 0.0;
					v.y = 0.0;
					v.z = 1.0;
				}
			}
			*/
		}

		return v;
	}

    public static inline function init() {
		iron.object.Uniforms.externalVec3Links.push( vec3Link );
    }

}
