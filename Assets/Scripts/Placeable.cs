using System.Collections;
using System.Collections.Generic;
using Tilia.Interactions.Interactables.Interactables;
using UnityEngine;
using UnityEngine.Events;

public class Placeable : MonoBehaviour
{
    public GameObject placeable;

    public GameObject LController;
    public GameObject RController;

    public UnityEvent SuccessfullConnect = new UnityEvent();

    bool activated = false;

    bool renderPlaceable = false;
    void Start(){
        if(!renderPlaceable) return;
        foreach(Renderer renderer in GetComponentsInChildren<Renderer>()){
            renderer.enabled = false;
        }
    }

    void OnTriggerEnter(Collider col){
        if(activated) return;
        if(col.gameObject == placeable || col.transform.IsChildOf(placeable.transform)){
            activated=true;
            StartCoroutine(WaitForRelease());
        }
    }

    IEnumerator WaitForRelease(){
        while(placeable.GetComponent<InteractableFacade>().IsGrabbed){
            yield return new WaitForEndOfFrame();
        }
        placeable.GetComponent<InteractableFacade>().enabled = false;

        float length = 0.5f;
        for (float i = 0; i < length; i = i+1*Time.deltaTime )
        {
            LerpObject(placeable.transform,placeable.transform,transform,i/length);
            yield return new WaitForEndOfFrame();
        }

        SuccessfullConnect.Invoke();
        
        placeable.transform.position = transform.position;
        placeable.transform.rotation = transform.rotation;
        Destroy(gameObject);

    }

    void LerpObject(Transform obj1, Transform obj1Origin, Transform obj2, float t){ 
        obj1.position = Vector3.Lerp(obj1Origin.position,obj2.position,t);
        obj1.rotation = Quaternion.Lerp(obj1Origin.rotation,obj2.rotation,t);
    }




}
