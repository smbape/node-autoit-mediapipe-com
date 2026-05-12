using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using Mediapipe.InteropServices;
using Cv_Object = OpenCV.InteropServices.Cv_Object;
using ICv_Object = OpenCV.InteropServices.ICv_Object;
using ICv_Mat_Object = OpenCV.InteropServices.ICv_Mat_Object;

public static class Program
{
    private static bool useRuntime = false;

    private static IMediapipe_Object mp;
    private static ICv_Object cv;
    private static IMediapipe_Tasks_Autoit_Core_Download_utils_Object download_utils;
    private static IMediapipe_Tasks_Autoit_Object autoit;
    private static IMediapipe_Tasks_Autoit_Vision_Object vision;

    private static void SetUp(string image_path, String image_url, string _MODEL_FILE, string _MODEL_URL)
    {
        if (useRuntime)
        {
            cv = OpenCvComInterop.ObjCreate("cv");
            if (ReferenceEquals(cv, null))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create cv com object");
            }

            mp = MediapipeComInterop.ObjCreate("mediapipe");
            if (ReferenceEquals(mp, null))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mediapipe com object");
            }

            download_utils = MediapipeComInterop.ObjCreate("mediapipe.tasks.autoit.core.download_utils");
            if (ReferenceEquals(download_utils, null))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mediapipe.tasks.autoit.core.download_utils com object");
            }

            autoit = MediapipeComInterop.ObjCreate("mediapipe.tasks.autoit");
            if (ReferenceEquals(autoit, null))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mediapipe.tasks.autoit com object");
            }

            vision = MediapipeComInterop.ObjCreate("mediapipe.tasks.autoit.vision");
            if (ReferenceEquals(vision, null))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mediapipe.tasks.autoit.vision com object");
            }
        }
        else
        {
            mp = new Mediapipe_Object();
            cv = new Cv_Object();
            download_utils = new Mediapipe_Tasks_Autoit_Core_Download_utils_Object();
            autoit = new Mediapipe_Tasks_Autoit_Object();
            vision = new Mediapipe_Tasks_Autoit_Vision_Object();
        }

        string[,] sample_files = {
            {image_path, image_url},
            {_MODEL_FILE, _MODEL_URL},
        };

        // Download necessary files.
        for (int i = 0; i < sample_files.GetLength(0); i++)
        {
            var file_path = sample_files[i, 0];
            var url = sample_files[i, 1];
            if (!File.Exists(file_path))
            {
                Console.WriteLine("Downloading " + file_path);
                download_utils.download(url, file_path);
                Console.WriteLine("Downloaded " + file_path);
            }
        }
    }

    private static void Example(string image_path, String image_url, string _MODEL_FILE, string _MODEL_URL)
    {
        // STEP 1: Import the necessary modules.
        SetUp(image_path, image_url, _MODEL_FILE, _MODEL_URL);

        // STEP 2: Create a FaceDetector object.
        var base_options = autoit.BaseOptions[MediapipeComInterop.Params(new Hashtable() { { "model_asset_path", _MODEL_FILE } })];
        var options = vision.FaceDetectorOptions[MediapipeComInterop.Params(new Hashtable() { { "base_options", base_options } })];
        var detector = vision.FaceDetector.create_from_options(options);

        // STEP 3: Load the input image.
        var image = mp.Image.create_from_file(image_path);

        // Compute the scale to make drawn elements visible when the image is resized for display
        var scale = 1 / resize_and_show(image.mat_view(), show: false);

        // STEP 4: Detect faces in the input image.
        var detection_result = detector.detect(image);

        // STEP 5: Process the detection result. In this case, visualize it.
        var annotated_image = visualize(image.mat_view(), detection_result, scale);
        resize_and_show(annotated_image, "face_detector");
        cv.waitKey();
    }

    private static bool isclose(double a, double b)
    {
        return Math.Abs(a - b) <= 1e-6;
    }

    //  Checks if the float value is between 0 and 1.
    private static bool is_valid_normalized_value(double val)
    {
        return val >= 0 && val <= 1 || isclose(0, val) || isclose(1, val);
    }

    // Converts normalized value pair to pixel coordinates.
    private static object _normalized_to_pixel_coordinates(double normalized_x, double normalized_y, int image_width, int image_height)
    {
        if (!(is_valid_normalized_value(normalized_x) && is_valid_normalized_value(normalized_y)))
        {
            //  TODO: Draw coordinates even if it's outside of the image bounds.
            return Type.Missing;
        }

        var x_px = Math.Min(Math.Floor(normalized_x * image_width), image_width - 1);
        var y_px = Math.Min(Math.Floor(normalized_y * image_height), image_height - 1);
        return new dynamic[] { x_px, y_px };
    }

    /*
    Draws bounding boxes and keypoints on the input image and return it.
    Args:
        image: The input RGB image.
        detection_result: The list of all "Detection" entities to be visualize.
    Returns:
        Image with bounding boxes.
    */
    private static ICv_Mat_Object visualize(dynamic rgb_image, dynamic detection_result, double scale = 1.0)
    {
        var MARGIN = 10 * scale; //  pixels
        var ROW_SIZE = 10; //  pixels
        var FONT_SIZE = scale;
        var FONT_THICKNESS = 2 * scale;
        var TEXT_COLOR = new dynamic[] { 0, 0, 255 };  //  red

        var bbox_thickness = 3 * scale;

        var keypoint_color = new dynamic[] { 0, 255, 0 }; // blue
        var keypoint_thickness = 2 * scale;
        var keypoint_radius = 2 * scale;

        var annotated_image = cv.cvtColor(rgb_image, cv.enums.COLOR_RGB2BGR);
        var width = rgb_image.width;
        var height = rgb_image.height;

        foreach (var detection in detection_result.detections())
        {
            //  Draw bounding_box
            var bbox = detection.bounding_box;
            var start_point = new dynamic[] { bbox.origin_x, bbox.origin_y };
            var end_point = new dynamic[] { bbox.origin_x + bbox.width, bbox.origin_y + bbox.height };
            cv.rectangle(annotated_image, start_point, end_point, TEXT_COLOR, bbox_thickness);

            //  Draw keypoints
            foreach (var keypoint in detection.keypoints)
            {
                var keypoint_px = _normalized_to_pixel_coordinates(keypoint.x, keypoint.y, width, height);
                // NOTE: Some parameters and properties may be casely different from the docs.
                // This is a known Microsoft software issue; see "Q220137 - "MIDL Changes the Case of Identifier in Generated Type Library" for details.
                // Also, according to Microsoft Corporation, this behavior is by design.
                // https://www.betaarchive.com/wiki/index.php/Microsoft_KB_Archive/220137
                // https://ftp.zx.net.nz/pub/archive/ftp.microsoft.com/MISC/KB/en-us/220/137.HTM
                // https://stackoverflow.com/questions/1278166/midl-changes-case-of-identifier-when-compiling-idl-file
                // https://stackoverflow.com/questions/26302927/midl-changes-the-interface-name
                cv.Circle(annotated_image, keypoint_px, keypoint_thickness, keypoint_color, keypoint_radius);
            }

            //  Draw label and score
            var category = detection.categories(0);
            var category_name = category.category_name;
            var probability = Math.Round(category.score, 2);
            var result_text = $"{category_name} ({probability})";
            var text_location = new dynamic[] { MARGIN + bbox.origin_x, MARGIN + ROW_SIZE + bbox.origin_y };
            cv.putText(annotated_image, result_text, text_location, cv.enums.FONT_HERSHEY_PLAIN, FONT_SIZE, TEXT_COLOR, FONT_THICKNESS);
        }

        return annotated_image;
    }

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static double resize_and_show(dynamic image, string title = "", bool show = true)
    {
        var w = image.width;
        var h = image.height;

        if (h < w)
        {
            h = h / ((double) w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / ((double) h / DESIRED_HEIGHT);
            h = DESIRED_HEIGHT;
        }

        var interpolation = DESIRED_WIDTH > image.width || DESIRED_HEIGHT > image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        if (show)
        {
            var img = cv.resize(image, new dynamic[] { w, h }, OpenCvComInterop.Params(new Hashtable() {
                { "interpolation", interpolation },
            }));
            cv.imshow(title, img.convertToShow());
        }

        return (double) w / image.width;
    }

#if DEBUG
    private static readonly string DEBUG_PREFIX = "d";
#else
    private static readonly string DEBUG_PREFIX = "";
#endif

    static void Main(string[] args)
    {
        string opencv_world_dll = null;
        string opencv_com_dll = null;
        string mediapipe_com_dll = null;
        var register = false;
        var unregister = false;
        string buildType = null;
        string MEDIAPIPE_SAMPLES_DATA_PATH = MediapipeComInterop.FindFile("examples\\data");

        string image_path = MediapipeComInterop.FindFile("examples\\data\\brother-sister-girl-family-boy-977170.jpg");
        string image_url = "https://i.imgur.com/Vu2Nqwb.jpg";
        string _MODEL_FILE = MEDIAPIPE_SAMPLES_DATA_PATH + "\\blaze_face_short_range.tflite";
        string _MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_detector/blaze_face_short_range/float16/1/blaze_face_short_range.tflite";

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

                case "--runtime":
                    useRuntime = true;
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

            // From this point, COM classes will work
        }
        else
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
        }

        try
        {
            Example(image_path, image_url, _MODEL_FILE, _MODEL_URL);
        }
        finally
        {
            if (unregister)
            {
                MediapipeComInterop.Unregister();
                OpenCvComInterop.Unregister();
            }
            else if (!register)
            {
                MediapipeComInterop.DllDeactivateActCtx();
            }
        }

        MediapipeComInterop.DllClose();
        OpenCvComInterop.DllClose();
    }

}
