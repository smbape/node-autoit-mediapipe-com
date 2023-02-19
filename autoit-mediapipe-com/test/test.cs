using System;
using System.Collections;
using System.ComponentModel;
using System.Runtime.InteropServices;
using Mediapipe.InteropServices;
using Cv_Object = OpenCV.InteropServices.Cv_Object;
using ICv_Object = OpenCV.InteropServices.ICv_Object;

public static class Test
{
#if DEBUG
    private static readonly string DEBUG_PREFIX = "d";
#else
    private static readonly string DEBUG_PREFIX = "";
#endif

    private static readonly int DISP_E_PARAMNOTFOUND = -2147352572;

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static float ResizeAndShow(dynamic cv, string title, dynamic image)
    {
        float w = image.width;
        float h = image.height;

        if (h < w)
        {
            h = h / (w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / (h / DESIRED_HEIGHT);
            h = DESIRED_HEIGHT;
        }

        int interpolation = DESIRED_WIDTH > image.width || DESIRED_HEIGHT > image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        dynamic[] size = { w, h };
        var kwargs = new Hashtable() {
            { "interpolation", interpolation },
        };

        dynamic img = cv.resize(image, size, OpenCvComInterop.Params(ref kwargs));
        cv.imshow(title, img.convertToShow());

        return (float)img.width / image.width;
    }

    private static void CompiletimeExample(string image_path)
    {
        ICv_Object cv = new Cv_Object();
        IMediapipe_Object mp = new Mediapipe_Object();

        var image = cv.imread(image_path);

        // Preview the images.
        var ratio = ResizeAndShow(cv, "preview", image);

        var mp_face_detection = mp.solutions.face_detection;
        var mp_drawing = mp.solutions.drawing_utils;

        // Run MediaPipe Face Detection
        var face_detection = mp_face_detection.FaceDetection.get_create();

        // Convert the BGR image to RGB and process it with MediaPipe Face Detection.
        var results = face_detection.process(cv.cvtColor(image, cv.enums.COLOR_BGR2RGB));
        if (DISP_E_PARAMNOTFOUND.Equals(results["detections"]))
        {
            Console.Error.WriteLine("No face detection for " + image_path);
            return;
        }

        // enlarge/shrink drawings to keep them visible after resize
        var thickness = 2 / ratio;
        var keypoint_drawing_spec = mp_drawing.DrawingSpec[mp_drawing.RED_COLOR, thickness, thickness];
        var bbox_drawing_spec = mp_drawing.DrawingSpec[mp_drawing.WHITE_COLOR, thickness, thickness];

        // Draw face detections of each face.
        foreach (var detection in results["detections"])
        {
            mp_drawing.draw_detection(image, detection, keypoint_drawing_spec, bbox_drawing_spec);
        }

        ResizeAndShow(cv, "face detection", image);

        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void RuntimeExample(string image_path)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (ReferenceEquals(cv, null))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create cv com");
        }

        var mp = MediapipeComInterop.ObjCreate("mediapipe");
        if (ReferenceEquals(mp, null))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mp com");
        }

        var image = cv.imread(image_path);

        // Preview the images.
        var ratio = ResizeAndShow(cv, "preview", image);

        var mp_face_detection = mp.solutions.face_detection;
        var mp_drawing = mp.solutions.drawing_utils;

        // Run MediaPipe Face Detection
        var face_detection = mp_face_detection.FaceDetection.create();

        // Convert the BGR image to RGB and process it with MediaPipe Face Detection.
        var results = face_detection.process(cv.cvtColor(image, cv.enums.COLOR_BGR2RGB));
        if (DISP_E_PARAMNOTFOUND.Equals(results["detections"]))
        {
            Console.Error.WriteLine("No face detection for " + image_path);
            return;
        }

        // enlarge/shrink drawings to keep them visible after resize
        var thickness = 2 / ratio;
        var keypoint_drawing_spec = mp_drawing.DrawingSpec.create(mp_drawing.RED_COLOR, thickness, thickness);
        var bbox_drawing_spec = mp_drawing.DrawingSpec.create(mp_drawing.WHITE_COLOR, thickness, thickness);

