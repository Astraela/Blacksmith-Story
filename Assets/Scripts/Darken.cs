using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class Darken : MonoBehaviour
{
    public Volume volume;

    public void Darkenen(){
        StartCoroutine(endarken());
    }

    IEnumerator endarken(){
            yield return new WaitForSeconds(5f);
        var volumeProfile = volume.profile;
        ColorAdjustments ColAdjs;
        volumeProfile.TryGet<ColorAdjustments>(out ColAdjs);
        float length = 20f;
        for (float i = 0; i < length; i += Time.deltaTime/4)
        {
            ColAdjs.postExposure.Override(Mathf.Clamp(-1.36f - i,-100,0));
            yield return new WaitForEndOfFrame();
        }
        yield return new WaitForSeconds(20f);
        UnityEngine.SceneManagement.SceneManager.LoadScene(0);
    }
}
