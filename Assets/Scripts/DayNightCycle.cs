using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayNightCycle : MonoBehaviour
{
    public AudioSource dayAmbient;
    public AudioSource nightAmbient;
    public Material daySkybox;
    public Material nightSkybox;

    bool night = true;
    float dayQuotent = 1;
    float nightQuotent = 1;
    public void Switch(){
        dayQuotent -= 0.15f;
        nightQuotent -= 0.05f;
        if(night){
            RenderSettings.skybox = daySkybox;
            StartCoroutine(disableNight());
            StartCoroutine(enableDay());
            night= false;
        }else{
            RenderSettings.skybox = nightSkybox;
            StartCoroutine(enableNight());
            StartCoroutine(disableDay());
            night = true;
        }
    }

    IEnumerator disableNight(){
        float length = 2f;
        for (float i = 0; i < length; i += Time.deltaTime)
        {
            nightAmbient.volume = Mathf.Lerp(1*nightQuotent,0,i/length);
            yield return new WaitForEndOfFrame();
        }
    }
    IEnumerator enableNight(){
        float length = 2f;
        for (float i = 0; i < length; i += Time.deltaTime)
        {
            nightAmbient.volume = Mathf.Lerp(0*nightQuotent,1,i/length);
            yield return new WaitForEndOfFrame();
        }
    }
    IEnumerator disableDay(){
        float length = 2f;
        for (float i = 0; i < length; i += Time.deltaTime)
        {
            dayAmbient.volume = Mathf.Lerp(1*dayQuotent,0,i/length);
            yield return new WaitForEndOfFrame();
        }
    }
    IEnumerator enableDay(){
        float length = 2f;
        for (float i = 0; i < length; i += Time.deltaTime)
        {
            dayAmbient.volume = Mathf.Lerp(0,1*dayQuotent,i/length);
            yield return new WaitForEndOfFrame();
        }
    }
}
