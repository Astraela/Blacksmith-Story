using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HammerAnimater : MonoBehaviour
{
    Vector3 StarterEuler = new Vector3(0,0,0);
    Vector3 EndEuler = new Vector3(90,0,0);

    float current = 0;
    float step = 3f;

    public float UpStep = -1f;
    public float DownStep = 3;
    void Update()
    {
        transform.eulerAngles = Vector3.Lerp(StarterEuler,EndEuler,current);
        current += step*Time.deltaTime;
        if(current >= 1) step = UpStep;
        else if(current <= 0 ) step = DownStep;
    }
}
