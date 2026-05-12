using System;
using System.Collections;
using System.Collections.Generic;
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
    private static string MEDIAPIPE_SAMPLES_DATA_PATH;

    private static IMediapipe_Object mp;
    private static ICv_Object cv;
    private static IMediapipe_Tasks_Autoit_Core_Download_utils_Object download_utils;
    private static IMediapipe_Tasks_Autoit_Object autoit;
    private static IMediapipe_Tasks_Autoit_Vision_Object vision;
    private static IMediapipe_Tasks_Vision_Hand_landmarker_HandLandmarksConnections_Object mp_hands;
    private static IMediapipe_Tasks_Autoit_Vision_Drawing_utils_Object mp_drawing;
    private static IMediapipe_Tasks_Autoit_Vision_Drawing_styles_Object mp_drawing_styles;

    private static void SetUp(string[] image_filenames, string _MODEL_FILE, string _MODEL_URL)
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

        mp_hands = mp.tasks.vision.HandLandmarksConnections;
        mp_drawing = mp.tasks.vision.drawing_utils;
        mp_drawing_styles = mp.tasks.vision.drawing_styles;

        string[,] sample_files = new string[1 + image_filenames.Length, 2];

        sample_files[0, 0] = _MODEL_FILE;
        sample_files[0, 1] = _MODEL_URL;

        for (int i = 0; i < image_filenames.Length; i++)
        {
            string config = image_filenames[i];
            string name, url;
            int pos = config.IndexOf("@");
            if (pos != -1)
            {
                name = config.Substring(0, pos);
                url = config.Substring(pos + 1);
            }
            else
            {
                name = config;
                url = $"https://storage.googleapis.com/mediapipe-tasks/gesture_recognizer/{name}";
            }
            sample_files[i + 1, 0] = $"{MEDIAPIPE_SAMPLES_DATA_PATH}\\{name}";
            sample_files[i + 1, 1] = url;
        }

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

    private static void Example(string[] image_filenames, string _MODEL_FILE, string _MODEL_URL)
    {
        // STEP 1: Import the necessary modules.
        SetUp(image_filenames, _MODEL_FILE, _MODEL_URL);

        // STEP 2: Create a GestureRecognizer object.
        var base_options = autoit.BaseOptions[MediapipeComInterop.Params(new Hashtable() { { "model_asset_path", _MODEL_FILE } })];
        var options = vision.GestureRecognizerOptions[MediapipeComInterop.Params(new Hashtable() { { "base_options", base_options } })];
        var recognizer = vision.GestureRecognizer.create_from_options(options);

        foreach (var image_file_name in image_filenames)
        {
            // STEP 3: Load the input image.
            var image = mp.Image.create_from_file(MEDIAPIPE_SAMPLES_DATA_PATH + "\\" + image_file_name);

            // STEP 4: Recognize gestures in the input image.
            var recognition_result = recognizer.recognize(image);

            // STEP 5: Process the result. In this case, visualize it.
            var top_gesture = recognition_result.gestures[0][0];
            var hands_landmarks = recognition_result.hand_landmarks;
            display_image_with_gestures_and_hand_landmarks(image, top_gesture, hands_landmarks);
        }

        cv.waitKey();
    }

    /*
    Displays an image with the gesture category and its score along with the hand landmarks.
    */
    private static void display_image_with_gestures_and_hand_landmarks(dynamic image, dynamic gesture, dynamic hands_landmarks)
    {
        // Display gestures and hand landmarks.
        var annotated_image = cv.cvtColor(image.mat_view(), cv.enums.COLOR_RGB2BGR);
        var title = String.Format("{0} ({1:f2})", gesture.category_name, gesture.score);

        // Compute the scale to make drawn elements visible when the image is resized for display
        var scale = 1 / resize_and_show(annotated_image, show: false);

        foreach (var hand_landmarks in hands_landmarks)
        {
            mp_drawing.draw_landmarks(
                    annotated_image,
                    hand_landmarks,
                    mp_hands.HAND_CONNECTIONS,
                    mp_drawing_styles.get_default_hand_landmarks_style(scale),
                    mp_drawing_styles.get_default_hand_connections_style(scale));
        }

        resize_and_show(annotated_image, title);
    }

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static double resize_and_show(dynamic image, string title = "", bool show = true)
    {
        var w = image.width;
        var h = image.height;

        if (h < w)
        {
            h = h / ((double)w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / ((double)h / DESIRED_HEIGHT);
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

        return (double)w / image.width;
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
        MEDIAPIPE_SAMPLES_DATA_PATH = MediapipeComInterop.FindFile("examples\\data");

        string[] default_image_filenames = new string[] { "thumbs_down.jpg", "victory.jpg", "thumbs_up.jpg", "pointing_up.jpg" };
        List<string> image_filenames_list = new List<string>();
        string _MODEL_FILE = MEDIAPIPE_SAMPLES_DATA_PATH + "\\gesture_recognizer.task";
        string _MODEL_URL = "https://storage.googleapis.com/mediapipe-models/gesture_recognizer/gesture_recognizer/float16/1/gesture_recognizer.task";

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
                    image_filenames_list.Add(args[i + 1]);
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
            Example(image_filenames_list.Count == 0 ? default_image_filenames : image_filenames_list.ToArray(), _MODEL_FILE, _MODEL_URL);
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
