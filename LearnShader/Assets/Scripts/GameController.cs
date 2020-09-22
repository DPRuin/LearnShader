using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    // Start is called before the first frame update
    public Button saveButton;
    
    private Sprite sprite;

    private Texture2D texture;
    
    void Start()
    {
        saveButton.onClick.AddListener(ButtonClick);
        sprite = Resources.Load<Sprite>("Texture/Icon_1024");
        texture = Resources.Load<Texture2D>("Texture/imm");
    }

    private void ButtonClick()
    {
        //StartCoroutine(SaveImage());
        SaveImage2();
    }

    public IEnumerator SaveImage()
    {
        Debug.Log("SaveImage");
        yield return new WaitForEndOfFrame();
        // 图片
        Texture2D tex = new Texture2D((int)sprite.rect.height, (int)sprite.rect.width, TextureFormat.RGBA32, false);
        tex.ReadPixels(sprite.rect, 0, 0, false);
        tex.Apply();


        byte[] shareTex = tex.EncodeToPNG();
        // 保存
        //string destination = "/sdcard/DCIM/TestSave";
        string destination = Application.streamingAssetsPath + "/sdcard/DCIM/TestSave";
        //判断目录是否存在，不存在则会创建目录
        if (!Directory.Exists(destination))
        {
            Directory.CreateDirectory(destination);
        }
        string path = destination + "/" + "xxylShare.PNG";
        //存图片
        System.IO.File.WriteAllBytes(path, shareTex);
    }

    private void SaveImage2()
    {
        Debug.Log("SaveImage2");

        byte[] shareTex = texture.EncodeToPNG();
#if UNITY_EDITOR
        string destination = Application.streamingAssetsPath + "/sdcard/DCIM/TestSave";
#elif UNITY_ANDROID
        string destination = "/sdcard/DCIM/TestSave";
#endif
        //判断目录是否存在，不存在则会创建目录
        if (!Directory.Exists(destination))
        {
            Directory.CreateDirectory(destination);
        }
        string path = destination + "/" + "xxylShare.PNG";
        //存图片
        System.IO.File.WriteAllBytes(path, shareTex);

        if (Application.platform == RuntimePlatform.Android)
        {
            using (AndroidJavaClass playerActivity = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
            {
                using (AndroidJavaObject jo = playerActivity.GetStatic<AndroidJavaObject>("currentActivity"))
                {
                    Debug.Log("scanFile:m_androidJavaObject ");
                    jo.Call("scanFile", destination);
                }

            }
        }
    }

}