        // Draw face detections of each face.
        foreach (var detection in results["detections"])
        {
            mp_drawing.draw_detection(image, detection, keypoint_drawing_spec, bbox_drawing_spec);
        }

        ResizeAndShow(cv, "face detection", image);

        cv.waitKey();
        cv.destroyAllWindows();
    }

    static void Main(string[] args)
    {
        string opencv_world_dll = null;
        string opencv_com_dll = null;
        string mediapipe_com_dll = null;
        var register = false;
        var unregister = false;
        string buildType = null;
        string image_path = OpenCvComInterop.FindFile("examples\\data\\garrett-jackson-auTAb39ImXg-unsplash.jpg");

        for (int i = 0; i < args.Length; i += 1)
        {
            switch (args[i])
            {

                case "--image":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    image_path = args[i + 1];
                    i += 1;
                    break;

                case "--opencv-world-dll":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    opencv_world_dll = args[i + 1];
                    i += 1;
                    break;

                case "--opencv-com-dll":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    opencv_com_dll = args[i + 1];
                    i += 1;
                    break;

                case "--mediapipe-com-dll":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    mediapipe_com_dll = args[i + 1];
                    i += 1;
                    break;

                case "--build-type":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    buildType = args[i + 1];
                    i += 1;
                    break;

                case "--register":
                    register = true;
                    break;

                case "--unregister":
                    unregister = true;
                    break;

                default:
                    throw new ArgumentException("Unexpected argument " + args[i]);
            }
        }

        OpenCvComInterop.DllOpen(
            string.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world470*", buildType: buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com470*", buildType: buildType) : opencv_com_dll
        );

        MediapipeComInterop.DllOpen(
            string.IsNullOrWhiteSpace(opencv_world_dll) ? MediapipeComInterop.FindDLL("opencv_world470*", buildType: buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(mediapipe_com_dll) ? MediapipeComInterop.FindDLL("autoit_mediapipe_com-*-470*", buildType: buildType) : mediapipe_com_dll
        );

        if (register)
        {
            OpenCvComInterop.Register();
            MediapipeComInterop.Register();
        }

        // To make registration free works with compile time COM classes
        // the activated context needs to have all the dependencies of our application.
        // Therefore, there is a mediapipe.sxs.manifest file which declares all the dependencies
        // of our application.
        var manifest = MediapipeComInterop.FindFile($"mediapipe{DEBUG_PREFIX}.sxs.manifest", new string[] {
            ".",
            "autoit-mediapipe-com",
            "autoit-mediapipe-com\\udf"
        });

        // Make opencv com and mediapipe com to use this manifest instead of the one embeded in their respective dll
        Environment.SetEnvironmentVariable("OPENCV_ACTCTX_MANIFEST", manifest);
        Environment.SetEnvironmentVariable("MEDIAPIPE_ACTCTX_MANIFEST", manifest);

        // Activate a context with this manifest
        MediapipeComInterop.DllActivateManifest();
        // From this point, COM classes will work

        try
        {
            // Tell mediapipe where to look for its binary files,
            // otherwise, it will look them relatively to working directory
            var resourceDir = MediapipeComInterop.FindResourceDir(buildType: buildType);
            IMediapipe_Autoit__framework_bindings_Resource_util_Object resource_util = new Mediapipe_Autoit__framework_bindings_Resource_util_Object();
            resource_util.set_resource_dir(resourceDir);

            CompiletimeExample(image_path);
        }
        finally
        {
            MediapipeComInterop.DllDeactivateActCtx();
        }

        try
        {
            // Tell mediapipe where to look for its binary files,
            // otherwise, it will look them relatively to working directory
            var resourceDir = MediapipeComInterop.FindResourceDir(buildType: buildType);
            var resource_util = MediapipeComInterop.ObjCreate("mediapipe.autoit._framework_bindings.resource_util");
            resource_util.set_resource_dir(resourceDir);

            RuntimeExample(image_path);
        }
        finally
        {
            if (unregister)
            {
                MediapipeComInterop.Unregister();
                OpenCvComInterop.Unregister();
            }
            MediapipeComInterop.DllClose();
            OpenCvComInterop.DllClose();
        }
    }

}
