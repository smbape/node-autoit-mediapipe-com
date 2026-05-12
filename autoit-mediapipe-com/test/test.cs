using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
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

    // private static readonly int DISP_E_PARAMNOTFOUND = -2147352572;

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static float ResizeAndShow(dynamic cv, dynamic bgr_image, string title = "", bool show = true)
    {
        float w = bgr_image.width;
        float h = bgr_image.height;

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

        int interpolation = DESIRED_WIDTH > bgr_image.width || DESIRED_HEIGHT > bgr_image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        dynamic[] size = { w, h };
        var kwargs = new Hashtable() {
            { "interpolation", interpolation },
        };

        dynamic img = cv.resize(bgr_image, size, OpenCvComInterop.Params(kwargs));

        if (show)
        {
            cv.imshow(title, img.convertToShow());
        }

        return (float)img.width / bgr_image.width;
    }

    private static void DownloadIfNotExists(dynamic download_utils, string file_path, string url)
    {
        if (!File.Exists(file_path))
        {
            Console.Error.WriteLine("Downloading " + file_path);
            download_utils.download(url, file_path);
            Console.Error.WriteLine("Downloaded " + file_path);
        }
    }

    private static dynamic DrawLandmarksOnImage(
        dynamic cv,
        dynamic vision,
        dynamic drawing_styles,
        dynamic drawing_utils,
        dynamic rgb_image, dynamic detection_result)
    {
        // Compute the scale to make drawn elements visible when the image is resized for display
        var scale = 1 / ResizeAndShow(cv, rgb_image, "", false);

        var face_landmarks_list = detection_result.face_landmarks;
        var annotated_image = cv.cvtColor(rgb_image, cv.enums.COLOR_RGB2BGR);

        // Loop through the detected faces to visualize.
        foreach (var face_landmarks in face_landmarks_list)
        {
            // Draw the face landmarks.

            drawing_utils.draw_landmarks(MediapipeComInterop.Params(new Hashtable() {
                {"image", annotated_image},
                {"landmark_list", face_landmarks},
                {"connections", vision.FaceLandmarksConnections.FACE_LANDMARKS_TESSELATION},
                {"landmark_drawing_spec", DBNull.Value},
                {"connection_drawing_spec", drawing_styles.get_default_face_mesh_tesselation_style(scale)},
            }));
            drawing_utils.draw_landmarks(MediapipeComInterop.Params(new Hashtable() {
                {"image", annotated_image},
                {"landmark_list", face_landmarks},
                {"connections", vision.FaceLandmarksConnections.FACE_LANDMARKS_CONTOURS},
                {"landmark_drawing_spec", DBNull.Value},
                {"connection_drawing_spec", drawing_styles.get_default_face_mesh_contours_style(1, scale)},
            }));
            drawing_utils.draw_landmarks(MediapipeComInterop.Params(new Hashtable() {
                {"image", annotated_image},
                {"landmark_list", face_landmarks},
                {"connections", vision.FaceLandmarksConnections.FACE_LANDMARKS_LEFT_IRIS},
                {"landmark_drawing_spec", DBNull.Value},
                {"connection_drawing_spec", drawing_styles.get_default_face_mesh_iris_connections_style(scale)},
            }));
            drawing_utils.draw_landmarks(MediapipeComInterop.Params(new Hashtable() {
                {"image", annotated_image},
                {"landmark_list", face_landmarks},
                {"connections", vision.FaceLandmarksConnections.FACE_LANDMARKS_RIGHT_IRIS},
                {"landmark_drawing_spec", DBNull.Value},
                {"connection_drawing_spec", drawing_styles.get_default_face_mesh_iris_connections_style(scale)},
            }));
        }

        return annotated_image;
    }

    private static void CompiletimeExample(string image_path, String image_url, string _MODEL_FILE, string _MODEL_URL)
    {
        IMediapipe_Object mp = new Mediapipe_Object();
        ICv_Object cv = new Cv_Object();

        var tasks = mp.tasks;
        var download_utils = tasks.core.download_utils;
        var vision = tasks.vision;
        var drawing_utils = vision.drawing_utils;
        var drawing_styles = vision.drawing_styles;

        DownloadIfNotExists(download_utils, image_path, image_url);
        DownloadIfNotExists(download_utils, _MODEL_FILE, _MODEL_URL);

        // STEP 2: Create a FaceLandmarker object.
        var base_options = tasks.BaseOptions[MediapipeComInterop.Params(new Hashtable() { { "model_asset_path", _MODEL_FILE } })];
        var options = vision.FaceLandmarkerOptions[MediapipeComInterop.Params(new Hashtable() {
            {"base_options", base_options},
            {"output_face_blendshapes", true},
            {"output_facial_transformation_matrixes", true},
            {"num_faces", 1}
        })];
        var detector = vision.FaceLandmarker.create_from_options(options);

        // STEP 3: Load the input image.
        var image = vision.core.Image.Image.create_from_file(image_path);

        // STEP 4: Detect hand landmarks from the input image.
        var detection_result = detector.detect(image);

        // STEP 5: Process the classification result. In this case, visualize it.
        var annotated_image = DrawLandmarksOnImage(cv, vision, drawing_styles, drawing_utils, image.mat_view(), detection_result);
        ResizeAndShow(cv, cv.cvtColor(image.mat_view(), cv.enums.COLOR_RGB2BGR), "preview");
        ResizeAndShow(cv, annotated_image, "face landmarkers");
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void RuntimeExample(string image_path, String image_url, string _MODEL_FILE, string _MODEL_URL)
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

        var tasks = mp.tasks;
        var download_utils = tasks.core.download_utils;
        var vision = tasks.vision;
        var drawing_utils = vision.drawing_utils;
        var drawing_styles = vision.drawing_styles;

        DownloadIfNotExists(download_utils, image_path, image_url);
        DownloadIfNotExists(download_utils, _MODEL_FILE, _MODEL_URL);

        // STEP 2: Create a FaceLandmarker object.
        var base_options = tasks.BaseOptions[MediapipeComInterop.Params(new Hashtable() { { "model_asset_path", _MODEL_FILE } })];
        var options = vision.FaceLandmarkerOptions[MediapipeComInterop.Params(new Hashtable() {
            {"base_options", base_options},
            {"output_face_blendshapes", true},
            {"output_facial_transformation_matrixes", true},
            {"num_faces", 1}
        })];
        var detector = vision.FaceLandmarker.create_from_options(options);

        // STEP 3: Load the input image.
        var image = mp.Image.create_from_file(image_path);

        // STEP 4: Detect hand landmarks from the input image.
        var detection_result = detector.detect(image);

        // STEP 5: Process the classification result. In this case, visualize it.
        var annotated_image = DrawLandmarksOnImage(cv, vision, drawing_styles, drawing_utils, image.mat_view(), detection_result);
        ResizeAndShow(cv, cv.cvtColor(image.mat_view(), cv.enums.COLOR_RGB2BGR), "preview");
        ResizeAndShow(cv, annotated_image, "face landmarkers");
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
        string MEDIAPIPE_SAMPLES_DATA_PATH = MediapipeComInterop.FindFile("examples\\data");

        string image_path = MediapipeComInterop.FindFile("examples\\data\\business-person.png");
        string image_url = "https://storage.googleapis.com/mediapipe-assets/business-person.png";
        string _MODEL_FILE = MEDIAPIPE_SAMPLES_DATA_PATH + "\\face_landmarker.task";
        string _MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task";

        for (int i = 0; i < args.Length; i += 1)
        {
            switch (args[i])
            {

                case "-i":
                case "--image":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    image_path = args[i + 1];
                    i += 1;
                    break;

                case "-u":
                case "--url":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    image_url = args[i + 1];
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
            string.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world4130*", buildType: buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com4130*", buildType: buildType) : opencv_com_dll
        );

        MediapipeComInterop.DllOpen(
            string.IsNullOrWhiteSpace(opencv_world_dll) ? MediapipeComInterop.FindDLL("opencv_world4130*", buildType: buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(mediapipe_com_dll) ? MediapipeComInterop.FindDLL("autoit_mediapipe_com-*-4130*", buildType: buildType) : mediapipe_com_dll
        );

        if (register)
        {
            OpenCvComInterop.Register();
            MediapipeComInterop.Register();
        }

        try
        {

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
            if (!MediapipeComInterop.DllActivateManifest())
            {
                throw new ArgumentException("DllActivateManifest failed");
            }
            // From this point, COM classes will work

            try
            {
                CompiletimeExample(image_path, image_url, _MODEL_FILE, _MODEL_URL);
            }
            finally
            {
                MediapipeComInterop.DllDeactivateActCtx();
            }

            RuntimeExample(image_path, image_url, _MODEL_FILE, _MODEL_URL);

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
