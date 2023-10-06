using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    public Vector3 eulerGoal = Vector3.zero;

    public bool testOpen = false;

    void Update(){
        if(testOpen){
            testOpen = false;
            Open();
        }
    }

    public void Open(){
        StartCoroutine(OpenDoor());
        if(GetComponent<AudioSource>()){
            var audio = GetComponent<AudioSource>();
            audio.PlayOneShot(audio.clip);
        }
    }

    IEnumerator OpenDoor(){
        float timeLength = 1.5f;
        for (float i = 0; i < timeLength; i = i+1 * Time.deltaTime)
        {
            transform.rotation = Quaternion.Lerp(transform.rotation,Quaternion.Euler(eulerGoal),i/timeLength);
            yield return new WaitForEndOfFrame();
        }
    }
}
