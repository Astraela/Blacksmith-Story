using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class SaturationEditor : MonoBehaviour
{
    public Volume volume;

    public bool testBool = false;
    float saturationGoal = 0;
    float currentSaturation = 0;
    ColorAdjustments ColAdjs;
    void Update(){
        if(testBool) {
            testBool = false;
            UpdateSaturation();
        }

        
        if(currentSaturation > saturationGoal){
            currentSaturation -= Time.deltaTime;
            ColAdjs.saturation.Override(Mathf.Clamp(currentSaturation,-100,0));
        }
    }

    void Start(){
        var volumeProfile = volume.profile;
        volumeProfile.TryGet<ColorAdjustments>(out ColAdjs);
    }


    public void UpdateSaturation(){
        saturationGoal -= 12.5f;
//        var volumeProfile = volume.profile;
//        ColorAdjustments ColAdjs;
//        volumeProfile.TryGet<ColorAdjustments>(out ColAdjs);
//        ColAdjs.saturation.Override(Mathf.Clamp(ColAdjs.saturation.value-12.5f,-100,0));
    }
    
}
