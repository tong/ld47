package superposition.renderpath;

import armory.renderpath.Inc;
import armory.renderpath.RenderPathForward;
import armory.renderpath.RenderPathDeferred;
import iron.RenderPath;

class RenderPathCreator {

	public static var path: RenderPath;

	#if (rp_renderer == "Forward")
	public static var setTargetMeshes = RenderPathForward.setTargetMeshes;
	public static var drawMeshes = RenderPathForward.drawMeshes;
	public static var applyConfig = RenderPathForward.applyConfig;
	#elseif (rp_renderer == "Deferred")
	public static var setTargetMeshes = RenderPathDeferred.setTargetMeshes;
	public static var drawMeshes = RenderPathDeferred.drawMeshes;
	public static var applyConfig = RenderPathDeferred.applyConfig;

	#else
	public static var setTargetMeshes = () -> {};
	public static var drawMeshes = () -> {};
	public static var applyConfig = () -> {};
	#end

	#if rp_voxelao
	public static var voxelFrame = 0;
	public static var voxelFreq = 6; // Revoxelizing frequency
	#end

	// Last target before drawing to framebuffer
	public static var finalTarget : RenderTarget = null;

	public static function get() : RenderPath {

		path = new iron.RenderPath();
		Inc.init( path );

		#if (rp_renderer == "Forward")
		RenderPathForward.init(path);
		path.commands = RenderPathForward.commands;

		#elseif (rp_renderer == "Deferred")
		RenderPathDeferred.init(path);
		path.commands = RenderPathDeferred.commands;

		#elseif (rp_renderer == "Raytracer")
		RenderPathRaytracer.init(path);
		path.commands = RenderPathRaytracer.commands;
		#end

		#if rp_pp
		iron.App.notifyOnInit( () -> {
			superposition.renderpath.Postprocess.init();
		});
		#end

		return path;
	}

}
