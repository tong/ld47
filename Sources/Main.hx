// Auto-generated
package ;
class Main {
    public static inline var projectName = 'Superposition';
    public static inline var projectVersion = '0.3.30';
    public static inline var projectPackage = 'superposition';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 8;
            iron.object.LightObject.cascadeCount = 4;
            iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.main(
            'Boot',
            0,
            true,
            true,
            true,
            1920,
            1080,
            1,
            true,
            superposition.renderpath.RenderPathCreator.get
        );
    }
}
