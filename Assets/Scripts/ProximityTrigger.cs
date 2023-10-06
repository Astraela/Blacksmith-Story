using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class ProximityTrigger : MonoBehaviour
{
    public Transform player;
    public float detectionRange;

    public UnityEvent OnEnter = new UnityEvent();
    // Update is called once per frame

    bool isInRange = false;
    void Update()
    {
        if(!isInRange && Vector3.Distance(transform.position,player.position) <= detectionRange){
            isInRange = true;
            OnEnter.Invoke();
        }else if(isInRange && Vector3.Distance(transform.position,player.position) > detectionRange){
            isInRange = false;
        }
    }
}
